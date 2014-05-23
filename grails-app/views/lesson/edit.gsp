<%@ page import="ar.com.okada.Lesson" %>

<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title><g:message code="edit.lesson" default="Editar clase" /></title>
    <script>
        var ids = ${lessonInstance.students*.id};
    </script>

</head>

<body>
<a href="#edit-event" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                            default="Skip to content&hellip;"/></a>

<div id="edit-event" class="content scaffold-edit" role="main">
    <div class="nav" role="navigation">
        <ul>
        </ul>
    </div>
    <h1><g:message code="edit.lesson" default="Editar clase" /></h1>
    <g:if test="${flash.message}">
        <div class="message" role="status">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${lessonInstance}">
        <ul class="errors" role="alert">
            <g:eachError bean="${lessonInstance}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                        error="${error}"/></li>
            </g:eachError>
        </ul>
    </g:hasErrors>
    <g:form method="post" class="main">
        <g:hiddenField name="id" value="${lessonInstance?.id}"/>
        <g:hiddenField name="version" value="${lessonInstance?.version}"/>
        <g:hiddenField name="editType" value="" />

        <fieldset class="form">
            <div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'active', 'error')}">
                <label for="active"><g:message code="lesson.active.label" default="Active" /></label>
                <g:checkBox name="active" value="${lessonInstance.active}" />
            </div>
            <g:render template="form"/>
        </fieldset>
        <fieldset class="buttons">

            <g:actionSubmit class="save ${lessonInstance.isRecurring ? 'recurring' : ''}" action="update"
                            value="${message(code: 'default.button.update.label', default: 'Update')}"/>
            <sec:ifAllGranted roles="ROLE_ADMIN">
                <g:actionSubmit class="delete ${lessonInstance.isRecurring ? 'recurring' : ''}" action="delete"
                            value="${message(code: 'default.button.delete.label', default: 'Delete')}" formnovalidate="" />
            </sec:ifAllGranted>
        </fieldset>

    </g:form>
    
    <g:if test="${lessonInstance.isRecurring}">
        <g:render template="editPopup" model="model" />
        <g:render template="deletePopup" model="model" />
    </g:if>

</div>

</body>
</html>
