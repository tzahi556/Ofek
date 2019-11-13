var testdata = [
    {
        key: "One",
        y: 5
    },
    {
        key: "Two",
        y: 2
    },
    {
        key: "Three",
        y: 9
    },
    {
        key: "Four",
        y: 7
    },
    {
        key: "Five",
        y: 4
    },
    {
        key: "Six",
        y: 3
    },
    {
        key: "Seven",
        y: .5
    }
];
function data() {
    var sin = [],
        cos = [];

    for (var i = 0; i < 100; i++) {
        sin.push({x: i, y: Math.sin(i / 10)});
        cos.push({x: i, y: .5 * Math.cos(i / 10)});
    }

    return [
        {
            values: sin,
            key: 'Product ABC',
            color: $greenActive
        },
        {
            values: cos,
            key: 'Product XYZ',
            color: $redActive
        }
    ];
}
nv.addGraph(function () {
    var chart = nv.models.lineChart()
            .useInteractiveGuideline(true)
        ;

    chart.xAxis
        .axisLabel('Time (ms)')
        .tickFormat(d3.format(',r'))
    ;

    chart.yAxis
        .axisLabel('Voltage (v)')
        .tickFormat(d3.format('.02f'))
    ;

    d3.select('#chartTwoLine svg')
        .datum(data())
        .transition().duration(500)
        .call(chart)
    ;

    nv.utils.windowResize(chart.update);
    return chart;
});
function nvD3PieChart(windowWidth){
    nv.addGraph(function () {

        if(windowWidth < 1100 && windowWidth > 768){
            var width = '350',
                height = '350';
        }else if(windowWidth < 769){

            var width = windowWidth -100,
                height = windowWidth -100;
        } else{
            var width = '450',
                height = '450';
        }

        var chart = nv.models.pieChart()
            .x(function (d) {
                return d.key
            })
            .y(function (d) {
                return d.y
            })
            .color(d3.scale.category10().range())
            .width(width)
            .height(height);

        d3.select("#test1")
            .datum(testdata)
            .transition().duration(1200)
            .attr('width', width)
            .attr('height', height)
            .call(chart);

        chart.dispatch.on('stateChange', function (e) {
            nv.log('New State:', JSON.stringify(e));
        });

        return chart;
    });
}
function nvD3HalfPieChart(windowWidth){
    nv.addGraph(function () {
        if(windowWidth < 1100 && windowWidth > 768){
            var width = '350',
                height = '350';
        }else if(windowWidth < 769){

            var width = windowWidth -100,
                height = windowWidth -100;
        } else{
            var width = '480',
                height = '480';
        }

        var chart = nv.models.pieChart()
            .x(function (d) {
                return d.key
            })
            //.y(function(d) { return d.value })
            //.labelThreshold(.08)
            //.showLabels(false)
            .color(d3.scale.category10().range())
            .width(width)
            .height(height)
            .donut(true);

        chart.pie
            .startAngle(function (d) {
                return d.startAngle / 2 - Math.PI / 2
            })
            .endAngle(function (d) {
                return d.endAngle / 2 - Math.PI / 2
            });

        //chart.pie.donutLabelsOutside(true).donut(true);

        d3.select("#test2")
            //.datum(historicalBarChart)
            .datum(testdata)
            .transition().duration(1200)
            .attr('width', width)
            .attr('height', height)
            .call(chart);

        return chart;
    });
}
function threeChartTogether(){
    var mainExample, exampleOne, exampleThree;

    //var colors = d3.scale.category20().range();

    var test_data = stream_layers(3, 20 + Math.random() * 50, .1).map(function (data, i) {
        return {
            key: 'Stream' + i, values: data
            //, color: colors[i]
        };
    });


    // --------------------------- MAIN EXAMPLE ---------------------------------


    nv.addGraph(function () {
        var chart = nv.models.multiBarChart()
            .margin({top: 50, bottom: 30, left: 40, right: 10});

        chart.xAxis
            .tickFormat(d3.format(',f'));

        chart.yAxis
            .tickFormat(d3.format(',.1f'));

        d3.select('#mainExample')
            .datum(test_data)
            .transition().duration(500).call(chart);

        nv.utils.windowResize(chart.update);

        chart.legend.dispatch.on('legendClick.updateExamples', function () {
            setTimeout(function () {
                exampleOne.update();
                exampleThree.update();
            }, 100);
        });

        mainExample = chart;

        return chart;
    });


    // --------------------------- EXAMPLE ONE ---------------------------------


    nv.addGraph(function () {
        var chart = nv.models.lineChart()
                .showLegend(false)
                .margin({top: 10, bottom: 30, left: 40, right: 10})
                .useInteractiveGuideline(true)
            ;

        chart.xAxis // chart sub-models (ie. xAxis, yAxis, etc) when accessed directly, return themselves, not the partent chart, so need to chain separately
            .tickFormat(d3.format(',r'));

        chart.yAxis
            .tickFormat(d3.format(',.1f'));

        d3.select('#exampleOne')
            .datum(test_data)
            .transition().duration(500)
            .call(chart);

        //TODO: Figure out a good way to do this automatically
        nv.utils.windowResize(chart.update);
        //nv.utils.windowResize(function() { d3.select('#chart1 svg').call(chart) });

        exampleOne = chart;

        return chart;
    });


    nv.addGraph(function () {
        var chart = nv.models.stackedAreaChart()
            .margin({top: 10, bottom: 30, left: 40, right: 10})
            .showControls(false)
            .showLegend(false)
            .useInteractiveGuideline(true)
            .style('stacked');

        chart.yAxis
            .tickFormat(d3.format(',.1f'));

        d3.select("#exampleThree")
            .datum(test_data)
            .transition().duration(500).call(chart);

        nv.utils.windowResize(chart.update);


        chart.stacked.dispatch.on('areaClick.updateExamples', function (e) {
            setTimeout(function () {
                mainExample.update();
                exampleOne.update();
                //exampleThree.update();
            }, 100);
        })

        exampleThree = chart;

        return chart;
    });
}

$(function () {
    threeChartTogether();
    var windowWidth = $(window).width();
    nvD3PieChart(windowWidth);
    nvD3HalfPieChart(windowWidth);
    $( window ).resize(function() {
        var windowWidth = $(window).width();
        nvD3PieChart(windowWidth);
        nvD3HalfPieChart(windowWidth);
    });
});



