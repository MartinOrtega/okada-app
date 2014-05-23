package ar.com.okada

class Teacher {

    static hasMany = [payments: Payment]

	String name

	String lastName
	
	String dni

	String age
	
	SexType gender
	
	String mail
	
	String phone
	
	String notes

    List payments

    static constraints = {
    	name (blank: false)
    	lastName (blank: false)
    	dni (unique: true, nullable: true)
    	age (nullable: true)
    	gender (nullable: true)
    	mail (email: true, nullable: true)
    	phone (nullable: true)
    	notes (nullable: true)
    }

    @Override
    String toString() {
        return name + " " + lastName
    }
}
