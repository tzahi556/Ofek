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
            FillDropDownList();
           

            $(".modal").draggable({
                handle: ".modal-header"
            });




        });

        var IsFirst = true;


        function FillUCommandTemplate() {
            var myCommandata = Ajax("Admin_GetUCommandBySchoolId");

            BuildCombo(myCommandata, ".ddlUCommand", "UCommandId", "UCommandName");


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
                    //$("#txtFirstName_" + UserId).val(mydata[i].UserId);

                }

                var UCommandId = mydata[i].UCommandId;
                $("#ddlUCommand_" + mydata[i].UserId + " option[value=" + UCommandId + "]").attr('selected', true);



            }

            var UserTemplate = $("#dvUserTemplate").html();
            UserTemplate = UserTemplate.replace(/@Id/g, "0");
            $("#dvUserContainer").append(UserTemplate);

            $("#dvDelete_0").remove();

            $("#dvSave_0").html("הוסף משתמש");




        }


        function SaveData(UserId) {

            var FirstName = $("#txtFirstName_" + UserId).val();
            var LastName = $("#txtLastName_" + UserId).val();
            var UserName = $("#txtUserName_" + UserId).val();
            var Password = $("#txtPassword_" + UserId).val();
            var UCommands = GetSelectedValueMultiSelect("#ddlUCommand_" + UserId);


            Ajax("Admin_SetUsers", "UserId=" + UserId + "&FirstName=" + FirstName +
                "&LastName=" + LastName
             + "&UserName=" + UserName + "&Password=" + Password + "&UCommands=" + UCommands);


            FillData();
            FillDropDownList();

        }

        var DeleteUserId = "";

        function DeleteUser(UserId) {
            DeleteUserId = UserId;
            OpenMessage(" האם אתה בטוח שברצונך למחוק את המשתמש ? ", "כן", "לא");
           

        }


        function CallBackFromYesNo(Type) {
            if (Type == 1) {
                Ajax("Admin_DeleteUser", "UserId=" + DeleteUserId);

                FillData();
                FillDropDownList();

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
                        <div class="col-md-2 dvTableHeader">
                            בקרים
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
            <div class="col-md-2">
                <div class="input-group ls-group-input">
                    <input type="text" id="txtFirstName_@Id" placeholder="שם פרטי" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group ls-group-input">
                    <input type="text" id="txtLastName_@Id" placeholder="שם משפחה" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group ls-group-input">
                    <input type="text" id="txtUserName_@Id" placeholder="שם משתמש" class="form-control">
                </div>
            </div>
            <div class="col-md-2">
                <div class="input-group ls-group-input">
                    <input type="text" id="txtPassword_@Id" placeholder="סיסמא" class="form-control">
                </div>
            </div>

            <div class="col-md-2">
                <select id="ddlUCommand_@Id" class="ddlUCommand" multiple="multiple">
                 

                </select>
            </div>

            <div class="col-md-1 btn btn-primary btn-round" id="dvSave_@Id" onclick='SaveData(@Id)'>
                שמור 
            </div>
            <div class="col-md-1 btn btn-danger btn-round" id="dvDelete_@Id" onclick="DeleteUser(@Id)">
                מחק 
            </div>
        </div>

    </div>




</asp:Content>
