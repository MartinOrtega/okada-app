import ar.com.okada.Student
import ar.com.okada.Teacher
import ar.com.okada.Location
import ar.com.okada.ColorType
import ar.com.okada.security.User
import ar.com.okada.security.Role
import ar.com.okada.security.UserRole

class BootStrap {

    def init = { servletContext ->

        Role role = new Role(authority: "ROLE_ADMIN")
        role.save(flush:true, failOnError: true)

        Role role1 = new Role(authority: "ROLE_USER")
        role1.save(flush:true, failOnError: true)

        User user = new User(username: "admin", password: "admin")
        user.save(flush:true, failOnError: true)

        UserRole.create user, role


    }
    def destroy = {
    }
}
