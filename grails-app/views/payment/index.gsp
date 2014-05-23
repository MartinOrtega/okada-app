
<%@ page import="ar.com.okada.Payment" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'payment.label', default: 'Payment')}" />
		<title><g:message code="default.list.title.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-payment" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><g:link class="list" action="debtors"><g:message code="debtors.label" default="Debtors" /></g:link></li>
				<li><g:link class="list" action="paymentToTeachers"><g:message code="paymentsToTeachers.label" default="Payment to Teachers" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-payment" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
						
						<g:sortableColumn property="date" title="${message(code: 'date.label', default: 'Date')}" />

						<g:sortableColumn property="amount" title="${message(code: 'amount.label', default: 'Amount')}" />
					
						<th><g:message code="student.label" default="Student" /></th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${paymentInstanceList}" status="i" var="paymentInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${paymentInstance.id}"><g:formatDate date="${paymentInstance.date}" format="dd-MM-yyyy" /></g:link></td>
					
						<td>${fieldValue(bean: paymentInstance, field: "amount")}</td>
					
						<td>${fieldValue(bean: paymentInstance, field: "student")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${paymentInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
