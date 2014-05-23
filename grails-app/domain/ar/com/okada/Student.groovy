package ar.com.okada

class Student implements Comparable{

	static hasMany = [lessons: Lesson, payments: Payment]

	String name

	String lastName
	
	String dni

	String age
	
	SexType gender
	
	String mail
	
	String phone

	List lessons

    List payments

    static constraints = {
    	name (blank: false)
    	lastName (blank: false)
    	dni (unique: true, nullable: true)
    	age (nullable: true)
    	gender (nullable: true)
    	mail (email: true, nullable: true)
    	phone (nullable: true)
    	lessons (nullable: true)
    }

    @Override
    String toString() {
        return name + " " + lastName
    }

    int compareTo(obj) {
        id.compareTo(obj.id)
    }
}
