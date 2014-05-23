class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.${format})?"{
            constraints {
                // apply constraints here
            }
        }

		"/" ( controller: 'lesson', action: 'home')

        "500"(view:'/error')
	}
}
