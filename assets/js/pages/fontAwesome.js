/*------------------------------------------------------------------
 [ Fontawesome Icons Trigger Javascript ]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :  http://aimmate.com
 Support     :  aimmateteam@gmail.com
 Primary use :	Fontawesome Icons

 -------------------------------------------------------------------*/

/*-----------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';

    fontawesome_icons();
});

/*---------------- FONTAWESOME ICONS -------------------*/
function fontawesome_icons(){
    'use strict';

    $('div.fontawesome-icon-list div').click(function () {
        var className = $(this).children('i').attr('class');
        var $html = '<div class="popupIcon"><i class="' + className + '"></i>' +
            '<pre><code>&lt;i class="' + className + '"&gt;&lt;/i&gt;</code></pre></div>';
        bootbox.dialog({
            message: $html,
            title: "Icon Preview",
            buttons: {
                main: {
                    label: "Close",
                    className: "btn-primary btn-xs",
                    callback: function() {

                    }
                }
            }
        });
    });
}
