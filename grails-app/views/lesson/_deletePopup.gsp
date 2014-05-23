<div id="deletePopup" style="display: none;">

<g:form action="delete">
    <g:hiddenField name="id" value="${lessonInstance.id}" />
    <g:hiddenField name="occurrenceStart" value="${occurrenceStart}" />

    <p>Desea eliminar solo esta clase, o todas las del curso?</p>

    <table>
        <tbody>
        <tr>
            <td><button type="submit" name="deleteType" value="occurrence">Solo esta clase</button></td>
            <td>El resto de las clases del curso no se borraran.</td>
        </tr>

        <tr>
            <td><button type="submit" name="deleteType" value="following">Todas las Siguientes</button></td>
            <td>Esta y las siguientes clases del curso seran borradas.</td>
        </tr>
        <tr>
            <td><button type="submit" name="deleteType" value="all">Todas las Clases</button></td>
            <td>Todas las clases del curso seran borradas.</td>
        </tr>
        </tbody>

    </table>

</div>


</g:form>

</div>