<div id="person">
		<g:if test="${type=='Alumno'}">
			<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'student', 'error')} required">
				<label for="student">
					<g:message code="student.label" default="Student" />
					<span class="required-indicator">*</span>
				</label>
				<g:select id="student" name="student.id" from="${ar.com.okada.Student.list()}" optionKey="id" required="" value="${paymentInstance?.student?.id}" class="many-to-one" noSelection="['': '']"/>
			</div>
		</g:if>
		<g:if test="${type=='Profesor'}">
			<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'teacher', 'error')} required">
				<label for="teacher">
					<g:message code="teacher.label" default="Teacher" />
					<span class="required-indicator">*</span>
				</label>
				<g:select id="teacher" name="teacher.id" from="${ar.com.okada.Teacher.list()}" optionKey="id" required="" value="${paymentInstance?.teacher?.id}" class="many-to-one" noSelection="['': '']"/>
			</div>
		</g:if>
</div>