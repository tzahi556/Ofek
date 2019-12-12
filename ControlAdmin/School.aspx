<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true"
    CodeFile="School.aspx.cs" Inherits="ControlAdmin_School" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../assets/js/jquery-ui.js"></script>

    <script type="text/javascript">

        var mydata;


        $(document).ready(function () {

            FillData();
            

            $(".modal").draggable({
                handle: ".modal-header"

            });

            $("div[id^='dvSchool']").removeClass("schoolSelected");
            $("#dvSchool_" + SchoolId).addClass("schoolSelected");



        });





        function FillData() {

            $("#dvMainContainer").html("");

            mydata = Ajax("Gen_GetTable", "TableName=School&Condition=Active=1");

            for (var i = 0; i < mydata.length; i++) {

                // Add School

                var SchoolTemplate = $("#dvSchoolTemplate").html();
                SchoolTemplate = SchoolTemplate.replace(/@SchoolName/g, mydata[i].Name.replace(/["']/g, "''")).replace(/@SchoolId/g, mydata[i].SchoolId);
                $("#dvMainContainer").append(SchoolTemplate);


            }

            $("#dvMainContainer").append("<div class='col-md-3'><div onclick='OpenSchool(null,null)' class='btn btn-success btn-round'><i class='glyphicon glyphicon-plus-sign'></i><br>הוסף בית ספר</div></div>");



        }

        function OpenSchool(SelectSchoolId, Name) {
          

            SelectedSchoolId = SelectSchoolId;
            $("#txtSchoolName").val(Name);
            $("#myModal").modal();
        }

        function SetAction(SelectSchoolId, SchoolName, Type, e) {

            e.cancelBubble = true;
            SelectedSchoolId = SelectSchoolId;
            if (Type == 1) {
                $("div[id^='dvSchool']").removeClass("schoolSelected");
                $("#dvSchool_" + SelectSchoolId).addClass("schoolSelected");


                $("#dvCurrentSchoolName").html(SchoolName);

                Ajax("Admin_SetSchoolIdToSession", "SchoolId=" + SelectSchoolId + "&SchoolName=" + SchoolName);

            }

            if (Type == 2) {

                OpenMessage("האם אתה בטוח שברצונך למחוק את נתוני בית הספר?", "כן", "לא");


            }


            if (Type == 3) {
                location.href = "Bakar.aspx";

            }


        }


        function CallBackFromYesNo(Type) {


            if (Type == 1) {
                Ajax("Admin_SetSchool", "SchoolId=" + SelectedSchoolId + "&SchoolName=&Type=2");
                Ajax("Admin_SetSchoolIdToSession", "SchoolId=&SchoolName=");
                FillData();
            }
        }

        var SelectedSchoolId = "";

        function UpdateSchool() {

            //alert(SelectedSchoolId);
            var SchoolName = $("#txtSchoolName").val();

            if (!SchoolName) {

                OpenMessage("חובה לשים שם בית ספר");
                return;
            }

            Ajax("Admin_SetSchool", "SchoolId=" + SelectedSchoolId + "&SchoolName=" + SchoolName + "&Type=1");
            FillData();
            $("#myModal").modal("hide");

        }



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="col-md-12">
        <div class="row dvSection">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">&nbsp;רשימת בתי ספר באופק
                      
                    </h3>



                </div>
                <div class="panel-body">
                    <div class="col-md-12">
                        לחיצה אחת על 
                          <b>"בית ספר"</b>
                        של בית ספר אותו תרצה לעבוד עליו באתר.
                          <b>דאבל קליק</b> על 
                          <b>"בית ספר"</b>
                        יקח אותך לבקרים שיש בבית ספר.

                         
                         <br />
                        <br />
                    </div>
                    <div class="col-md-12" id="dvMainContainer">
                    </div>


                </div>
            </div>
        </div>

    </div>

    <%-- חלון מודלי של בית ספר --%>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header label-info">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title">בית ספר
                    </h4>
                </div>
                <div class="modal-body" id="Div4">

                    <div class="col-md-3">
                        <span class="help-block m-b-none">שם בית ספר: </span>
                    </div>
                    <div class="col-md-5">

                        <div class="input-group ls-group-input">
                            <input type="text" id="txtSchoolName" class="form-control">
                        </div>
                    </div>


                    <div class="col-md-3" style="text-align: center">
                        <button type="button" class="btn btn-info btn-round" onclick="UpdateSchool()">
                            <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>עדכן</span>
                        </button>
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


    <div id="dvSchoolTemplate" style="display: none">
        <div class="col-md-4 dvMarginBott">
            <div class="btn btn-info btn-round dvConnect" id="dvSchool_@SchoolId" onclick='SetAction(@SchoolId,"@SchoolName",1,event)' ondblclick='SetAction(@SchoolId,"@SchoolName",3,event)'>

                <span>@SchoolName</span>
                <div class="btn btn-danger btn-round" style="float: left" onclick="SetAction(@SchoolId,'',2,event)">
                    מחק 
                </div>
                <div class="btn btn-primary btn-round" style="float: left" onclick='OpenSchool(@SchoolId,"@SchoolName")'>
                    ערוך 
                </div>
            </div>
        </div>
    </div>

    <div id="dvTimeTemplate" style="display: none">
        <div class="btn btn-info   btn-round @time" onclick="DeleteTime(@UConnectLoozId)">
            <img src="../assets/images/@Status.png" />
            <span>@Time</span>
        </div>
    </div>
</asp:Content>
