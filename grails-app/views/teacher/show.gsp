
<%@ page import="ar.com.okada.Teacher" %>
<%@ page import="ar.com.okada.Lesson" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'teacher.label', default: 'Teacher')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<div class="example-screen">
			<a href="#show-teacher" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
			<div class="nav" role="navigation">
				<ul>
					<sec:ifAllGranted roles="ROLE_ADMIN">
						<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
						<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
					</sec:ifAllGranted>
					<li><g:link class="print" type="button" onClick="window.print()"><g:message code="default.print"/></g:link></li>
				</ul>
			</div>
		</div>
		<div id="show-teacher" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<div class="example-screen">
				<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
				</g:if>
			</div>
			<ol class="property-list teacher">
			
				<g:if test="${teacherInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${teacherInstance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${teacherInstance?.lastName}">
				<li class="fieldcontain">
					<span id="lastName-label" class="property-label"><g:message code="lastName.label" default="Last Name" /></span>
					
						<span class="property-value" aria-labelledby="lastName-label"><g:fieldValue bean="${teacherInstance}" field="lastName"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${teacherInstance?.dni}">
				<li class="fieldcontain">
					<span id="dni-label" class="property-label"><g:message code="dni.label" default="Dni" /></span>
					
						<span class="property-value" aria-labelledby="dni-label"><g:fieldValue bean="${teacherInstance}" field="dni"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${teacherInstance?.age}">
				<li class="fieldcontain">
					<span id="age-label" class="property-label"><g:message code="age.label" default="Age" /></span>
					
						<span class="property-value" aria-labelledby="age-label"><g:fieldValue bean="${teacherInstance}" field="age"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${teacherInstance?.gender}">
				<li class="fieldcontain">
					<span id="gender-label" class="property-label"><g:message code="gender.label" default="Gender" /></span>
					
						<span class="property-value" aria-labelledby="gender-label">
							${teacherInstance.gender.name}
						</span>
					
				</li>
				</g:if>
			
				<g:if test="${teacherInstance?.mail}">
				<li class="fieldcontain">
					<span id="mail-label" class="property-label"><g:message code="mail.label" default="Mail" /></span>
					
						<span class="property-value" aria-labelledby="mail-label"><g:fieldValue bean="${teacherInstance}" field="mail"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${teacherInstance?.phone}">
				<li class="fieldcontain">
					<span id="phone-label" class="property-label"><g:message code="phone.label" default="Phone" /></span>
					
						<span class="property-value" aria-labelledby="phone-label"><g:fieldValue bean="${teacherInstance}" field="phone"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${teacherInstance?.notes}">
				<li class="fieldcontain">
					<span id="notes-label" class="property-label"><g:message code="notes.label" default="Notes" /></span>
					
						<span class="property-value" aria-labelledby="notes-label"><g:fieldValue bean="${teacherInstance}" field="notes"/></span>
					
				</li>
				</g:if>

				<li class="fieldcontain">
					<span id="lessons-label" class="property-label"><g:message code="courses.label" default="Lessons" /></span>
					
					<g:each in="${Lesson.list()}" var="l">
						<g:if test="${l.active}">
						<g:if test="${!l.sourceLesson}">
							<g:if test="${l.teacher.id == teacherInstance.id}">
							<span class="property-value" aria-labelledby="lessons-label">
								<g:link controller="lesson" action="show" id="${l.id}">${l.title?.encodeAsHTML()}</g:link>
								 - ${l.getWhen()}
							</span>
							</g:if>
						</g:if>
						</g:if>
					</g:each>
				</li>
			
			</ol>
			<div class="example-screen">
				<g:form url="[resource:teacherInstance, action:'delete']" method="DELETE">
					<fieldset class="buttons">
						<sec:ifAllGranted roles="ROLE_ADMIN">
							<g:link class="edit" action="edit" resource="${teacherInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
							<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
						</sec:ifAllGranted>
					</fieldset>
				</g:form>
			</div>
		</div>
	</body>
</html>
