/*------------------------------------------------------------------
 [ Glyphicon Icons Trigger Javascript ]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :  http://aimmate.com
 Support     :  aimmateteam@gmail.com
 Primary use :	Glyphicon Icons

 -------------------------------------------------------------------*/

/*-----------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';

    glyphicons_icons();
});

/*---------------- GLYPHICONS ICONS -------------------*/
function glyphicons_icons(){
    'use strict';

    $('ul.ls-glyphicons-list li').click(function () {
        var className = $(this).children('span').attr('class');
        var $html = '<div class="popupIcon"><i class="' + className + '"></i>' +
            '<pre><code>&lt;i class="' + className + '"&gt;&lt;/i&gt;</code></pre></div>';
        bootbox.alert($html, function () {
        });
    });
}
