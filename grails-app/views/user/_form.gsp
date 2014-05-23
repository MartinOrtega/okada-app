<%@ page import="ar.com.okada.security.User" %>
<%@ page import="ar.com.okada.security.RoleType" %>


<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'username', 'error')} required">
	<label for="username">
		<g:message code="username.label" default="Username" />
		<span class="required-indicator">*</span>
	</label>
	<sec:ifAllGranted roles="ROLE_ADMIN">
		<g:textField name="username" required="" value="${userInstance?.username}"/>
	</sec:ifAllGranted>
	<sec:ifNotGranted roles="ROLE_ADMIN">
		${userInstance?.username}
	</sec:ifNotGranted>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'password', 'error')} required">
	<label for="password">
		<g:message code="password.label" default="Password" />
		<span class="required-indicator">*</span>
	</label>
	<g:passwordField name="password" required="" value="${userInstance?.password}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'teacher', 'error')} ">
	<label for="teacher">
		<sec:ifAllGranted roles="ROLE_ADMIN">
			<g:message code="teacher.label" default="Teacher" />
		</sec:ifAllGranted>
		<sec:ifNotGranted roles="ROLE_ADMIN">
			<g:message code="user.me.label" default="Me" />
		</sec:ifNotGranted>
	</label>
					
	<sec:ifAllGranted roles="ROLE_ADMIN">
		<g:select id="teacher" name="teacher.id" from="${ar.com.okada.Teacher.list()}" optionKey="id" value="${userInstance?.teacher?.id}" class="many-to-one" noSelection="['null': '']"/>
	</sec:ifAllGranted>
	<sec:ifNotGranted roles="ROLE_ADMIN">
		${userInstance?.teacher}
	</sec:ifNotGranted>
</div>

<sec:ifAllGranted roles="ROLE_ADMIN">
	<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'role', 'error')}">
	    <label for="role"><g:message code="role.label" default="Role" /></label>
	    <g:select name="role" from="${RoleType.values()}" optionValue="name" value="${role}" noSelection="['null': '']"/>
	</div>
</sec:ifAllGranted>
<sec:ifAllGranted roles="ROLE_ADMIN">
	<div class="fieldcontain ${hasErrors(bean: userInstance, field: 'enabled', 'error')} ">
		<label for="enabled">
			<g:message code="user.enabled.label" default="Enabled" />
			
		</label>
		<g:checkBox name="enabled" value="${userInstance?.enabled}" />
	</div>
</sec:ifAllGranted>
