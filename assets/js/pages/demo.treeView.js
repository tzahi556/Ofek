/*------------------------------------------------------------------
 [ Tree View Trigger Javascript ]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.1
 Author      : 	AimMateTeam
 URL         :  http://aimmate.com
 Support     :  aimmateteam@gmail.com
 Primary use :	Tree View

 -------------------------------------------------------------------*/

/*-----------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';

    easyTree();
    multiNestedList();

});

/*---------------- EASY TREE VIEW -------------------*/
function easyTree(){
    'use strict';

    $('.easy-tree').EasyTree({
        addable: true,
        editable: true,
        deletable: true,
        i18n: {
            deleteNull: 'Please select the item you want to delete.',
            deleteConfirmation: 'You sure you want to delete operation?',
            confirmButtonLabel: 'Confirm',
            editNull: 'Please select the item you want to edit.',
            editMultiple: 'You can only edit one',
            addMultiple: 'Please select an add',
            collapseTip: 'Collapse branch',
            expandTip: 'Expand Branch',
            selectTip: 'Select',
            unselectTip: 'Deselect',
            editTip: 'Editing',
            addTip: 'Add to',
            deleteTip: 'Delete',
            cancelButtonLabel: 'Cancel'
        }

    });
}


/*---------------- Multi Nested List -------------------*/
function multiNestedList(){
    'use strict';

    var $this;

    // Select the main list and add the class "hasSubmenu" in each LI that contains an UL
    $('.ls-animated-multi-lists ul').each(function(){
        $this = $(this);
        $this.find("li").has("ul").addClass("hasSubmenu");
    });
// Find the last li in each level
    $('.ls-animated-multi-lists li:last-child').each(function(){
        $this = $(this);
        // Check if LI has children
        if ($this.children('ul').length === 0){
            // Add border-left in every UL where the last LI has not children
            $this.closest('ul').css("border-right", "1px solid #e3dfd8");
        } else {
            // Add border in child LI, except in the last one
            $this.closest('ul').children("li").not(":last").css("border-right","1px solid #e3dfd8");
            // Add the class "addBorderBefore" to create the pseudo-element :defore in the last li
            $this.closest('ul').children("li").last().children("a").addClass("addBorderBefore");
            // Add margin in the first level of the list
            //$this.closest('ul').css("margin-top","20px");
            // Add margin in other levels of the list
            $this.closest('ul').find("li").children("ul").css("margin-top","20px");
        };

        /*---------------------------------------------------*** For Ltr ******-----------------

         else {
         // Add border in child LI, except in the last one
         $this.closest('ul').children("li").not(":last").css("border-left","1px solid #e3dfd8");
         // Add the class "addBorderBefore" to create the pseudo-element :defore in the last li
         $this.closest('ul').children("li").last().children("a").addClass("addBorderBefore");
         // Add margin in the first level of the list
         //$this.closest('ul').css("margin-top","20px");
         // Add margin in other levels of the list
         $this.closest('ul').find("li").children("ul").css("margin-top","20px");
         };


         -----------------------------------------------------------------------------------------*/
    });
// Add bold in li and levels above
    $('.ls-animated-multi-lists ul li').each(function(){
        $this = $(this);
        $this.mouseenter(function(){
            $( this ).children("a").css({"font-weight":"bold","color":"#ff7878"});
        });
        $this.mouseleave(function(){
            $( this ).children("a").css({"font-weight":"normal","color":"#65615B"});
        });
    });
// Add button to expand and condense - Using FontAwesome
    $('.ls-animated-multi-lists ul li.hasSubmenu').each(function(){
        $this = $(this);
        $this.prepend("<a href='#'><i class='fa fa-minus-circle'></i><i style='display:none;' class='fa fa-plus-circle'></i></a>");
        $this.children("a").not(":last").removeClass().addClass("toogle");
    });
// Actions to expand and consense
    $('.ls-animated-multi-lists ul li.hasSubmenu a.toogle').click(function(){
        $this = $(this);
        $this.closest("li").children("ul").toggle("slow");
        $this.children("i").toggle();
        return false;
    });
}
