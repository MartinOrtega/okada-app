<%@ page import="org.joda.time.Instant" %>

<div class="eventPopup">

<h2>${lessonInstance.title}</h2>
<h4>${lessonInstance.description}</h4>
<h5>Profesor: ${lessonInstance.teacher}</h5>
<g:message code="location.label" default="Location" />: ${lessonInstance.location}
<p class="date">
    Desde: <g:formatDate date="${new Instant(occurrenceStart).toDate()}" format="E dd MMM, HH:mm"/> </br>
    Hasta: <g:formatDate date="${new Instant(occurrenceEnd).toDate()}" format="E dd MMM, HH:mm"/>
</p>
<p>
    <g:link action="show" id="${lessonInstance.id}" params="[occurrenceStart: occurrenceStart, occurrenceEnd: occurrenceEnd]">Mas Detalles »</g:link>

    <g:link action="edit" id="${lessonInstance.id}" params="[occurrenceStart: occurrenceStart, occurrenceEnd: occurrenceEnd]">Editar »</g:link>
</p>
</div>