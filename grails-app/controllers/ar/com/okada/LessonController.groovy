package ar.com.okada

import org.joda.time.DateTime
import org.joda.time.Instant

import grails.converters.JSON
import java.text.SimpleDateFormat
import groovy.time.TimeCategory
import static java.util.Calendar.*
import grails.plugin.springsecurity.annotation.Secured
import ar.com.okada.security.Role

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class LessonController {

    def springSecurityService
    def lessonService

    def index = {

    }

    def list = {

        def (startRange, endRange) = [params.long('start'), params.long('end')].collect { new Instant(it  * 1000L).toDate() }

        def lessons = Lesson.withCriteria {
            or {
                and {
                    eq("isRecurring", false)
                    between("startTime", startRange, endRange)
                }
                and {
                    eq("isRecurring", true)
                    or {
                        isNull("recurUntil")
                        ge("recurUntil", startRange)
                    }
                }
            }
        }


        // iterate through to see if we need to add additional Lesson instances because of recurring
        // lessons
        def lessonList = []

        def displayDateFormatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")

        def user = springSecurityService.currentUser
        def isAdmin = Role.findByAuthority("ROLE_ADMIN") in user.getAuthorities()

        lessons.each {lesson ->

            if(isAdmin || user.teacher == lesson.teacher) {
            
                def dates = lessonService.findOccurrencesInRange(lesson, startRange, endRange)

                dates.each { date ->
                    DateTime startTime = new DateTime(date)
                    DateTime endTime = startTime.plusMinutes(lesson.durationMinutes)

                    /*
                        start/end and occurrenceStart/occurrenceEnd are separate because fullCalendar will use the client's local timezone (which may be different than the server's timezone)
                        start/end are used to render the lessons on the calendar and the occurrenceStart/occurrenceEnd values are passed along to the show popup
                    */

                    lessonList << [
                            id: lesson.id,
                            title: lesson.title,
                            allDay: false,
                            start: displayDateFormatter.format(startTime.toDate()),
                            end: displayDateFormatter.format(endTime.toDate()),
                            occurrenceStart: startTime.toInstant().millis,
                            occurrenceEnd: endTime.toInstant().millis,
                            color: lesson.location?.color?.name
                    ]
                }
            }
        }

        withFormat {
            html {
                [lessonInstanceList: lessonList]
            }
            json {
                render lessonList as JSON
            }
        }
    }

    def create = {
        def lessonInstance = new Lesson()
        lessonInstance.properties = params

        if (params.startTime){
            if(request.xhr){
                Date startTime = new Date().parse("dd-MM-yyyy", params.startTime)
                lessonInstance.startTime = startTime
                lessonInstance.endTime = startTime
            } else {
                def start = lessonInstance.startTime
                def end = lessonInstance.startTime
                def splitedStartTime = params.start.split("\\:")
                lessonInstance.startTime = new DateTime(start).plusHours(splitedStartTime[0].toInteger()).plusMinutes(splitedStartTime[1].toInteger()).toDate()
                def splitedEndTime = params.end.split("\\:")
                lessonInstance.endTime = new DateTime(end).plusHours(splitedEndTime[0].toInteger()).plusMinutes(splitedEndTime[1].toInteger()).toDate()
            }
        }

        def user = springSecurityService.currentUser
        lessonInstance.teacher = user.teacher
        
        def timeList = ["00:00","00:30","01:00","01:30","02:00","02:30",
                        "03:00","03:30","04:00","04:30","05:00","05:30",
                        "06:00","06:30","07:00","07:30","08:00","08:30",
                        "09:00","09:30","10:00","10:30","11:00","11:30",
                        "12:00","12:30","13:00","13:30","14:00","14:30",
                        "15:00","15:30","16:00","16:30","17:00","17:30",
                        "18:00","18:30","19:00","19:30","20:00","20:30",
                        "21:00","21:30","22:00","22:30","23:00","23:30"]

        def model = [lessonInstance: lessonInstance, timeList: timeList]

        if (request.xhr) {
            render(view: "createPopup", model:model)
        }
        else {
            model
        }
    }


    def show = {
        def lessonInstance = Lesson.get(params.id)
        def occurrenceStart = params.long('occurrenceStart') ?: new Instant(lessonInstance?.startTime)
        def occurrenceEnd = params.long('occurrenceEnd') ?: new Instant(lessonInstance?.endTime)

        if (!lessonInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'lesson.label', default: 'Lesson'), params.id])}"
            redirect(action: "home")
        }
        else {
            def model = [lessonInstance: lessonInstance, occurrenceStart: occurrenceStart, occurrenceEnd: occurrenceEnd]

            if (request.xhr) {
                render(template: "showPopup", model: model)
            }
            else {
                model
            }
        }

    }

    def save = {

        def students = params.students

        params.remove("students")

        def lessonInstance = new Lesson(params)

        Student.getAll(students).each{ s ->
            lessonInstance.addToStudents(s)
        }
        
        lessonInstance.active = true;

        if(params.start && params.end){
            def start = lessonInstance.startTime
            def end = lessonInstance.startTime
            def splitedStartTime = params.start.split("\\:")
            def splitedEndtTime = params.end.split("\\:")
            lessonInstance.startTime = new DateTime(start).plusHours(splitedStartTime[0].toInteger()).plusMinutes(splitedStartTime[1].toInteger()).toDate()
            lessonInstance.endTime = new DateTime(end).plusHours(splitedEndtTime[0].toInteger()).plusMinutes(splitedEndtTime[1].toInteger()).toDate()
        }

        
        if (lessonInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'lesson.label', default: 'Lesson'), lessonInstance.id])}"
            redirect(action: "show", id: lessonInstance.id)
        }
        else {
            render(view: "create", model: [lessonInstance: lessonInstance])
        }

    }

    def edit = {
        def lessonInstance = Lesson.get(params.id)
        def (occurrenceStart, occurrenceEnd) = [params.long('occurrenceStart'), params.long('occurrenceEnd')]

        if (!lessonInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'lesson.label', default: 'Lesson'), params.id])}"
            redirect(action: "home")
        } else {
            [lessonInstance: lessonInstance, occurrenceStart: occurrenceStart, occurrenceEnd: occurrenceEnd]
        }

    }

    def update = {

        def lessonInstance = Lesson.get(params.id)

        LessonRecurActionType editType = params.editType ? params.editType.toUpperCase() as LessonRecurActionType : null

        Date occurrenceStartTime = params.date('startTime', ['dd/MM/yyyy HH:mm'])
        Date occurrenceEndTime = params.date('endTime', ['dd/MM/yyyy HH:mm'])

        def result = lessonService.updateLesson(lessonInstance, editType, occurrenceStartTime, occurrenceEndTime, params)

        if (!result.error) {
            flash.message = "${message(code: 'default.updated.message', args: [message(code: 'lesson.label', default: 'Lesson'), lessonInstance.id])}"
            redirect(action: "home")
        }
        if (result.error == 'not.found') {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'lesson.label', default: 'Lesson'), params.id])}"
            redirect(action: "home")
        }
        else if (result.error == 'has.errors') {
            render(view: "edit", model: [lessonInstance: lessonInstance])
        }

    }


    def delete = {
        def lessonInstance = Lesson.get(params.id)

        LessonRecurActionType deleteType = params.deleteType ? params.deleteType.toUpperCase() as LessonRecurActionType : null
        Date occurrenceStart = new Instant(params.long('occurrenceStart')).toDate()

        def result = lessonService.deleteLesson(lessonInstance, deleteType, occurrenceStart)

        if (!result.error) {
            redirect(action: "home")
        }
        if (result.error == 'not.found') {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'lesson.label', default: 'Lesson'), params.id])}"
            redirect(action: "home")
        }
        else if (result.error == 'has.errors') {
            redirect(action: "home")
        }
    }

    def home = {
        redirect(uri: "/lesson/index.gsp")
    }
}
