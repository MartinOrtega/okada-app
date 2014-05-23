
<%@ page import="ar.com.okada.Payment" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'paymentToTeacher.label', default: 'Payment to Teacher')}" />
		<title><g:message code="default.list.title.label" args="[entityName + 'e']" /></title>
	</head>
	<body>
		<a href="#list-debtors" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><g:link class="list" action="debtors"><g:message code="debtors.label" default="Debtors" /></g:link></li>
				<li><g:link class="list" action="index"><g:message code="payments.label" default="Payments" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="['Pago']" /></g:link></li>
			</ul>
		</div>
		<div id="list-payment" class="content scaffold-list" role="main">
			<h1><g:message code="paymentsToTeachers.label" default="Payment to Teachers" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<th><g:message code="teacher.label" default="Teacher" /></th>

						<th><g:message code="amount.label" default="Amount" /></th>
						
					</tr>
				</thead>
				<tbody>
				<g:each in="${paymentsList}" status="i" var="payment">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td
						<g:link controller="teacher" action="show" id="${payment.teacher.id}">${payment.teacher.encodeAsHTML()}</g:link></td>

						<td>$ ${fieldValue(bean: payment, field: "amount")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${paymentCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
