<%@ page import="ar.com.okada.Teacher" %>
<%@ page import="ar.com.okada.SexType" %>


<div class="fieldcontain ${hasErrors(bean: teacherInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${teacherInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: teacherInstance, field: 'lastName', 'error')} required">
	<label for="lastName">
		<g:message code="lastName.label" default="Last Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="lastName" required="" value="${teacherInstance?.lastName}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: teacherInstance, field: 'dni', 'error')} ">
	<label for="dni">
		<g:message code="dni.label" default="Dni" />
		
	</label>
	<g:textField name="dni" value="${teacherInstance?.dni}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: teacherInstance, field: 'age', 'error')} ">
	<label for="age">
		<g:message code="age.label" default="Age" />
		
	</label>
	<g:textField name="age" value="${teacherInstance?.age}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: teacherInstance, field: 'gender', 'error')} ">
	<label for="gender">
		<g:message code="gender.label" default="Gender" />
		
	</label>
	<g:each in="${SexType.values()}">
    	<g:radio name="gender" value="${it}" checked="${it == teacherInstance?.gender}"/>
    	${it.name}
	</g:each>
</div>

<div class="fieldcontain ${hasErrors(bean: teacherInstance, field: 'mail', 'error')} ">
	<label for="mail">
		<g:message code="mail.label" default="Mail" />
		
	</label>
	<g:field type="email" name="mail" value="${teacherInstance?.mail}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: teacherInstance, field: 'phone', 'error')} ">
	<label for="phone">
		<g:message code="phone.label" default="Phone" />
		
	</label>
	<g:textField name="phone" value="${teacherInstance?.phone}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: teacherInstance, field: 'notes', 'error')} ">
	<label for="notes">
		<g:message code="notes.label" default="Notes" />
		
	</label>
	<g:textArea name="notes"  value="${teacherInstance?.notes}" />
</div>


