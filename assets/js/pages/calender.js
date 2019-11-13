/*------------------------------------------------------------------
 [ Calender  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   Calender Page
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    calendario_trigger_call();
    full_calendar_trigger_call();
    dragablaeElementSet();

});
/****** calendario Start*****/
var transEndEventNames, transEndEventName;
var $wrapper,$calendar,cal,$month,$year;

function calendario_trigger_call(){
    'use strict';

    transEndEventNames = {
        'WebkitTransition': 'webkitTransitionEnd',
        'MozTransition': 'transitionend',
        'OTransition': 'oTransitionEnd',
        'msTransition': 'MSTransitionEnd',
        'transition': 'transitionend'
    },
        transEndEventName = transEndEventNames[ Modernizr.prefixed('transition') ],
        $wrapper = $('#custom-inner'),
        $calendar = $('#calendar'),
        cal = $calendar.calendario({
            onDayClick: function ($el, $contentEl, dateProperties) {

                if ($contentEl.length > 0) {
                    showEvents($contentEl, dateProperties);
                }

            },
            caldata: codropsEvents,
            displayWeekAbbr: true
        }),
        $month = $('#custom-month').html(cal.getMonthName()),
        $year = $('#custom-year').html(cal.getYear());
    $('#custom-next').on('click', function () {
        cal.gotoNextMonth(updateMonthYear);
    });
    $('#custom-prev').on('click', function () {
        cal.gotoPreviousMonth(updateMonthYear);
    });
}
function updateMonthYear() {
    'use strict';

    $month.html(cal.getMonthName());
    $year.html(cal.getYear());
}

// just an example..
function showEvents($contentEl, dateProperties) {
    'use strict';

    hideEvents();

    var $events = $('<div id="custom-content-reveal" class="custom-content-reveal"><h4>Events for ' + dateProperties.monthname + ' ' + dateProperties.day + ', ' + dateProperties.year + '</h4></div>'),
        $close = $('<span class="custom-content-close"></span>').on('click', hideEvents);

    $events.append($contentEl.html(), $close).insertAfter($wrapper);

    setTimeout(function () {
        $events.css('top', '0%');
    }, 25);

}

function hideEvents() {
    'use strict';

    var $events = $('#custom-content-reveal');
    if ($events.length > 0) {

        $events.css('top', '100%');
        Modernizr.csstransitions ? $events.on(transEndEventName, function () {
            $(this).remove();
        }) : $events.remove();

    }

}
/****** calendario End *****/
/****** fullcalendar Start *****/
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();
var $trash = $("#trash");
var full_calendar;

function full_calendar_trigger_call(){
    'use strict';

    full_calendar = $('#full-calendar').fullCalendar({
        /*height: 650,*/
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        selectable: true,
        selectHelper: true,
        select: function (start, end, allDay) {
            bootbox.prompt("Event name?", function (result) {
                if (result === null) {

                } else {

                    full_calendar.fullCalendar('renderEvent',
                        {
                            title: result,
                            start: start,
                            end: end,
                            allDay: allDay
                        },
                        true // make the event "stick"
                    );
                }
                full_calendar.fullCalendar('unselect');
            });
        },
        editable: true,
        events: [
            {
                title: 'All Day Event',
                start: new Date(y, m, 1)
            },
            {
                title: 'Long Event',
                start: new Date(y, m, d - 5),
                end: new Date(y, m, d - 2)
            },
            {
                id: 999,
                title: 'Repeating Event',
                start: new Date(y, m, d - 3, 16, 0),
                allDay: false
            },
            {
                id: 999,
                title: 'Repeating Event',
                start: new Date(y, m, d + 4, 16, 0),
                allDay: false
            },
            {
                title: 'Meeting',
                start: new Date(y, m, d, 10, 30),
                allDay: false
            },
            {
                title: 'Lunch',
                start: new Date(y, m, d, 12, 0),
                end: new Date(y, m, d, 14, 0),
                allDay: false
            },
            {
                title: 'Birthday Party',
                start: new Date(y, m, d + 1, 19, 0),
                end: new Date(y, m, d + 1, 22, 30),
                allDay: false
            },
            {
                title: 'Click for Google',
                start: new Date(y, m, 28),
                end: new Date(y, m, 29),
                url: 'http://google.com/'
            }
        ],
        droppable: true, // this allows things to be dropped onto the calendar !!!
        drop: function (date, allDay) { // this function is called when something is dropped
            //console.log("Dropped on " + date + " with allDay=" + allDay);
            // retrieve the dropped element's stored Event Object
            var originalEventObject = $(this).data('eventObject');

            // we need to copy it, so that multiple events don't have a reference to the same object
            var copiedEventObject = $.extend({}, originalEventObject);

            // assign it the date that was reported
            copiedEventObject.start = date;
            copiedEventObject.allDay = allDay;

            // render the event on the calendar
            // the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
            $('#full-calendar').fullCalendar('renderEvent', copiedEventObject, true);

            // is the "remove after drop" checkbox checked?
            if ($('#drop-remove').is(':checked')) {
                // if so, remove the element from the "Draggable Events" list
                $(this).remove();
            }

        },
        eventDragStart: eventDragStart,
        /*events: "json-events.php",*/
        loading: function (bool) {
            if (bool) $('#loading').show();
            else $('#loading').hide();
        }
    });
    full_calendar_control();
}
function full_calendar_control(){
    'use strict';

    $('button.addEvent').click(function () {
        bootbox.prompt("Draggable Event name?", function (result) {
            if (result != null && result != "") {
                var $html = "<div class='external-event'>" + result + "</div>";
                $("div.eventList").append($html);
                dragablaeElementSet();
            }
        });
    });
    $trash.droppable({
        drop: function (event, ui) {
            /*console.log(event);*/
            /*console.log($(ui));*/
            $(ui.draggable).remove();
            $('#trash').removeClass('active');
        }
    });
}
function eventDragStart(event, jsEvent, ui, view) {
    'use strict';

    /*console.log(event);
     console.log(jsEvent);
     console.log(ui);
     console.log(view);*/
}
function dragablaeElementSet() {
    'use strict';

    $('#external-events div.external-event').each(function () {

        // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
        // it doesn't need to have a start or end
        var eventObject = {
            title: $.trim($(this).text()) // use the element's text as the event title
        };

        // store the Event Object in the DOM element so we can get to it later
        $(this).data('eventObject', eventObject);

        // make the event draggable using jQuery UI
        $(this).draggable({
            zIndex: 999,
            revert: true,      // will cause the event to go back to its
            revertDuration: 0,  //  original position after the drag
            start: startDraging,
            stop: stopDraging
        });

    });
}
function startDraging() {
    'use strict';

    $('#trash').addClass('active');
}

function stopDraging() {
    'use strict';

    $('#trash').removeClass('active');
}

/****** fullcalendar End *****/