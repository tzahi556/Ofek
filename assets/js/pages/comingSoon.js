/*------------------------------------------------------------------
 [ Coming Soon Trigger Javascript ]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :  http://aimmate.com
 Support     :  aimmateteam@gmail.com
 Primary use :	Coming Soon

 -------------------------------------------------------------------*/

window.addEventListener('mousemove', handleMouseMove, false);
var updateSliderScale;
var shine;

/*-----------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';

    text_shine();
    timeCirclesLoad();
    resize_window_timecircles();

});

/*---------------- TEXT SHINE -------------------*/
function text_shine(){
    'use strict';

    var config = new shinejs.Config({
        numSteps: 4,
        opacity: 0.4,
        shadowRGB: new shinejs.Color(255, 255, 255, 0.92)

        //rgba(255, 255, 255, 0.92)
    });

    shine = new Shine(document.getElementById('headline'), config);

}

/*----------------- HANDLE MOUSE MOVE ------------------*/
function handleMouseMove(event) {
    shine.light.position.x = event.clientX;
    shine.light.position.y = event.clientY;
    shine.draw();
}


/*----------------- TIME CIRCLES LOAD ---------------*/
function timeCirclesLoad(){
    'use strict';

    $("#DateCountdown").TimeCircles({
        "animation": "smooth",
        "bg_width": 0.1,
        "fg_width": 0.006666666666666667,
        "circle_bg_color": "#ffffff",
        "time": {
            "Days": {
                "text": "Days",
                "color": "#ff7878",
                "show": true
            },
            "Hours": {
                "text": "Hours",
                "color": "#ff7878",
                "show": true
            },
            "Minutes": {
                "text": "Minutes",
                "color": "#ff7878",
                "show": true
            },
            "Seconds": {
                "text": "Seconds",
                "color": "#ff7878",
                "show": true
            }
        }
    });
}


/*----------  RESIZE WINDOW TIMECIRCLES -----------*/
function resize_window_timecircles(){
    'use strict';

    $( window ).resize(function() {
        clearTimeout(updateSliderScale);
        updateSliderScale = setTimeout(function(){
            $("#DateCountdown").TimeCircles().destroy();
            timeCirclesLoad();
        }, 100);

    });
}