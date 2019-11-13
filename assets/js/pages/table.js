/*------------------------------------------------------------------
 [ Table Trigger Javascript ]

 Project     :	Fickle Responsive Admin Template
 Version     :	1.0
 Author      : 	AimMateTeam
 URL         :  http://aimmate.com
 Support     :  aimmateteam@gmail.com
 Primary use :	Table

 -------------------------------------------------------------------*/

/*-----------------------------------------------*/
jQuery(document).ready(function($) {
    'use strict';

    progressBar();
    table_DnD();
    table_Drag();
    table_Sort();
    data_editable_table();
    table_row_column_color();
});

/*---------------- PROGRESSBAR -----------------*/
function progressBar(){
    'use strict';

    $('.progress-bar').progressbar();
    var $ps = $('.progress-bar');
    $('#m-multi-trigger').click(function() {
        $('.progress-bar').progressbar();
    });
}

/*---------------- TABLE DND -----------------*/
function table_DnD(){
    'use strict';

    $('#ls-row').tableDnD();
}

/*---------------- DRAG-TABLE -----------------*/
function table_Drag(){
    'use strict';

    $('#ls-column').dragtable();
}

/*---------------- SORT-TABLE -----------------*/
function table_Sort(){
    'use strict';

    $('.ls-animated-table').tableSort({
        animation: 'slide',
        speed: 500
    });
}

/*---------------- EIDTABLE-TABLE -----------------*/
function data_editable_table(){
    'use strict';

    $('#ls-editable-table').dataTable(
        {
            "sPaginationType": "full_numbers"
        }
    ).makeEditable({
            //sUpdateURL: "UpdateData.php",
            sUpdateURL: function (value, settings) {
                return (value);
            }
    });
}

/*---------------- TABLE ROW COLUMN COLOR -----------------*/
function table_row_column_color(){
    'use strict';

    $("#ls-row tr td:nth-of-type(odd)").css("background-color", "#EFF1F1");
    $("#ls-column tr td:nth-of-type(even)").css("background-color", "#EFF1F1");
}
