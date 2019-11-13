/*------------------------------------------------------------------
 [ Sortable  Trigger Js]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :   http://aimmate.com
 Support     :   aimmateteam@gmail.com
 Primary use :   Drag & Drop
 -------------------------------------------------------------------*/


jQuery(document).ready(function($) {
    'use strict';

    sortable_one_call();
    simple_with_drop();
    drag_and_drop_different();
    simple_with_animation();
});

function sortable_one_call(){
    var group1 = $("ul.sortable1").sortable({
        onDrop: function (item, container, _super) {
            $('#serialize_output_1').text(group1.sortable("serialize").get().join("\n"))
            _super(item, container)
        },
        serialize: function (parent, children, isContainer) {
            return isContainer ? children.join() : parent.text()
        }
    });
}
function simple_with_drop(){
    var group2 =  $("ul.simple_with_drop").sortable({
        group: 'no-drop-simple',
        handle: 'i.fa-arrows',
        onDragStart: function (item, container, _super) {
            // Duplicate items of the no drop area
            if(!container.options.drop)
                item.clone().insertAfter(item)
            _super(item);
        },
        onDrop: function (item, container, _super) {
            $('#serialize_output_2').text(group2.sortable("serialize").get().join("\n"))
            _super(item, container)
        },
        serialize: function (parent, children, isContainer) {
            return isContainer ? children.join() : parent.text()
        }
    });
}
function drag_and_drop_different(){
    $("ul.simple_with_no_drop").sortable({
        group: 'no-drop',
        drop: false
    });
    $("ul.simple_with_no_drag").sortable({
        group: 'no-drop',
        drag: false
    });
}
function simple_with_animation(){
    $("ul.sortable2").sortable({
        group: 'simple_with_animation',
        pullPlaceholder: false,
        // animation on drop
        onDrop: function (item, targetContainer, _super) {
            var clonedItem = $('<li/>').css({height: 0});
            item.before(clonedItem);
            clonedItem.animate({'height': item.height()});

            item.animate(clonedItem.position(), function () {
                clonedItem.detach();
                _super(item)
            })
        },

        // set item relative to cursor position
        onDragStart: function ($item, container, _super) {
            var offset = $item.offset(),
                pointer = container.rootGroup.pointer;

            adjustment = {
                left: pointer.left - offset.left,
                top: pointer.top - offset.top
            };

            _super($item, container)
        },
        onDrag: function ($item, position) {
            $item.css({
                left: position.left - adjustment.left,
                top: position.top - adjustment.top
            })
        }
    });
}

