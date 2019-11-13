/*------------------------------------------------------------------
 [ bootstrapSwitch,Switchery &Ladda  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   use on buttonSwitch
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    bootstrap_switch_call();
    Switchery_call();
    ladda_call();
});
/*** bootstrapSwitch Call ***/
function bootstrap_switch_call(){
    'use strict';

    $(".switchCheckBox").bootstrapSwitch();
}

/*** Switchery Call ***/
function Switchery_call(){
    'use strict';
    var defaults = {
        color: '#64bd63', secondaryColor: '#dfdfdf', className: 'switchery', disabled: false, disabledOpacity: 0.5, speed: '0.4s'
    };

    var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch-dft'));
    elems.forEach(function (html) {
        var switchery = new Switchery(html);
    });

    var elemsDisabled = Array.prototype.slice.call(document.querySelectorAll('.js-switch-disabled'));
    elemsDisabled.forEach(function (htmlDisabled) {
        var switcheryDisabled = new Switchery(htmlDisabled, { disabled: true });

    });

    var elementRed = Array.prototype.slice.call(document.querySelectorAll('.js-switch-red-dft'));
    elementRed.forEach(function (htmlRed) {
        var switcheryRed = new Switchery(htmlRed, { color: $redActive });
    });
    var elementBlue = Array.prototype.slice.call(document.querySelectorAll('.js-switch-blue-dft'));
    elementBlue.forEach(function (htmlBlue) {
        var switcheryBlue = new Switchery(htmlBlue, { color: $blueActive });
    });

    var elementLightBlue = Array.prototype.slice.call(document.querySelectorAll('.js-switch-light-blue-dft'));
    elementLightBlue.forEach(function (htmlLightBlue) {
        var switcheryLightBlue = new Switchery(htmlLightBlue, { color: $lightBlueActive });
    });

    var elementDefault = Array.prototype.slice.call(document.querySelectorAll('.js-switch-default'));
    elementDefault.forEach(function (htmlDefault) {
        var switcheryDefault = new Switchery(htmlDefault, { color: $defultColor });
    });

    var elementbrown = Array.prototype.slice.call(document.querySelectorAll('.js-switch-brown'));
    elementbrown.forEach(function (htmlbrown) {
        var switcherybrown = new Switchery(htmlbrown, { color: $brownActive });
    });

    var elementgreen = Array.prototype.slice.call(document.querySelectorAll('.js-switch-green'));
    elementgreen.forEach(function (htmlgreen) {
        var switcherygreen = new Switchery(htmlgreen, { color: $greenActive });
    });
    var elementLightGreen = Array.prototype.slice.call(document.querySelectorAll('.js-switch-light-green-dft'));
    elementLightGreen.forEach(function (htmlgreen) {
        var elementLightGreen = new Switchery(htmlgreen, { color: $lightGreen });
    });
}
/*** ladda Call ***/
function ladda_call(){
    'use strict';
    Ladda.bind('button.ladda-button', { timeout: 2000 });
}