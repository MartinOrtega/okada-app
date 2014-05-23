package ar.com.okada

class Payment {

	Date date = new Date()

	Integer amount

	String changeDescription

    static constraints = {
    	changeDescription(nullable: true)
    }
}
