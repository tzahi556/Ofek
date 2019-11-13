
$(function(){
    var $windowWidth = $(window).width();
    var $rightSidebarControl = $('.right-sidebar');
    var $navigationControl = $('.menu-control');
    var $leftNavigation = $('#left-navigation');
    var $minWrapper = $('#min-wrapper');
    var $navigation = $('ul.mainNav');
    /********************  Left Menu accordion Start  ******************************/
    $navigation.multiAccordion({
        multiAccordion:true,
        speed: 500,
        closedSign: '<i class="fa fa-caret-down"></i>',
        openedSign: '<i class="fa fa-caret-up"></i>'
    });
    /********************  Left Menu accordion End  ******************************/


    /********************  Right Box Display Start  ******************************/
    $rightSidebarControl.click(function(){
        $('#setting-tab a:first').tab('show');
        $( "#right-wrapper" ).animate({
            right: '0'
        }, 500, function() {});
    });
    var $rightSidebarSetting = $('.right-sidebar-setting')
    $rightSidebarSetting.click(function(){
        $('#setting-tab a:last').tab('show');
        $( "#right-wrapper" ).animate({
            right: '0'
        }, 500, function() {});
    });
    $('#right-wrapper .close-right-wrapper a').click(function(){
        $( "#right-wrapper" ).animate({
            right: '-280px'
        }, 500, function() {});
    });
    /********************  Right Box Display End  ******************************/


    if($windowWidth > 800){
        onDesktop();
    }
    else if($windowWidth < 500){
        // On phone
        onPhone()
    } else if($windowWidth < 810 ){
        // On Pad
        onTabletDefault();
    }
    $('.phone-nav-control').click(function(){
        if ( $navigation.is( ":hidden" ) ) {
            $navigation.slideDown();
        } else{
            $navigation.slideUp();
        }
    });

    /********************  Minimize left menu hover Display Start  ******************************/
    $('ul.mainNav li').hover(
        function() {
            if($($leftNavigation).hasClass('active')){
                $(this).children('ul').addClass('open');
            }

        }, function() {
            if($($leftNavigation).hasClass('active')){
                $(this).children('ul').removeClass('open');
                if($(this).hasClass('active')){
                    $(this).children('ul').removeAttr( "style" );
                }
            }
        }
    );
    /********************  Minimize left menu hover Display End  ******************************/

    /********************  Call resize when minimize left menu Start  ******************************/
    function dropDownMenuControl(){
        $('ul.mainNav li').children('ul').removeAttr( "style" );
    }
    /********************  Call resize when minimize left menu End  ******************************/

    /********************  Desktop view Start  ******************************/
    function onDesktop(){
        $($navigationControl).click(function(){
            $leftNavigation.css("opacity","0.2");
            dropDownMenuControl();
            if($navigationControl.hasClass('active')){
                $($leftNavigation).animate({
                    width: '200px'
                }, 500, function() {
                    $navigationControl.addClass('spinOut').removeClass('spinIn');
                    changeMenuSizeTriger();
                });
                $($minWrapper).animate({
                    paddingLeft: '200px'
                },500, function(){
                    $navigationControl.removeClass('active');
                    $leftNavigation.children('ul').removeClass('active');
                    $leftNavigation.removeClass('active');
                    $leftNavigation.css("opacity","1");
                });
            } else{
                $navigationControl.addClass('active');
                $leftNavigation.children('ul').addClass('active');
                $leftNavigation.addClass('active');
                $($leftNavigation).animate({
                    width: '50px'
                }, 500, function() {
                    $navigationControl.addClass('spinIn').removeClass('spinOut');
                    changeMenuSizeTriger();
                });
                $($minWrapper).animate({
                    paddingLeft: '50px'
                },500, function(){
                    $leftNavigation.css("opacity","1");
                });
            }

        });
    }
    /********************  Desktop view End  ******************************/

    /********************  Tablet view Start  ******************************/
    function onTabletDefault(){

        $($leftNavigation).width('50px');
        $navigationControl.addClass('spinIn').removeClass('spinOut');
        $navigationControl.addClass('active');
        $leftNavigation.children('ul').addClass('active');
        $leftNavigation.addClass('active');

        $($minWrapper).css('paddingLeft', '50px');
        $(window).trigger('resize');
        $navigation.slideDown();
    }
    function onTablet(){
        $navigation.slideDown();
        $($leftNavigation).animate({
            width: '50px'
        }, 100, function() {
            $navigationControl.addClass('spinIn').removeClass('spinOut');
            $navigationControl.addClass('active');
            $leftNavigation.children('ul').addClass('active');
            $leftNavigation.addClass('active');

        });
        $($minWrapper).animate({
            paddingLeft: '50px'
        },100, function(){
            $(window).trigger('resize');
        });

    }
    /********************  Tablet view End  ******************************/

    /********************  Phone view Start  ******************************/
    function onPhone(){
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
            paddingLeft: '0'
        },100, function(){});
    }
    /********************  Phone view End  ******************************/

    /********************  Layout Size Change Start  ******************************/
    $(window).resize(function(){
        var $currentWindowWidth = $(window).width();
        if($currentWindowWidth < 500){
            // On phone
            onPhone();
        } else if($currentWindowWidth < 810 ){
            // On Pad
            onTablet();
        } else if($currentWindowWidth > 810){
            // On Desktop
            //onDesktop();

            //phoneToDesktop();
        }
    });
    function phoneToDesktop(){
        $($leftNavigation).animate({
            width: '200px'
        }, 500, function() {
            $navigationControl.addClass('spinOut').removeClass('spinIn');
            changeMenuSizeTriger();
        });
        $($minWrapper).animate({
            paddingLeft: '200px'
        },500, function(){
            $navigationControl.removeClass('active');
            $leftNavigation.children('ul').removeClass('active');
            $leftNavigation.removeClass('active');
            $leftNavigation.css("opacity","1");
        });
    }
    function changeMenuSizeTriger(){
        $(window).trigger('resize');
    }
    /********************  Layout Size Change End  ******************************/


    /********************  Layout Change color Start  ******************************/
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
                right: '-200px'
            }, 500, function() {

            });
        } else{
            $(this).addClass('active');
            $($changeColor).animate({
                right: '0'
            }, 500, function() {

            });
        }
    });
    /********************  Layout Change color End  ******************************/
    try{
        /********************  Panel Change Start  ******************************/
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
        /********************  Panel Change Start  ******************************/



        /************************** Plugin load for layout Start **********************************/
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
        /************************** Plugin load for layout End **********************************/
            // ADD SLIDEDOWN ANIMATION TO DROPDOWN //
        $('.dropdown').on('show.bs.dropdown', function(e){
            $(this).find('.dropdown-menu').first().stop(true, true).slideDown( 500, function(){});
        });

        // ADD SLIDEUP ANIMATION TO DROPDOWN //
        $('.dropdown').on('hide.bs.dropdown', function(e){
            $(this).find('.dropdown-menu').first().stop(true, true).slideUp(500, function(){});
        });

    } catch (e){

    }

});



var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
elems.forEach(function (html) {
    var switchery = new Switchery(html);
});
var elementRed = Array.prototype.slice.call(document.querySelectorAll('.js-switch-red'));
elementRed.forEach(function (htmlRed) {
    var switcheryRed = new Switchery(htmlRed, { color: $redActive });
});
var elementLightGreen = Array.prototype.slice.call(document.querySelectorAll('.js-switch-light-green'));
elementLightGreen.forEach(function (htmlgreen) {
    var elementLightGreen = new Switchery(htmlgreen, { color: $lightGreen });
});
var elementLightBlue = Array.prototype.slice.call(document.querySelectorAll('.js-switch-light-blue'));
elementLightBlue.forEach(function (htmlLightBlue) {
    var switcheryLightBlue = new Switchery(htmlLightBlue, { color: $lightBlueActive });
});

