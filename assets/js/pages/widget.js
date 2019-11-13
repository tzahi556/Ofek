/*------------------------------------------------------------------
 [ Widget Trigger Javascript ]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :  http://aimmate.com
 Support     :  aimmateteam@gmail.com
 Primary use :	Widget

 -------------------------------------------------------------------*/

/*------------ USED ON WIDGET SIMPLE WEATHER ICONS -------------*/
var icons = new Skycons({"color": "#fff"}),
    list  = [
        "clear-day", "clear-night", "partly-cloudy-day",
        "partly-cloudy-night", "cloudy", "rain", "sleet", "snow", "wind",
        "fog"
    ],

i;

for(i = list.length; i--; )
    icons.set(list[i], list[i]);

icons.play();

/*---------- USED ON WIDGET GET RANDOM DATA ---------*/
var data = [],
    totalPoints = 500;

/*------ USED ON WIDGET PLOT REAL TIME CHART -----*/
var updateInterval = 300;
var plot;
/*------- USED ON WIDGET PLOT CHART TOGGLE --------*/
var choiceContainer;
var datasets;




/*-----------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';

    widget_easy_pie_chart();
    widget_simple_weather();
    widget_plot_real_time_chart();
    widget_plot_update();


    $(".switchCheckBox").bootstrapSwitch();
    widget_social_share();
    widget_color_switcher();
    progress_bar();


    flotChartStartPie();
    plotAccordingToChoicesDataSet(); //Series Toggle Widget chart Load
    plotAccordingToChoicesToggle(); //Series Toggle Widget chart toggle button Trigger
});

/*---------------- WIDGET EASY PIE CHART ---------------*/
function widget_easy_pie_chart(){
    'use strict';


    $('.easyPieChartFacebook').easyPieChart({
        barColor: $redActive,
        scaleColor: $redActive,
        easing: 'easeOutBounce',
        onStep: function (from, to, percent) {
            $(this.el).find('.easyPiePercentFacebook').text(Math.round(percent));
        }
    });

    $('.easyPieChartLightGreen').easyPieChart({
        barColor: $lightGreen,
        scaleColor: $lightGreen,
        easing: 'easeOutBounce',
        onStep: function (from, to, percent) {
            $(this.el).find('.easyPieChartLightGreenPercent').text(Math.round(percent));
        }
    });

    $('.easyPieChartBlack').easyPieChart({
        barColor: '#3F414D',
        scaleColor: '#3F414D',
        easing: 'easeOutBounce',
        onStep: function (from, to, percent) {
            $(this.el).find('.easyPieChartBlackPercent').text(Math.round(percent));
        }
    });

}


/*---------------- WIDGET SIMPLE WEATHER -----------------*/
function widget_simple_weather(){
    'use strict';


    $.simpleWeather({
        location: 'Austin, TX',
        woeid: '',
        unit: 'c',
        success: function (weather) {
            var html = '<i class="icon-' + weather.code + '"></i><h2>' + weather.temp + '&deg;' + weather.units.temp + '</h2>';
            html += '<ul><li>' + weather.city + ', ' + weather.region + '</li>';
            html += '<li class="currently">' + weather.currently + '</li>';
            html += '<li>' + weather.wind.direction + ' ' + weather.wind.speed + ' ' + weather.units.speed + '</li></ul>';

            $("#weather").html(html);
        },
        error: function (error) {
            $("#weather").html('<p>' + error + '</p>');
        }
    });

    $.simpleWeather({
        location: 'Dhaka, Bangladesh',
        woeid: '',
        unit: 'c',
        success: function (weather) {
            var html = '<i class="icon-' + weather.code + '"></i><h2>' + weather.temp + '&deg;' + weather.units.temp + '</h2>';
            html += '<ul><li>' + weather.city + ', ' + weather.region + '</li>';
            html += '<li class="currently">' + weather.currently + '</li>';
            html += '<li>' + weather.wind.direction + ' ' + weather.wind.speed + ' ' + weather.units.speed + '</li></ul>';

            $("#weather2").html(html);
        },
        error: function (error) {
            $("#weather2").html('<p>' + error + '</p>');
        }
    });

    $.simpleWeather({
        location: 'Paris, Franch',
        woeid: '',
        unit: 'c',
        success: function (weather) {
            var html = '<i class="icon-' + weather.code + '"></i><h2>' + weather.temp + '&deg;' + weather.units.temp + '</h2>';
            html += '<ul><li>' + weather.city + ', ' + weather.region + '</li>';
            html += '<li class="currently">' + weather.currently + '</li>';
            html += '<li>' + weather.wind.direction + ' ' + weather.wind.speed + ' ' + weather.units.speed + '</li></ul>';

            $("#weather3").html(html);
        },
        error: function (error) {
            $("#weather3").html('<p>' + error + '</p>');
        }
    });

    $.simpleWeather({
        location: 'London',
        woeid: '',
        unit: 'c',
        success: function (weather) {
            var html = '<i class="icon-' + weather.code + '"></i><h2>' + weather.temp + '&deg;' + weather.units.temp + '</h2>';
            html += '<ul><li>' + weather.city + ', ' + weather.region + '</li>';
            html += '<li class="currently">' + weather.currently + '</li>';
            html += '<li>' + weather.wind.direction + ' ' + weather.wind.speed + ' ' + weather.units.speed + '</li></ul>';

            $("#weather4").html(html);
        },
        error: function (error) {
            $("#weather4").html('<p>' + error + '</p>');
        }
    });


    /*------ Weather Feed Start -------*/

    $('#weatherfeed').weatherfeed(['UKXX0085']); // COUNTRY CODE ['UKXX0085'] for UNITED KINGDOM
    $('#weatherfeed2').weatherfeed(['BGXX0003'],
        {
            unit: 'c'
        }
    );
    $('#weatherfeed3').weatherfeed(['FRXX0076']);

    /*------ Weather Feed End ---------*/
}

/*---------------- WIDGET PLOT REAL TIME CHART ------------------*/
function widget_plot_real_time_chart(){
    'use strict';


    $("#updateInterval").val(updateInterval).change(function () {
        var v = $(this).val();
        if (v && !isNaN(+v)) {
            updateInterval = +v;
            if (updateInterval < 1) {
                updateInterval = 1;
            } else if (updateInterval > 2000) {
                updateInterval = 2000;
            }
            $(this).val("" + updateInterval);
        }
    });

     plot = $.plot("#realTimeChart", [ getRandomData() ], {
        series: {
            lines: {
                show: true,
                lineWidth:1,
                fill: true,
                fillColor: {

                    colors: [
                        {
                            opacity: 0.2
                        },
                        {
                            opacity: 0.1
                        }
                    ]
                }
            },
            shadowSize: 0
        },
        colors: ['#1FB5AD'],
        yaxis: {
            min: 0,
            max: 150
        },
        xaxis: {
            show: false
        },
        grid: {
            tickColor: $fillColor1,
            borderWidth: 0
        }
    });

}

/*----------------- WIDGET PLOT UPDATE ------------------*/
function widget_plot_update() {
    'use strict';

    plot.setData([getRandomData()]);

    // Since the axes don't change, we don't need to call plot.setupGrid()

    plot.draw();
    setTimeout(widget_plot_update, updateInterval);
}


/******** Flot According To Choices chart Start  ************/
var choiceContainer;
var datasets;
function plotAccordingToChoicesDataSet(){
    'use strict';

    datasets = {
        "a": {
            label: "Product A",
            data: [
                [2010, 0],
                [2011, 40],
                [2012, 60],
                [2013, 80],
                [2014, 70]
            ]
        },
        "b": {
            label: "Product B",
            data: [
                [2010, 30],
                [2011, 45],
                [2012, 80],
                [2013, 75],
                [2014, 90]
            ]
        },
        "c": {
            label: "Product C",
            data: [
                [2010, 10],
                [2011, 20],
                [2012, 30],
                [2013, 40],
                [2014, 80]
            ]
        }
    };
    var i = 0;
    $.each(datasets, function (key, val) {
        val.color = i;
        ++i;
    });

// insert checkboxes
    choiceContainer = $("#choicesWidget");
    $.each(datasets, function (key, val) {
        //<input class="switchCheckBox" type="checkbox" checked data-size="mini">
        choiceContainer.append("<li><input class='switchCheckBox' data-size='mini' type='checkbox' name='" + key +
        "' checked='checked' id='id" + key + "'></input>" +
        "<br/><label class='switch-label' for='id" + key + "'>"
        + val.label + "</label></li>");
    });

    plotAccordingToChoices();
}

function plotAccordingToChoices() {
    'use strict';

    var data = [];
    choiceContainer.find("input:checked").each(function () {
        var key = $(this).attr("name");
        if (key && datasets[key]) {
            data.push(datasets[key]);
        }
    });

    if (data.length > 0) {
        $.plot("#seriesToggleWidget", data, {
            highlightColor: $lightGreen,
            yaxis: {
                min: 0,
                show:true,
                color: '#E3DFD8'
            },
            xaxis: {
                tickDecimals: 0,
                show:true,
                color: '#E3DFD8'

            },
            colors: [$lightGreen, $redActive, $lightBlueActive, $greenActive],
            grid: {
                borderColor: '#E3DFD8'
            }
        });
    }
    $(".switchCheckBox").bootstrapSwitch();
}
function plotAccordingToChoicesToggle(){
    'use strict';

    $(".switchCheckBox").on('switchChange.bootstrapSwitch', function (event, state) {
        plotAccordingToChoices();
    });
}

/********* flot Chart Pie Widget Start  *********/
function flotChartStartPie(){
    'use strict';

    var pieData = [],
        series = Math.floor(Math.random() * 6) + 1;

    for (var i = 0; i < series; i++) {
        pieData[i] = {
            label: "Product - " + (i + 1),
            data: Math.floor(Math.random() * 100) + 1
        }
    }
    var $flotPieChart = $('#flotPieChart');
    var pieData = [
        {
            label:"Product - 1",
            data:43
        },{
            label:"Product - 2",
            data:19
        },{
            label:"Product - 3", data:89
        },{ label:"Product - 4", data:83
        }
    ]
    $.plot($flotPieChart, pieData, {
        series: {
            pie: {
                show: true,
                radius: 1,
                label: {
                    show: true,
                    radius: 3/4,
                    formatter: labelFormatter,
                    background: {
                        opacity: 0.5,
                        color: '#000'
                    }
                }
            }
        },
        legend: {
            show: false
        },
        colors: [$fillColor2, $lightBlueActive, $redActive, $blueActive, $brownActive, $greenActive]
    });
}
function labelFormatter(label, series) {
    return "<div style='font-size:8pt; text-align:center; padding:2px; color:white;'>" + label + "<br/>" + Math.round(series.percent) + "%</div>";
}
/********* flot Chart Pie Widget End  *********/

/*--------------------- WIDGET GET RANDOM DATA -------------------*/
function getRandomData() {

    if (data.length > 0)
        data = data.slice(1);

    // Do a random walk

    while (data.length < totalPoints) {

        var prev = data.length > 0 ? data[data.length - 1] : 50,
            y = prev + Math.random() * 10 - 5;

        if (y < 0) {
            y = 0;
        } else if (y > 100) {
            y = 99;
        }

        data.push(y);
    }

    // Zip the generated y values with the x values

    var res = [];
    for (var i = 0; i < data.length; ++i) {
        res.push([i, data[i]])
    }

    return res;
}

/*-------------- MORRIS CHART --------------*/


/*-------------- WIDGET SOCIAL SHARE ---------------*/
function widget_social_share(){
    'use strict';

    $(".social-share").mouseenter(function(){
        // handle the mouseenter functionality
        $(this).addClass("overlay-hover");
    }).mouseleave(function(){
        // handle the mouseleave functionality
        $(this).removeClass("overlay-hover");
    });
}

/*---------------- WIDGET COLOR SWITCHER ----------------*/
function widget_color_switcher(){
    'use strict';

    var $fullContent = $("body");
    $('.change-color-switch ul li ').click(function(){

        $fullContent.removeClass('black-color');
        $fullContent.removeClass('blue-color');
        $fullContent.removeClass('deep-blue-color');
        $fullContent.removeClass('red-color');
        $fullContent.removeClass('light-green-color');
        $fullContent.removeClass('default');
        $('.change-color-switch ul li ').removeClass('active');

        if($(this).hasClass('active')){

        } else{
            var className = $(this).attr('class');
            $fullContent.addClass(className);
            $(this).addClass('active');
        }
    });
}


/*------------- PROGRESSBAR ------------*/
function progress_bar(){
    'use strict';

    $('.progress-bar').progressbar({
        display_text: 'fill'
    });
}
