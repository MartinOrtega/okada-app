<%@ page import="ar.com.okada.Lesson" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="main" />
    <title><g:message code="create.lesson" default="Crear curso" /></title>
    <script>
        var ids = "";
    </script>

</head>
<body>
<div class="nav" role="navigation">
    <ul>
    </ul>
</div>
<div id="create-event" class="content scaffold-create" role="main">

<h1><g:message code="create.lesson" default="Crear curso" /></h1>

<g:if test="${flash.message}">
    <div class="alert-message block-message info">${flash.message}</div>
</g:if>

<g:hasErrors bean="${lessonInstance}">
    <ul class="errors" role="alert">
        <g:eachError bean="${lessonInstance}" var="error">
            <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                    error="${error}"/></li>
        </g:eachError>
    </ul>
</g:hasErrors>

<g:form action="save" class="main" method="post" >

    <fieldset class="form">
        <g:render template="form" model="model" />
    </fieldset>

    <fieldset class="buttons">
        <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
    </fieldset>

</g:form>

</div>
</body>
</html>