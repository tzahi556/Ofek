/*------------------------------------------------------------------
 [C3 Chart Js Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :	C3 Chart Js use on c3js
 -------------------------------------------------------------------*/

jQuery(document).ready(function($) {
    'use strict';

    c3_bar_chart();
    c3_line_and_bar();
    c3_chart_combination();
    c3_chart_donut();

});

function c3_bar_chart(){
    'use strict';

    var chart = c3.generate({
        bindto: '#c3BarCharts', //Here is the selector id
        color: { pattern: [$brownActive,$lightBlueActive, $lightGreen, $blueActive] }, //Here is the color

        data: {
            xs: {
                'ABCD': 'x1',
                'XYZ': 'x2',
                'MNOP': 'x3'
            },
            columns: [ //Here is the data
                ['x1', 2010, 2011, 2012, 2013, 2014],
                ['x2', 2010, 2011, 2012, 2013, 2014],
                ['x3', 2010, 2011, 2012, 2013, 2014],
                ['ABCD', 30, 200, 100, 400, 150, 250],
                ['XYZ', 130, 150, 200, 300, 200, 100],
                ['MNOP', 200, 100, 180, 50, 300, 250]
            ],
            type: 'bar'
        },
        bar: {
            width: {
                ratio: 1 // this makes bar width 50% of length between ticks
            }
        },
        axis: {
            show: true,
            label: {
                text: 'X Label',
                position: 'outer-middle'
            }
        }
    });
}
function c3_line_and_bar(){
    'use strict';

    var chart_combination = c3.generate({
        bindto: '#line-and-bar',
        color: { pattern: [$redActive, $lightBlueActive, $lightGreen, $blueActive, $brownActive] },
        data: {
            columns: [
                ['data1', 30, 200, 100, 400, 150, 250],
                ['data2', 50, 20, 10, 40, 15, 25]
            ],
            axes: {
                data2: 'y2'
            },
            types: {
                data2: 'bar' // ADD
            }

        },
        axis: {
            y: {
                label: {
                    text: 'Y Label',
                    position: 'outer-middle'
                }
            },
            y2: {
                show: true,
                label: {
                    text: 'Y2 Label',
                    position: 'outer-middle'
                }
            },
            x:{
                show: true,
                label: {
                    text: 'X Label',
                    position: 'outer-middle'
                }
            }
        }
    });
}
function c3_chart_combination(){
    'use strict';

    var chart = c3.generate({
        bindto: '#chart_combination',
        color: { pattern: [$lightGreen, $brownActive,$orangeActive, $redActive, $lightBlueActive] },
        data: {
            columns: [
                ['data1', 30, 20, 50, 40, 60, 50],
                ['data2', 200, 130, 90, 240, 130, 220],
                ['data3', 300, 200, 160, 400, 250, 250],
                ['data4', 200, 130, 90, 240, 130, 220],
                ['data5', 130, 120, 150, 140, 160, 150],
                ['data6', 90, 70, 20, 50, 60, 120]
            ],
            type: 'bar',
            types: {
                data3: 'spline',
                data4: 'line',
                data6: 'area'
            },
            groups: [
                ['data1','data2']
            ]
        }
    });
}
function c3_chart_donut(){
    'use strict';

    var donut = c3.generate({
        bindto: '#chart_donut',
        color: { pattern: [$lightBlueActive, $brownActive, $lightGreen, $blueActive] },
        data: {

            columns: [
                ["Designer", 0.2, 0.2, 0.2, 0.2, 0.2, 0.4, 0.3, 0.2, 0.2, 0.1, 0.2, 0.2, 0.1, 0.1, 0.2, 0.4, 0.4, 0.3, 0.3, 0.3, 0.2, 0.4, 0.2, 0.5, 0.2, 0.2, 0.4, 0.2, 0.2, 0.2, 0.2, 0.4, 0.1, 0.2, 0.2, 0.2, 0.2, 0.1, 0.2, 0.2, 0.3, 0.3, 0.2, 0.6, 0.4, 0.3, 0.2, 0.2, 0.2, 0.2],
                ["Programmer", 1.4, 1.5, 1.5, 1.3, 1.5, 1.3, 1.6, 1.0, 1.3, 1.4, 1.0, 1.5, 1.0, 1.4, 1.3, 1.4, 1.5, 1.0, 1.5, 1.1, 1.8, 1.3, 1.5, 1.2, 1.3, 1.4, 1.4, 1.7, 1.5, 1.0, 1.1, 1.0, 1.2, 1.6, 1.5, 1.6, 1.5, 1.3, 1.3, 1.3, 1.2, 1.4, 1.2, 1.0, 1.3, 1.2, 1.3, 1.3, 1.1, 1.3],
                ["Marketing", 2.5, 1.9, 2.1, 1.8, 2.2, 2.1, 1.7, 1.8, 1.8, 2.5, 2.0, 1.9, 2.1, 2.0, 2.4, 2.3, 1.8, 2.2, 2.3, 1.5, 2.3, 2.0, 2.0, 1.8, 2.1, 1.8, 1.8, 1.8, 2.1, 1.6, 1.9, 2.0, 2.2, 1.5, 1.4, 2.3, 2.4, 1.8, 1.8, 2.1, 2.4, 2.3, 1.9, 2.3, 2.5, 2.3, 1.9, 2.0, 2.3, 1.8]
            ],
            type : 'donut'
        },
        donut: {
            title: "Project Report"
        }
    });
}