
<%@ page import="ar.com.okada.Payment" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'debtor.label', default: 'Debtor')}" />
		<title><g:message code="default.list.title.label" args="[entityName + 'e']" /></title>
	</head>
	<body>
		<a href="#list-debtors" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="payments.label" default="Payments" /></g:link></li>
				<li><g:link class="list" action="paymentToTeachers"><g:message code="paymentsToTeachers.label" default="Payments to Teachers" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="['Pago']" /></g:link></li>
			</ul>
		</div>
		<div id="list-payment" class="content scaffold-list" role="main">
			<h1><g:message code="debtors.label" default="Debtors" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<th><g:message code="student.label" default="Student" /></th>

						<th><g:message code="amount.label" default="Amount" /></th>
						
					</tr>
				</thead>
				<tbody>
				<g:each in="${debtorList}" status="i" var="debtor">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td
						<g:link controller="student" action="show" id="${debtor.id}">${debtor.student.encodeAsHTML()}</g:link></td>

						<td>$ ${fieldValue(bean: debtor, field: "amount")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${debtorCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
