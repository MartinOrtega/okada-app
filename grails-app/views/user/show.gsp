
<%@ page import="ar.com.okada.security.User" %>
<%@ page import="ar.com.okada.security.RoleType" %>
<%@ page import="ar.com.okada.Lesson" %>


<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-user" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
		<sec:ifAllGranted roles="ROLE_ADMIN">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</sec:ifAllGranted>
		</div>
		<div id="show-user" class="content scaffold-show" role="main">

			<g:if test="${userInstance.id.toString().equals(sec.loggedInUserInfo(field:'id').toString())}">
			    <h1><g:message code="show.me.label"/></h1>
			</g:if>
			<g:else>
				<h1><g:message code="show.user.label"/></h1>
			</g:else>
			
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>

			<ol class="property-list user">
			
				<g:if test="${userInstance?.username}">
				<li class="fieldcontain">
					<span id="username-label" class="property-label"><g:message code="username.label" default="Username" /></span>
					
						<span class="property-value" aria-labelledby="username-label"><g:fieldValue bean="${userInstance}" field="username"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${userInstance?.teacher}">
				<li class="fieldcontain">
					<span id="teacher-label" class="property-label">
						<sec:ifAllGranted roles="ROLE_ADMIN">
							<g:message code="teacher.label" default="Teacher" />
						</sec:ifAllGranted>
						<sec:ifNotGranted roles="ROLE_ADMIN">
							<g:message code="user.me.label" default="Me" />
						</sec:ifNotGranted>
					</span>
					<span class="property-value" aria-labelledby="teacher-label">
						<sec:ifAllGranted roles="ROLE_ADMIN">
							<g:link controller="teacher" action="show" id="${userInstance?.teacher?.id}">${userInstance?.teacher?.encodeAsHTML()}</g:link>
						</sec:ifAllGranted>
						<sec:ifNotGranted roles="ROLE_ADMIN">
							${userInstance?.teacher}
						</sec:ifNotGranted>
					</span>
				</li>
				</g:if>
				
				
				<sec:ifAllGranted roles="ROLE_ADMIN">

					<li class="fieldcontain">
						<span id="enabled-label" class="property-label">
							<g:message code="role.label" default="Role" />
						</span>
						
							<span class="property-value" aria-labelledby="enabled-label">
								<g:each in="${userInstance.getAuthorities()}">
									${(it.toString() as RoleType).name}
								</g:each>
							</span>
						
					</li>

					<li class="fieldcontain">
						<span id="enabled-label" class="property-label"><g:message code="user.enabled.label" default="Enabled" /></span>
						
							<span class="property-value" aria-labelledby="enabled-label"><g:checkBox name="enabled" value="${userInstance.enabled}" disabled="true" /></span>
						
					</li>
				</sec:ifAllGranted>

				<sec:ifNotGranted roles="ROLE_ADMIN">
					<li class="fieldcontain">
						<span id="lessons-label" class="property-label"><g:message code="courses.label" default="Lessons" /></span>
						
						<g:each in="${Lesson.list()}" var="l">
							<g:if test="${l.active}">
							<g:if test="${!l.sourceLesson}">
								<g:if test="${l.teacher.id == userInstance.teacher.id}">
								<span class="property-value" aria-labelledby="lessons-label">
									<g:link controller="lesson" action="show" id="${l.id}">${l.title?.encodeAsHTML()}</g:link>
									 - ${l.getWhen()}
								</span>
								</g:if>
							</g:if>
							</g:if>
						</g:each>
					</li>
				</sec:ifNotGranted>


			</ol>
			<g:form url="[resource:userInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${userInstance}">
						<sec:ifAllGranted roles="ROLE_ADMIN">
							<g:message code="default.button.edit.label" default="Edit" />
						</sec:ifAllGranted>
						<sec:ifNotGranted roles="ROLE_ADMIN">
							<g:message code="default.button.update.password.label" default="Edit Password" />
						</sec:ifNotGranted>
					</g:link>



					<sec:ifAllGranted roles="ROLE_ADMIN">
						<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
					</sec:ifAllGranted>
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
