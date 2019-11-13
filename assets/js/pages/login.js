/*------------------------------------------------------------------
 [ Login  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   Login Page
 -------------------------------------------------------------------*/

jQuery(document).ready(function($) {
    'use strict';

    bootstrap_switch_trigger_call();
    forgo_password_view();
    login_view_submit();
    // Bind progress buttons and simulate loading progress
    ladda_button_call();
});
/*** Switch Call ***/
function bootstrap_switch_trigger_call(){
    $(".switchCheckBox").bootstrapSwitch();

}
/*** Switch Call  End***/
function forgo_password_view(){
    $(".forgot-password, .login-view").click(function () {
        $('.login-form, .forgot-pass-box').slideToggle('slow');
    });


}
function login_view_submit(){
    $('#form-login').submit(function () {
        /*var setUrl = window.location.origin + '/index.html'
         window.location.assign(setUrl);*/

        return false;
    });
}

function ladda_button_call(){
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
                    jacked.log("<i class='fa fa-smile-o'></i> Successfully logedin ");

//                    setInterval(function () {
//                        var setUrl = '/index.html';
//                        window.location.assign(setUrl);
//                    }, 500);
                }
            }, 200);
        }
    });
}