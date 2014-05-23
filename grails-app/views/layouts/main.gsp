<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<%@ page import="ar.com.okada.security.User" %>
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="Grails"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'LogoOkadaIcono.ico')}" type="image/x-icon">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">
		<g:layoutHead/>
		<g:javascript library="application"/>	
		<r:require module="core" />
		<r:require module="calendar" />
    	<r:require module="selectmodule" />
		<r:layoutResources />
	</head>
	<body>
		<div class="row">
			<div class="col-md-6">
				<a href="/okada-app/lesson/index"><img src="${resource(dir: 'images', file: 'logo-okada.png')}"/></a>
			</div>
			<div class="col-md-6" style="text-align:right;">
			  	<sec:ifLoggedIn>
			  		<div class="example-screen">
				  		<g:link controller="logout" class="btn">Cerrar Sesion</g:link>
				  		</br></br></br></br>
				  		<h4>
					  		<div class="col-md-12" style="text-align:right;">
				  				<g:link class="user-name" controller="user" action="show" id="${sec.loggedInUserInfo(field:'id')}">${User.get(sec.loggedInUserInfo(field:'id'))}</g:link>
					  		</h4>
						</div>
					</div>
				</sec:ifLoggedIn>
			</div>
		</div>
		<sec:ifNotLoggedIn>
			<div class="orage-line"></div>
		</sec:ifNotLoggedIn>
		<sec:ifLoggedIn>
		<div class="example-screen">
			<ul id="tabs" class="nav nav-tabs ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all" style="text-align:right; vertical-align:middle;">
				<li><a href="/okada-app/lesson/index.gsp">Cursos</a></li>
				<li><a href="/okada-app/student/index.gsp">Alumnos</a></li>
				<sec:ifAllGranted roles="ROLE_ADMIN">
					<li><a href="/okada-app/teacher/index.gsp">Profesores</a></li>
					<li><a href="/okada-app/payment/index.gsp">Pagos</a></li>
					<li><a href="/okada-app/location/index.gsp">Aulas</a></li>
					<li><a href="/okada-app/user/index.gsp">Usuarios</a></li>
				</sec:ifAllGranted>
			</ul>
		</div>
		</sec:ifLoggedIn>
		<g:layoutBody/>
		<sec:ifNotLoggedIn>
			<fieldset class="buttons"></fieldset>
		</sec:ifNotLoggedIn>
		<div id="spinner" class="spinner" style="display:none;"><g:message code="spinner.alt" default="Loading&hellip;"/></div>
		<r:layoutResources />
	</body>
</html>