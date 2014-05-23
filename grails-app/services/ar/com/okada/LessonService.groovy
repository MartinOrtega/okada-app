package ar.com.okada

import org.springframework.transaction.annotation.Transactional

import org.joda.time.DateTime
import org.joda.time.Days
import org.joda.time.Weeks
import static org.joda.time.DateTimeConstants.MONDAY
import static org.joda.time.DateTimeConstants.SUNDAY
import org.joda.time.Months
import org.joda.time.Years
import org.joda.time.Instant
import org.joda.time.Minutes


class LessonService {

    def updateLesson(Lesson lessonInstance, LessonRecurActionType actionType, Date occurrenceStartTime, Date occurrenceEndTime, def params) {
        def result = [:]
        def students = params.students
        params.remove("students")

        def lessonStored = Lesson.get(lessonInstance.id)


        try {
            if (!lessonInstance) {
                result = [error: 'not.found']
            }
            else if (!lessonStored.isRecurring) {
                lessonInstance.properties = params

                    def tmp = [] 
                    tmp.addAll(lessonInstance.students) 
                    tmp.each { 
                        lessonInstance.removeFromStudents(it) 
                        lessonInstance.save(flush:true) 
                    }
                    students.each { s->
                        lessonInstance.addToStudents(Student.get(s))
                    }

                if (lessonInstance.hasErrors() || !lessonInstance.save(flush: true)) {
                    result = [error: 'has.errors']
                }
            }
            else {
                DateTime occurrenceStartDateTime = new DateTime(occurrenceStartTime)
                DateTime occurrenceEndDateTime = new DateTime(occurrenceEndTime)

                switch (actionType) {
                    case LessonRecurActionType.OCCURRENCE:
                        // Add an exclusion
                        lessonStored.addToExcludeDays(params.date('dayToExclude', ['dd/MM/yyyy'])).save(flush: true)

                        // single lesson
                        Lesson newLesson = new Lesson(params)
                        newLesson.startTime = occurrenceStartTime
                        newLesson.endTime = occurrenceEndTime
                        newLesson.isRecurring = false // ignore recurring options this is a single lesson
                        if (lessonInstance.sourceLesson) {
                            newLesson.sourceLesson = lessonInstance.sourceLesson
                        } else {
                            newLesson.sourceLesson = lessonInstance.id
                        }
                        students.each { s->
                            newLesson.addToStudents(Student.get(s))
                        }

                        newLesson.save(flush: true, failOnError: true)
                        

                        break

                    case LessonRecurActionType.FOLLOWING:
                        // create a new lesson for the changes following this occurrence

                        Lesson newLesson = new Lesson(params)
                        newLesson.startTime = occurrenceStartTime
                        newLesson.endTime = occurrenceEndTime
                        newLesson.recurUntil = lessonInstance.recurUntil
                        newLesson.isRecurring = true 
                        if (lessonInstance.sourceLesson) {
                            newLesson.sourceLesson = lessonInstance.sourceLesson
                        } else {
                            newLesson.sourceLesson = lessonInstance.id
                        }

                        students.each { s->
                            newLesson.addToStudents(Student.get(s))
                        }
                        newLesson.save(flush: true)

                        lessonInstance.recurUntil = params.date('dayToExclude', ['dd/MM/yyyy'])
                        lessonInstance.save(flush: true)

                        break

                    case LessonRecurActionType.ALL:
                        // Using the date from the original startTime and endTime with the update time from the form
                        int updatedDuration = Minutes.minutesBetween(occurrenceStartDateTime, occurrenceEndDateTime).minutes

                        Date updatedStartTime = new DateTime(lessonInstance.startTime).withTime(occurrenceStartDateTime.hourOfDay, occurrenceStartDateTime.minuteOfHour, 0, 0).toDate()
                        Date updatedEndTime = new DateTime(updatedStartTime).plusMinutes(updatedDuration).toDate()

                        lessonInstance.properties = params
                        lessonInstance.startTime = updatedStartTime
                        lessonInstance.endTime = updatedEndTime

                        def tmp = [] 
                        tmp.addAll(lessonInstance.students) 
                        tmp.each { 
                            lessonInstance.removeFromStudents(it) 
                            lessonInstance.save(flush:true) 
                        }
                        students.each { s->
                            lessonInstance.addToStudents(Student.get(s))
                        }

                        if (lessonInstance.hasErrors() || !lessonInstance.save(flush: true)) {
                            result = [error: 'has.errors']
                        }


                }
            }

        }
        catch (Exception ex) {
            result = [error: 'has.errors']
        }
        
        result
    }

    def deleteLesson(Lesson lessonInstance, LessonRecurActionType actionType, Date occurrenceStart) {

        def result = [:]

        try {
            if (!lessonInstance) {
                result = [error: 'not.found']
            }
            if (!lessonInstance.isRecurring || actionType == LessonRecurActionType.ALL) {
                
                Lesson.list().each { l ->
                    if(l.sourceLesson == l.id) {
                        l.sourceLesson = null
                    }
                }

                def tmp = []
                tmp.addAll(lessonInstance.students)
                tmp.each{
                    it.removeFromLessons(lessonInstance)
                    it.save flush: true
                } 

                lessonInstance.delete flush: true
            }
            else {
                switch (actionType) {
                    case LessonRecurActionType.OCCURRENCE:
                        // Add an exclusion
                        lessonInstance.addToExcludeDays(new DateTime(occurrenceStart).withTime(0, 0, 0, 0).toDate())
                        lessonInstance.save(flush: true)
                        break

                    case LessonRecurActionType.FOLLOWING:
                        lessonInstance.recurUntil = occurrenceStart
                        lessonInstance.save(flush: true)
                        break

                }

            }
        }
        catch (Exception ex) {
            result = [error: 'has.errors']
        }

        result
    }

    @Transactional(readOnly = true)
    public def findOccurrencesInRange(Lesson lesson, Date rangeStart, Date rangeEnd) {
        def dates = []

        Date currentDate
        if (lesson.isRecurring) {
            currentDate = findNextOccurrence(lesson, rangeStart)

            while (currentDate && currentDate < rangeEnd) {
                dates.add(currentDate)
                Date nextMinute = new DateTime(currentDate).plusMinutes(1).toDate()
                currentDate = findNextOccurrence(lesson, nextMinute)
            }
        }
        // One time (non-recurring) lesson
        else {
            if (lesson.startTime >= rangeStart && lesson.endTime <= rangeEnd) {
                dates.add(lesson.startTime)
            }
        }

        dates
    }

    // For repeating lesson get next occurrence after the specified date
    @Transactional(readOnly = true)
    Date findNextOccurrence(Lesson lesson, Date afterDate) {
        Date nextOccurrence

        if (!lesson.isRecurring) {
            // non-repeating lesson
            nextOccurrence = null
        } else if (lesson.recurUntil && afterDate > lesson.recurUntil) {
            // Lesson is already over
            nextOccurrence = null
        } else if (afterDate < lesson.startTime) {
            // First occurrence
            if (lesson.recurType == LessonRecurType.WEEKLY && !(isOnRecurringDay(lesson, lesson.startTime))) {
                Date nextDay = new DateTime(lesson.startTime).plusDays(1).toDate()
                nextOccurrence = findNextOccurrence(lesson, nextDay)
            }
            else {
                nextOccurrence = lesson.startTime
            }
        } else {
            switch (lesson.recurType) {
                case LessonRecurType.DAILY:
                    nextOccurrence = findNextDailyOccurrence(lesson, afterDate)
                    break
                case LessonRecurType.WEEKLY:
                    nextOccurrence = findNextWeeklyOccurrence(lesson, afterDate)
                    break
                case LessonRecurType.MONTHLY:
                    nextOccurrence = findNextMonthlyOccurrence(lesson, afterDate)
                    break
                case LessonRecurType.YEARLY:
                    nextOccurrence = findNextYearlyOccurrence(lesson, afterDate)
                    break
            }


        }

        if (isOnExcludedDay(lesson, nextOccurrence)) {
            // Skip this occurrence and go to the next one
            nextOccurrence = findNextOccurrence(lesson, nextOccurrence)
        }
        else if (lesson.recurUntil && lesson.recurUntil <= nextOccurrence) {
            // Next occurrence happens after recurUntil date
            nextOccurrence = null
        }

        nextOccurrence
    }

    private Date findNextDailyOccurrence(Lesson lesson, Date afterDate) {
        DateTime nextOccurrence = new DateTime(lesson.startTime)

        int daysBeforeDate = Days.daysBetween(new DateTime(lesson.startTime), new DateTime(afterDate)).getDays()

        int occurrencesBeforeDate = Math.floor(daysBeforeDate / lesson.recurInterval)

        int daysToAdd = (occurrencesBeforeDate + 1) * lesson.recurInterval

        nextOccurrence = nextOccurrence.plusDays(daysToAdd)

        nextOccurrence.toDate()
    }


    private Date findNextWeeklyOccurrence(Lesson lesson, Date afterDate) {
        int weeksBeforeDate = Weeks.weeksBetween(new DateTime(lesson.startTime), new DateTime(afterDate)).getWeeks()
        int weekOccurrencesBeforeDate = Math.floor(weeksBeforeDate / lesson.recurInterval)

        DateTime lastOccurrence = new DateTime(lesson.startTime)
        lastOccurrence = lastOccurrence.plusWeeks(weekOccurrencesBeforeDate * lesson.recurInterval)
        lastOccurrence = lastOccurrence.withDayOfWeek(MONDAY)

        DateTime nextOccurrence
        if (isInSameWeek(lastOccurrence.toDate(), afterDate)) {
            nextOccurrence = lastOccurrence.plusDays(1)
        }
        else {
            nextOccurrence = lastOccurrence.plusWeeks(lesson.recurInterval)
        }

        boolean occurrenceFound = false

        while (!occurrenceFound) {
            if (nextOccurrence.toDate() > afterDate && isOnRecurringDay(lesson, nextOccurrence.toDate())) {
                occurrenceFound = true
            }
            else {
                if (nextOccurrence.getDayOfWeek() == SUNDAY) {
                    // we're about to pass into the next week
                    nextOccurrence = nextOccurrence.withDayOfWeek(MONDAY).plusWeeks(lesson.recurInterval)
                }
                else {
                    nextOccurrence = nextOccurrence.plusDays(1)
                }
            }

        }

        nextOccurrence.toDate()
    }

    private Date findNextMonthlyOccurrence(Lesson lesson, Date afterDate) {
        DateTime nextOccurrence = new DateTime(lesson.startTime)

        int monthsBeforeDate = Months.monthsBetween(new DateTime(lesson.startTime), new DateTime(afterDate)).getMonths()
        int occurrencesBeforeDate = Math.floor(monthsBeforeDate / lesson.recurInterval)
        nextOccurrence = nextOccurrence.plusMonths((occurrencesBeforeDate + 1) * lesson.recurInterval)

        nextOccurrence.toDate()
    }

    private Date findNextYearlyOccurrence(Lesson lesson, Date afterDate) {
        DateTime nextOccurrence = new DateTime(lesson.startTime)

        int yearsBeforeDate = Years.yearsBetween(new DateTime(lesson.startTime), new DateTime(afterDate)).getYears()
        int occurrencesBeforeDate = Math.floor(yearsBeforeDate / lesson.recurInterval)
        nextOccurrence = nextOccurrence.plusYears((occurrencesBeforeDate + 1) * lesson.recurInterval)

        nextOccurrence.toDate()
    }


    private boolean isInSameWeek(Date date1, Date date2) {
        DateTime dateTime1 = new DateTime(date1)
        DateTime dateTime2 = new DateTime(date2)

        ((Weeks.weeksBetween(dateTime1, dateTime2)).weeks == 0)
    }

    private boolean isOnSameDay(Date date1, Date date2) {
        DateTime dateTime1 = new DateTime(date1)
        DateTime dateTime2 = new DateTime(date2)

        ((Days.daysBetween(dateTime1, dateTime2)).days == 0)
    }

    private boolean isOnRecurringDay(Lesson lesson, Date date) {
        int day = new DateTime(date).getDayOfWeek()

        lesson.recurDaysOfWeek.find{it == day}
    }

    private def isOnExcludedDay(Lesson lesson, Date date) {
        date = (new DateTime(date)).withTime(0, 0, 0, 0).toDate()
        lesson.excludeDays?.contains(date)
    }
}
