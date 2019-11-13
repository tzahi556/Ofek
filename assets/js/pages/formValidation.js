/*------------------------------------------------------------------
 [Form Validation Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   use on formValidation
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    bootstrap_validator_call();
    animated_text_area();
    mask_input_validation();
    validation_engine_call();
});

function bootstrap_validator_call(){
    'use strict';

    $('#defaultForm').bootstrapValidator();
}
function animated_text_area(){
    'use strict';

    $('.animatedTextArea').autosize({append: "\n"});
}
function mask_input_validation(){
    'use strict';

    $.mask.definitions['~'] = "[+-]";
    $("#date").mask("99/99/9999", {completed: function () {
        alert("completed!");
    }});
    $("#phone").mask("(999) 999-9999");
    $("#phoneExt").mask("(999) 999-9999? x99999");
    $("#iphone").mask("+33 999 999 999");
    $("#tin").mask("99-9999999");
    $("#ssn").mask("999-99-9999");
    $("#product").mask("a*-999-a999", { placeholder: " " });
    $("#eyescript").mask("~9.99 ~9.99 999");
    $("#po").mask("PO: aaa-999-***");
    $("#pct").mask("99%");
}
function validation_engine_call(){
    'use strict';


    $("#formID").validationEngine('attach', {
        showOneMessage: false,
        promptPosition: "bottomLeft",
        autoHidePrompt: true,
        scroll: true,
        onValidationComplete: function (form, status) {

        }
        /*showPrompts:false*/
    });
}