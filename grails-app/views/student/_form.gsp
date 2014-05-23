<%@ page import="ar.com.okada.Student" %>
<%@ page import="ar.com.okada.Lesson" %>
<%@ page import="ar.com.okada.SexType" %>


<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${studentInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'lastName', 'error')} required">
	<label for="lastName">
		<g:message code="lastName.label" default="Last Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="lastName" required="" value="${studentInstance?.lastName}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'lessons', 'error')}">
    <label for="lessons"><g:message code="courses.label" default="Lessons" /></label>

    <select class="multiselect" multiple="multiple" id="lessons" name="lessons">
        <g:each in="${Lesson.list()}" var="lessonInstance">
            <option value="${lessonInstance.id}">${lessonInstance.title + " - " + lessonInstance.getWhenReduced()}</option>
        </g:each>
    </select>
</div>

<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'dni', 'error')} ">
	<label for="dni">
		<g:message code="dni.label" default="Dni" />
		
	</label>
	<g:textField name="dni" value="${studentInstance?.dni}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'age', 'error')} ">
	<label for="age">
		<g:message code="age.label" default="Age" />
		
	</label>
	<g:textField name="age" value="${studentInstance?.age}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'gender', 'error')} ">
	<label for="gender">
		<g:message code="gender.label" default="Gender" />
		
	</label>
	<g:each in="${SexType.values()}">
    	<g:radio name="gender" value="${it}" checked="${it == studentInstance?.gender}"/>
    	${it.name}
	</g:each>
</div>

<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'mail', 'error')} ">
	<label for="mail">
		<g:message code="mail.label" default="Mail" />
		
	</label>
	<g:field type="email" name="mail" value="${studentInstance?.mail}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: studentInstance, field: 'phone', 'error')} ">
	<label for="phone">
		<g:message code="phone.label" default="Phone" />
		
	</label>
	<g:textField name="phone" value="${studentInstance?.phone}"/>
</div>

