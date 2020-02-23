<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage/MasterPage.master"
    CodeFile="ControllerTable.aspx.cs" Inherits="ControlAdmin_ControllerTable" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../assets/js/jquery-ui.js"></script>

    <script type="text/javascript">

        var mydata;
        var CommandSelected;



        $(document).ready(function () {
            if (!SchoolId) {

                OpenMessage("עליך לבחור בית ספר בכדי להמשיך ...");
                $("#alertRed").hide();
                $("#MainContainer").hide();
                return;
            }
            FillUCommandTemplate();
            FillData();
            FillDropDownList();
        });


        function CheckValid() {
            var res = true;
            for (i = 0; i < arguments.length; i++) {
                var isDisable = $("#" + arguments[i]).prop('disabled');
                if (!arguments[i] || isDisable) continue;
                var valueOfArg = $("#" + arguments[i]).val();
                if (!valueOfArg) {
                    $("#" + arguments[i]).addClass("inputAlertRed");
                    $(".dvAlertRed").addClass("col-md-6");
                    $("#btn").removeClass("col-md-12");
                    $("#btn").addClass("col-md-6");
                    $(".dvAlertRed").show();
                    res = false;
                }
            }
            return res;
        }

        function ConnectChange(connectId) {

            var UConnType = $("#connectType_" + connectId).val();
            if (UConnType == 2) {
                $("#tempRegister_" + connectId).prop('disabled', false);
                $("#tempRegister_" + connectId).attr('placeholder', "הכנס טמפרטורה");
            }
            else {
                $("#tempRegister_" + connectId).val("");
                $("#tempRegister_" + connectId).attr('placeholder', "טמפרטורת רגיסטר");
                $("#tempRegister_" + connectId).prop('disabled', true);
            }
        }
        function FillDropDownList() {


            var myCommandata = Ajax("Admin_GetUCommandBySchoolId", "SchoolId=" + SchoolId);

            var UserId = "";
            var UCommandId = "";


            var ddlUCommandId = "";

            for (var i = 0; i < myCommandata.length; i++) {

                //UserId = mydata[i].UserId;
                UCommandId = myCommandata[i].UCommandId;

                if (ddlUCommandId != "#ddlUCommand") {
                    GetComboMultiSelect("#ddlUCommand", "", "", "UCommandId", "UCommandName", "");

                    ddlUCommandId = "#ddlUCommand";
                }

            }
            GetComboMultiSelect("#ddlUCommand", "", "", "UCommandId", "UCommandName", "");

        }
    

        function FillData() {
            CommandSelected = GetSelectedValueMultiSelect("#ddlUCommand");
            $("#dvConnectContainer").html("");
            //for (i = 0; i < UCommands.length; i++) {
            //var commandId = UCommands[i];
            var connectsByCommandData = Ajax("Admin_GetCategoryAndConnectByCommand", "UCommandId=" + CommandSelected);
            // connectId = connectsByCommandData[i].UConnectId;
            for (var i = 0; i < connectsByCommandData.length; i++) {
                //var connectsData = Ajax("Gen_GetTable", "TableName=UConnect&Condition=UConnectId=" + connectsByCommandData[i].UConnectId);
                var connectId = connectsByCommandData[i].UConnectId;

                ClearInputAlert("connectName_" + connectId, "startRegister_" + connectId, "endRegister_" + connectId, "connectType_" + connectId, "location_" + connectId, "tempRegister_" + connectId);
                var UserConnectsTemplate = $("#dvConnectTemplate").html();
                UserConnectsTemplate = UserConnectsTemplate.replace(/@Id/g, connectId);

                $("#dvConnectContainer").append(UserConnectsTemplate);
                //SchoolTemplate = SchoolTemplate.replace(/@SchoolName/g, mydata[i].Name.replace(/["']/g, "''")).replace(/@SchoolId/g, mydata[i].SchoolId);

                UconnType = connectsByCommandData[i].UConnType;
                if (UconnType == 1) {
                    $("#connectType_" + connectId).val(1);
                    $("#tempRegister_" + connectId).prop('disabled', true);
                }
                if (UconnType == 2) {
                    $("#connectType_" + connectId).val(2);
                    $("#tempRegister_" + connectId).val(connectsByCommandData[i].UTempRigester);
                }
                $("#connectName_" + connectId).val(connectsByCommandData[i].UConnectName);
                $("#startRegister_" + connectId).val(connectsByCommandData[i].UStartRigster);
                $("#endRegister_" + connectId).val(connectsByCommandData[i].UEndRigster);

                $("#location_" + connectId).val(connectsByCommandData[i].UConnSeq);
            }


            //}
        }
        function ClearInputAlert() {
            for (i = 0; i < arguments.length; i++) {
                $(".dvAlertRed").hide();
                $("#" + arguments[i]).removeClass("inputAlertRed");
                $(".dvAlertRed").removeClass("col-md-6");
                $("#btn").removeClass("col-md-6")
                $("#btn").addClass("col-md-12");

            }

        }
        function FillUCommandTemplate() {

            var myCommandata = Ajax("Admin_GetUCommandBySchoolId", "SchoolId=" + SchoolId);

            BuildCombo(myCommandata, ".ddlUCommand", "UCommandId", "UCommandName");


        }
        function UpdateDataConnect() {

            
            mydata = Ajax("Admin_GetCategoryAndConnectByCommand", "UCommandId=" + CommandSelected);
            var connectId = "";
            var UTempRigester = "";



            for (var i = 0; i < mydata.length; i++) {

                connectId = mydata[i].UConnectId;
                categoryId = mydata[i].UCategoryId;
                //get data from inputs
                //ClearInputAlert("connectName_" + connectId, "startRegister_" + connectId, "endRegister_" + connectId, "connectType_" + connectId, "location_" + connectId, "tempRegister_" + connectId);
                var UConnectName = $("#connectName_" + connectId).val();
                var UStartRigster = $("#startRegister_" + connectId).val();
                var UEndRigster = $("#endRegister_" + connectId).val();
                var UConnType = $("#connectType_" + connectId).val();
                if (UConnType == 2)
                    UTempRigester = $("#tempRegister_" + connectId).val();
                else
                    UTempRigester = "";
                var UConnectSeq = $("#location_" + connectId).val();


                if (!UConnectSeq) UConnectSeq = "0";

                var res = CheckValid("connectName_" + connectId, "startRegister_" + connectId, "endRegister_" + connectId, "connectType_" + connectId, "location_" + connectId, "tempRegister_" + connectId);
                if (!res) return;
                //update db 
                var resData = Ajax("Admin_SetUConnect", "UConnectId=" + connectId + "&UCategoryId=" + categoryId
                       + "&UEndRigster=" + UEndRigster
                       + "&UConnectName=" + UConnectName + "&UConnectSeq=" + UConnectSeq + "&UStartRigster=" + UStartRigster
                       + "&UConnType=" + UConnType
                       + "&UTempRigester=" + UTempRigester

                );

            }
            if (!resData) {
                openMessage("ישנה בעיה בעדכון הנתונים אנא בדוק חיבורים של היחידות");
            } else {
                OpenMessage("הנתונים עודכנו בהצלחה");
            }
            FillData();


        }
        function CreateBakarRigster(Type) {
            var SelectedUCommandId;
            if (Type == 2) {
                DeleteType = "4";
                OpenMessage("האם אתה בטוח שברצונך למחוק את כל הריגסטרים של הבקר?", "כן", "לא");

            } else {

                var Startrigster = $("#txtStartrigster").val();
                var Jump = $("#txtJump").val();


                if (!Startrigster || !Jump) {

                    alert("בכדי ליצור ריגסטרים השדות הם חובה");
                    return;

                }
                var UCommands = GetSelectedValueMultiSelect("#ddlUCommand");
                var res = Ajax("Admin_UCommandRegister", "UCommandId=" + UCommands[0] + "&Startrigster=" + Startrigster + "&Jump=" + Jump + "&Type=1");
                //alert("יצירת כל הרגיסטרים של הבקר בוצעו בהצלחה");
                OpenMessage("יצירת כל הרגיסטרים של הבקר בוצעו בהצלחה");
                //  FillCategoryData();

                FillData();


            }

        }



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="col-md-12" id="MainContainer">
        <div class="row dvSection">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <div class="container-fluid">
                        <div class="row">
                            <%-- <div class="col-sm-4">
                              <h3 class="panel-title">&nbsp;רשימת נקודות </h3>
                            </div>--%>
                            <div class="col-md-2">
                                <select id="ddlUCommand" class="ddlUCommand" onchange="FillData()" >
                                </select>
                            </div>
                            <div class="col-md-1" style="text-align: left; margin-left: 0; padding: 0;">
                                <button style="text-align: left;" type="button" class="btn btn-info btn-round btn-sm col-12" onclick="UpdateDataConnect()">
                                    <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>עדכן</span>
                                </button>
                            </div>


                            <div class="col-md-9">
                                   <div class="col-md-2" style="float:left">
                                    <button type="button" class="btn btn-primary btn-round" onclick="CreateBakarRigster(1)">
                                        <i class="glyphicon glyphicon-edit"></i><span>&nbsp;צור רגיסטרים </span>
                                    </button>
                                </div>
                                <div class="col-md-2" style="float:left;">
                                    <input type="number" id="txtJump" class="form-control" style="background:white">
                                </div>
                                <div class="col-md-1" style="float:left">
                                    <span class="help-block m-b-none">בקפיצות </span>
                                </div>
                                   <div class="col-md-2 " style="float:left;">
                                    <input type="number" id="txtStartrigster" class="form-control" style="background:white">
                                </div>
                                <div class="col-md-2" style="float:left">
                                    <span class="help-block m-b-none">רגיסטר התחלה</span>
                                </div>
                             
                                
                                
                             
                            </div>

                            <%--  <div class="col-md-1" style="">
                         <div class="btn  btn-danger btn-round" onclick='CreateBakarRigster(2)'> מחק ריגסטרים</div>
                        </div>--%>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-2 dvTableHeader">
                            סוג יחידה
                        </div>
                        <div class="col-md-2 dvTableHeader">
                            שם יחידה
                        </div>
                        <div class="col-md-2 dvTableHeader">
                            התחלת רגיסטר
                        </div>
                        <div class="col-md-2 dvTableHeader">
                            סוף רגיסטר
                        </div>
                        <div class="col-md-2 dvTableHeader">
                            טמפרטורת רגיסטר
                        </div>
                        <div class="col-md-2 dvTableHeader">
                            מיקום
                        </div>

                    </div>

                    <hr />

                    <div id="dvConnectContainer">
                    </div>


                </div>
            </div>
        </div>

    </div>
    <div id="dvConnectTemplate" style="display: none">
        <div class="row">
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <select style="font-size: medium;" id="connectType_@Id" class="form-control" onchange="ConnectChange(@Id)">
                        <option value="1">מתח</option>
                        <option value="2">מתח + טמפרטורה</option>
                        <%--  <option value="3">טמפרטורה</option>
                        <option value="4">חיישן</option>
                        <option value="5">נצירת שבת</option>--%>
                    </select>
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input style="font-size: medium;" type="text" id="connectName_@Id" placeholder="שם נקודה" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input style="font-size: medium;" type="number" id="startRegister_@Id" placeholder="התחלת רגיסטר" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input style="font-size: medium;" type="number" id="endRegister_@Id" placeholder="סוף רגיסטר" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input style="font-size: medium;" type="number" id="tempRegister_@Id" placeholder="טמפרטורת רגיסטר" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input style="font-size: medium;" type="text" id="location_@Id" placeholder="מיקום" class="form-control">
                </div>
            </div>
        </div>
    </div>

    <div class="row" style="margin: 0;">
        <div id="alertRed" class="dvAlertRed ">
            השדות המסומנים הינם שדות חובה!
        </div>

    </div>

</asp:Content>





