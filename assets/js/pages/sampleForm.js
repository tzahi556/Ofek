/*------------------------------------------------------------------
 [autosize & fileinput Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   use on sample-form
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    animated_text_area();
    file_input_trigger();
});
function animated_text_area(){
    'use strict';

    $('.animatedTextArea').autosize({append: "\n"});
}
/*** file input Call ****/
function file_input_trigger(){
    'use strict';

    $("#file-3").fileinput({
        showCaption: false,
        browseClass: "btn btn-ls",
        fileType: "any",
        'showUpload': false
    });
}
/*** file input Call end ****/