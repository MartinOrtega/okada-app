<%@ page import="ar.com.okada.Lesson" %>
<%@ page import="ar.com.okada.LessonRecurType" %>
<%@ page import="ar.com.okada.Location" %>
<%@ page import="ar.com.okada.Student" %>
<%@ page import="org.joda.time.Instant" %>

<div class="eventPopup">
<div class="ui-dialog-titlebar-2 ui-widget-header ui-corner-all ui-helper-clearfix">
    Crear curso
</div>
<g:form action="save" class="main" method="post" >

    <g:hiddenField name="startTime" value="${formatDate(date: lessonInstance?.startTime, format: 'dd/MM/yyyy HH:mm')}"/>
    <g:hiddenField name="endTime" value="${formatDate(date: lessonInstance?.endTime, format: 'dd/MM/yyyy HH:mm')}"/>


    <div class="fieldcontain">
        <label for="date">
            <g:message code="date.label" default="Date" />:
        </label>
        ${formatDate(date: lessonInstance?.startTime, format: 'EEEE, dd/MM/yyyy')}
    </div>

    <div class="fieldcontain">
        <label for="date">
            Desde
        </label>
        <g:select id="start" name="start" from="${timeList}"/>
        ${' Hasta  '}
        <g:select id="end" name="end" from="${timeList}"/>
    </div>

    <div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'title', 'error')}">
        <label for="title">
            <g:message code="title.label" default="Title" />:
        </label>
        <g:textField required="" name="title" value="${lessonInstance?.title}"/>
    </div>

    <div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'teacher', 'error')}">
        <label for="teacher">
            <g:message code="teacher.label" default="Teacher" />:
        </label>    
        <sec:ifAllGranted roles="ROLE_ADMIN">
            <g:select id="teacher" name="teacher.id" from="${ar.com.okada.Teacher.list()}" optionKey="id" value="${lessonInstance?.teacher?.id}" class="many-to-one" noSelection="['': '']"/>
        </sec:ifAllGranted>
        <sec:ifNotGranted roles="ROLE_ADMIN">
            ${lessonInstance?.teacher}
            <g:hiddenField id="teacher" name="teacher" value="${lessonInstance?.teacher?.id}"/>
        </sec:ifNotGranted>
    </div>

    <div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'location', 'error')}">
        <label for="location">
            <g:message code="location.label" default="Location" />:
        </label>    
        <g:select required="" id="location" name="location.id" from="${ar.com.okada.Location.list()}" optionKey="id" value="${lessonInstance?.location?.id}" class="many-to-one" noSelection="['': '']"/>
    </div>

    <div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'price', 'error')}">
        <label for="price">
            <g:message code="price.label" default="Price" />:
        </label>
        <g:textField name="price" value="${lessonInstance?.price}"/>
    </div>

    </br>
    <fieldset class="buttons">
        <g:submitButton name="Crear" class="save">Save</g:submitButton>
        <g:actionSubmit value="Editar" action="create" class="edit"/>
    </fieldset>

</g:form>
</div>
