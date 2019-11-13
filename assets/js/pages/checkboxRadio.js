/*------------------------------------------------------------------
 [ icheck  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   use on Checkbox & Radio
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    icheck_check_and_radio_call();
});

/*** Icheck for check & radio Call ***/

function icheck_check_and_radio_call(){
    'use strict';
    /*** Icheck for check & radio Call ***/
    $('input.icheck-green').iCheck({
        checkboxClass: 'icheckbox_minimal-green',
        radioClass: 'iradio_minimal-green',
        increaseArea: '20%' // optional
    });
    $('input.icheck-polaris').iCheck({
        checkboxClass: 'icheckbox_polaris',
        radioClass: 'iradio_polaris',
        increaseArea: '20%' // optional
    });

    $('input.icheck').iCheck({
        checkboxClass: 'icheckbox_minimal-green',
        radioClass: 'iradio_minimal-green',
        increaseArea: '20%' // optional
    });

    $('input.icheck-red').iCheck({
        checkboxClass: 'icheckbox_flat-red',
        radioClass: 'iradio_flat-red',
        increaseArea: '20%' // optional
    });
    $('input.icheck-blue').iCheck({
        checkboxClass: 'icheckbox_flat-blue',
        radioClass: 'iradio_flat-blue',
        increaseArea: '20%' // optional
    });
    $('input.icheck-aero').iCheck({
        checkboxClass: 'icheckbox_flat-aero',
        radioClass: 'iradio_flat-aero',
        increaseArea: '20%' // optional
    });

    $('input.icheck-aero').iCheck({
        checkboxClass: 'icheckbox_flat-aero',
        radioClass: 'iradio_flat-aero',
        increaseArea: '20%' // optional
    });

    $('input.icheck-black').iCheck({
        checkboxClass: 'icheckbox_flat',
        radioClass: 'iradio_flat',
        increaseArea: '20%' // optional
    });

    $('input.icheck-purple').iCheck({
        checkboxClass: 'icheckbox_square-purple',
        radioClass: 'iradio_square-purple',
        increaseArea: '20%' // optional
    });
    $('input.icheck-square-green').iCheck({
        checkboxClass: 'icheckbox_square-green',
        radioClass: 'iradio_square-green',
        increaseArea: '20%' // optional
    });
}