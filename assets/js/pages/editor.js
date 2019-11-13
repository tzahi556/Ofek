/*------------------------------------------------------------------
 [ summernote Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   use on editor
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    summer_note_call();
    summer_note_theme_call();
    summer_note_air_mode_call();
    summer_note_custom_tool_bar_call();
});
var edit = function() {
    $('.click2edit').summernote({focus: true});
};
var save = function() {
    var aHTML = $('.click2edit').code(); //save HTML If you need(aHTML: array).
    $('.click2edit').destroy();
};
function summer_note_call(){
    'use strict';

    $('.summernote').summernote({
        height: 150,                 // set editor height
        minHeight: null,             // set minimum height of editor
        maxHeight: null,             // set maximum height of editor

        focus: true,                 // set focus to editable area after initializing summernote
        codemirror: { // codemirror options
            theme: 'monokai'
        }
    });
}
function summer_note_theme_call(){
    'use strict';

    $('.summernoteTheme').summernote({
        height: 300,                 // set editor height

        minHeight: null,             // set minimum height of editor
        maxHeight: null,             // set maximum height of editor

        focus: true                 // set focus to editable area after initializing summernote
    });
}
function summer_note_air_mode_call(){
    'use strict';

    $('.summernoteAirMode').summernote({
        airMode: true
    });
}
function summer_note_custom_tool_bar_call(){
    'use strict';

    $('.customToolBar').summernote({
        toolbar: [
            //[groupname, [button list]]

            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['font', ['strikethrough']],
            ['fontsize', ['fontsize']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']],
        ]
    });
}