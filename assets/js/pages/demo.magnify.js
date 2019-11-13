/*------------------------------------------------------------------
 [ Image Magnify Trigger Javascript ]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.1
 Author      : 	AimMateTeam
 URL         :  http://aimmate.com
 Support     :  aimmateteam@gmail.com
 Primary use :	Magnify

 -------------------------------------------------------------------*/

/*-----------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';

    image_Magnify();
    image__Fluid_Box();
});

/*---------------- IMAGE MAGNIFY -------------------*/
function image_Magnify(){
    'use strict';

    $('.ls-image-magnify img').magnify();
}


/*------------------- IMAGE FLUID BOX --------------------*/
function image__Fluid_Box(){
    'use strict';

    // You can use any kind of selectors for jQuery Fluidbox
    $('.ls-image-fluid-box a').fluidbox();

    // Smooth scrolling plugin by Chris Coiyer - not needed for Fluidbox functionality
    // Source: http://css-tricks.com/snippets/jquery/smooth-scrolling/
    $('a[href*=#]:not([href=#])').click(function() {
        if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: target.offset().top
                }, 1000);
                return false;
            }
        }
    });
}
