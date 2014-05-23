package ar.com.okada

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import org.joda.time.Instant
import org.joda.time.DateTime
import org.joda.time.Months
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_ADMIN'])
@Transactional(readOnly = true)
class PaymentController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Payment.list(params), model:[paymentInstanceCount: Payment.count()]
    }

    def show(Payment paymentInstance) {
        respond paymentInstance
    }

    def create() {
        respond new Payment(params)
    }

    @Transactional
    def save(Payment paymentInstance) {
        if (paymentInstance == null) {
            notFound()
            return
        }

        if (paymentInstance.hasErrors()) {
            respond paymentInstance.errors, view:'create'
            return
        }

        paymentInstance.save flush:true

        if(params)

        request.withFormat {
            form {
                flash.message = message(code: 'default.created.message', args: [message(code: 'paymentInstance.label', default: 'Payment'), paymentInstance.id])
                redirect paymentInstance
            }
            '*' { respond paymentInstance, [status: CREATED] }
        }
    }

    def edit(Payment paymentInstance) {
        respond paymentInstance
    }

    @Transactional
    def update(Payment paymentInstance) {
        
        if (paymentInstance == null) {
            notFound()
            return
        }

        if (paymentInstance.hasErrors()) {
            respond paymentInstance.errors, view:'edit'
            return
        }

        paymentInstance.save flush:true

        request.withFormat {
            form {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Payment.label', default: 'Payment'), paymentInstance.id])
                redirect paymentInstance
            }
            '*'{ respond paymentInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Payment paymentInstance) {

        if (paymentInstance == null) {
            notFound()
            return
        }

        paymentInstance.delete flush:true

        request.withFormat {
            form {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Payment.label', default: 'Payment'), paymentInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'paymentInstance.label', default: 'Payment'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    def debtors() {
        
        def list = []

        Student.list().each { s ->
            
            def debtor = new Expando()
            def amount = 0

            s.lessons.each { l ->

                DateTime now = new DateTime()
                DateTime startTimeDateTime = new DateTime(l.startTime)
                DateTime recurUntilDateTime = new DateTime(l.recurUntil)

                DateTime end = recurUntilDateTime >= now ? recurUntilDateTime : now

                def pastMonths = Months.monthsBetween(startTimeDateTime, end).getMonths()

                //No se cobra lo que no empezo ni los que son deribados de otra clase (cambio de dia, etc)
                if (startTimeDateTime < now && !l.sourceLesson) {
                    amount += l.price * (pastMonths + 1) //Se suma 1 porque se entiende que se paga por anticipado.
                }
            }

            s.payments.each { p ->
                amount -= p.amount
            }

            if(amount>0){
                debtor.id = s.id
                debtor.student = s
                debtor.amount = amount

                list << debtor
            }
        }

        model:[debtorList: list, debtorCount:list.size()]
    }

    def paymentToTeachers() {
        
        def list = []

        Teacher.list().each { t ->
            
            def teacher = new Expando()
            def amount = 0

            Lesson.findAllByTeacher(t).each { l ->

                if (l.students) {
                    
                    amount += l.price

                    t.payments.each { p ->
                        amount -= p.amount
                    }

                    if(amount>0){
                        teacher.teacher = t
                        teacher.amount = amount

                        list << teacher
                    }

                }
            }
        }
        model:[paymentsList: list, paymentCount:list.size()]
    }

    def selectPersonType = {
        def type = params.type
        render(template: 'persons', model:  [type: type])
    }
}
