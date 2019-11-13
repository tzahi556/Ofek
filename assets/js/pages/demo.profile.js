/*------------------------------------------------------------------
 [ Profile Trigger Javascript ]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :  http://aimmate.com
 Support     :  aimmateteam@gmail.com
 Primary use :	Profile

 -------------------------------------------------------------------*/

/*-----------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';

    lightGallery();
    nanoScroller();
    progressBar();
    userCircliful();
    userEasyPieChart();
    userTaskManager();
    morrisCHartStart();
    $(window).resize(function(){
        var windowWidth = $(window).width();
        if(windowWidth < 1025){
            $('#hero-donut').html('');

            clearTimeout(resizeIdMorris);
            resizeIdMorris= setTimeout(morrisCHartStart, 600);
        }

    });

    userGoMap();
});





/*------- LIGHT-GALLERY POPUP --------*/
function lightGallery(){
    'use strict';

    $("#ls-project-lightGallery").lightGallery();
}

/*-------------- NanoScroller --------------*/
function nanoScroller(){
    'use strict';

    $('.nano').nanoScroller({
        preventPageScrolling: true
    });
}

/*---------------- PROGRESSBAR ------------------*/
function progressBar(){
    'use strict';

    $('.progress-bar').progressbar({
        display_text: 'fill'
    });
}

/*-------------- USER CIRCLIFUL -------------------*/
function userCircliful(){
    'use strict';

    $('#ls-user-friends').circliful({
        foregroundColor: "#269ABC",
        backgroundColor: "#eee",
        width: 3,
        dimension: "112",
        fillColor: false
    });

    $('#ls-user-followers').circliful({
        foregroundColor: "#269ABC",
        backgroundColor: "#eee",
        width: 3,
        dimension: "112",
        fillColor: false
    });

    $('#ls-user-following').circliful({
        foregroundColor: "#269ABC",
        backgroundColor: "#eee",
        width: 3,
        dimension: "112",
        fillColor: false
    });
    $('#ls-user-posts').circliful({
        foregroundColor: "#269ABC",
        backgroundColor: "#eee",
        width: 3,
        dimension: "112",
        fillColor: false
    });
    $('#ls-user-likes').circliful({
        foregroundColor: "#269ABC",
        backgroundColor: "#eee",
        width: 3,
        dimension: "112",
        fillColor: false
    });
}
/*------------- USER EASY PIE CHART -----------------*/
function userEasyPieChart(){
    'use strict';

    $('.easyPieChartBlack').easyPieChart({
        barColor: '#269ABC',
        scaleColor: '#FF7878',
        easing: 'easeOutBounce',
        size: 100,
        lineWidth: 3,
        onStep: function (from, to, percent) {
            $(this.el).find('.easyPieChartBlackPercent').text(Math.round(percent));
        }
    });
}
/*---------------- MORRIS-CHAT-DONUT --------------------*/
function morrisCHartStart(){
    <!--OS Skill-->
    Morris.Donut({
        element: 'hero-donut',
        data: [
            {label: 'OSX', value: 50 },
            {label: 'Linux', value: 60 },
            {label: 'Ubuntu', value: 90 },
            {label: 'Other', value: 10 }
        ],
        formatter: function (y) {
            return y + "%"
        },
        colors: [$fillColor2, $redActive, $greenActive, $lightBlueActive]
    });
}

/*---------------- GoMAP ------------------*/
function userGoMap(){
    'use strict';

    $(".user-google-location").click(function(){

        $("#user-locator").goMap({
            markers: [{
                latitude: 56.948813,
                longitude: 24.704004,
                html: {
                    content: 'Mr. John Doe',
                    popup:true
                }
            }],
            hideByClick: true
        });

    });

}

/*------------------- Task Manager-SLIP --------------------*/
function userTaskManager(){
    'use strict';

    $('ul#slippylist li i').click(function(){
        if($(this).parent('li').hasClass('strikeout')){
            $(this).parent('li').removeClass('strikeout');
            $(this).addClass('fa-circle-o');
            $(this).removeClass('fa-check');
        } else{
            $(this).addClass('fa-check');
            $(this).removeClass('fa-circle-o');
            $(this).parent('li').addClass('strikeout');

        }
    });

    $(document).on("click", "button.removeTask", function () {
        $(this).parent('li').remove();
        new Slip(ol);
    });

    var ol = document.getElementById('slippylist');
    ol.addEventListener('slip:beforereorder', function (e) {
        if (/demo-no-reorder/.test(e.target.className)) {
            e.preventDefault();
        }
    }, false);

    ol.addEventListener('slip:beforeswipe', function (e) {
        if (e.target.nodeName == 'INPUT' || /demo-no-swipe/.test(e.target.className)) {
            e.preventDefault();
        }
    }, false);

    ol.addEventListener('slip:beforewait', function (e) {
        if (e.target.className.indexOf('instant') > -1) e.preventDefault();
    }, false);

    ol.addEventListener('slip:afterswipe', function (e) {
        e.target.parentNode.removeChild(e.target);
    }, false);

    ol.addEventListener('slip:reorder', function (e) {
        e.target.parentNode.insertBefore(e.target, e.detail.insertBefore);
        return false;
    }, false);

    new Slip(ol);
}

