/*------------------------------------------------------------------
 [chartjs  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   Chart Js use on chartjs
 -------------------------------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';
    chartLoad();
});

var sizeId;
$(window).resize(function() {
    clearTimeout(sizeId);
    sizeId= setTimeout(chartSize, 1000);

});
/******** Chart js Data set Start********/
var randomScalingFactor = function(){ return Math.round(Math.random()*10)};
var barChartData = {
    labels : ["January","February","March","April","May","June","July"],
    datasets: [
        {
            fillColor: $info,
            data: [65, 59, 90, 81, 56, 55, 40]
        },
        {
            fillColor: $lightGreen,
            data: [28, 48, 40, 19, 96, 27, 100]
        },
        {
            fillColor: $redActive,
            data: [30, 20, 100, 10, 80, 27, 50]
        }
    ]

}


var pieData = [
    {
        value: 30,
        color: $info,
        highlight: $redActive,
        label: "Product A"
    },
    {
        value: 50,
        color: $lightBlueActive,
        highlight: $redActive,
        label: "Product B"
    },
    {
        value: 20,
        color: $lightGreen,
        highlight: $redActive,
        label: " Product C"
    }

];
var doughnutData = [
    {
        label: "Product A",
        value: 20,
        color: $textColor
    },
    {
        label: "Product B",
        value: 50,
        color: $greenActive
    },
    {
        label: "Product C",
        value: 100,
        color: $fillColor4
    },
    {
        label: "Product D",
        value: 40,
        color: $lightBlueActive
    },
    {
        label: "Product E",
        value: 120,
        color: $redActive
    }

];
var polarData = [
    {
        label: "Product A",
        value: 0.6,
        color: $greenActive
    },
    {
        label: "Product B",
        value: 0.8,
        color: $fillColor5
    },
    {
        label: "Product C",
        value: 0.7,
        color: $fillColor6
    },
    {
        label: "Product D",
        value: 0.9,
        color: $fillColor4
    },
    {
        label: "Product E",
        value: 0.7,
        color: $fillColor7
    }
];

var radarChartData = {
    labels: ["Eating", "Drinking", "Sleeping", "Designing", "Coding", "Cycling", "Running"],
    datasets: [
        {
            label: "My First dataset",
            fillColor: "rgba(220,220,220,0.2)",
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: [65,59,90,81,56,55,40]
        },
        {
            label: "My Second dataset",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: [28,48,40,19,96,27,100]
        }
    ]
};
var lineChartData = {
    labels : ["January","February","March","April","May","June","July"],
    datasets: [
        {
            label: "My Second dataset",
            fillColor: $blueFillColor,
            strokeColor: $strokeColor,
            pointColor: $info,
            pointStrokeColor: "#fff",
            data: [65, 59, 90, 81, 56, 55, 40]
        },
        {
            label: "My Second dataset",
            fillColor: $lightGreenFillColor,
            strokeColor: strokeColor2,
            pointColor: $lightGreen,
            pointStrokeColor: "#fff",
            data: [28, 48, 40, 19, 96, 27, 100]
        }
    ]

};
/******** Chart js Data set End********/

/******** Chart js Defaults Global Value Set Start ********/
Chart.defaults.global = {
    // Boolean - Whether to animate the chart
    animation: true,

    // Number - Number of animation steps
    animationSteps: 60,

    // String - Animation easing effect
    animationEasing: "easeOutQuart",

    // Boolean - If we should show the scale at all
    showScale: true,

    // Boolean - If we want to override with a hard coded scale
    scaleOverride: false,

    // ** Required if scaleOverride is true **
    // Number - The number of steps in a hard coded scale
    scaleSteps: null,
    // Number - The value jump in the hard coded scale
    scaleStepWidth: null,
    // Number - The scale starting value
    scaleStartValue: null,

    // String - Colour of the scale line
    scaleLineColor: "rgba(0,0,0,.1)",

    // Number - Pixel width of the scale line
    scaleLineWidth: 1,

    // Boolean - Whether to show labels on the scale
    scaleShowLabels: true,

    // Interpolated JS string - can access value
    scaleLabel: "<%=value%>",

    // Boolean - Whether the scale should stick to integers, not floats even if drawing space is there
    scaleIntegersOnly: true,

    // Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
    scaleBeginAtZero: false,

    // String - Scale label font declaration for the scale label
    scaleFontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",

    // Number - Scale label font size in pixels
    scaleFontSize: 12,

    // String - Scale label font weight style
    scaleFontStyle: "normal",

    // String - Scale label font colour
    scaleFontColor: "#666",

    // Boolean - whether or not the chart should be responsive and resize when the browser does.
    responsive: true,

    // Boolean - whether to maintain the starting aspect ratio or not when responsive, if set to false, will take up entire container
    maintainAspectRatio: true,

    // Boolean - Determines whether to draw tooltips on the canvas or not
    showTooltips: true,

    // Array - Array of string names to attach tooltip events
    tooltipEvents: ["mousemove", "touchstart", "touchmove"],

    // String - Tooltip background colour
    tooltipFillColor: "rgba(0,0,0,0.8)",

    // String - Tooltip label font declaration for the scale label
    //tooltipFontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",

    // Number - Tooltip label font size in pixels
    tooltipFontSize: 14,

    // String - Tooltip font weight style
    tooltipFontStyle: "normal",

    // String - Tooltip label font colour
    tooltipFontColor: "#fff",

    // String - Tooltip title font declaration for the scale label
    //tooltipTitleFontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",

    // Number - Tooltip title font size in pixels
    tooltipTitleFontSize: 14,

    // String - Tooltip title font weight style
    tooltipTitleFontStyle: "bold",

    // String - Tooltip title font colour
    tooltipTitleFontColor: "#fff",

    // Number - pixel width of padding around tooltip text
    tooltipYPadding: 6,

    // Number - pixel width of padding around tooltip text
    tooltipXPadding: 6,

    // Number - Size of the caret on the tooltip
    tooltipCaretSize: 8,

    // Number - Pixel radius of the tooltip border
    tooltipCornerRadius: 6,

    // Number - Pixel offset from point x to tooltip edge
    tooltipXOffset: 10,

    // String - Template string for single tooltips
    tooltipTemplate: "<%if (label){%><%=label%>: <%}%><%= value %>",

    // String - Template string for single tooltips
    multiTooltipTemplate: "<%= value %>",

    // Function - Will fire on animation progression.
    onAnimationProgress: function(){},

    // Function - Will fire on animation completion.
    onAnimationComplete: function(){}
};
/******** Chart js Defaults Global Value Set End ********/


var myBar;
var myLine;
var myPie;
var myDoughnut;
var myPolarArea;
var myRadar;
function chartLoad(){
    'use strict';
    var ctx = document.getElementById("bar_chart_canvas").getContext("2d");
    myBar = new Chart(ctx).Bar(barChartData, {responsive : true, barShowStroke: false });

    var ctx = document.getElementById("pie-chart-area").getContext("2d");
    myPie = new Chart(ctx).Pie(pieData, {responsive : true});

    var ctx = document.getElementById("doughnut-chart-area").getContext("2d");
    myDoughnut = new Chart(ctx).Doughnut(doughnutData, {responsive : true});

    var ctx = document.getElementById("polar-chart-area").getContext("2d");
    myPolarArea = new Chart(ctx).PolarArea(polarData, {
        responsive:true
    });
    myRadar = new Chart(document.getElementById("radar-chart-area").getContext("2d")).Radar(radarChartData, {responsive: true });
    var ctx = document.getElementById("line-chart-area").getContext("2d");
    myLine  = new Chart(ctx).Line(lineChartData, { responsive: true });
}
function chartSize(){
    //console.log('LOG');
    myLine.destroy();
    myBar.destroy();
    myPie.destroy();
    myDoughnut.destroy();
    myPolarArea.destroy();
    myRadar.destroy();
    chartLoad();
}