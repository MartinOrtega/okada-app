$(document).ready(function() {
    renderCalendar();
    setupDatePickers();
    setupRecurOptions();
    setupRecurSavePopups();
    renderCalendarCreatePopup();
});

function renderCalendarCreatePopup() {
    $(".fc-day").on('click' , function() {
        $(this).qtip({
            content: {
                text: ' ',
                ajax: {
                    url: "create",
                    type: "GET",
                    data: {startTime: $(this).attr('data-date')}
                }
            },
            show: {
                ready: true,
                event: false,
                solo: true
            },
            hide: {
                event: 'unfocus'
            },
            style: {
                width: '500px',
                widget: true
            },
            position: {
                my: 'bottom middle',
                at: 'top middle',
                viewport: true
            }
        });
    });
}

function renderCalendar() {
    $("#calendar").fullCalendar({
        events: 'list.json',
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        eventRender: function(event, element) {
            $(element).addClass(event.cssClass);

            var occurrenceStart = event.occurrenceStart;
            var occurrenceEnd = event.occurrenceEnd;

            var data = {id: event.id, occurrenceStart: occurrenceStart, occurrenceEnd: occurrenceEnd};

            $(element).qtip({
                content: {
                    text: ' ',
                    ajax: {
                        url: "show",
                        type: "GET",
                        data: data
                    }
                },
                show: {
                    event: 'click',
                    solo: true
                },
                hide: {
                    event: 'unfocus'
                },
                style: {
                    width: '500px',
                    widget: true
                },
                position: {
                    my: 'bottom middle',
                    at: 'top middle',
                    viewport: true
                }
            });
        },
        eventMouseover: function(event, jsEvent, view) {
            $(this).addClass("active");
        },
        eventMouseout: function(event, jsEvent, view) {
           $(this).removeClass("active");
        }
    });
}

function setupDatePickers() {
    $("input.datetime").datetimepicker({
        addSliderAccess: true,
        sliderAccessArgs: { touchonly: false },
        numberOfMonths: 2,
        ampm: true,
        stepMinute: 5
    });

    $("input.datepicker").datepicker();
}


function setupRecurSavePopups() {

    $( document ).on( "click", ".delete.recurring", function() {
        $("#deletePopup").dialog({
            title: "Borrar clases",
            width: 400,
            modal: true
         });

        return false;
    });

    var editPopup = $("#editPopup").dialog({
        title: "Editar clases",
        width: 400,
        modal: true,
        autoOpen: false
    });

    $(".save.recurring").click(function() {
        var editTypeField = $("#editType");

        if ($(editTypeField).val() == "") {
            $(editPopup).dialog('open');
            return false;
            alert('lalala')
        }
        else {
            return true;
            alert('false')
        }
    });

    $("#editPopup button").click(function() {
        $("#editType").val($(this).val());
        $(editPopup).dialog('close');
        $(".save.recurring").trigger('click');
    });

}


function setupRecurOptions() {

    $("#isRecurring").change(function() {
        if ($(this).is(":checked")) {
            showRecurPopup();
            $("#editRecurringLink").show();
        }
        else {
            $("#editRecurringLink").hide();
        }

        updateRecurDescriptions();
    });


    $("#editRecurringLink").click(function() {
        showRecurPopup();
    });

    $("#recurType").change(function() {

        if ($(this).val() == "WEEKLY") {
            $("#weeklyOptions").show();
        }
        else {
            $("#weeklyOptions").hide();
        }

        updateRecurDescriptions();
    });

    $("#recurInterval, input[name='recurDaysOfWeek']").change(function() {
        updateRecurDescriptions();
    });


    $("input[name='recurEndOption']").click(function() {
        if ($(this).val() == "never") {
            $("#recurUntil").val('');
            $("#recurCount").val('');
        }
        if ($(this).val() == "occurrences") {
            $("#recurUntil").val('');
        }
        else {
            $("#recurCount").val('');
        }
        updateRecurDescriptions();
    });

    $("#recurUntil, #recurCount").focusout(function() {
        // Make sure correct option is checked
        var checkboxId = + $(this).parent("label").attr("for");
        $("#" + checkboxId).attr("checked", true);

        updateRecurDescriptions();
    });

    $("#recurUntil").datetimepicker({
        ampm: true,
        onSelect: function(dateText, inst) {
            // Make sure correct option is checked
            var checkboxId = + $(this).parent("label").attr("for");
            $("#" + checkboxId).attr("checked", true);

            updateRecurDescriptions();
        }
    });

    updateRecurDescriptions();
}

function showRecurPopup() {

    var recurPopup = $("#recurPopup").dialog({
        title: 'Repetir',
        width: 400,
        modal: true,
        open: function(event, ui) {
          $("#recurOptions").show().appendTo("#recurPopup");
        },
        close: function(event, ui) {
          $("#recurOptions").hide().appendTo("form.main");
        },
        buttons: {
            Ok: function() {
                $( this ).dialog( "close" );
            }
        }
    });

}


function getRecurDescription() {
    var description = ' ';
    var recurTypeText = $("#recurType option:selected").text();
    var recurTypeValue = $("#recurType option:selected").val();
    var recurUntil = $("#recurUntil").val();
    var recurCount = $("#recurCount").val();
    var recurInterval = $("#recurInterval").val();

    if ($("#isRecurring").is(":checked")) {

        if (recurInterval == 1) {
            description += recurTypeText;
        }
        else {
            description += "Cada " + recurInterval + " " + getRecurTypeUnit(recurTypeValue);
        }

        if (recurTypeValue.toLowerCase() == "weekly") {
            description += " los dias ";
            $("input[name='recurDaysOfWeek']:checked").each(function() {
                description += " " + $(this).attr("title") + ",";
            });
            // Remove last comma
            description = description.replace(/,$/,'');
        }

        if (recurCount) {
            description += ", " + recurCount + " veces" ;
        }
        else if (recurUntil) {
            description += ", hasta el " + recurUntil;
        }

    }
    else {
        description = "..." ;
    }

    return description;
}

function getRecurTypeUnit(recurType) {
    var result = "";
    if(recurType){
        switch(recurType.toLowerCase())
        {
            case "daily":
                result = "dias";
                break;
            case "weekly":
                result = "semanas";
                break;
            case "monthly":
                result = "meses";
                break;
            case "yearly":
                result = "años";
        }
    }
    return result;
}


function updateRecurDescriptions() {
    var recurType = $("#recurType option:selected").val();
    var repeatType = getRecurTypeUnit(recurType);
    $("#repeatLabel").html(repeatType);

    var description = getRecurDescription();
    $("#recurDescription").html(description);
    $("#recurSummary").html(description);
}
