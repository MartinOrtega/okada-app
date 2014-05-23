package ar.com.okada

import org.joda.time.DateTime
import org.joda.time.Minutes

class Lesson {

    def lessonService

    String title
    String description
    Location location
    SortedSet students
    boolean active
    Teacher teacher

    Integer price

    Date startTime
    Date endTime

    // Recurring Options
    boolean isRecurring
    LessonRecurType recurType
    Integer recurInterval = 1
    Date recurUntil
    Integer recurCount

    // Backlink to original recurring lesson this lesson was created from
    Long sourceLesson

    static belongsTo = Student
    static hasMany = [recurDaysOfWeek: Integer, excludeDays: Date, students: Student]
    static transients = ['durationMinutes']

    static constraints = {
        title(nullable: false, blank: false)
        location(nullable: true)
        teacher(nullable: true)
        description(nullable: true)
        recurType(nullable: true)
        recurInterval(nullable: true)
        recurUntil(nullable: true)
        recurCount(nullable: true)
        excludeDays(nullable: true)
        sourceLesson(nullable: true)
        price(nullable: true)
        startTime(required: true, nullable: false)
        endTime(required: true, nullable: false, validator: {val, obj -> val >= obj.startTime} )
        recurDaysOfWeek(validator: {val, obj -> 
            if (obj.recurType == LessonRecurType.WEEKLY && !val) {return 'null'}
        })
    }

    public String getWhen(){
        def when = ""
        if (!isRecurring){
            when = "Desde " + startTime.format('E dd MMM yyyy, HH:mm') + ", hasta " + endTime.format('E dd MMM yyyy, HH:mm')
        } else {
            when += this.recurType.name + " "
            if (recurCount){
                when += "desde " + startTime.format('E dd MMM yyyy') + "."
                when += " Finaliza despues de " + recurCount + " ${recurCount > 1 ? 'repeticiones' : 'repeticion'}. "
                when += "\n"
            } else if (recurUntil){
                when += "deste " + startTime.format('E dd MMM yyyy')
                when += ", hasta " + recurUntil.format('E dd MMM yyyy') + ". "
                when += "\n"
            }
            if(recurType == LessonRecurType.WEEKLY){
                when += "Los dias "
                this.recurDaysOfWeek.each{ d ->
                    when += this.getDayString(d, false) + ", "
                }
                when = when.substring(0, when.length() - 2) + ". "
                when += "\n"
            }
            when += "De " + startTime.format('HH:mm') + " a " + endTime.format('HH:mm') + "."
        }
    }

    public String getWhenReduced(){
        def when = ""
        if (!isRecurring){
            when = startTime.format('dd/MM/yy, HH:mm') + " - " + endTime.format('dd/MM/yy, HH:mm')
        } else {
            when += this.recurType.name + " "
            if (recurCount){
                when += "desde " + startTime.format('dd/MM/yy')
                when += ", " + recurCount + " ${recurCount > 1 ? 'clases' : 'clase'}. "
            } else if (recurUntil){
                when += "desde " + startTime.format('dd/MM/yy')
                when += " hasta" + recurUntil.format('dd/MM/yy') + ". "
            }
            if(recurType == LessonRecurType.WEEKLY){
                when += "Los dias "
                this.recurDaysOfWeek.each{ d ->
                    when += this.getDayString(d, true) + ", "
                }
                when = when.substring(0, when.length() - 2) + ". "
                when += "\n"
            }
            when += "De " + startTime.format('HH:mm') + " a " + endTime.format('HH:mm') + "."
        }
    }

    private String getDayString(Integer day, boolean reduced){
        def days = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"]
        def daysReduced = ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab"]
        if (reduced){
            daysReduced[day]
        } else {
            days[day]
        }
    }

    public int getDurationMinutes() {
        Minutes.minutesBetween(new DateTime(startTime), new DateTime(endTime)).minutes
    }

    private void updateRecurringValues() {
        if (!isRecurring) {
            recurType = null
            recurCount = null
            recurInterval = null
            recurUntil = null
            excludeDays?.clear()
            recurDaysOfWeek?.clear()
        }

        // Set recurUntil date based on the recurCount value
        if (recurCount && !recurUntil) {
           Date recurCountDate = startTime

           // extra instance if startTime day is not in recurDaysOfWeek
           def extraInstance = this.recurType == LessonRecurType.WEEKLY && !(lessonService.isOnRecurringDay(this, this.startTime)) ? 1 : 0

           for (int i in 1..(recurCount - 1 + extraInstance)) {
               recurCountDate = lessonService.findNextOccurrence(this, new DateTime(recurCountDate).plusMinutes(1).toDate())
           }

           recurUntil = new DateTime(recurCountDate).plusMinutes(durationMinutes).toDate()
        }
        
    }

    def beforeUpdate() {
        updateRecurringValues()
    }
    
    def beforeInsert() {
        updateRecurringValues()
    }
}

public enum LessonRecurType {
    DAILY('Cada dia'),
    WEEKLY('Cada semana'),
    MONTHLY('Cada mes'),
    YEARLY('Cada año')

    String name

    LessonRecurType(String name) {
        this.name = name
    }
}

public enum LessonRecurActionType {
    OCCURRENCE, FOLLOWING, ALL
}

