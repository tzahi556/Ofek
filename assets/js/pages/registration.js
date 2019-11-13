/*------------------------------------------------------------------
 [ registration  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   registration Page
 -------------------------------------------------------------------*/

jQuery(document).ready(function($) {
    'use strict';

    form_register_call();
    ladda_button_load()
});

function form_register_call(){
    'use strict';

    $('#form-register').submit(function () {
        /*var setUrl = window.location.origin + '/index.html'
         window.location.assign(setUrl);*/

        return false;
    });
}
function ladda_button_load(){
    'use strict';

    Ladda.bind('button.ladda-button', {
        callback: function (instance) {
            var progress = 0;
            var interval = setInterval(function () {
                progress = Math.min(progress + Math.random() * 0.1, 1);
                instance.setProgress(progress);

                if (progress === 1) {
                    instance.stop();
                    clearInterval(interval);
                    //Checking Login in here


                    var jacked = humane.create({baseCls: 'humane-jackedup', addnCls: 'humane-jackedup-success'});
                    jacked.log("<span class='glyphicon glyphicon-ok'></span>  Successfully registered. check your mail <i class='fa fa-smile-o'></i> ");
                    /*var setUrl = window.location.origin + '/index.html'
                     window.location.assign(setUrl);*/
                }
            }, 200);
        }
    });
}