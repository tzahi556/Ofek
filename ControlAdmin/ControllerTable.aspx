<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage/MasterPage.master"
     CodeFile="ControllerTable.aspx.cs" Inherits="ControlAdmin_ControllerTable" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../assets/js/jquery-ui.js"></script>

    <script type="text/javascript">

        var mydata;

        


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
            
            // $("#MainContainer").html("");
            var UconnType = "";
            var connectId = "";
            mydata = Ajax("Admin_GetUConnectsBySchoolId","SchoolId="+ SchoolId);
            $("#dvConnectContainer").html("");
            for (var i = 0; i < mydata.length; i++) {
                
                connectId = mydata[i].UConnectId;
                Utempreg = mydata[i].UTempRigester;
                ClearInputAlert("connectName_" + connectId, "startRegister_" + connectId, "endRegister_" + connectId, "connectType_" + connectId, "location_" + connectId, "tempRegister_" + connectId);
                var UserConnectsTemplate = $("#dvConnectTemplate").html();
                UserConnectsTemplate = UserConnectsTemplate.replace(/@Id/g, mydata[i].UConnectId);

                $("#dvConnectContainer").append(UserConnectsTemplate);
                //SchoolTemplate = SchoolTemplate.replace(/@SchoolName/g, mydata[i].Name.replace(/["']/g, "''")).replace(/@SchoolId/g, mydata[i].SchoolId);
                
                UconnType = mydata[i].UConnType;
                if (UconnType == 1) {
                    $("#connectType_" + connectId).val(1);
                    $("#tempRegister_" + connectId).prop('disabled',true);
                }
                if (UconnType == 2)
                {
                    $("#connectType_" + connectId).val(2);
                    $("#tempRegister_" + connectId).val(mydata[i].UTempRigester);
                }
                $("#connectName_" + connectId).val(mydata[i].UConnectName);
                $("#startRegister_" + connectId).val(mydata[i].UStartRigster);
                $("#endRegister_" + connectId).val(mydata[i].UEndRigster);
                
                $("#location_" + connectId).val(mydata[i].UConnSeq);


                //$("#dvConnectContainer").append(UserConnectsTemplate);

            }

            //$("#dvMainContainer").append("<div class='col-md-3'><div onclick='OpenSchool(null,null)' class='btn btn-success btn-round'><i class='glyphicon glyphicon-plus-sign'></i><br>הוסף בית ספר</div></div>");



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
            
            
            mydata = Ajax("Admin_GetUConnectsBySchoolId", "SchoolId=" + SchoolId);
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
       
        function selectedCombo() {
            var UCommands = GetSelectedValueMultiSelect("#ddlUCommand");
            $("#dvConnectContainer").html("");
            for (i = 0; i < UCommands.length; i++) {
                var commandId = UCommands[i];
                var connectsByCommandData = Ajax("Admin_GetCategoryAndConnectByCommand", "UCommandId=" + commandId);
               // connectId = connectsByCommandData[i].UConnectId;
                for (j = 0; j < connectsByCommandData.length; j++) {     
                    var connectsData = Ajax("Gen_GetTable", "TableName=UConnect&Condition=UConnectId=" + connectsByCommandData[j].UConnectId);
                    var connectId = connectsData[0].UConnectId;

                   // ClearInputAlert("connectName_" + connectId, "startRegister_" + connectId, "endRegister_" + connectId, "connectType_" + connectId, "location_" + connectId, "tempRegister_" + connectId);
                    var UserConnectsTemplate = $("#dvConnectTemplate").html();
                    UserConnectsTemplate = UserConnectsTemplate.replace(/@Id/g, connectId);

                    $("#dvConnectContainer").append(UserConnectsTemplate);
                    //SchoolTemplate = SchoolTemplate.replace(/@SchoolName/g, mydata[i].Name.replace(/["']/g, "''")).replace(/@SchoolId/g, mydata[i].SchoolId);

                    UconnType = connectsData[0].UConnType;
                    if (UconnType == 1) {
                        $("#connectType_" + connectId).val(1);
                        $("#tempRegister_" + connectId).prop('disabled', true);
                    }
                    if (UconnType == 2) {
                        $("#connectType_" + connectId).val(2);
                        $("#tempRegister_" + connectId).val(connectsData[0].UTempRigester);
                    }
                    $("#connectName_" + connectId).val(connectsData[0].UConnectName);
                    $("#startRegister_" + connectId).val(connectsData[0].UStartRigster);
                    $("#endRegister_" + connectId).val(connectsData[0].UEndRigster);

                    $("#location_" + connectId).val(connectsData[0].UConnSeq);
                }
                

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
                            <div class="col-sm-4">
                              <h3 class="panel-title">&nbsp;רשימת נקודות </h3>
                            </div>
                            <div class="col-sm-4">
                                 <select id="ddlUCommand" class="ddlUCommand" onchange="selectedCombo()" multiple="multiple">
                                     
                                 </select>
                            </div>
                            <div class="col-sm-4" style="float:left;text-align:left;margin-left:0;padding:0;">
                                <button style="text-align:left;" type="button" class="btn btn-info btn-round btn-sm col-12" onclick="UpdateDataConnect()">
                                  <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>עדכן</span>
                                 </button>
                            </div>
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
                    <select style="font-size:medium;" id="connectType_@Id" class="form-control" onchange="ConnectChange(@Id)">
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
                    <input style="font-size:medium;" type="text" id="connectName_@Id" placeholder="שם נקודה" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input style="font-size:medium;" type="number" id="startRegister_@Id" placeholder="התחלת רגיסטר" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input style="font-size:medium;" type="number" id="endRegister_@Id" placeholder="סוף רגיסטר" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input style="font-size:medium;" type="number" id="tempRegister_@Id" placeholder="טמפרטורת רגיסטר" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input style="font-size:medium;" type="text" id="location_@Id" placeholder="מיקום" class="form-control">
                </div>
            </div>
        </div>
    </div>

    <div class="row" style="margin:0;">   
        <div id="alertRed" class="dvAlertRed ">
            השדות המסומנים הינם שדות חובה!
        </div>     

    </div>

</asp:Content>





