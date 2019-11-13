/*------------------------------------------------------------------
 [Mail Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :	Mail Inbox
 -------------------------------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';

    socialShare();
});
function socialShare(){
    'use strict';

    $(".ls-mail-img").mouseenter(function(){
        // handle the mouseenter functionality
        $(this).addClass("overlay-hover");
    }).mouseleave(function(){
        // handle the mouseleave functionality
        $(this).removeClass("overlay-hover");
    });

}
