package ar.com.okada

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured
import ar.com.okada.security.Role

@Transactional(readOnly = true)
class StudentController {

    def springSecurityService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    @Secured(['ROLE_ADMIN', 'ROLE_USER'])
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)

        def user = springSecurityService.currentUser
        def isAdmin = Role.findByAuthority("ROLE_ADMIN") in user.getAuthorities()

        if(!isAdmin){
            def studentsList = []
            def isStudent
            Student.list(params).each{ s ->
                isStudent = false
                s.lessons.each{ l ->
                    if (l.teacher.id == user.teacher.id && !isStudent){
                        studentsList << s
                        isStudent = true
                    }
                }
            }
            respond studentsList, model:[studentInstanceCount: studentsList.size()]
        } else {
            respond Student.list(params), model:[studentInstanceCount: Student.count()]
        }
    }

    @Secured(['ROLE_ADMIN', 'ROLE_USER'])
    def show(Student studentInstance) {
        respond studentInstance
    }

    @Secured(['ROLE_ADMIN'])
    def create() {
        respond new Student(params)
    }

    @Secured(['ROLE_ADMIN'])
    @Transactional
    def save(Student studentInstance) {
        if (studentInstance == null) {
            notFound()
            return
        }

        if (studentInstance.hasErrors()) {
            respond studentInstance.errors, view:'create'
            return
        }

        studentInstance.save flush:true

        request.withFormat {
            form {
                flash.message = message(code: 'default.created.message', args: [message(code: 'studentInstance.label', default: 'Student'), studentInstance.id])
                redirect studentInstance
            }
            '*' { respond studentInstance, [status: CREATED] }
        }
    }

    @Secured(['ROLE_ADMIN'])
    def edit(Student studentInstance) {
        respond studentInstance
    }

    @Secured(['ROLE_ADMIN'])
    @Transactional
    def update(Student studentInstance) {
        if (studentInstance == null) {
            notFound()
            return
        }

        if (studentInstance.hasErrors()) {
            respond studentInstance.errors, view:'edit'
            return
        }

        studentInstance.save flush:true

        request.withFormat {
            form {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Student.label', default: 'Student'), studentInstance.id])
                redirect studentInstance
            }
            '*'{ respond studentInstance, [status: OK] }
        }
    }

    @Secured(['ROLE_ADMIN'])
    @Transactional
    def delete(Student studentInstance) {

        if (studentInstance == null) {
            notFound()
            return
        }

        studentInstance.delete flush:true

        request.withFormat {
            form {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Student.label', default: 'Student'), studentInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'studentInstance.label', default: 'Student'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
