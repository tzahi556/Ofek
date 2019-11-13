/*------------------------------------------------------------------
 [ Task & Note  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   Task & Note Page
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    progressbar_trigger_call();
    task_progress();
    task_progress_change();

    live_note_trigger_call();
    add_new_live_note();
});


function progressbar_trigger_call(){
    'use strict';

    $('.progress-bar').progressbar({
        display_text: 'fill'
    });
}
/************ Task Progress **************/
$(document).on("click", "button.removeTask", function () {
    $(this).parent('li').remove();
    new Slip(ol);
});
var ol;
function  task_progress(){
    'use strict';

    ol = document.getElementById('slippylist');
    ol.addEventListener('slip:beforereorder', function (e) {
        if (/demo-no-reorder/.test(e.target.className)) {
            e.preventDefault();
        }
    }, false);

    ol.addEventListener('slip:beforeswipe', function (e) {
        if (e.target.nodeName == 'INPUT' || /demo-no-swipe/.test(e.target.className)) {
            e.preventDefault();
        }
    }, false);

    ol.addEventListener('slip:beforewait', function (e) {
        if (e.target.className.indexOf('instant') > -1) e.preventDefault();
    }, false);

    ol.addEventListener('slip:afterswipe', function (e) {
        //console.log(e.target);
        e.target.parentNode.removeChild(e.target);
    }, false);

    ol.addEventListener('slip:reorder', function (e) {
        e.target.parentNode.insertBefore(e.target, e.detail.insertBefore);
        return false;
    }, false);

    new Slip(ol);
}

function task_progress_change(){
    'use strict';

    $('ul#slippylist li i').click(function(){
        if($(this).parent('li').hasClass('strikeout')){
            $(this).parent('li').removeClass('strikeout');
            $(this).addClass('fa-circle-o');
            $(this).removeClass('fa-check');
        } else{
            $(this).addClass('fa-check');
            $(this).removeClass('fa-circle-o');
            $(this).parent('li').addClass('strikeout');

        }
    });
    new_task_add();
}
function new_task_add(){
    'use strict';

    $('#newTaskAdd').click(function () {

        if ($('#newTask').val()) {
            var $html =
                '<li>' +
                '<i class="fa fa-circle-o"></i> ' +
                '<span>' + $('#newTask').val() + '</span> ' +
                '<button class="btn ls-red-btn removeTask">' +
                '<i class="fa fa-trash-o"></i>' +
                '</button>' +
                '</li>';

            $('#slippylist').append($html);
            new Slip(ol);
            $('#newTask').val('');
        } else {
            /*console.log($('#newTask').val());*/
        }
    });
}
/************ Task Progress **************/

/************  Live Note  **************/
$(window).resize(function(){
    gridLiveNoteReload();
});

var $noteContent = $('.note-content');

function  live_note_trigger_call(){
    'use strict';

    // initialize
    $noteContent.masonry({
        itemSelector: '.panel-note'
    });
    $('.customToolBar').summernote({
        toolbar: [
            //[groupname, [button list]]

            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['font', ['strikethrough']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']],
        ]
    });

    noteButtonAction();
}
function gridLiveNoteReload(){
    'use strict';

    var $noteContent = $('.note-content');
    $noteContent.masonry();
}
function add_new_live_note(){
    'use strict';

    try{
        $("#note-form").submit(function(e){
            var noteHeading = $('#note-heading').val();
            var noteStyle = $('#note-style').val();
            var note = $('.customToolBar').code();

            var $html = "<div class='col-md-4 col-sm-6 col-xs-11 col-lg-4 panel-note'>"+
                "<div class='panel "+noteStyle+"'>"+
                "<div class='panel-heading'>"+
                "<h3 class='panel-title'>"+noteHeading+"</h3>"+
                "<ul class='panel-note-control'>"+
                "<li><a class='minus' href='javascript:void(0)'><i class='fa fa-minus'></i></a></li>"+
                "<li><a class='close-panel' href='javascript:void(0)'><i class='fa fa-times'></i></a></li>"+
                "</ul>"+
                "</div>"+
                "<div class='panel-body'>"+
                "<div class='myEditor'>"+
                note+
                "</div>"+
                "</div>"+
                "</div>"+
                "</div>";

            $('.note-content').prepend($html);
            $noteContent.masonry('destroy');

            $noteContent.masonry({
                itemSelector: '.panel-note'
            });


            /*$('.myEditor').destroy();*/


            $('.panel-note-control li a.minus').unbind("click");
            $('.panel-note-control li a.close-panel').unbind( "click" );

            noteButtonAction();
            $('#myModalSuccess').modal('hide');

            return false;
        });
    } catch (e){

    }
}

function noteButtonAction(){
    'use strict';

    try{
        $('.panel-note-control li a.close-panel').click(function(){
            var $elements = $(this).parents(".panel-note");
            $elements.animate({
                opacity: 0.5
            }, 1000, function() {
                var $noteContent = $('.note-content');
                $noteContent.masonry( 'remove', this);
                gridLiveNoteReload();
            });

        });
        $('.panel-note-control li a.minus').click(function(){
            var $elements = $(this).parents('div.panel-note').children().children("div.panel-body");
            if($(this).hasClass('active')){
                $elements.slideDown(200, function(){
                    gridLiveNoteReload();
                });
                $(this).children('i').removeClass('fa-square-o');
                $(this).children('i').addClass('fa-minus');
                $(this).removeClass('active');

            } else{
                $elements.slideUp(200, function(){
                    gridLiveNoteReload();
                });
                $(this).children('i').removeClass('fa-minus');
                $(this).children('i').addClass('fa-square-o');
                $(this).addClass('active');

            }

        });
        $('.myEditor').summernote({
            airMode: true
        });
    } catch (e){

    }
}


/************  Live Note  **************/