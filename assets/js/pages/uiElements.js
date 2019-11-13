/*------------------------------------------------------------------
 [ Plugin  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   Ui Element Page
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    progress_bar_call();
    toolbar_call();
    rating_call();
    tooltip_pophover_call();
    easy_pie_chart_call();
    tabulous_trigger_call();
    qrcode_call();
    bootbox_trigger_call();
});
function progress_bar_call(){
    'use strict';

    $('.progress-bar').progressbar({
        display_text: 'fill'
    });
}

function toolbar_call(){
    'use strict';

    $('#button-right').toolbar({content: '#user-options', position: 'right'});
    $('#normal-button').toolbar({content: '#user-options', position: 'top'});
    $('#button-left').toolbar({content: '#user-options', position: 'left'});
    $('#button-bottom').toolbar({content: '#user-options', position: 'bottom'});
    $('#link-toolbar').toolbar({content: '#user-options-small', position: 'top' });
}

function rating_call(){
    'use strict';


    $('#ls-rating').on('change', function () {
        var ratingValue = $(this).val();
        if (ratingValue) {
            ratingValue = 'Rating Changed: ' + ratingValue;
        } else {
            ratingValue = 'Rating removed';
        }
        notificationCenter(
            'glyphicon glyphicon-ok',
            'alert-success',
            ratingValue,
            'bottom right'
        );
    });
}

function tooltip_pophover_call(){
    'use strict';


    $('.tooltipLink').tooltip({
        animation: true
    });

    $('.popoverBox').popover({
        animation: true
    });
}
function easy_pie_chart_call(){
    'use strict';

    $('.easyPieChart').easyPieChart({
        barColor: $redActive,
        scaleColor: $redActive,
        easing: 'easeOutBounce',
        onStep: function (from, to, percent) {
            $(this.el).find('.easyPiePercent').text(Math.round(percent));
        }
    });
    var chart1 = window.chart = $('.easyPieChart').data('easyPieChart');
    $('.js_update').on('click', function () {
        chart1.update(Math.random() * 200 - 100);
    });


    $('.easyPieChartBlue').easyPieChart({
        barColor: $lightBlueActive,
        scaleColor: $lightBlueActive,
        easing: 'easeOutBounce',
        onStep: function (from, to, percent) {
            $(this.el).find('.easyPiePercentBlue').text(Math.round(percent));
        }
    });
    var chart2 = window.chart = $('.easyPieChartBlue').data('easyPieChart');
    $('.js_update_blue').on('click', function () {
        chart2.update(Math.random() * 200 - 100);
    });

    $('.easyPieChartGreen').easyPieChart({
        barColor: $greenActive,
        scaleColor: $greenActive,
        easing: 'easeOutBounce',
        onStep: function (from, to, percent) {
            $(this.el).find('.easyPiePercentGreen').text(Math.round(percent));
        }
    });
    var chart3 = window.chart = $('.easyPieChartGreen').data('easyPieChart');
    $('.js_update_green').on('click', function () {
        chart3.update(Math.random() * 200 - 100);
    });


    $('.easyPieChartBrown').easyPieChart({
        barColor: $brownActive,
        scaleColor: $brownActive,
        easing: 'easeOutBounce',
        onStep: function (from, to, percent) {
            $(this.el).find('.easyPiePercentBrown').text(Math.round(percent));
        }
    });
    var chart4 = window.chart = $('.easyPieChartBrown').data('easyPieChart');
    $('.js_update_brown').on('click', function () {
        chart4.update(Math.random() * 200 - 100);
    });
}

function tabulous_trigger_call(){
    'use strict';

    $('#tabs').tabulous({
        effect: 'scale'
    });
    $('#tabs2').tabulous({
        effect: 'slideLeft'
    });
    $('#tabs3').tabulous({
        effect: 'scaleUp'
    });

}

function qrcode_call(){
    'use strict';

    $('#qrcodeTable').qrcode({
        render: "table",
        text: "AimMate, email:aimmateteam@gmail.com"
    });
    $('#qrcodeCanvas').qrcode({
        text: "http://aimmate.com"
    });
}
function bootbox_trigger_call(){
    'use strict';

    $("#alertBootBox").click(function(){
        bootbox.alert("Hello world!", function() {
            notificationCenter(
                'glyphicon glyphicon-ok',
                'alert-success',
                'Hello world callback',
                'bottom right'
            );
        });
    });

    $("#confirmBootBox").click(function () {
        //alert();
        bootbox.confirm("Are you sure?", function (result) {
            var data = "Confirm result: " + result;
            notificationCenter(
                'glyphicon glyphicon-ok',
                'alert-success',
                data,
                'bottom right'
            );
        });
    });

    $("#promptrmBootBox").click(function(){
        bootbox.prompt("What is your name?", function(result) {
            if (result === null) {
                notificationCenter(
                    'fa fa-power-off',
                    'alert-danger',
                    'Prompt dismissed',
                    'bottom right'
                );
            } else {
                var data ="Hi: "+result;
                notificationCenter(
                    'glyphicon glyphicon-user',
                    'alert-success',
                    data,
                    'bottom right'
                );
            }
        });
    });
    $("#customDialogBootBox").click(function(){
        bootbox.dialog({
            message: "I am a custom dialog",
            title: "Custom title",
            buttons: {
                success: {
                    label: "Success!",
                    className: "ls-light-green-btn btn-xs",
                    callback: function() {
                        notificationCenter(
                            'fa fa-check',
                            'alert-success',
                            'Great Success',
                            'bottom right'
                        );
                    }
                },
                danger: {
                    label: "Danger!",
                    className: "ls-red-btn btn-xs",
                    callback: function() {
                        notificationCenter(
                            'fa fa-exclamation',
                            'alert-danger',
                            'Danger Here',
                            'bottom right'
                        );
                    }
                },
                main: {
                    label: "Click ME!",
                    className: "btn-info btn-xs",
                    callback: function() {
                        notificationCenter(
                            'fa fa-info',
                            'alert-info',
                            'Info Button',
                            'bottom right'
                        );
                    }
                }
            }
        });
    });
}

function notificationCenter(icon, type, message, position) {
    'use strict';

    $.notify.addStyle('custom', {
        html: "<div>" +
        "<div class='clearfix'>" +
        "<div class='customNotification alert " + type + "'>" +
        "<span class='" + icon + "'></span>  " + message +
        "</div>" +
        "</div>" +
        "</div>"
    });
    $.notify('Message', {
        style: 'custom',
        className: 'superblue',
        autoHide: true,
        globalPosition: position
    });
}