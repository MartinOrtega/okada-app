
<%@ page import="ar.com.okada.Teacher" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'teacher.label', default: 'Teacher')}" />
		<title><g:message code="default.list.title.label" args="[entityName + 'e']" /></title>
	</head>
	<body>
		<a href="#list-teacher" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-teacher" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName + 'e']" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="name" title="${message(code: 'name.label', default: 'Name')}" />
					
						<g:sortableColumn property="lastName" title="${message(code: 'lastName.label', default: 'Last Name')}" />
					
						<g:sortableColumn property="dni" title="${message(code: 'dni.label', default: 'Dni')}" />
					
						<g:sortableColumn property="age" title="${message(code: 'age.label', default: 'Age')}" />
					
						<g:sortableColumn property="gender" title="${message(code: 'gender.label', default: 'Gender')}" />
					
						<g:sortableColumn property="mail" title="${message(code: 'mail.label', default: 'Mail')}" />

						<g:sortableColumn property="phone" title="${message(code: 'phone.label', default: 'Phone')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${teacherInstanceList}" status="i" var="teacherInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${teacherInstance.id}">${fieldValue(bean: teacherInstance, field: "name")}</g:link></td>
					
						<td>${fieldValue(bean: teacherInstance, field: "lastName")}</td>
					
						<td>${fieldValue(bean: teacherInstance, field: "dni")}</td>
					
						<td>${fieldValue(bean: teacherInstance, field: "age")}</td>
					
						<td>${teacherInstance?.gender?.name}</td>
					
						<td>${fieldValue(bean: teacherInstance, field: "mail")}</td>

						<td>${fieldValue(bean: teacherInstance, field: "phone")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${teacherInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
