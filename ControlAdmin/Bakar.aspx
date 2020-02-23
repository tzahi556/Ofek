<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true"
    CodeFile="Bakar.aspx.cs" Inherits="ControlAdmin_Bakar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../assets/js/jquery-ui.js"></script>

    <script type="text/javascript">

        var mydata;

        var SelectedUCommandId = "1";
        var SelectedUConnectId = "";
        var SelectedUCategoryId = "";
        var SelectedUCommIP = "";
        var IsOnline = false;
        var FirstCommandId = "";
        $(document).ready(function () {
           
            HideMenuRight();

            $("#dvMainContainer").hide();
            if (!SchoolId) {

                OpenMessage("עליך לבחור בית ספר בכדי להמשיך ...");

                return;
            }
            $("#dvMainContainer").show();

            FillData();


            $(".modal").draggable({
                handle: ".modal-header"
            });

            if (FirstCommandId)
                SetAction(1,FirstCommandId, '0', false);

         

        });

        function FillDopDownList() {


            //$("#ddlUTemps").html("");

            //$("#ddlUTemps").append("<option value=''> --- בחר יחידה  שתפעיל את היחידה  ---</option>");

            //var myConnectdata = Ajax("Admin_GetUTempConnect", "UCommandId=" + SelectedUCommandId);

            //BuildCombo(myConnectdata, "#ddlUTemps", "UConnectId", "UConnectName");


        }

        //********************* Bakar *************************

        function FillData() {

            $("#dvUCommandContainer").html("");

            mydata = Ajax("Gen_GetTable", "TableName=UCommand&Condition=Active=1 and SchoolId=" + SchoolId);

           
            
            for (var i = 0; i < mydata.length; i++) {

                if(i==0) FirstCommandId = mydata[i].UCommandId;
                var UCommandTemplate = $("#dvUCommandTemplate").html();
                UCommandTemplate = UCommandTemplate.replace(/@UCommandName/g, mydata[i].UCommandName.replace(/["']/g, "''")).replace(/@UCommandId/g, mydata[i].UCommandId);
                UCommandTemplate = UCommandTemplate.replace(/@UCommIP/g, mydata[i].UCommIP);
                UCommandTemplate = UCommandTemplate.replace(/@UCommThingKey/g, mydata[i].UCommThingKey);
                UCommandTemplate = UCommandTemplate.replace(/@UCommPORT/g, mydata[i].UCommPORT);
                $("#dvUCommandContainer").append(UCommandTemplate);
               
            }

     

        }


        function OpenUCommand(UCommandId, UCommandName, UCommIP, UCommThingKey, UCommPORT,e) {
            ClearInputAlert("txtUCommandName", "txtUCommIP");
            e.cancelBubble = true;
            if (UCommandId != 0) {

                $("#spModalBakar").text(UCommandName);
                $("#txtUCommandName").val(isEmpty(UCommandName));
             
                $("#txtUCommIP").val(isEmpty(UCommIP));
                $("#txtUCommPORT").val(isEmpty(UCommPORT));
                


            } else {

                $("#spModalBakar").text("בקר חדש");
                $("#txtUCommandName").val("");
           
                $("#txtUCommIP").val("");
                $("#txtUCommPORT").val("");
             
            }

            SelectedUCommandId = UCommandId;
            $("#myModal").modal();


        }


        function SaveDataBakar() {
            ClearInputAlert("txtUCommandName", "txtUCommIP");

            var UCommandName = $("#txtUCommandName").val();
            var UCommIP = $("#txtUCommIP").val();
            var UCommPORT = $("#txtUCommPORT").val();

            var res = CheckValid("txtUCommandName", "txtUCommIP");
            if (!res) return;

            Ajax("Admin_SetUCommand", "UCommandId=" + SelectedUCommandId 
                 + "&UCommIP=" + UCommIP + "&UCommandName=" + UCommandName + "&UCommPORT=" + UCommPORT);

            FillData();

            $("#myModal").modal("hide");

        }


        function SetAction(Type, UCommandId, UCommIP, e) {
            e.cancelBubble = true;
            SelectedUCommandId = UCommandId;
            SelectedUCommIP = UCommIP;


            if (Type == 1) {

                $("div[id^='dvCommand']").removeClass("schoolSelected");
                $("#dvCommand_" + UCommandId).addClass("schoolSelected");
                FillDopDownList();
                FillCategoryData();

            }


            if (Type == 2) {
                DeleteType = "1";
                OpenMessage("האם אתה בטוח שברצונך למחוק את הבקר מהמערכת?", "כן", "לא");

            }

            // if (!e) var e = window.event;

            // if (e.stopPropagation) e.stopPropagation();
        }

        var DeleteType = "0";

        function CallBackFromYesNo(Type) {
            if (Type == 1 && DeleteType == "1") {
                Ajax("Admin_DeleteUCommand", "UCommandId=" + SelectedUCommandId);
                FillData();
                FillCategoryData();
            }
            if (Type == 1 && DeleteType == "2") {
                Ajax("Admin_DeleteUCategory", "UCategoryId=" + SelectedUCategoryId);
                FillCategoryData();
            }

            if (Type == 1 && DeleteType == "3") {
                Ajax("Admin_DeleteUConnect", "UConnectId=" + SelectedUConnectId);
                FillCategoryData();
            }

            if (Type == 1 && DeleteType == "4") {
                Ajax("Admin_UCommandRegister", "UCommandId=" + SelectedUCommandId + "&Startrigster=&Jump=&Type=2");
                FillCategoryData();
            }

        }

        function SetOnlineOffline() {

          
            // FillData();
            $("#dvMainCategoryContainer").html("");
            if (IsOnline) {
                $("#imgOnline").attr("src", "../assets/images/Offline.png");
                IsOnline = false;
            }
            else {
                $("#imgOnline").attr("src", "../assets/images/Online.png");
                IsOnline = true;
            }


        }

        //********************* Category *************************

        function FillCategoryData() {

            var mydata = Ajax("Admin_GetCategoryAndConnectByCommand", "UCommandId=" + SelectedUCommandId + "&IsOnline=" + IsOnline);

            //במידה והסתיים הסשן
            if (mydata[0].IsConnect && mydata[0].IsConnect == "sessFalse") {

                location.href = "../Login.aspx";
            }

            if (mydata[0].IsCommand) {

                OpenMessage("בקר לא מחובר...");
                return;
            }



            $("#dvMainCategoryContainer").html("");

            $("#dvMainCategoryContainer").append("<br><div class='col-md-9 spCategoryAdminTitle' >קטגוריות לבקר</div>");
            $("#dvMainCategoryContainer").append("<div class='col-md-3' style='padding-left:0px'><div style='float:left;' class='btn btn-success btn-round btn-xs' onclick='OpenCategory(0)'><i class='glyphicon glyphicon-plus-sign'></i> הוסף קטגוריה </div></div>");
            $("#dvMainCategoryContainer").append("<div class='clear'></div>");
            var UCategoryName = "";
            var UCategoryId = "";

            for (var i = 0; i < mydata.length; i++) {

                // Add Category
                if (mydata[i].UCategoryName != UCategoryName && SelectedUCommandId == mydata[i].UCommandId) {

                    UCategoryName = mydata[i].UCategoryName;
                    UCategoryId = mydata[i].UCategoryId;
                    var CategoryTemplate = $("#dvCategoryTemplate").html();
                    CategoryTemplate = CategoryTemplate.replace(/@UCategoryName/g, UCategoryName).replace(/@UCategoryId/g, UCategoryId).replace(/@Seq/g, mydata[i].Seq);
                    $("#dvMainCategoryContainer").append(CategoryTemplate);



                }

                // Add Connect
                if (mydata[i].UCommandId == SelectedUCommandId) {
                    var ConnectTemplate = $("#dvConnectTemplate").html();
                    ConnectTemplate = ConnectTemplate.replace(/@UConnectName/g, mydata[i].UConnectName);
                    ConnectTemplate = ConnectTemplate.replace(/@UConnectId/g, mydata[i].UConnectId);
                    ConnectTemplate = ConnectTemplate.replace(/@UCategoryId/g, mydata[i].UCategoryId);
                    ConnectTemplate = ConnectTemplate.replace(/@UEndRigster/g, mydata[i].UEndRigster);
                    ConnectTemplate = ConnectTemplate.replace(/@UConnectThingKey/g, mydata[i].UConnThingKey);
                    ConnectTemplate = ConnectTemplate.replace(/@Seq/g, mydata[i].UConnSeq);
                    ConnectTemplate = ConnectTemplate.replace(/@UStartRigster/g, mydata[i].UStartRigster);
                    ConnectTemplate = ConnectTemplate.replace(/@UTempRigester/g, mydata[i].UTempRigester);
                    ConnectTemplate = ConnectTemplate.replace(/@UConnType/g, mydata[i].UConnType);
                   // ConnectTemplate = ConnectTemplate.replace(/@btntype/g, ((mydata[i].UConnType == "1" || mydata[i].UConnType == "4") ? "btn-primary" : "btn-info"));
                    ConnectTemplate = ConnectTemplate.replace(/@URlyConnectId/g, mydata[i].URlyConnectId);
                    ConnectTemplate = ConnectTemplate.replace(/@Utemp/g, "0");
                   
                    //var ImageValid = "Valid.gif";

                    //if (mydata[i].Value == "")
                    //    ImageValid = "error.png";

                    //ConnectTemplate = ConnectTemplate.replace(/@Image/g, ImageValid);


                    if (mydata[i].UConnectId) $("#dvCategoryConainer_" + UCategoryId).append(ConnectTemplate);
                    if (mydata[i].UConnType == 1) $("#" + mydata[i].UConnectId + "_tempId").hide();
                    else $("#" + mydata[i].UConnectId + "_tempId").show();

                }
            }

            //  DefineDragAndDropEvents();
        }

        function OpenCategory(UCategoryId, UCategoryName, Seq) {
          
            ClearInputAlert("txtUCategoryName", "txtUCategorySeq");

            
            SelectedUCategoryId = UCategoryId;
            if (UCategoryId != 0) {

                $("#spModalCategory").text(UCategoryName);
                $("#txtUCategoryName").val(isEmpty(UCategoryName));
                $("#txtUCategorySeq").val(isEmpty(Seq));

            } else {

                $("#spModalCategory").text("קטגוריה חדשה");
                $("#txtUCategoryName").val("");
                $("#txtUCategorySeq").val("");

            }

            //  SelectedUCommandId = UCommandId;
            $("#myCategoryModal").modal();


        }

        function SaveDataCategory() {
            ClearInputAlert("txtUCategoryName", "txtUCategorySeq");

            var UCategoryName = $("#txtUCategoryName").val();
            var UCategorySeq = $("#txtUCategorySeq").val();

            if (!UCategorySeq) UCategorySeq = "0";

            var res = CheckValid("txtUCategoryName", "txtUCategorySeq");
            if (!res) return;



            Ajax("Admin_SetUCategory", "UCategoryId=" + SelectedUCategoryId + "&UCommandId=" + SelectedUCommandId + "&UCategoryName=" + UCategoryName
                 + "&UCategorySeq=" + UCategorySeq);

            FillCategoryData();
            $("#myCategoryModal").modal("hide");


        }

        function DeleteCategory(UCategoryId) {
            SelectedUCategoryId = UCategoryId;
            DeleteType = "2";
            OpenMessage("האם אתה בטוח שברצונך למחוק את הקטגוריה מהמערכת?", "כן", "לא");

        }

        //********************* Connect *************************

        function OpenConnect(UCategoryId, UConnectId, UConnectName, UEndRigster, UConnectThingKey, Seq, UStartRigster, UConnType, URlyConnectId, UTempRigester) {

            ClearInputAlert("txtUConnectName", "txtUStartRigster", "txtUEndRigster", "txtUConnectSeq", "txtUTempRigester");

            if (UConnType == 1 || !UConnType) $("#dvTempSection").hide();
            else $("#dvTempSection").show();



            SelectedUCategoryId = UCategoryId;
            SelectedUConnectId = UConnectId;
            if (UConnectId != 0) {

                $("#spModalConnect").text(UConnectName);
                $("#txtUConnectName").val(isEmpty(UConnectName));
                $("#txtUEndRigster").val(isEmpty(UEndRigster));
                $("#txtUTempRigester").val(isEmpty(UTempRigester));
                $("#txtUConnectSeq").val(isEmpty(Seq));

                $("#txtUStartRigster").val(isEmpty(UStartRigster));
                $("#ddlUConnMode").val(isEmpty(UConnType));
                $("#ddlUTemps").val(isEmpty(URlyConnectId));



            } else {


                var resData = Ajax("Admin_GetUConnectStartEndRegister", "UCommandId=" + SelectedUCommandId);
                
                $("#spModalConnect").text("יחידה חדשה");
                $("#txtUConnectName").val("");
             
                $("#txtUTempRigester").val("");
                $("#txtUConnectSeq").val("");
                $("#txtUStartRigster").val(resData[0].StartReg);
                $("#txtUEndRigster").val(resData[0].EndReg);
                $("#ddlUConnMode").val("1");
                $("#ddlUTemps").val("");
                

            }


            $("#myConnectModal").modal();

        }

        function DeleteConnect(UConnectId, e) {
            e.cancelBubble = true;

            SelectedUConnectId = UConnectId;
            DeleteType = "3";
            OpenMessage("האם אתה בטוח שברצונך למחוק את היחידה מהמערכת?", "כן", "לא");

        }

        function SaveDataConnect() {

            ClearInputAlert("txtUConnectName", "txtUStartRigster", "txtUEndRigster", "txtUConnectSeq", "txtUTempRigester");

            var UConnectName = $("#txtUConnectName").val();
            var UStartRigster = $("#txtUStartRigster").val();
            var UEndRigster = $("#txtUEndRigster").val();
            var UTempRigester = $("#txtUTempRigester").val();
                                     
            var UConnType = $("#ddlUConnMode").val();
            var UConnectSeq = $("#txtUConnectSeq").val();

            
            if (!UConnectSeq) UConnectSeq = "0";
           
            var temp = (UConnType == 1) ? "" : "txtUTempRigester";

            var res = CheckValid("txtUConnectName", "txtUConnectSeq", temp);
          
            if (!res) return;

            var resData = Ajax("Admin_SetUConnect", "UConnectId=" + SelectedUConnectId + "&UCategoryId=" + SelectedUCategoryId
                   + "&UEndRigster=" + UEndRigster
                   + "&UConnectName=" + UConnectName + "&UConnectSeq=" + UConnectSeq + "&UStartRigster=" + UStartRigster
                   + "&UConnType=" + UConnType 
                   + "&UCommIP=" + SelectedUCommIP
                   + "&UTempRigester=" + UTempRigester
                   
                   );


            if (resData[0]) {

                OpenMessage("ישנה בעיה בעדכון הנתונים אנא בדוק חיבורים של היחידות");
                return;
            }


            FillCategoryData();

           
            $("#myConnectModal").modal("hide");

        }

        function CreateBakarRigster(Type) {
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

                var res = Ajax("Admin_UCommandRegister", "UCommandId=" + SelectedUCommandId + "&Startrigster=" + Startrigster + "&Jump=" + Jump + "&Type=1");
                alert("יצירת כל הרגיסטרים של הבקר בוצעו בהצלחה");

                //  FillCategoryData();




            }

        }
        


        function CheckValid() {
            var res = true;
            for (i = 0; i < arguments.length; i++) {
               
                if (!arguments[i]) continue;
                var valueOfArg =  $("#" + arguments[i]).val();
                if (!valueOfArg) {
                    $("#" + arguments[i]).addClass("inputAlertRed");
                    $(".dvAlertRed").show();
                    res = false;
                }
            }
            return res;
        }

        function ClearInputAlert() {
            for (i = 0; i < arguments.length; i++) {
                $(".dvAlertRed").hide();
                $("#" + arguments[i]).removeClass("inputAlertRed");
            }

        }


        function ConnectChange() {
            var UConnType = $("#ddlUConnMode").val();
            if (UConnType == 1) {
                $("#dvTempSection").hide();
                $("#txtUTempRigester").val("");
            }
            else $("#dvTempSection").show();
            


        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="col-md-12" id="dvMainContainer">
       
       <%-- <button type="button" class="btn btn-info" >Simple collapsible</button>--%>
        
         <div class="row dvSection">
            <div class="panel panel-info"  data-toggle="collapse" data-target="#dvPanelBakar">
                <div class="panel-heading ">
                    <div class="panel-title">
                        &nbsp;רשימת בקרים 
                   
                        <div class="btnMargin">
                            <div class="btn  btn-success btn-round btn-xs" onclick='OpenUCommand(0,0,0,0,0,event)'><i class='glyphicon glyphicon-plus-sign'></i>&nbsp;הוסף בקר&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </div>
                        </div>
                        <div class="btnMargin" style="">
                            <img id="imgOnline" src="../assets/images/Offline.png" height="20px" onclick="SetOnlineOffline()" />
                        </div>

                    </div>


                </div>
                <div class="panel-body" id="dvPanelBakar">
                   <%-- <div class="col-md-12">
                        לחיצה אחת על 
                          <b>"בקר"</b>
                        תציג את כל התחנות שלו.
                        <br />   <br />
                    </div>--%>
                    <div class="col-md-12" id="dvUCommandContainer">
                    </div>

                </div>
            </div>
        </div>

    </div>

    <div class="col-md-12" id="dvMainCategoryContainer">
    </div>


    <%-- חלון מודלי של בקר --%>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header label-info">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title"><span id="spModalBakar"></span>
                    </h4>
                </div>
                <div class="modal-body" id="Div4">
                    <div class="col-md-12">

                        <div class="col-md-3">
                            <span class="help-block m-b-none">שם בקר: </span>
                        </div>

                        <div class="col-md-9 input-group ls-group-input ">
                            <input type="text" id="txtUCommandName" class="form-control">
                        </div>

                        <div class="col-md-3">
                            <span class="help-block m-b-none">כתובת IP: </span>
                        </div>

                        <div class="col-md-9 input-group ls-group-input">
                            <input type="text" id="txtUCommIP" class="form-control">
                        </div>

                        <div class="col-md-3">
                            <span class="help-block m-b-none">PORT: </span>
                        </div>

                        <div class="col-md-9 input-group ls-group-input">
                            <input type="text" id="txtUCommPORT" class="form-control">
                        </div>
                             <div class="col-md-12" style="text-align: left">
                            <button type="button" class="btn btn-info btn-round" onclick="SaveDataBakar()">
                                <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>עדכן</span>
                            </button>
                        </div>
          <%--               <div class="col-md-12" style="text-align: left">
                               <hr />
                             </div>
                      
                         <div class="col-md-3">
                            <span class="help-block m-b-none">ריגסטר התחלה</span>
                        </div>

                        <div class="col-md-3 ">
                            <input type="number" id="txtStartrigster" class="form-control">
                        </div>
                         <div class="col-md-3">
                            <span class="help-block m-b-none">בקפיצות </span>
                        </div>

                        <div class="col-md-3">
                            <input type="number" id="txtJump" class="form-control">
                        </div>
                         <div class="col-md-12"><br /></div>
                        <div class="col-md-6" style="">
                            </div>
                         <div class="col-md-3" style="">
                            <button type="button" class="btn btn-primary btn-round" onclick="CreateBakarRigster(1)">
                                <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>צור ריסטרים </span>
                            </button>
                        </div>

                        <div class="col-md-3" style="">
                         <div class="btn  btn-danger btn-round" onclick='CreateBakarRigster(2)'> מחק ריגסטרים</div>
                        </div>

                      <div class="col-md-12" style="text-align: left">
                               <hr />
                             </div>--%>


                   
                   

                         <div class="col-md-12 dvAlertRed " >
                             השדות המסומנים הינם שדות חובה!
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

    <%-- חלון מודלי של קטגוריה --%>
    <div class="modal fade" id="myCategoryModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header label-info">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title"><span id="spModalCategory"></span>
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">

                        <div class="col-md-3">
                            <span class="help-block m-b-none">שם קטגוריה: </span>
                        </div>

                        <div class="col-md-9 input-group ls-group-input ">
                            <input type="text" id="txtUCategoryName" class="form-control">
                        </div>

                        <div class="col-md-3">
                            <span class="help-block m-b-none">מיקום: </span>
                        </div>

                        <div class="col-md-9 input-group ls-group-input">
                            <input type="number" id="txtUCategorySeq" class="form-control">
                        </div>

                        <div class="col-md-12" style="text-align: left">
                            <button type="button" class="btn btn-info btn-round" onclick="SaveDataCategory()">
                                <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>עדכן</span>
                            </button>
                        </div>

                         <div class="col-md-12 dvAlertRed " >
                             השדות המסומנים הינם שדות חובה!
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

    <%-- חלון מודלי של יחידה --%>
    <div class="modal fade" id="myConnectModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header label-info">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title"><span id="spModalConnect"></span>
                    </h4>
                </div>
                <div class="modal-body" id="Div4">
                    <div class="col-md-12">

                        <div class="col-md-3">
                            <span class="help-block m-b-none">סוג יחידה: </span>
                        </div>

                        <div class="col-md-9" style="padding: 0px; margin: 0px;">
                            <select id="ddlUConnMode" class="form-control" onchange="ConnectChange()">
                                <option value="1">מתח</option>
                                <option value="2">מתח + טמפרטורה</option>
                              <%--  <option value="3">טמפרטורה</option>
                                <option value="4">חיישן</option>
                                <option value="5">נצירת שבת</option>--%>
                            </select>
                        </div>


                        <div class="clear">&nbsp;</div>
                        <div class="col-md-3">
                            <span class="help-block m-b-none">שם יחידה: </span>
                        </div>

                        <div class="col-md-9 input-group ls-group-input ">
                            <input type="text" id="txtUConnectName" class="form-control">
                        </div>
                        <div id="dvTempSection">
                        <div class="col-md-3">
                            <span class="help-block m-b-none"> ריגסטר טמפ': </span>
                        </div>

                        <div class="col-md-9 input-group ls-group-input">
                            <input type="number" id="txtUTempRigester" class="form-control">
                        </div>
                        </div>
                        <div class="col-md-3">
                            <span class="help-block m-b-none">התחלת ריגסטר: </span>
                        </div>

                        <div class="col-md-9 input-group ls-group-input">
                            <input type="number" id="txtUStartRigster" class="form-control">
                        </div>
                        <div class="col-md-3">
                            <span class="help-block m-b-none">סוף ריגסטר:</span>
                        </div>

                        <div class="col-md-9 input-group ls-group-input">
                            <input type="number" id="txtUEndRigster" class="form-control">
                        </div>

                        <%--  בינתיים לא צריך--%>
                        <div style="display: none">
                        </div>

                        <div class="col-md-3">
                            <span class="help-block m-b-none">מיקום: </span>
                        </div>

                        <div class="col-md-9 input-group ls-group-input">
                            <input type="number" id="txtUConnectSeq" class="form-control">
                        </div>



                        <div class="col-md-12" style="text-align: left">
                            <button type="button" class="btn btn-info btn-round" onclick="SaveDataConnect()">
                                <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>עדכן</span>
                            </button>
                        </div>

                        <div class="col-md-12 dvAlertRed " >
                             השדות המסומנים הינם שדות חובה!
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


    <%-- טמפלטים --%>
    <div id="dvUCommandTemplate" style="display: none">
        <div class="col-md-2 dvMarginBott">
            <div class="btn btn-info btn-round dvConnect" id="dvCommand_@UCommandId" onclick="SetAction(1,@UCommandId,'@UCommIP',event);">
                <span>@UCommandName</span>

                <div class="btn btn-danger btn-round" style="float: left" onclick="SetAction(2,@UCommandId,'@UCommIP',event);">
                    מחק 
                </div>
                <div class="btn btn-primary btn-round" style="float: left" onclick='OpenUCommand(@UCommandId,"@UCommandName","@UCommIP","@UCommThingKey","@UCommPORT",event)'>
                    ערוך 
                </div>
            </div>
        </div>
    </div>

    <div id="dvCategoryTemplate" style="display: none">

        <div class="row dvSection">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <div class="panel-title">
                        &nbsp; @UCategoryName

                     <%--    <div class="btnMargin">
                             <div class='btn btn-success btn-round  btn-xs' onclick='OpenCategory(0)'>
                                 <i class='glyphicon glyphicon-plus-sign'></i> הוסף קטגוריה </div>
                         </div>--%>
                        <div class="btnMargin">
                            <div class="btn btn-primary btn-round btn-xs" onclick='OpenConnect(@UCategoryId,"0","","","","","","","0","")'>
                                <i class='glyphicon glyphicon-plus-sign'></i>
                                הוסף יחידה
                            </div>
                        </div>


                        <div class="btnMargin">
                            <div class="btn  btn-danger btn-round btn-xs" onclick='DeleteCategory(@UCategoryId)'>מחק קטגוריה</div>
                        </div>
                        <div class="btnMargin">
                            <div class="btn btn-info btn-round btn-xs" onclick='OpenCategory(@UCategoryId,"@UCategoryName","@Seq")'>ערוך קטגוריה</div>
                        </div>


                        <div class="btnMargin">
                            מיקום: @Seq
                        </div>

                    </div>


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
            <div class="btn btn-primary @btntype btn-round dvConnect draggable droppable" id="dvConnect_@UConnectId"
                onclick="OpenConnect(@UCategoryId,@UConnectId,'@UConnectName','@UEndRigster', '@UConnectThingKey','@Seq','@UStartRigster','@UConnType','@URlyConnectId','@UTempRigester')">
                <span style="float:right">(@Seq) </span>

                <span class="badge" id="@UConnectId_tempId">@Utemp</span>

            
                <div style="float:left" class="btn  btn-danger btn-round btn-xs" onclick='DeleteConnect(@UConnectId,event)'>מחק</div>
                <br />
                <span>@UConnectName</span>
            </div>
        </div>
    </div>

</asp:Content>
