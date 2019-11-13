<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true"
    CodeFile="Borrow.aspx.cs" Inherits="Borrow_Borrow" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
    <script type="text/javascript">

        var mydata;


        var OrgUnitCode = "";

        $(document).ready(function () {


            SetPageConfigure();
            GetComboItems("Codes", "TableId=5", "#ddlArea", "ValueCode", "ValueDesc");

            InitDateTimePickerPlugin('#txtStartDate,#txtEndDate,#txtSearchDate', getDateTimeNowFormat(), 0);
            FillData();

            $(".modal").draggable({
                handle: ".modal-header"
            });




            $("#ddlArea").change(function () {
             
                FillData();
            });




        });


        function SetPageConfigure() {

            var docWidth = $(document).width() - 220;
            $('.dvPanelMainBorrow,.dvPanelMainRed ').css({ "width": docWidth / 2 });


        }


        function FillData() {


            $("#dvRelvantContainer,#dvBorrowCotainer,#dvRedRelvantCotainer,#dvRedCotainer").html("");

//            var StartDate = $('#txtStartDate').val();
//            var EndDate = $('#txtEndDate').val();
            OrgUnitCode = $('#ddlArea').val();

            if (OrgUnitCode == "0") {

                $(".spAreaName").text("");
                return;

            }
            $(".spAreaName").text($('#ddlArea option:selected').text());

            var SearchDate = $('#txtSearchDate').val();
            mydata = Ajax("Borrow_InitialData", "SearchDate=" + SearchDate + "&OrgUnitCode=" + OrgUnitCode);

            var Area = "";
            var EmpHtml = "";
            for (var i = 0; i < mydata.length; i++) {


                var Type = mydata[i].Type;
                var SourceOrgUnitCode = mydata[i].OrgUnitCode;
                var TargetOrgUnitCode = mydata[i].TargetOrgUnitCode;
                var SourceOrgUnitDesc = mydata[i].ValueDesc;

                EmpHtml = $("#dvEmployeeTemplate").html();
                EmpHtml = EmpHtml.replace("@Symbol", (mydata[i].Symbol) ? mydata[i].Symbol : "&nbsp;");
                EmpHtml = EmpHtml.replace("@BorrowId", mydata[i].BorrowId);

                


                // אזור הרלוונטיים להשאלות
                if (SourceOrgUnitCode != OrgUnitCode) {

                    // הגדרת כותרת אזורים בתוך הרלונטיים
                    if (Area != SourceOrgUnitDesc) {
                        Area = SourceOrgUnitDesc;
                        $("#dvRelvantContainer").append("<div class='dvAreaTitle'>" + Area + "</div>");

                    }

                    // אלו המושאלים לאזור הנוכחי
                    if (TargetOrgUnitCode == OrgUnitCode) {

                      

                        EmpHtml = EmpHtml.replace("@btnTheme", "btn-primary draggable");
                        EmpHtml = EmpHtml.replace("@OrgUnitDesc", SourceOrgUnitDesc);
                        EmpHtml = EmpHtml.replace("@EmpNo", "Borrow_" + mydata[i].EmpNo + "_" + mydata[i].BorrowId);
                        EmpHtml = EmpHtml.replace("@EmpNo", mydata[i].EmpNo);
                        EmpHtml = EmpHtml.replace("@EmpName", mydata[i].FullName + "<br>" + mydata[i].DatesRange);
                        $("#dvBorrowCotainer").append(EmpHtml);

                    }
                    else {
                        // מושאלים לאזור אחר
                        if (Type == "1") {
                            EmpHtml = EmpHtml.replace("@btnTheme", "btn-default");
                            EmpHtml = EmpHtml.replace("@OrgUnitDesc", "מושאל ל " + mydata[i].TargetOrgUnitDesc);

                        }

                        // נגרע מאזור אחר
                        else if (Type == "2") {
                            EmpHtml = EmpHtml.replace("@btnTheme", "btn-default");
                            EmpHtml = EmpHtml.replace("@OrgUnitDesc", "נגרע מ" + mydata[i].TargetOrgUnitDesc);
                        }
                        // עונה על התנאי של מתאים להשאיל אותו
                        else {
                            EmpHtml = EmpHtml.replace("@btnTheme", "btn-primary draggable");
                            EmpHtml = EmpHtml.replace("@OrgUnitDesc", SourceOrgUnitDesc);
                            EmpHtml = EmpHtml.replace("@EmpNo", "Relvant_" + mydata[i].EmpNo);
                        }

                        EmpHtml = EmpHtml.replace("@EmpName", mydata[i].FullName);

                        $("#dvRelvantContainer").append(EmpHtml);

                    }

                }
                // גריעות
                else {
                    // הוא כבר נגרע
                    if (Type == "2") {
                        EmpHtml = EmpHtml.replace("@btnTheme", "btn-primary draggable");
                        EmpHtml = EmpHtml.replace("@OrgUnitDesc", SourceOrgUnitDesc);
                        EmpHtml = EmpHtml.replace("@EmpNo", "Reduced_" + mydata[i].EmpNo);
                        EmpHtml = EmpHtml.replace("@EmpName", mydata[i].FullName + "<br>" + mydata[i].DatesRange);
                        $("#dvRedCotainer").append(EmpHtml);
                    }
                    // שייך לאזור ורלוונטי לגריעה
                    else {
                        EmpHtml = EmpHtml.replace("@btnTheme", "btn-primary draggable");
                        EmpHtml = EmpHtml.replace("@OrgUnitDesc", SourceOrgUnitDesc);
                        EmpHtml = EmpHtml.replace("@EmpNo", "RelRed_" + mydata[i].EmpNo);
                        EmpHtml = EmpHtml.replace("@EmpName", mydata[i].FullName );
                        $("#dvRedRelvantCotainer").append(EmpHtml);
                    }
                }
            }

            DefineDragAndDropEvents();
        }


        var Type = "";
        var EmpNo = "";
        var BorrowId = "";    
        function DefineDragAndDropEvents() {
            $(".draggable").draggable({
                helper: "clone",
                cursor: "hand",
               // revert: true,
                start: function (event, ui) {
                    ui.helper.width($(this).width());
                }


            });


            $(".droppable").droppable({
                // activeClass: "ui-state-default",
                // hoverClass: "ui-state-hover",
                accept: ".draggable",
                drop: function (event, ui) {

                    var EmpName = "";
                    var TargetId = $(this).attr("id");
                    var SourceId = ui.draggable.attr("id");


                    $("#dvBoorowAlert").html("&nbsp;");
                    $("#dvTransfer").hide();
                    $("#spAdd").text("עדכן");

                    // בא מרלוונטי למושאל
                    if (SourceId.indexOf("Relvant_") != -1 && TargetId == "dvBorrowCotainer") {


                        Type = "1";
                        EmpName = $("#" + SourceId + " .spWorkerName").html();
                        SourceId = SourceId.replace("dv_Relvant_", "");
                        EmpNo = SourceId;
                        $("#spTypeTransfer").text("בחירת תאריכים למעבר " + EmpName + " למושאלים ");

                        $("#dvBoorowAlert").html(" שים לב, כפתור העבר מסיר את העובד מהשיבוצים בטווח תאריכים הנ''ל . <br> כפתור הוסף מוסיף את העובד לאזור החדש ללא הסרה...");
                        $("#dvTransfer").show();
                        $("#spAdd").text("הוסף");

                        OpenModalDates();

                    }


                    // ביטול מושאל 
                    if (SourceId.indexOf("Borrow_") != -1 && TargetId == "dvRelvantContainer") {

                        Type = "11";
                        BorrowId = $("#" + SourceId).attr("BorrowId");

                        //alert(BorrowId);



                        EmpName = $("#" + SourceId + " .spWorkerName").html();
                        // SourceId = SourceId.replace("dv_Borrow_", "");
                        EmpNo = $("#" + SourceId).attr("EmpNo");


                     //   alert(EmpNo);


                        $("#spTypeTransfer").text(" ביטול " + EmpName.replace("<br>", "") + " מהשאלה ");
                        OpenModalDates();

                    }



                    // בא מאזור לגריעה
                    if (SourceId.indexOf("RelRed_") != -1 && TargetId == "dvRedCotainer") {


                        Type = "2";
                        EmpName = $("#" + SourceId + " .spWorkerName").html();
                        SourceId = SourceId.replace("dv_RelRed_", "");
                        EmpNo = SourceId;
                        $("#spTypeTransfer").text("בחירת תאריכים למעבר " + EmpName + " לגריעה ");
                        OpenModalDates();

                    }

                    // ביטול גריעה 
                    if (SourceId.indexOf("Reduced_") != -1 && TargetId == "dvRedRelvantCotainer") {


                        Type = "22";

                        BorrowId = $("#" + SourceId).attr("BorrowId");
                        EmpName = $("#" + SourceId + " .spWorkerName").html();
                        SourceId = SourceId.replace("dv_Reduced_", "");
                        EmpNo = SourceId;
                        $("#spTypeTransfer").text(" ביטול " + EmpName + " מגריעה ");
                        OpenModalDates();


                    }




                }
            });
        }


        function OpenModalDates() {

            InitDateTimePickerPlugin('#txtStartDate,#txtEndDate', $("#txtSearchDate").val(), 0);

           
            $("#ModalDates").modal();

        }



        function SaveTransformDB(IsAdd) {
          
           var StartDate = $('#txtStartDate').val();
           var EndDate = $('#txtEndDate').val();

           var res  =  Ajax("Borrow_SetDataDB", "StartDate=" + StartDate + "&EndDate=" + EndDate + "&OrgUnitCode=" + OrgUnitCode
              + "&Type=" + Type + "&EmpNo=" + EmpNo + "&BorrowId=" + BorrowId + "&IsAdd=" + IsAdd);

           if (res[0]) {

               var Message = "שים לב! עובד מושאל ל" + res[0].Area + " בתאריכים " + res[0].range
               $("#dvBoorowAlert").html(Message);

           } else {

                $("#ModalDates").modal('hide');
                FillData();
           }

        }


        function CancelTransform() {
            $("#ModalDates").modal('hide');
        }
      



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="col-md-12">
        <div class="row">
            <div class="panel panel-info" style="margin: 2px">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <i class="glyphicon glyphicon-th-list"></i>&nbsp; השאלות וגריעות עובדים לאזור
                    </h3>
                </div>
                <div class="panel-body" style="padding: 8px">
                    <div class="col-md-4">
                        <span class="help-block m-b-none">אזור</span>
                        <select id="ddlArea" class="form-control">
                          <option value="0">-- בחר --</option>
                        
                        </select>
                    </div>
                    <div class="col-md-3">
                        <span class="help-block m-b-none">הכנס תאריך תחילה </span>
                        <div class="input-group ls-group-input">
                            <input type="text" class="form-control" id="txtSearchDate">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                        </div>
                    </div>
                    <%--<div class="col-md-3" style="">
                        <span class="help-block m-b-none">הכנס תאריך סיום </span>
                        <div class="input-group ls-group-input">
                            <input type="text" class="form-control" id="txtEndDate">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                        </div>
                    </div>  --%>
                    <div class="col-md-2">
                        <span class="help-block m-b-none">&nbsp; </span>
                        <button type="button" class="btn btn-info btn-round" onclick="FillData()">
                            <i class="glyphicon glyphicon-user"></i>&nbsp; <span class="btnAssign">חפש </span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="panel panel-info dvPanelMainBorrow">
        <div class="panel-heading">
            <h3 class="panel-title">
                <i class="glyphicon glyphicon-th-list"></i>&nbsp; עובדים עם כישורים מתאימים ל -
                <span class="spAreaName"></span>
            </h3>
        </div>
        <div class="panel-body" style="padding: 0px">
            <div class="dvPanelBorrow droppable" id="dvRelvantContainer">
                &nbsp;
            </div>
        </div>
    </div>
    <div class="panel panel-info dvPanelMainBorrow">
        <div class="panel-heading">
            <h3 class="panel-title">
                <i class="glyphicon glyphicon-th-list"></i>&nbsp; עובדים מושאלים ל - <span class="spAreaName">
                </span>
            </h3>
        </div>
        <div class="panel-body" style="padding: 0px">
            <div class="dvPanelBorrow droppable" id="dvBorrowCotainer" style="padding-top: 25px">
                &nbsp;
            </div>
        </div>
    </div>
    <div class="panel panel-info dvPanelMainRed">
        <div class="panel-heading">
            <h3 class="panel-title">
                <i class="glyphicon glyphicon-th-list"></i>&nbsp; עובדים שייכים ל - <span class="spAreaName">
                </span>
            </h3>
        </div>
        <div class="panel-body" style="padding: 0px">
            <div class="dvPanelRed droppable" id="dvRedRelvantCotainer">
                &nbsp;
            </div>
        </div>
    </div>
    <div class="panel panel-info dvPanelMainRed">
        <div class="panel-heading">
            <h3 class="panel-title">
                <i class="glyphicon glyphicon-th-list"></i>&nbsp; עובדים שנגרעו מ - <span class="spAreaName">
                </span>
            </h3>
        </div>
        <div class="panel-body" style="padding: 0px">
            <div class="dvPanelRed droppable" id="dvRedCotainer">
                &nbsp;
            </div>
        </div>
    </div>
    <%-- חלון מודלי של הגדרת עובד--%>
    <div class="modal fade" id="ModalDates" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header label-info">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title">
                      <span id="spTypeTransfer"></span>
                    </h4>
                </div>
                <div class="modal-body" id="Div8">
                    <div class="col-md-12">
                        <div style="text-decoration: underline; direction: ltr; text-align: right" id="txtTitleForAddHour">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <span class="help-block m-b-none">תאריך התחלה</span>
                        <div class="input-group ls-group-input">
                            <input type="text" id="txtStartDate" class="form-control">
                            <span class="input-group-addon spDateIcon"><i class="fa fa-calendar"></i></span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <span class="help-block m-b-none">תאריך סיום</span>
                        <div class="input-group ls-group-input">
                            <input type="text" id="txtEndDate" class="form-control">
                            <span class="input-group-addon spDateIcon"><i class="fa fa-calendar"></i></span>
                        </div>
                    </div>
                    <div class="col-md-6 dvMessageRed" id="dvBoorowAlert">
                               שים לב, העברת עובד מסירה אותו מהשיבוצים בטווח תאריכים
                               
                    </div>
                    <div class="col-md-6" style="text-align: left">
                        <div class="btn ls-red-btn btn-round" onclick="CancelTransform()">
                            <i class="glyphicon glyphicon-remove-sign"></i>&nbsp; <span>בטל</span>
                        </div>

                         <div class="btn btn-info btn-round" onclick="SaveTransformDB(1)">
                            <i class="glyphicon glyphicon-edit"></i>&nbsp; <span id="spAdd">הוסף</span>
                        </div>



                        <div class="btn btn-primary btn-round" id="dvTransfer" onclick="SaveTransformDB(0)">
                            <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>העבר</span>
                        </div>
                    </div>
                   
                    <div class="clear">
                        &nbsp;</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-info btn-xs" data-dismiss="modal">
                        סגור</button>
                </div>
            </div>
        </div>
    </div>
    <%-- טמפלט של עובד --%>
    <div id="dvEmployeeTemplate" style="display: none">
        <div class="btn @btnTheme btnWorkerBorrow" BorrowId="@BorrowId" id="dv_@EmpNo" EmpNo="@EmpNo" title="@OrgUnitDesc">
            <span class="spJobSign">@Symbol</span> <span class="spWorkerName">@EmpName</span>
        </div>
    </div>
</asp:Content>
