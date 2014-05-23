<%@ page import="ar.com.okada.Payment" %>
<%@ page import="org.joda.time.Instant" %>

<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'date', 'error')} required">
	<label for="date">
		<g:message code="date.label" default="Date" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField required="" name="date"
         value="${formatDate(date: paymentInstance.date, format: 'dd/MM/yyyy')}"
         class="datepicker" />
</div>

<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'amount', 'error')} required">
	<label for="amount">
		<g:message code="amount.label" default="Amount" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="amount" value="${fieldValue(bean: paymentInstance, field: 'amount')}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'type', 'error')} required">
	<label for="type">
		<g:message code="type.label" default="Pago A" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="type" name="type" from="${['Alumno', 'Profesor']}" required="" noSelection="['': '']" onchange="${remoteFunction (controller: 'payment', action: 'selectPersonType', params: ' \'type=\' +this.value', update: 'person')}" />
</div>


<div id="person">
</div>

