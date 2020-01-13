<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true"
    CodeFile="Dashboard.aspx.cs" Inherits="Control_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../assets/js/jquery-ui.js"></script>
    <script src="../assets/js/bootstrap-multiselect.js"></script>
    <link href="../assets/css/bootstrap-multiselect.css" rel="stylesheet" />
    <script type="text/javascript">

        var mydata;
        var UCommandId = "";
        var UConnectIdSelected = "";
        var Status = 1;
        var typefromyesno = 0;
        $(document).ready(function () {

            if (!SchoolId) {

                OpenMessage("עליך לבחור בית ספר בכדי להמשיך ...");

                return;

            }

            FillCommand();

            FillData();
            FillDate();



            $(".modal").draggable({
                handle: ".modal-header"
            });





            $('input[type=radio][name=radgroup]').change(function () {

                if (this.value == "4") {
                    $("#txtHours").attr("disabled", false);
                } else {
                    $("#txtHours").val("");
                    $("#txtHours").attr("disabled", true);

                }

            });

            $('input[type=radio][name=loozortemp]').change(function () {

                //אם לוז
                if (this.value == "1") {

                    LoozUdate();

                } else {


                    TempUpdate();
                }

            });

        });

        function LoozUdate() {
            $("#txtTempStart").val("");


        }

        function TempUdate() {



        }

        function SaveConnectStatus() {

            var TempStart = $("#txtTempStart").val();

            var TempEnd = $("#txtTempEnd").val();



            var Type = "2";// ($("#loozortemp2").prop("checked")) ? 2 : 1;



            if (Type == 2) {
                if (!$.isNumeric(TempStart) || !$.isNumeric(TempEnd)) {

                    OpenMessage("חובה להזין טמפרטורה תיקנית");
                    return;
                }

            }




            Ajax("Control_SetUserConnectStatus", "LoozOrTemp=" + Type + "&UtempStart=" + TempStart + "&UtempEnd=" + TempEnd + "&UConnectId=" + UConnectIdSelected);
            FillData();



        }

        function FillDate() {
            $('#txtStartDate').datetimepicker(
            {

                timepicker: true,
                datepicker: false,
                format: 'H:i',
                mask: true,
                validateOnBlur: false

            });


        }

        function FillCommand() {
            mydata = Ajax("Control_GetUserCommandData");


            var FirstSelected = "";
            var UCommandName = "";


            for (var i = 0; i < mydata.length; i++) {


                UCommandName = mydata[i].UCommandName;



                if (i == 0) {
                    FirstSelected = "ucommandSelected";
                    UCommandId = mydata[i].UCommandId;
                }
                else {
                    FirstSelected = "";
                }

                var elemCommand = "<li><div id='dvCommand_" + mydata[i].UCommandId + "'  onclick='OpenCommand(" + mydata[i].UCommandId + ")' class='btn btn-info btn-round btn-xs btnArea " + FirstSelected + "'>"
                                 + UCommandName + "</div></li>"


               $("#ulCommand").append(elemCommand);

               $("#ddlCommands").append("<optgroup label='" + mydata[i].UCommandName + "'>" + getHtmlBakarConnect(mydata[i].UCommandId) + "</optgroup>");
                


            }

           

            $("#ddlCommands,#ddlDays").multiselect({
                enableClickableOptGroups: true,
                includeSelectAllOption: true,
                inheritClass: true,
                enableClickableOptGroups: true,
                buttonWidth: '100%'

            });

            //fillComboByCommandId();

        }
        function fillComboByCommandId() {
            
            mydata = Ajax("Control_GetUserCommandData");
            for (var i = 0; i < mydata.length; i++) {
                if (mydata[i].UCommandId == UCommandId) {
                    $("#ddlCommands").append("<optgroup label='" + mydata[i].UCommandName + "'>" + getHtmlBakarConnect(mydata[i].UCommandId) + "</optgroup>");
                }
            }
        }
        function FillData() {



            $("#dvMainContainer").html("");
            mydata = Ajax("Control_GetUserDataByUCommand", "UCommandId=" + UCommandId);

            //במידה והסתיים הסשן
            //if (mydata[0].IsConnect && mydata[0].IsConnect == "sessFalse") {

            //    location.href = "../Login.aspx";
            //}

            // יש סשן רק בקר לא במערכת
            //if (mydata[0].IsCommand) {

            //    OpenMessage("בקר לא מחובר , אנא פנה למנהל מערכת.");
            //    return;
            //}




            var UCategoryName = "";
            var UCategoryId = "";

            for (var i = 0; i < mydata.length; i++) {

                // Add Category
                if (mydata[i].UCategoryName != UCategoryName) {

                    UCategoryName = mydata[i].UCategoryName;
                    UCategoryId = mydata[i].UCategoryId;
                    var CategoryTemplate = $("#dvCategoryTemplate").html();
                    CategoryTemplate = CategoryTemplate.replace("@CategoryName", UCategoryName).replace("@UCategoryId", UCategoryId);
                    $("#dvMainContainer").append(CategoryTemplate);



                }

                // Add Connect
                if (mydata[i].UCommandId == UCommandId) {
                    var ConnectTemplate = $("#dvConnectTemplate").html();



                    ConnectTemplate = ConnectTemplate.replace(/@UConnType2/g, mydata[i].UConnType2);
                    ConnectTemplate = ConnectTemplate.replace(/@LoozOrTemp/g, mydata[i].LoozOrTemp);
                    ConnectTemplate = ConnectTemplate.replace(/@URlyConnectId/g, mydata[i].URlyConnectId);
                    ConnectTemplate = ConnectTemplate.replace(/@UtempStart/g, mydata[i].UtempStart);
                    ConnectTemplate = ConnectTemplate.replace(/@UtempEnd/g, mydata[i].UtempEnd);
                    ConnectTemplate = ConnectTemplate.replace(/@UTemp/g, (mydata[i].UTemp) ? mydata[i].UTemp : 0);
                    ConnectTemplate = ConnectTemplate.replace(/@UConnectName/g, mydata[i].UConnectName).replace(/@UConnectId/g, mydata[i].UConnectId);

                    // אם הוא נצירת שבת
                    //if (mydata[i].UConnType == "5") {
                    //    ConnectTemplate = ConnectTemplate.replace(/@img/g, "clock");
                    //}
                    //else
                    //{


                    if (mydata[i].UStatus == "2")
                        ConnectTemplate = ConnectTemplate.replace(/@img/g, (mydata[i].Value == "0") ? "Off" : ((mydata[i].Value == "1") ? "On" : "error"));
                    else
                        ConnectTemplate = ConnectTemplate.replace(/@img/g, (mydata[i].UStatus == "0") ? "Off" : "On");

                    // }

                    $("#dvCategoryConainer_" + UCategoryId).append(ConnectTemplate);

                    if (mydata[i].UConnType == 1) {

                        $('#tempTuner_' + mydata[i].UConnectId).hide();

                    } 

                    $("#" + mydata[i].UConnectId + "_" + mydata[i].UStatus).addClass("imgSelected");


                    // $("#ddlConnects").append("<option value=" + mydata[i].UConnectId + ">" + mydata[i].UConnectName + "</option>");
                }
            }
            
            DefineDragAndDropEvents();


        }

        function getHtmlBakarConnect(CurrentCommandId) {

            //$("#ddlConnects").html("");
            //var CurrentCommandId = $("#ddlCommands").val();

            var htmlOption = "";
            var Currentmydata = Ajax("Control_GetUserDataByUCommand", "UCommandId=" + CurrentCommandId);
            for (var i = 0; i < Currentmydata.length; i++) {


                htmlOption += "<option value=" + Currentmydata[i].UConnectId + ">&nbsp;&nbsp;&nbsp;" + Currentmydata[i].UConnectName + "</option>";
            }

            return htmlOption;
        }

        function OpenCommand(UCommandIdSelected) {


            $("#dvCommand_" + UCommandId).removeClass("ucommandSelected");
            UCommandId = UCommandIdSelected;
            
            
            FillData();
            $("#dvCommand_" + UCommandId).addClass("ucommandSelected");

            


        }

        function OpenConnect(UConnectId, UConnectName, URlyConnectId, UtempStart, UtempEnd, LoozOrTemp, UConnType2,e) {

            e.cancelBubble = true;
            //// רק אם היחידה המקושרת היא טמפרטורה תציג
            //if (4 == "1") {
            //    $("#dvStatusContainer").hide();
            //} else {
            //    $("#dvStatusContainer").show();
            //    $("#txtTempStart").val(isEmpty(UtempStart));
            //    $("#txtTempEnd").val(isEmpty(UtempEnd));
            //}





            //$("#loozortemp" + LoozOrTemp).prop("checked", true);

            UConnectIdSelected = UConnectId;
            //$("#ddlCommands").val(UConnectIdSelected);
            //fillComboByCommandId();
            GetConnectTimeLooz();


            $("#modalTitle").text(UConnectName);
            $("#myModal").modal();

            //
            //  $("#ddlCommands").val(UConnectIdSelected);
            $("#ddlCommands").multiselect("clearSelection");
            $('#ddlCommands').multiselect('select', [UConnectIdSelected]);
            $('#ddlCommands').multiselect('refresh');
            $("#ddlDays").multiselect("clearSelection");
            //$('#txtStartDate').val('').datetimepicker("update");

            //var $hours = $('#txtStartDate').datepicker();

            //$hours.datepicker('setDate', null);
            $("#txtStartDate").val("");
            FillDate();
            //$('#ddlDays').multiselect('select', [UConnectIdSelected]);
            //$('#ddlDays').multiselect('refresh');


        }

        var TypeSelected;
        function OpenShortAction(Type, UConnectId) {

            // אם הוא בחור לא לתת עוד פעם בחירה
            if ($("#" + UConnectId + "_" + Type).hasClass("imgSelected")) {

                return;
            }


            UConnectIdSelected = UConnectId;
            TypeSelected = Type;




            if (Type == 1) {
                $("#ModalAuto").modal();

            } else {
                $("img[id^='" + UConnectId + "_']").removeClass("imgSelected");
                $("#" + UConnectId + "_" + Type).addClass("imgSelected");

                replaceStatusAfterSave(Type, UConnectIdSelected);
                // 2 שעון
                // 0 כיבוי
                var myConnectdata = AjaxAsync("Control_SetConnectAutoAction", "UConnectId=" + UConnectIdSelected
                                  + "&UStatus=" + Type + "&UStaticOnHour=");


            }

        }

        function SetAutoHour() {

            var UStatus = $('input[name=radgroup]:checked').val(); // $('input[type=radio][name=radgroup]').val();
            var UStaticOnHour = $('#txtHours').val();

            $("img[id^='" + UConnectIdSelected + "_']").removeClass("imgSelected");
            $("#" + UConnectIdSelected + "_" + TypeSelected).addClass("imgSelected");



            if (UStatus == 4 && !$.isNumeric(UStaticOnHour)) {
                OpenMessage("חובה לשים מספר תיקני");
                return;
            }

            if (UStatus != 4) {
                UStaticOnHour = $('input[name=radgroup]:checked').val();


            }
            if (UStatus == 4) UStatus = 1;

            replaceStatusAfterSave("1", UConnectIdSelected);

            var myConnectdata = AjaxAsync("Control_SetConnectAutoAction", "UConnectId=" + UConnectIdSelected
                                      + "&UStatus=1&UStaticOnHour=" + UStaticOnHour);
            //setTimeout(function () {
            //    FillData();
            //}, 2000);




            $("#ModalAuto").modal("hide");

        }

        function replaceStatusAfterSave(uStatus, UConnectId) {

            if (uStatus == "1") {

                $("#img_" + UConnectId).attr("src", "../assets/images/On.png");

            } else {
                $("#img_" + UConnectId).attr("src", "../assets/images/Off.png");


            }

        }


        function replaceStatus() {

            if (Status == 1) {
                // imgEnter" src="../assets/images/On.png"
                $("#imgEnter").attr("src", "../assets/images/Off.png");
                Status = 0;
            } else {
                $("#imgEnter").attr("src", "../assets/images/On.png");
                Status = 1;

            }

        }

        function SaveData() {

            //  Ajax("School_UpdateConfigHours", "Hours=" + arr);
            //  bootbox.alert("המידע נשמר בהצלחה");

        }

        function GetConnectTimeLooz() {

            $(".timeZone").remove();

            var myConnectdata = Ajax("Control_GetConnectLooz", "UConnectId=" + UConnectIdSelected);

            for (var i = 0; i < myConnectdata.length; i++) {

                var TimeTemplate = $("#dvTimeTemplate").html();
                TimeTemplate = TimeTemplate.replace(/@UConnectLoozId/g, myConnectdata[i].UConnectLoozId);
                TimeTemplate = TimeTemplate.replace(/@DayId/g, myConnectdata[i].DayId);
                TimeTemplate = TimeTemplate.replace(/@Time/g, myConnectdata[i].Time);
                TimeTemplate = TimeTemplate.replace(/@Status/g, myConnectdata[i].Status);
                TimeTemplate = TimeTemplate.replace(/@time/g, "timeZone");

                var DayId = myConnectdata[i].DayId;

                $("#day_" + DayId).append(TimeTemplate);


            }




        }

        function AddTimeToLooz() {

            var ConnectsList = GetSelectedValueMultiSelect('#ddlCommands');
            // var connectList = $("#ddlCommands").val();
            var DaysIds = GetSelectedValueMultiSelect('#ddlDays');
           // var DayId = $("#ddlDays").val();
            var Time = $("#txtStartDate").val();

            if (Time.replace(/[_:]/g, '') == "") {


                OpenMessage("לא ניתן להכניס שעה ללוז ללא שעה.");
                return;
            }

            var myConnectdata = Ajax("Control_SetConnectLooz", "UConnectId=" + ConnectsList
                                    + "&DayId=" + DaysIds + "&Time=" + Time + "&Status=" + Status
            );

            GetConnectTimeLooz();


        }

        function DeleteTime(UConnectLoozId, DayId) {

            Ajax("Control_DeleteConnectLooz", "UConnectLoozId=" + UConnectLoozId + "&UConnectId=" + UConnectIdSelected + "&DayId=" + DayId);
            GetConnectTimeLooz();
        }

        
        TargetId = "";
        SourceId = "";
        function CallBackFromYesNo(Type) {

            if (Type == 1) {

                // מעתיק את כל הלוז

                var TypeToCopy = "1";
                typefromyesno = 1;
                if (SourceId == UConnectIdSelected.toString()) {
                    Ajax("Control_SetCopyConnectLoozToManyConnects", "&UConnectSourceId=" + SourceId + "&UConnectTargetId=" + TargetId);
                    return;
                }
                if (SourceId.indexOf("dvConnect_") != "-1" && TargetId.indexOf("dvConnect_") != "-1") {

                    SourceId = SourceId.replace("dvConnect_", "");
                    TargetId = TargetId.replace("dvConnect_", "");

                }

                if (SourceId.indexOf("day_") != "-1" && TargetId.indexOf("day_") != "-1") {

                    SourceId = SourceId.replace("day_", "");
                    TargetId = TargetId.replace("day_", "");
                    TypeToCopy = "2";
                }



               Ajax("Control_SetCopyConnectLooz", "UConnectId=" + UConnectIdSelected + "&Type=" + TypeToCopy + "&UConnectSourceId=" + SourceId
                                   + "&UConnectTargetId=" + TargetId);
                
                if (TypeToCopy == "2") {

                    GetConnectTimeLooz();
                }
                

            }
        }
        function CopyLoozFromModal(type) {
            TargetId = '';
            var ConnectsList = GetSelectedValueMultiSelect('#ddlCommands');
            var ConnectsNames = '';
            
            for (i = 0; i < ConnectsList.length; i++) {
                if (ConnectsList[i] == UConnectIdSelected) {
                    continue;
                }
                var data = Ajax("Gen_GetTable", "TableName=UConnect&Condition=UConnectId=" + ConnectsList[i]);
                if (i > 0 && i < ConnectsList.length) {
                    ConnectsNames += ',';
                    TargetId += ',';
                }

                ConnectsNames += data[0].UConnectName;

                TargetId += ConnectsList[i].toString();
            }
            SourceId = UConnectIdSelected.toString();
           

            OpenMessage(" האם להעתיק לוז נוכחי אל הנקודות:" + '\n' + ConnectsNames.toString() + "?","כן","לא");
            
        }
        function ChangeTemp(UConnectId, Temp, Val,e) {
            e.stopPropagation();
            Ajax("Admin_UpdateTempByConnectId", "UConnectId=" + UConnectId + "&val=" + Val);
            var data = Ajax("Gen_GetTable", "TableName=UConnect&Condition=UConnectId=" + UConnectId);
            Temp =  data[0].UTemp;
            $('#temp_' + UConnectId).html(Temp);

        }

        function DefineDragAndDropEvents() {
            $(".draggable").draggable({
                cancel: ".borrowStyleNoDrag",
                helper: "clone",
                cursor: "move",
                //revert: true,
                start: function (event, ui) {
                    ui.helper.width($(this).width());

                }


            });


            $(".droppable").droppable({

                accept: ".draggable",
                drop: function (event, ui) {


                    TargetId = $(this).attr("id");
                    SourceId = ui.draggable.attr("id");


                    // alert(SourceId + "  " + TargetId);

                    OpenMessage("האם אתה בטוח שברצונך להעתיק את כל הלוז ? ", "כן", "לא");


                }
            });
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="col-md-12" id="dvMainContainer">
    </div>

    <%-- חלון מודלי של לוז שבועי לנקודה --%>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header label-info">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title">לו"ז שבועי - <span id="modalTitle"></span>
                    </h4>
                </div>
                <div class="modal-body" id="Div4">

                    <%--  <div id="dvStatusContainer">
                       <div class="col-md-1">
                            סטטוס:
                        </div>

                        <div class="col-md-3">
                            <label class="radio-inline">
                                <input type="radio" name="loozortemp" id="loozortemp1" value="1">לפי לו"ז</label>
                            <label class="radio-inline">
                                <input type="radio" name="loozortemp" id="loozortemp2" value="2">לפי טמפרטורה</label>


                        </div>--%>
                    <%--<div class="col-md-1">
                            <span class="help-block m-b-none">מטמפרטורה:</span>
                        </div>

                        <div class="col-md-2">
                            <div class="input-group ls-group-input">
                                <input type="text" id="txtTempStart" class="form-control">
                            </div>
                        </div>
                        <div class="col-md-1" style="text-align:left">
                            <span class="help-block m-b-none">עד: </span>
                        </div>

                        <div class="col-md-2">
                            <div class="input-group ls-group-input">
                                <input type="text" id="txtTempEnd" class="form-control">
                            </div>
                        </div>


                        <div class="col-md-1" style="text-align: center">
                            <button type="button" class="btn btn-info btn-round" onclick="SaveConnectStatus()">
                                <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>שמור סטטוס</span>
                            </button>
                        </div>--%>


                    <%--  <div class="clear">
                            <hr />
                        </div>
                    </div>--%>

                    <div id="dvLoozContainer">
                        <div class="col-md-2" style="text-align: center">
                            <label>העתק אל התחנות</label>
                            <button type="button" id=""  class="btn btn-success btn-round" onclick=" CopyLoozFromModal()">
                                <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>  העתק לו"ז נוכחי </span>
                            </button>
                        </div>
                        <div class="col-md-3">
                            <label>בקר/תחנות</label>
                            <select id="ddlCommands" class="form-control"
                                multiple="multiple" multi-select>
                            </select>
                        </div>


                        <%-- <div class="col-md-2">
                            <label>תחנה</label>
                            <select id="ddlConnects" class="form-control">
                            </select>
                        </div>--%>




                        <div class="col-md-2">
                            <label>יום</label>
                            <select id="ddlDays" class="form-control" multiple="multiple" multi-select>
                                <option value="1">ראשון</option>
                                <option value="2">שני</option>
                                <option value="3">שלישי</option>
                                <option value="4">רביעי</option>
                                <option value="5">חמישי</option>
                                <option value="6">שישי</option>
                                <option value="7">שבת</option>
                            </select>
                        </div>


                        <div class="col-md-2">
                            <label>שעה</label>
                            <div class="input-group ls-group-input">
                                <input type="text" id="txtStartDate" class="form-control">
                                <span class="input-group-addon spDateIcon"><i class="glyphicon glyphicon-time"></i></span>
                            </div>
                        </div>


                        <div class="col-md-1">
                            <br />
                            <img id="imgEnter" src="../assets/images/On.png" onclick="replaceStatus()" />
                        </div>

                        <div class="col-md-2" style="text-align: center">
                            <br />
                            <button type="button" class="btn btn-info btn-round" onclick="AddTimeToLooz()">
                                <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>הוסף ללו"ז</span>
                            </button>
                        </div>

                        <div class="clear">
                            <hr />
                        </div>

                        <div class="col-md-12">
                            <span class="spTitle">להסרת שעה מהלו"ז עליך ללחוץ על השעה המבוקשת.</span>
                            <br />
                            <br />
                        </div>
                        <div class="clear">
                            <hr />
                        </div>

                        <div class="col-md-1 dvLoozDayFirst draggable droppable" id="day_1">
                            <div class="col-md-2">ראשון</div>


                        </div>

                        <div class="col-md-1 dvLoozDay draggable droppable" id="day_2">
                            <div class="col-md-2">שני</div>
                        </div>

                        <div class="col-md-1 dvLoozDay draggable droppable" id="day_3">
                            <div class="col-md-2">שלישי</div>


                        </div>
                        <div class="col-md-1 dvLoozDay draggable droppable" id="day_4">
                            <div class="col-md-2 ">רביעי</div>



                        </div>
                        <div class="col-md-1 dvLoozDay draggable droppable" id="day_5">
                            <div class="col-md-2">חמישי</div>

                        </div>
                        <div class="col-md-1 dvLoozDay draggable droppable" id="day_6">
                            <div class="col-md-2">שישי</div>

                        </div>
                        <div class="col-md-1 dvLoozDay draggable droppable" id="day_7">
                            <div class="col-md-2">שבת</div>

                        </div>

                    </div>

                    <div class="clear">
                        &nbsp;
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-info btn-xs" data-dismiss="modal">
                        סגור</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalAuto" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header label-info">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title">
                        <span>הדלקה קבועה</span>
                    </h4>
                </div>
                <div class="modal-body" id="Div2">

                    <div class="col-md-12">
                        <label class="rdblock">
                            <input type="radio" name="radgroup" checked="checked" value="0">הדלקה עד להודעה חדשה.</label>
                        <label class="rdblock">
                            <input type="radio" name="radgroup" value="1">1 שעה.</label>
                        <label class="rdblock">
                            <input type="radio" name="radgroup" value="2">2 שעות.</label>
                        <label class="rdblock">
                            <input type="radio" name="radgroup" value="3">3 שעות.</label>
                        <label class="rdblock">
                            <input type="radio" name="radgroup" value="4">אחר:
                            <input type="text" id="txtHours" disabled>
                        </label>
                    </div>
                    <div class="col-md-12" style="text-align: left">

                        <div class="btn btn-info btn-round" onclick="SetAutoHour()">
                            <i class="glyphicon glyphicon-edit"></i>&nbsp; <span id="spYesText">אישור</span>
                        </div>
                    </div>
                    <div class="clear">
                        &nbsp;
                    </div>
                </div>
                <%--  <div class="modal-footer">
                    <button type="button" class="btn btn-info btn-xs" data-dismiss="modal">
                        סגור</button>
                </div>--%>
            </div>
        </div>
    </div>

    <div id="dvCategoryTemplate" style="display: none">
        <div class="row dvSection">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">&nbsp; @CategoryName
                    </h3>
                </div>
                <div class="panel-body">

                    <div class="col-md-12" id="dvCategoryConainer_@UCategoryId">
                    </div>


                </div>
            </div>
        </div>




    </div>

    <div id="dvConnectTemplate" style="display: none">
        <div class="col-md-2">
            <div style="height:60px;" class="btn btn-default btn-round dvConnect draggable droppable dvConnectPanel" id="dvConnect_@UConnectId" onclick="OpenConnect(@UConnectId,'@UConnectName','@URlyConnectId','@UtempStart','@UtempEnd',@LoozOrTemp,@UConnType2,event)">
                <img id="img_@UConnectId" src="../assets/images/@img.png" />
                
                <span style="align-items:center;" id="tempTuner_@UConnectId">                 
                    
                   
                    <i style="padding:0;" class='btn btn-dark btn-round glyphicon glyphicon-plus-sign' onclick="ChangeTemp(@UConnectId,@UTemp,1,event)">

                    </i>
                    <span id="temp_@UConnectId">@UTemp</span>
                    <i  style="padding:0;" class='btn btn-dark btn-round glyphicon glyphicon-minus-sign' onclick="ChangeTemp(@UConnectId,@UTemp,-1,event)"></i>
                 </span>                                    
                <br />
                <span>@UConnectName</span>
            </div>
            <div style="text-align: center" id="dvStatic_@UConnectId">
                <img id="@UConnectId_2" src="../assets/images/lightNormalIcon.png" onclick="OpenShortAction(2,@UConnectId)" />
                <img id="@UConnectId_1" src="../assets/images/lightOnConstant.png" onclick="OpenShortAction(1,@UConnectId)" />
                <img id="@UConnectId_0" src="../assets/images/lightOffConstant.png" onclick="OpenShortAction(0,@UConnectId)" />
            </div>

        </div>

    </div>

    <div id="dvTimeTemplate" style="display: none">
        <div class="btn btn-info   btn-round @time" onclick="DeleteTime(@UConnectLoozId,@DayId)">
            <img src="../assets/images/@Status.png" />
            <span>@Time</span>
        </div>
    </div>
</asp:Content>
