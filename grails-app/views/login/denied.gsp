<html>
<head>
	<title><g:message code="springSecurity.denied.title"/></title>
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'LogoOkadaIcono.ico')}" type="image/x-icon">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
		<g:javascript library="application"/>	
		<r:require module="core" />
		<r:require module="calendar" />
    	<r:require module="selectmodule" />
		<r:layoutResources />
</head>
<body>
		<div class="row">
			<div class="col-md-12">
				<img src="${resource(dir: 'images', file: 'logo-okada.png')}"/>
			</div>
		</div>

		<div class="orage-line"></div>
		<div>
			<div class="nav" role="navigation">
				<ul>
					<li><a class="home" href="${createLink(uri: '/lesson/index.gsp')}"><g:message code="default.home.label"/></a></li>
					<li><a class="user" href="${createLink(uri: '/logout')}"><g:message code="denied.button.login"/></a></li>
				</ul>
			</div>					
		</div>

		<h1><g:message code="springSecurity.denied.title" default="Denied!"/></h1>
		
    	<h2><g:message code="springSecurity.denied.message" /></h2> 
</body>
</html>
