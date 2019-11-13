/*------------------------------------------------------------------
 [Layout Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :	Layout
 -------------------------------------------------------------------*/
var $windowWidth = $(window).width();
var $rightSidebarControl = $('.right-sidebar');
var $navigationControl = $('.menu-control');
var $leftNavigation = $('#left-navigation');
var $minWrapper = $('#min-wrapper');
var $navigation = $('ul.mainNav');


jQuery(document).ready(function($) {
    'use strict';


    call_navigation(); // Left Navigation Accordion
    /***** browser size detect on loading Start ******/
    if($windowWidth > 1025){
        onDesktop();
    }
    else if($windowWidth < 500){
        // On phone
        onPhoneDefault()
    } else if($windowWidth < 1025 ){
        // On Pad
        onTabletDefault();
    }
    /***** browser size detect on loading End ******/

    minimize_left_menu_hover_Display();
    right_box_display(); //Right Box Display
    phone_nav_control();
    layout_change_color_start();
    plugin_load_for_layout();
    panel_change_start();
    dropdown_top_nav_bar();
    dropDownMenuControl();
    left_bar_minimize();
});


/********************  Left Menu accordion Start  ******************************/
function call_navigation(){
    'use strict';

    $navigation.multiAccordion({
        multiAccordion:true,
        speed: 500,
        closedSign: '<i class="fa fa-caret-down"></i>',
        openedSign: '<i class="fa fa-caret-up"></i>'
    });
}
/********************  Left Menu accordion End  ******************************/
/********************  Minimize left menu hover Display Start  ******************************/
function minimize_left_menu_hover_Display(){
    $('ul.mainNav li').hover(
        function() {
            if($($leftNavigation).hasClass('active')){
                $(this).children('ul').addClass('open');
            }
        }, function() {
            if($($leftNavigation).hasClass('active')){
                $(this).children('ul').removeClass('open');
                $(this).children('ul').removeAttr( "style" );
            }
        }
    );
}

/********************  Minimize left menu hover Display End  ******************************/

/********************  Call resize when minimize left menu Start  ******************************/
function dropDownMenuControl(){
    'use strict';

    $('ul.mainNav li').children('ul').removeAttr( "style" );
}
/********************  Call resize when minimize left menu End  ******************************/

/********************  Resize Call after resize left menu Start ******************************/
function changeMenuSizeTriger(){
    'use strict';

    $(window).trigger('resize');
}
/********************  Resize Call after resize left menu End  ******************************/


/********************  Desktop view Start  ******************************/

/********************  Left Navigation Transition  callback Start ******************************/
/*$leftNavigation.on('webkitTransitionEnd moztransitionend transitionend oTransitionEnd', function (){

 });*/
/********************  Left Navigation Transition  callback end ******************************/
function left_bar_minimize(){
    'use strict';

    $($navigationControl).click(function () {
       
        if ($navigation.hasClass('active')) {
            $leftNavigation.removeClass('active');
            $navigation.removeClass('active');
            $minWrapper.removeClass('active');
            changeMenuSizeTriger();
        } else {
            $navigation.addClass('active');
            $minWrapper.addClass('active');
            $leftNavigation.addClass('active');
            $navigation.find('ul').removeAttr('style');
            changeMenuSizeTriger();
        }
    });
}
function onDesktop(){
//    'use strict';
//    $navigation.addClass('active');
//    $minWrapper.addClass('active');
//    $leftNavigation.addClass('active');
//    $navigation.find('ul').removeAttr('style');
//    changeMenuSizeTriger();
//    
    //alert();

}


function HideMenuRight() {
        'use strict';
        $navigation.addClass('active');
        $minWrapper.addClass('active');
        $leftNavigation.addClass('active');
        $navigation.find('ul').removeAttr('style');
        changeMenuSizeTriger();

    }

    function ShowMenuRight() {

        $leftNavigation.removeClass('active');
        $navigation.removeClass('active');
        $minWrapper.removeClass('active');
        changeMenuSizeTriger();
    }



/********************  Desktop view End  ******************************/


/********************  Tablet view Start  ******************************/
function onTabletDefault(){
    'use strict';

    $navigation.addClass('active');
    $minWrapper.addClass('active');
    $leftNavigation.addClass('active');
    $navigation.slideDown();
}
function onTablet(){
    'use strict';

    $navigation.addClass('active');
    $minWrapper.addClass('active');
    $leftNavigation.addClass('active');
}
/********************  Tablet view End  ******************************/


/********************  Phone view Start  ******************************/
function onPhoneDefault(){
    'use strict';

    $navigation.addClass('mobile');
    $navigation.css('display', 'none');
    $leftNavigation.css('width', '100%');
    $navigationControl.removeClass('spinIn').addClass('spinOut');
    $navigationControl.removeClass('active');
    $leftNavigation.children('ul').removeClass('active');
    $leftNavigation.removeClass('active');

    $($minWrapper).css('paddingLeft','0');
}
function onPhone(){
    'use strict';

    $($navigation).addClass('mobile');
    $($navigation).css('display', 'none');
    $($leftNavigation).animate({
        width: '100%'
    }, 100, function() {
        $navigationControl.removeClass('spinIn').addClass('spinOut');
        $navigationControl.removeClass('active');
        $leftNavigation.children('ul').removeClass('active');
        $leftNavigation.removeClass('active');

    });
    $($minWrapper).animate({
        paddingRight: '0'
    },100, function(){});
}
/********************  Phone view End  ******************************/


/********************  Layout Size Change Start  ******************************/
var resizeId;
$(window).resize(function() {
    clearTimeout(resizeId);
    resizeId= setTimeout(doneResizingLayout, 500);

});

function doneResizingLayout(){
    var $currentWindowWidth = $(window).width();
    //console.log('Previous Width ->'+$windowWidth);
    //console.log('Current width ->'+$currentWindowWidth);
    if($windowWidth != $currentWindowWidth){
        if($currentWindowWidth < 500){
            // On phone
            onPhone();
        } else if($currentWindowWidth < 1025 ){
            $leftNavigation.removeAttr('style');
            $minWrapper.removeAttr('style');
            $leftNavigation.removeAttr('style');
            $navigation.removeAttr('style');
            $navigation.removeClass('mobile');

            onTablet();
        } else if($currentWindowWidth > 1025){
            // On Desktop
            desktopResize();
        }
        $windowWidth = $currentWindowWidth;
    } else {
        $windowWidth = $currentWindowWidth;
    }
}
function desktopResize(){
    $leftNavigation.removeAttr('style');
    $minWrapper.removeAttr('style');
    $leftNavigation.removeAttr('style');
    $navigation.removeAttr('style');
    $navigation.removeClass('mobile');
    onDesktop();

}
/********************  Layout Size Change End  ******************************/

/********************  Right Box Display Start  ******************************/
function right_box_display(){
    'use strict';

    $rightSidebarControl.click(function(){
        $('#setting-tab a:first').tab('show');
        $( "#right-wrapper" ).animate({
            left: '0'
        }, 500, function() {});
    });
    var $rightSidebarSetting = $('.right-sidebar-setting')
    $rightSidebarSetting.click(function(){
        $('#setting-tab a:last').tab('show');
        $( "#right-wrapper" ).animate({
            left: '0'
        }, 500, function() {});
    });
    $('#right-wrapper .close-right-wrapper a').click(function(){
        $( "#right-wrapper" ).animate({
            left: '-280px'
        }, 500, function() {});
    });

}
/********************  Right Box Display End  ******************************/

/********************  phone nav control Start  ******************************/
function phone_nav_control(){
    'use strict';

    $('.phone-nav-control').click(function(){
        if ( $navigation.is( ":hidden" ) ) {
            $navigation.slideDown();
        } else{
            $navigation.slideUp();
        }
    });
}
/********************  phone nav control End  ******************************/

/********************  Layout Change color Start  ******************************/
function layout_change_color_start(){
    'use strict';

    var $fullContent = $("body");
    $('.change-color-box ul li ').click(function(){
        $fullContent.removeClass('black-color');
        $fullContent.removeClass('blue-color');
        $fullContent.removeClass('deep-blue-color');
        $fullContent.removeClass('red-color');
        $fullContent.removeClass('light-green-color');
        $fullContent.removeClass('default');
        $('.change-color-box ul li ').removeClass('active');
        if($(this).hasClass('active')){
        } else{
            var className = $(this).attr('class');
            $fullContent.addClass(className);
            $(this).addClass('active');
        }
    });
    var $changeColor = $('#change-color')
    $('#change-color-control a').click(function(){
        if($(this).hasClass('active')){
            $(this).removeClass('active');
            $($changeColor).animate({
                left: '-200px'
            }, 500, function() {

            });
        } else{
            $(this).addClass('active');
            $($changeColor).animate({
                left: '0'
            }, 500, function() {

            });
        }
    });
}
/********************  Layout Change color End  ******************************/

/********************  Panel Change Start  ******************************/
function panel_change_start(){
    'use strict';

    $('.panel-control li a.close-panel').click(function(){
        var $elements = $(this).parents(".panel");
        $elements.animate({
            opacity: 0.1
        }, 1000, function() {
            $(this).remove();
        });
    });
    $('.panel-control li a.minus').click(function(){
        var $elements = $(this).parents(".panel").children(".panel-body");
        if($(this).hasClass('active')){
            $elements.slideDown(200);
            $(this).children('i').removeClass('fa-square-o');
            $(this).children('i').addClass('fa-minus');
            $(this).removeClass('active');
        } else{
            $elements.slideUp(200);
            $(this).children('i').removeClass('fa-minus');
            $(this).children('i').addClass('fa-square-o');
            $(this).addClass('active');
        }
    });
}
/********************  Panel Change End  ******************************/
function dropdown_top_nav_bar(){
    'use strict';

    // ADD SLIDEDOWN ANIMATION TO DROPDOWN //
    $('.dropdown').on('show.bs.dropdown', function(e){
        $(this).find('.dropdown-menu').first().stop(true, true).slideDown( 500, function(){});
    });


    // ADD SLIDEUP ANIMATION TO DROPDOWN //
    $('.dropdown').on('hide.bs.dropdown', function(e){
        $(this).find('.dropdown-menu').first().stop(true, true).slideUp(500, function(){});
    });
}
/********************  Panel Change End  ******************************/



/************************** Plugin load for layout Start **********************************/
function plugin_load_for_layout(){
    'use strict';

    try {
        $('.nano').nanoScroller({
            preventPageScrolling: true,
            alwaysVisible: true,
            scroll: 'top'
        });
        $('.nano-chat').nanoScroller({
            preventPageScrolling: true,
            alwaysVisible: true,
            scroll: 'bottom'
        });
        $('.progress-bar').progressbar({
            display_text: 'fill'
        });
        $('.easyPieChart').easyPieChart({
            barColor: $redActive,
            scaleColor: $redActive,
            easing: 'easeOutBounce',
            onStep: function (from, to, percent) {
                $(this.el).find('.easyPiePercent').text(Math.round(percent));
            }
        });
        var chart1 = window.chart = $('.easyPieChart').data('easyPieChart');
        $('.js_update').on('click', function () {
            chart1.update(Math.random() * 200 - 100);
        });


        var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
        elems.forEach(function (html) {
            var switchery = new Switchery(html);
        });
        var elementRed = Array.prototype.slice.call(document.querySelectorAll('.js-switch-red'));
        elementRed.forEach(function (htmlRed) {
            var switcheryRed = new Switchery(htmlRed, {color: $redActive});
        });
        var elementLightGreen = Array.prototype.slice.call(document.querySelectorAll('.js-switch-light-green'));
        elementLightGreen.forEach(function (htmlgreen) {
            var elementLightGreen = new Switchery(htmlgreen, {color: $lightGreen});
        });
        var elementLightBlue = Array.prototype.slice.call(document.querySelectorAll('.js-switch-light-blue'));
        elementLightBlue.forEach(function (htmlLightBlue) {
            var switcheryLightBlue = new Switchery(htmlLightBlue, {color: $lightBlueActive});
        });
    } catch (e){

    }
}
/************************** Plugin load for layout End **********************************/

/************************** Detect IE Start **********************************/
function detectIE() {
    'use strict';

    var ua = window.navigator.userAgent;
    var msie = ua.indexOf('MSIE ');
    var trident = ua.indexOf('Trident/');

    if (msie > 0) {
        // IE 10 or older => return version number
        return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
    }

    if (trident > 0) {
        // IE 11 (or newer) => return version number
        var rv = ua.indexOf('rv:');
        return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
    }
    // other browser
    return false;
}
/************************** Detect IE End **********************************/

