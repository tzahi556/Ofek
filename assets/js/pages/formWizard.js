/*------------------------------------------------------------------
 [smartWizard Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   use on form-wizard
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    form_wizard_call();
    vertical_form_wizard_call();
});

function form_wizard_call(){
    'use strict';

    $('#wizard').smartWizard({
        // Properties
        selected: 0,  // Selected Step, 0 = first step
        keyNavigation: true, // Enable/Disable key navigation(left and right keys are used if enabled)
        enableAllSteps: true,  // Enable/Disable all steps on first load
        transitionEffect: 'fade', // Effect on navigation, none/fade/slide/slideleft
        contentURL: null, // specifying content url enables ajax content loading
        contentURLData: null, // override ajax query parameters
        contentCache: true, // cache step contents, if false content is fetched always from ajax url
        cycleSteps: false, // cycle step navigation
        enableFinishButton: false, // makes finish button enabled always
        hideButtonsOnDisabled: false, // when the previous/next/finish buttons are disabled, hide them instead
        errorSteps: [],    // array of step numbers to highlighting as error steps
        labelNext: 'Next', // label for Next button
        labelPrevious: 'Previous', // label for Previous button
        labelFinish: 'Finish',  // label for Finish button
        noForwardJumping: false,
        ajaxType: 'POST',
        // Events
        onLeaveStep: null, // triggers when leaving a step
        onShowStep: null,  // triggers when showing a step
        onFinish: null,  // triggers when Finish button is clicked
        includeFinishButton: true   // Add the finish button
    });
}
function vertical_form_wizard_call(){
    'use strict';

    $('#verticalWizard').smartWizard({
        // Properties
        selected: 0,  // Selected Step, 0 = first step
        keyNavigation: true, // Enable/Disable key navigation(left and right keys are used if enabled)
        enableAllSteps: true,  // Enable/Disable all steps on first load
        transitionEffect: 'fade', // Effect on navigation, none/fade/slide/slideleft
        contentURL: null, // specifying content url enables ajax content loading
        contentURLData: null, // override ajax query parameters
        contentCache: true, // cache step contents, if false content is fetched always from ajax url
        cycleSteps: false, // cycle step navigation
        enableFinishButton: false, // makes finish button enabled always
        hideButtonsOnDisabled: false, // when the previous/next/finish buttons are disabled, hide them instead
        errorSteps: [],    // array of step numbers to highlighting as error steps
        labelNext: 'Next', // label for Next button
        labelPrevious: 'Previous', // label for Previous button
        labelFinish: 'Finish',  // label for Finish button
        noForwardJumping: false,
        ajaxType: 'POST',
        // Events
        onLeaveStep: null, // triggers when leaving a step
        onShowStep: null,  // triggers when showing a step
        onFinish: null,  // triggers when Finish button is clicked
        includeFinishButton: true   // Add the finish button
    });
}
