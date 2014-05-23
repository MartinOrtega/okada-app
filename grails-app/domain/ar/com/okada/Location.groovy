package ar.com.okada


class Location {

    String name
    String description
    ColorType color

    static constraints = {
        name (nullable:false, blank:false)
        description (nullable:true)
        color (unique: true)
    }

    @Override
    String toString() {
        return name
    }
}    

public enum ColorType {
    RED('Rojo'),
    GREEN('Verde'),
    BLUE('Azul'),
    VIOLET('Violeta'),
    GRAY('Gris')

    String name

    ColorType(String name) {
        this.name = name
    }
}