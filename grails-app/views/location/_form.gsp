<%@ page import="ar.com.okada.Location" %>
<%@ page import="ar.com.okada.ColorType" %>



<div class="fieldcontain ${hasErrors(bean: locationInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${locationInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: locationInstance, field: 'color', 'error')} ">
	<label for="color">
		<g:message code="color.label" default="Color" />
		<span class="required-indicator">*</span>
	</label>
	<g:select required="" name="color" from="${ColorType.values()}" optionValue="name" value="${locationInstance?.color}" noSelection="['': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: locationInstance, field: 'description', 'error')} ">
	<label for="description">
		<g:message code="description.label" default="Description" />
		
	</label>
	<g:textField name="description" value="${locationInstance?.description}"/>
</div>


