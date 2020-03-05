<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true"
    CodeFile="Users.aspx.cs" Inherits="ControlAdmin_Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../assets/js/jquery-ui.js"></script>

    <script type="text/javascript">

        var mydata;


        $(document).ready(function () {

            
            $("#dvMainContainer").hide();
            if (!SchoolId) {

                OpenMessage("עליך לבחור בית ספר בכדי להמשיך ...");
               
                return;
            }
            $("#dvMainContainer").show();
            FillUCommandTemplate();
            FillData();
           // FillDropDownList();
           

            $(".modal").draggable({
                handle: ".modal-header"
            });



           

        });

        var IsFirst = true;




        function FillUCommandTemplate() {
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

               

                $(".ddlUCommand").append("<optgroup label='" + mydata[i].UCommandName + "'>" + getHtmlBakarConnect(mydata[i].UCommandId) + "</optgroup>");



            }



          


        }
        function getHtmlBakarConnect(CurrentCommandId) {


            var htmlOption = "";
            var Currentmydata = Ajax("Control_GetUserDataByUCommand", "UCommandId=" + CurrentCommandId);
            for (var i = 0; i < Currentmydata.length; i++) {


                htmlOption += "<option value=" + Currentmydata[i].UConnectId + ">&nbsp;&nbsp;&nbsp;" + Currentmydata[i].UConnectName + "</option>";
            }

            return htmlOption;
        }

        function FillDropDownList() {




            var UserId = "";
            var UCommandId = "";


            var ddlUCommandId = "";

            for (var i = 0; i < mydata.length; i++) {

                UserId = mydata[i].UserId;
                UCommandId = mydata[i].UCommandId;

                if (ddlUCommandId != "#ddlUCommand_" + UserId) {
                    GetComboMultiSelect("#ddlUCommand_" + UserId, "", "", "UCommandId", "UCommandName", "");

                    ddlUCommandId = "#ddlUCommand_" + UserId;
                }

            }
            GetComboMultiSelect("#ddlUCommand_0", "", "", "UCommandId", "UCommandName", "");

        }



        function FillData() {
            mydata = Ajax("Admin_GetUserForSchool");

            var UserId = "";

            $("#dvUserContainer").html("");

            for (var i = 0; i < mydata.length; i++) {

               
                if (mydata[i].UserId != UserId) {

                    var UserTemplate = $("#dvUserTemplate").html();
                    UserTemplate = UserTemplate.replace(/@Id/g, mydata[i].UserId);

                    $("#dvUserContainer").append(UserTemplate);

                    UserId = mydata[i].UserId;

                    
                    $("#txtFirstName_" + UserId).val(mydata[i].FirstName);
                    $("#txtLastName_" + UserId).val(mydata[i].LastName);
                    $("#txtUserName_" + UserId).val(mydata[i].UserName);
                    $("#txtPassword_" + UserId).val(mydata[i].Password);

                    var RoleValue = mydata[i].RoleId;
                    $("#RoleId_" + UserId).val(RoleValue);
                    $("#Editable_" + UserId).prop('checked', mydata[i].Editable);

                    $("#ddlUCommand_" + UserId).multiselect({
                        enableClickableOptGroups: true,
                        includeSelectAllOption: true,
                        inheritClass: true,
                        enableClickableOptGroups: true,
                        buttonWidth: '100%',
                    });






                }
                if (mydata[i].UserId == UserId) {

                    $('#ddlUCommand_' + UserId).multiselect('select', mydata[i].UConnectId);
                }
              //  var UCommandId = mydata[i].UCommandId;
                //    $("#ddlUCommand_" + mydata[i].UserId + " option[value=" + UCommandId + "]").attr('selected', true);



            }

            var UserTemplate = $("#dvUserTemplate").html();
            UserTemplate = UserTemplate.replace(/@Id/g, "0");
            $("#dvUserContainer").append("<hr>" + UserTemplate);

            $("#dvDelete_0").remove();
            $('#dvSave_0').css({ 'width': '80px' });

            $("#dvSave_0").html("הוסף משתמש");


            $("#ddlUCommand_0").multiselect({
                enableClickableOptGroups: true,
                includeSelectAllOption: true,
                inheritClass: true,
                enableClickableOptGroups: true,
                buttonWidth: '100%',
            });




        }
        function getIndexfromData(data, value) {
            for (var i = 0; i < data.length; i++) {
                if (data[i].UConnectId == value)
                    return i;
            }
        }
        function SaveData(UserId) {
            var UCommands = [];
            var Data = Ajax("Control_GetUserConnectDataCombo", "SchoolId=" + SchoolId); 

            var FirstName = $("#txtFirstName_" + UserId).val();
            var LastName = $("#txtLastName_" + UserId).val();
            var UserName = $("#txtUserName_" + UserId).val();
            var Password = $("#txtPassword_" + UserId).val();
            var UConnects = GetSelectedValueMultiSelect("#ddlUCommand_" + UserId);
            for (i = 0; i < UConnects.length; i++) {
                for (j in Data)
                    if (Data[j].UConnectId == UConnects[i])
                          UCommands[i] = Data[j].UCommandId;
            }
            var RoleId = $("#RoleId_"+UserId).val();
            var Editable = $("#Editable_" + UserId).is(':checked');
           

            Ajax("Admin_SetUsers", "UserId=" + UserId + "&FirstName=" + FirstName +
                "&LastName=" + LastName + "&RoleId=" + RoleId + "&Editable=" + Editable + "&UCommands=" + UCommands
             + "&UserName=" + UserName + "&Password=" + Password + "&UConnects=" + UConnects);

            window.location.reload();
        }

        var DeleteUserId = "";

        function DeleteUser(UserId) {
            DeleteUserId = UserId;
            OpenMessage(" האם אתה בטוח שברצונך למחוק את המשתמש ? ", "כן", "לא");
           

        }


        function CallBackFromYesNo(Type) {
            if (Type == 1) {
                Ajax("Admin_DeleteUser", "UserId=" + DeleteUserId);
                window.location.reload();

            }
        }



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="col-md-12" id="dvMainContainer">
        <div class="row dvSection">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">&nbsp;רשימת משתמשים 
                    </h3>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-2 dvTableHeader">
                            שם פרטי
                        </div>
                        <div class="col-md-2 dvTableHeader">
                            שם משפחה
                        </div>
                        <div class="col-md-2 dvTableHeader">
                            שם משתמש
                        </div>
                        <div class="col-md-2 dvTableHeader">
                            סיסמא
                        </div>
                        <div class="col-md-1 dvTableHeader"style="padding:0;">
                           נקודות
                        </div>
                        <div class="col-md-1 dvTableHeader">
                           תפקיד
                        </div>
                        <div class="col-md-1 dvTableHeader">
                           עריכה
                        </div>
                    </div>

                    <hr />

                    <div id="dvUserContainer">
                    </div>



                </div>
            </div>
        </div>

    </div>

    <div id="dvUserTemplate" style="display: none">

     
        <div class="row">
            <div class="col-md-2 " >
                <div class="input-group-sm ls-group-input">
                    <input type="text" id="txtFirstName_@Id" placeholder="שם פרטי" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input type="text" id="txtLastName_@Id" placeholder="שם משפחה" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input type="text" id="txtUserName_@Id" placeholder="שם משתמש" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group-sm ls-group-input">
                    <input type="text" id="txtPassword_@Id" placeholder="סיסמא" class="form-control">
                </div>
            </div>

            <div class="col-md-1" style="padding:0;">
                <select id="ddlUCommand_@Id" class="ddlUCommand form-control" 
                    multiple="multiple" >
                 

                </select>
            </div>
            <div class="col-md-1 " >
                <select id="RoleId_@Id" style="height:30px;width:70px;">
                    <option value="2">מנהל</option>
                    <option value="3">עובד</option>
                </select>
            </div>
            <div class="col-md-1 " >
                <div class="checkbox" style="margin:0;">
                  <label><input id="Editable_@Id"  type="checkbox"> עריכה</label>
                </div>
            </div>
            <div class="col-md-1 btn btn-sm btn-primary btn-round" id="dvSave_@Id" style="width:40px;" onclick='SaveData(@Id)'>
                שמור 
            </div>
            <div class="col-md-1 btn btn-sm btn-danger  btn-round" id="dvDelete_@Id" style="width:40px;"  onclick="DeleteUser(@Id)">
                מחק 
            </div>
        </div>

     

    </div>




</asp:Content>
