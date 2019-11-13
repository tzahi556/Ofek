/*------------------------------------------------------------------
 [ Lock Screen  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   Lock Screen Page
 -------------------------------------------------------------------*/

jQuery(document).ready(function($) {
    'use strict';

    form_lock_screen_trigger_call();
    ladda_progress_button_load();
});
function form_lock_screen_trigger_call(){
    $('#form-lock-screen').submit(function () {
        /*var setUrl = window.location.origin + '/index.html'
         window.location.assign(setUrl);*/

        return false;
    });
}

function ladda_progress_button_load(){
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
                    jacked.log("<span class='fa fa-unlock'></span> Successfully unlock <i class='fa fa-smile-o'></i> ");
                    setInterval(function () {
                        var setUrl = '/index.html';
                        window.location.assign(setUrl);
                    }, 500);
                }
            }, 200);
        }
    });
}