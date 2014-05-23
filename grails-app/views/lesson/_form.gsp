<%@ page import="ar.com.okada.Lesson" %>
<%@ page import="ar.com.okada.LessonRecurType" %>
<%@ page import="ar.com.okada.Location" %>
<%@ page import="ar.com.okada.Student" %>
<%@ page import="org.joda.time.Instant" %>

<g:set var="entityName" value="${message(code: 'lesson.label', default: 'Event')}" />

<div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'title', 'error')}">
    <label for="title">
        <g:message code="title.label" default="Title" />
        <span class="required-indicator">*</span>
    </label>
    <g:textField required="" name="title" value="${lessonInstance?.title}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'startTime', 'error')}">
    <label for="startTime">
        <g:message code="startTime.label" default="Start Time" />
        <span class="required-indicator">*</span>
    </label>
    <g:textField required="" name="startTime"
         value="${formatDate(date: occurrenceStart ? new Instant(occurrenceStart).toDate() : lessonInstance?.startTime, format: 'dd/MM/yyyy HH:mm')}"
         class="datetime" />
    <input type="hidden" name="dayToExclude" value="${formatDate(date: occurrenceStart ? new Instant(occurrenceStart).toDate() : lessonInstance?.startTime, format: 'dd/MM/yyyy HH:mm')}"/>
</div>


<div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'endTime', 'error')}">
    <label for="endTime">
        <g:message code="endTime.label" default="End Time" />
        <span class="required-indicator">*</span>
    </label>
    <g:textField required="" name="endTime"
         value="${formatDate(date: occurrenceEnd ? new Instant(occurrenceEnd).toDate() : lessonInstance?.endTime, format: 'dd/MM/yyyy HH:mm')}"
         class="datetime" />
</div>

<div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'isRecurring', 'error')}">
    <label for="isRecurring"><g:message code="lesson.isRecurring.label" default="Repeat" /></label>
    <g:checkBox name="isRecurring" value="${lessonInstance.isRecurring}" />
    <span id="recurDescription"></span>
    <a id="editRecurringLink" ${lessonInstance.isRecurring ?  "" : 'style=display:none'} href="#">Editar</a>
</div>

<div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'teacher', 'error')}">
    <label for="teacher">
        <g:message code="teacher.label" default="Teacher" />
        <span class="required-indicator">*</span>
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
        <g:message code="location.label" default="Location" />
        <span class="required-indicator">*</span>
    </label>    
    <g:select required="" id="location" name="location.id" from="${ar.com.okada.Location.list()}" optionKey="id" value="${lessonInstance?.location?.id}" class="many-to-one" noSelection="['': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'price', 'error')}">
    <label for="price">
        <g:message code="price.label" default="Price" />
        <span class="required-indicator">*</span>
    </label>
    <g:textField required="" name="price" value="${lessonInstance?.price}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'students', 'error')}">
    <label for="students"><g:message code="students.label" default="Students" /></label>

    <select class="multiselect" multiple="multiple" id="students" name="students">
        <g:each in="${Student.list()}" var="studentInstance">
            <option value="${studentInstance.id}">${studentInstance}</option>
        </g:each>
    </select>
</div>

<div class="fieldcontain ${hasErrors(bean: lessonInstance, field: 'description', 'error')}">
    <label for="description"><g:message code="description.label" default="Description" /></label>
    <g:textArea name="description"  value="${lessonInstance?.description}" />
</div>


<div id="recurPopup"></div>
<div id="recurOptions" style="display:none" >

    <table>
        <tr>
            <td>
                <label>Se repite:</label>
            </td>
            <td>
                <g:select name="recurType" from="${LessonRecurType.values()}" optionValue="name" value="${lessonInstance?.recurType}"/>
            </td>
        </tr>
        <tr>
            <td>
                <label>Repetir cada:</label>
            </td>
            <td>
            <g:select name="recurInterval" from="${1..30}" value="${lessonInstance?.recurInterval}" />
            <span id="repeatLabel"></span>
            </td>
        </tr>
        <tr id="weeklyOptions" ${lessonInstance.recurType != LessonRecurType.WEEKLY ? 'style=display:none' : ''}>
            <td>
                <label>Repetir el: </label>
            </td>
            <td>
                <div class="options">
                    <calendar:daysOfWeek name="recurDaysOfWeek" selectedDays="${lessonInstance?.recurDaysOfWeek}" />
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <label>Finaliza:</label>
            </td>
            <td>
                <div class="input">
                    <input id="recurEndOption1" name="recurEndOption" type="radio" group="recurEndOption" ${(!lessonInstance.recurCount && !lessonInstance.recurUntil) ? 'checked="checked"' : ''} value="never" />
                    <label for="recurEndOption1">Nunca</label><br />

                    <input id="recurEndOption2" name="recurEndOption" type="radio" group="recurEndOption" ${(lessonInstance.recurCount) ? 'checked="checked"' : ''} value="occurrences" />
                    <label for="recurEndOption2">Despues de <g:textField name="recurCount" size="3" value="${lessonInstance?.recurCount}" /> repeticiones</label><br/>

                    <input id="recurEndOption3" name="recurEndOption" type="radio" group="recurEndOption" ${(!lessonInstance.recurCount && lessonInstance.recurUntil) ? 'checked="checked"' : ''} value="endDate" />
                    <label for="recurEndOption3">El <g:textField name="recurUntil" size="8" value="${formatDate(date: (lessonInstance?.recurCount ? null : lessonInstance?.recurUntil), format: 'dd/MM/yyyy HH:mm')}" /></label>
                </div>
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td><strong><span id="recurSummary"></span></strong></td>
        </tr>
    </table>
</div>
