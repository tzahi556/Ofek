/*------------------------------------------------------------------
 [Sparkline  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   use on sparkline
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';
    sparkPieChart();
    randomDataSparkLine();

    var windowWidth = $(window).width();
    if(windowWidth < 400){
        sparkBarChart(true);
    } else {
        sparkBarChart(false);
    }

});
$(window).resize(function(){
    var size = $(window).width();
    if(size < 400){
        sparkBarChart(true);
    } else {
        sparkBarChart(false);
    }
});
function randomDataSparkLine() {
    var mrefreshinterval = 800; // update display every 500ms
    var mpoints = [];
    var mpoints_max = 30;
    var mdraw = function () {
        var myData = [10, 3, 4, 8, 5, 2.5, 4, 3, 2, 4, 6, 7, 1, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 1, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 10, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 4, 3, 2, 4, 6, 7, 10, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 3, 2, 4, 6, 7, 4, 3, 2, 4, 6];
        var randomItem = myData[Math.floor(Math.random() * myData.length)];
        mpoints.push(randomItem);
        if (mpoints.length > mpoints_max)
            mpoints.splice(0, 1);

        /*console.log(mpoints);*/
        $('#sparkLine').sparkline(mpoints, {
            /*width: mpoints.length*2,*/
            tooltipSuffix: ' is random added data',
            height: "250px",
            width: "100%",
            lineColor: $greenActive,
            highlightLineColor: $redActive,
            fillColor: $fillColor2
        });
        setTimeout(mdraw, mrefreshinterval);
    }
    // We could use setInterval instead, but I prefer to do it this way
    setTimeout(mdraw, mrefreshinterval);
}
function sparkBarChart(size){


    if(size){
        var myData = [10, 3, 4, 8, 5, 2.5, 4, 3, 2, 4, 6, 7, 1, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 1, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 10, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 4, 3, 2, 4, 10];
    } else{
        var myData = [10, 3, 4, 8, 5, 2.5, 4, 3, 2, 4, 6, 7, 1, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 1, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 10, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 4, 3, 2, 4, 6, 7, 10, 3, 4, 8, 5, 2, 4, 3, 2, 4, 6, 7, 4, 8, 5, 2, 4, 3, 2];
    }
    var range_map = $.range_map({
        '1:5': $lightBlueActive,
        '6:9': $defultColor,
        '10:': $redActive
    });

    $('#sparkBar').sparkline(myData, {
        type: 'bar',
        height: "250px",
        width: "100%",
        lineColor: $redActive,
        fillColor: $defultColor,
        stackedBarColor: $defultColor,
        colorMap: range_map
    });
}
function sparkPieChart(){
    $('#sparkPie').sparkline([1, 3, 4, 8, 5, 2], {
        type: 'pie',
        height: "250px",
        width: "100%",
        sliceColors: [$defultColor, $defultBorder, $lightBlueActive, $redActive, $brownActive, $blueActive],
        borderColor: $defultColor
    });
}