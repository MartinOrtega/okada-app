
<%@ page import="ar.com.okada.Student" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'student.label', default: 'Student')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<div class="example-screen">
			<a href="#show-student" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
			<div class="nav" role="navigation">
				<ul>
					<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
					<sec:ifAllGranted roles="ROLE_ADMIN">
						<li>
							<g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link>
						</li>
					</sec:ifAllGranted>
					<li><g:link class="print" type="button" onClick="window.print()"><g:message code="default.print"/></g:link></li>
				</ul>
			</div>
		</div>
		<div id="show-student" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<div class="example-screen">
				<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
				</g:if>
			</div>
			<ol class="property-list student">
			
				<g:if test="${studentInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${studentInstance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${studentInstance?.lastName}">
				<li class="fieldcontain">
					<span id="lastName-label" class="property-label"><g:message code="lastName.label" default="Last Name" /></span>
					
						<span class="property-value" aria-labelledby="lastName-label"><g:fieldValue bean="${studentInstance}" field="lastName"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${studentInstance?.dni}">
				<li class="fieldcontain">
					<span id="dni-label" class="property-label"><g:message code="dni.label" default="Dni" /></span>
					
						<span class="property-value" aria-labelledby="dni-label"><g:fieldValue bean="${studentInstance}" field="dni"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${studentInstance?.age}">
				<li class="fieldcontain">
					<span id="age-label" class="property-label"><g:message code="age.label" default="Age" /></span>
					
						<span class="property-value" aria-labelledby="age-label"><g:fieldValue bean="${studentInstance}" field="age"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${studentInstance?.gender}">
				<li class="fieldcontain">
					<span id="gender-label" class="property-label"><g:message code="gender.label" default="Gender" /></span>
					
						<span class="property-value" aria-labelledby="gender-label">
							${studentInstance.gender.name}
						</span>
					
				</li>
				</g:if>
			
				<g:if test="${studentInstance?.mail}">
				<li class="fieldcontain">
					<span id="mail-label" class="property-label"><g:message code="mail.label" default="Mail" /></span>
					
						<span class="property-value" aria-labelledby="mail-label"><g:fieldValue bean="${studentInstance}" field="mail"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${studentInstance?.phone}">
				<li class="fieldcontain">
					<span id="phone-label" class="property-label"><g:message code="phone.label" default="Phone" /></span>
					
						<span class="property-value" aria-labelledby="phone-label"><g:fieldValue bean="${studentInstance}" field="phone"/></span>
					
				</li>
				</g:if>
			

				<li class="fieldcontain">
					<span id="lessons-label" class="property-label"><g:message code="courses.label" default="Lessons" /></span>
					
					<g:each in="${studentInstance?.lessons}" var="l">
						<g:if test="${l.active}">
						<g:if test="${!l.sourceLesson}">
							<span class="property-value" aria-labelledby="lessons-label">
								<g:link controller="lesson" action="show" id="${l.id}">${l.title?.encodeAsHTML()}</g:link>
								 - ${l.getWhen()}
							</span>
						</g:if>
						</g:if>
					</g:each>
				</li>

			
			</ol>
			<div class="example-screen">
			<g:form url="[resource:studentInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<sec:ifAllGranted roles="ROLE_ADMIN">
						<g:link class="edit" action="edit" resource="${studentInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
						<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
					</sec:ifAllGranted>
				</fieldset>
			</g:form>
			<div>
		</div>
	</body>
</html>
