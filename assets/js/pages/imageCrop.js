/*------------------------------------------------------------------
 [ Image Cropper Trigger Javascript ]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :  http://aimmate.com
 Support     :  aimmateteam@gmail.com
 Primary use :	Image-Crop

 -------------------------------------------------------------------*/

/*-----------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';

    imageCrop();
});

/*---------------- IMAGE CROPPER -----------------*/
function imageCrop(){
    'use strict';

    var $cropper = $(".cropper"),
        $dataX = $("#dataX"),
        $dataY = $("#dataY"),
        $dataH = $("#dataH"),
        $dataW = $("#dataW"),
        cropper;

    $cropper.cropper({
        aspectRatio: 16 / 9,
        data: {
            x: 300,
            y: 250,
            width: 640,
            height: 360
        },
        preview: ".preview",
        dragCrop: true,
        modal: false,
        resizeable: true,

        done: function(data) {
            $dataX.val(data.x);
            $dataY.val(data.y);
            $dataH.val(data.height);
            $dataW.val(data.width);
        }
    });

    cropper = $cropper.data("cropper");

    $("#reset").click(function() {
        $cropper.cropper("reset");
    });

    $("#release").click(function() {
        $cropper.cropper("release");
    });

    /*$("#destroy").click(function() {
     $cropper.cropper("destroy");
     });*/

    $("#setImgSrc").click(function() {
        $cropper.cropper(
            "setImgSrc", $("#imgSrc").val()
        );
    });

}
