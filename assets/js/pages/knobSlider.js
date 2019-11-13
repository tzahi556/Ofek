/*------------------------------------------------------------------
 [ Knob & Ranges  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   knob slider
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    /***  Range Slider Call ***/
    rangeSliderLoad();
    /***  Range Slider Call End ***/

    /**** Knob call ****/
    Knob_call();
    /**** Knob call end****/

});
/*$( window ).resize(function() {

});*/

var ionRangeSlider;
$(window).resize(function() {
    clearTimeout(ionRangeSlider);
    ionRangeSlider = setTimeout(doneResizingIonRangeSlider, 600);

});
function doneResizingIonRangeSlider(){
    $("#rangeSlider_1").ionRangeSlider("update");
    $("#rangeSlider_2").ionRangeSlider("update");
    $("#rangeSlider_3").ionRangeSlider("update");
    $("#rangeSlider_4").ionRangeSlider("update");
}
/***  Range Slider Call ***/
function rangeSliderLoad(){
    $("#rangeSlider_1").ionRangeSlider({
        min: 0,
        max: 5000,
        from: 1000,
        to: 4000,
        type: 'double',
        prefix: "$",
        maxPostfix: "+",
        prettify: false,
        hasGrid: true
    });

    $("#rangeSlider_2").ionRangeSlider({
        min: 0,
        max: 10,
        type: 'single',
        step: 0.1,
        postfix: " carats",
        prettify: false,
        hasGrid: true,
        from: 4
    });

    $("#rangeSlider_3").ionRangeSlider({
        values: [
            "January", "February", "March",
            "April", "May", "June",
            "July", "August", "September",
            "October", "November", "December"
        ],
        type: 'single',
        hasGrid: true

    });
    $("#rangeSlider_4").ionRangeSlider({
        min: 10000,
        max: 100000,
        step: 100,
        postfix: " km",
        from: 55000,
        hideMinMax: true,
        hideFromTo: false
    });
}
/***  Range Slider Call End ***/

function Knob_call(){
    $(".dial").knob({
        'release': function (v) { /*make something*/
        },
        draw: function () {

            // "tron" case
            if (this.$.data('skin') == 'tron') {

                this.cursorExt = 0.3;

                var a = this.arc(this.cv)  // Arc
                    , pa                   // Previous arc
                    , r = 1;

                this.g.lineWidth = this.lineWidth;

                if (this.o.displayPrevious) {
                    pa = this.arc(this.v);
                    this.g.beginPath();
                    this.g.strokeStyle = this.pColor;
                    this.g.arc(this.xy, this.xy, this.radius - this.lineWidth, pa.s, pa.e, pa.d);
                    this.g.stroke();
                }

                this.g.beginPath();
                this.g.strokeStyle = r ? this.o.fgColor : this.fgColor;
                this.g.arc(this.xy, this.xy, this.radius - this.lineWidth, a.s, a.e, a.d);
                this.g.stroke();

                this.g.lineWidth = 2;
                this.g.beginPath();
                this.g.strokeStyle = this.o.fgColor;
                this.g.arc(this.xy, this.xy, this.radius - this.lineWidth + 1 + this.lineWidth * 2 / 3, 0, 2 * Math.PI, false);
                this.g.stroke();

                return false;
            }
        }
    });
}