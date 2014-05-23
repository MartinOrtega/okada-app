package ar.com.okada.security

class Role {

	String authority

	static mapping = {
		cache true
	}

	static constraints = {
		authority blank: false, unique: true
	}

	@Override
    String toString() {
        return authority
    }
}

public enum RoleType {
    ROLE_ADMIN('Administrador'),
    ROLE_USER('Usuario')

    String name

    RoleType(String name) {
        this.name = name
    }
}
