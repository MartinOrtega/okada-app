modules = {
    application {
        resource url:'js/application.js'
    }

    core {
        resource url:'/js/jquery-1.11.0.js', disposition: 'head'
        resource url:'/js/jquery-ui-1.10.4.custom.js', disposition: 'head'
        resource url: '/css/jquery-ui-1.10.4.custom.css'
    }

    datePicker {
        dependsOn 'core'
        resource url: '/js/jquery-ui-timepicker-addon.js'
    }


    fullCalendar {
        dependsOn 'core'
        resource url:'/js/fullcalendar.js'
        resource url:'/css/fullcalendar.css'
    }

    qtip {
        dependsOn 'core'

        resource url: '/js/jquery.qtip.js'
        resource url: '/css/jquery.qtip.css'
    }


    calendar {
        dependsOn 'fullCalendar, datePicker, qtip'

        resource url: '/js/calendar.js'
        resource url: '/css/calendar.css'
    }

    dynamicData {
        dependsOn 'core'

        resource url: '/js/jquery.appendGrid-1.3.1.js'
        resource url: '/css/jquery.appendGrid-1.3.1.css'
    }

    multiselect {
        dependsOn 'core'

        resource url: '/js/bootstrap-multiselect.js'
        resource url: '/js/bootstrap.js'
        resource url: '/js/prettify.js'
        resource url: '/css/bootstrap-multiselect.css'
        resource url: '/css/bootstrap.css'
        resource url: '/css/prettify.css'
    }

    selectmodule {
        dependsOn 'multiselect'
        resource url: '/js/selectmodule.js'
    }
}