<%@ page import="ar.com.okada.Lesson" %>
<%@ page import="org.joda.time.Instant" %>


<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'event.label', default: 'Event')}"/>
    <title><g:message code="default.show.label" args="['Curso']"/></title>
</head>

<body>
<a href="#show-event" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                            default="Skip to content&hellip;"/></a>

<div class="nav" role="navigation">
    <ul>
        <li><g:link action="create" class="create">Nueva Clase</g:link></li>
    </ul>
</div>

<div id="show-event" class="content scaffold-show" role="main">
    <h1><g:message code="default.show.label" args="['Curso']" /></h1>


    <g:if test="${flash.message}">
        <div class="message" role="status">${flash.message}</div>
    </g:if>

    <ol class="property-list event">

        
        <li class="fieldcontain">
            <span id="title-label" class="property-label"><g:message code="title.label"
                                                                            default="Title"/></span>

            <span class="property-value" aria-labelledby="title-label">
                ${lessonInstance?.title}
            </span>

        </li>

        <li class="fieldcontain">
            <span id="when-label" class="property-label"><g:message code="when.label"
                                                                            default="When"/></span>

            <span class="property-value" aria-labelledby="when-label">
                ${lessonInstance.getWhen()}
            </span>

        </li>

        <g:if test="${lessonInstance?.teacher}">
            <li class="fieldcontain">
                <span id="teacher-label" class="property-label"><g:message code="teacher.label"
                                                                            default="Teacher"/></span>

                <span class="property-value" aria-labelledby="teacher-label"><g:fieldValue bean="${lessonInstance}"
                                                                                            field="teacher"/></span>

            </li>
        </g:if>

        <g:if test="${lessonInstance?.location}">
            <li class="fieldcontain">
                <span id="location-label" class="property-label"><g:message code="location.label"
                                                                            default="Location"/></span>

                <span class="property-value" aria-labelledby="location-label"><g:fieldValue bean="${lessonInstance}"
                                                                                            field="location"/></span>

            </li>
        </g:if>

        <li class="fieldcontain">
            <span id="price-label" class="property-label"><g:message code="price.label"
                                                                        default="Price"/></span>

            <span class="property-value" aria-labelledby="price-label"><g:fieldValue bean="${lessonInstance}"
                                                                                        field="price"/></span>

        </li>

        <g:if test="${lessonInstance?.description}">
            <li class="fieldcontain">
                <span id="description-label" class="property-label"><g:message code="description.label"
                                                                               default="Description"/></span>

                <span class="property-value" aria-labelledby="description-label"><g:fieldValue bean="${lessonInstance}"
                                                                                               field="description"/></span>

            </li>
        </g:if>

        <g:if test="${lessonInstance?.students}">
            <li class="fieldcontain">
                <span id="description-label" class="property-label"><g:message code="students.label"
                                                                               default="Students"/></span>

                <span class="property-value" aria-labelledby="description-label">

                <g:each in="${lessonInstance.students}" var="studentInstance">
                    ${studentInstance}</br>
                </g:each>
            </li>
        </g:if>

    </ol>
    <g:form>
        <fieldset class="buttons">
            <g:hiddenField name="id" value="${lessonInstance?.id}"/>

            <g:hiddenField name="occurrenceStart" value="${occurrenceStart}" />
            <g:hiddenField name="occurrenceEnd" value="${occurrenceEnd}" />

            <g:actionSubmit class="edit" action="edit"
                            value="${message(code: 'default.button.edit.label', default: 'Edit')}"/>
            <sec:ifAllGranted roles="ROLE_ADMIN">
                <g:actionSubmit class="delete ${lessonInstance.isRecurring ? 'recurring' : ''}" action="delete"
                            value="${message(code: 'default.button.delete.label', default: 'Delete')}" />
            </sec:ifAllGranted>
        </fieldset>
    </g:form>

    <g:if test="${lessonInstance.isRecurring}">
        <g:render template="deletePopup" model="model" />
    </g:if>

</div>
</body>
</html>
