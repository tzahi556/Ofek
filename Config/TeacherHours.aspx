<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true"
    CodeFile="TeacherHours.aspx.cs" Inherits="Config_TeacherHours" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   <script type="text/javascript" src="../assets/js/jquery-ui.js"></script>
   <link href="../assets/css/jquery-ui.css" rel="stylesheet" type="text/css" />
   <link href="../assets/css/rtl-css/typeahead.js-bootstrap.css" rel="stylesheet" type="text/css" />
    
    
    
    
    <script src="../assets/js/bootstrap3-typeahead.min.js" type="text/javascript"></script>
    <script type="text/javascript">

        var mydata;
        var TeacherData;
        var SelectedTeacherId = "";
        var SelectedFirstName = "";
        var SelectedLastName = "";
        var SelectedTafkidId = "";
        var SelectedEmail = "";

        var SelectedType = "";


        $(document).ready(function () {

            $('input.typeahead').focus();

            // mydata = Ajax("Gen_GetTable", "TableName=SchoolHours&Condition=ConfigurationId=" + ConfigurationId);

            $('#dvAllDays').hide();

            // 

            GetComboItems("Tafkid", "ConfigurationId=" + ConfigurationId, "#ddlTafkid", "TafkidId", "Name");

            $('input.typeahead').change(function () {
                if (!$('input.typeahead').val()) {
                    resetTeacher();
                }

            });

            InitAutoComplete();

            SelectedTeacherId = 1;
            BuildTeacherLooz();

            //  $('input.typeahead').val("עדי חזן");
        });



        function resetTeacher() {
            $('input.typeahead').val("");
            SelectedTeacherId = "";
            $('.spTeacherName').text("");
            BuildTeacherLooz();

        }

        function InitAutoComplete() {

            TeacherData = Ajax("Teacher_GetTeacherList", "TeacherId=");
            $('input.typeahead').typeahead({
                items: 15,
                source: function (query, process) {
                    states = [];
                    map = {};

                  
                    $.each(TeacherData, function (i, state) {
                        map[state.FullText] = state;
                        states.push(state.FullText);
                    });

                    process(states);
                },

                updater: function (item) {
                    SelectedTeacherId = map[item].TeacherId;
                    SelectedFirstName = map[item].FirstName;
                    SelectedLastName = map[item].LastName;
                    SelectedTafkidId = map[item].TafkidId;
                    SelectedEmail = map[item].Email;
                    BuildTeacherLooz();
                    return item;
                }


            });

        }

        function BuildTeacherLooz() {

            if (SelectedTeacherId) {
                $('.spTeacherName').text(SelectedFirstName + " " + SelectedLastName);
                BuildMatrixHours();
                
                $('#dvAllDays').show();
            } else {

                $('#dvAllDays').hide();
            
             }
        }


        function BuildMatrixHours() {


            $("#dv1,#dv2,#dv3,#dv4,#dv5,#dv6").html("");


            var mydata = Ajax("Teacher_GetTeacherHours", "TeacherId=" + SelectedTeacherId);

            for (var i = 0; i < mydata.length; i++) {

                var HourId = mydata[i].HourId;
                var HourTypeId = mydata[i].HourTypeId;
                var HourType = mydata[i].HourType;
                var Comment = mydata[i].Comment;
                var HourOnly = HourId.toString().substring(1);
                var dvDay = HourId.toString().substring(0, 1);




                $("#dv" + dvDay).append("<div id=" + HourId + "><span class='spSeqNumber'>" + HourOnly + ") "
                + HourType + "</span>" + Comment + "&nbsp;</div>");


            }

            InitSelectableNGN(mydata, "HourIdTeacaher");

            DefineRightClickEVENT();
        }


        function CallBackAdd(ObjId) {

          
            var mydata = Ajax("Teacher_SetTeacherHours", "TeacherId=" + SelectedTeacherId + "&HourId=" + ObjId + "&Type=1");

            DefineRightClickEVENT(); 

        }

        function CallBackRemove(ObjId) {

            var mydata = Ajax("Teacher_SetTeacherHours", "TeacherId=" + SelectedTeacherId + "&HourId=" + ObjId + "&Type=2");

            DefineRightClickEVENT(); 

        }


        function OpenUpdateTeacher(Type) {

            if (!SelectedTeacherId && Type != "2") {
                bootbox.alert("חובה לבחור מורה בכדי לעדכן נתונים");
                return;
            }

            SelectedType = Type;

            // עדכון
            if (Type == "1") {

                $("#ddlTafkid").val(SelectedTafkidId);
                $("#txtFirstName").val(SelectedFirstName);
                $("#txtLastName").val(SelectedLastName);
                $("#txtEmail").val(SelectedEmail);
                $("#spModalTitle").html("עדכון פרטי מורה - " + SelectedFirstName + " " + SelectedLastName);
                $("#ModalTeacher").modal();
            }

            // הוספה
            if (Type == "2") {
              
                $("#ddlTafkid").val("0");
                $("#txtFirstName").val("");
                $("#txtLastName").val("");
                $("#txtEmail").val("");
                $("#spModalTitle").html(" הוספת מורה חדש/ה ");
                $("#ModalTeacher").modal();
            }

            //מחיקה
            if (Type == "3") {
               // bootbox.confirm("האם אתה בטוח שברצונך למחוק מורה עם השיבוצים שלו?", ConfirmDelete);

                    bootbox.confirm("האם אתה בטוח שברצונך למחוק מורה עם השיבוצים שלו?", function (result) {
                    if (result) {

                        SaveData();
                        resetTeacher();

                    }
                }); 
               
            }


        }

        function SaveData() {

          


            var Tafkid =  $("#ddlTafkid").val();
            var FirstName = $("#txtFirstName").val();
            var LastName = $("#txtLastName").val();
            var Email = $("#txtEmail").val();


            if (SelectedType!="3" && (Tafkid == "0" || !FirstName || !LastName)) {
                bootbox.alert("בחירת תפקיד שם ושם משפחה הינם שדות חובה");
                return;
            }


            var res = Ajax("Teacher_DML", "TeacherId=" + SelectedTeacherId + "&Tafkid=" + Tafkid
            + "&FirstName=" + FirstName + "&LastName=" + LastName + "&Email=" + Email + "&Type=" + SelectedType);

            // אם חדש
            if (SelectedType == "2") SelectedTeacherId = res[0].TeacherId;
       

            InitAutoComplete();

            UpdateSelectedFromData();

            BuildTeacherLooz();

            $("#ModalTeacher").modal("hide");

        }

        function UpdateSelectedFromData() {
          
            for (var i = 0; i < TeacherData.length; i++) {

                if (SelectedTeacherId == TeacherData[i].TeacherId) {

                  
                    SelectedTeacherId = TeacherData[i].TeacherId;
                    SelectedFirstName = TeacherData[i].FirstName;
                    SelectedLastName = TeacherData[i].LastName;
                    SelectedTafkidId = TeacherData[i].TafkidId;
                    SelectedEmail = TeacherData[i].Email;


                   
                    $('input.typeahead').val(SelectedFirstName + " " + SelectedLastName);



                  
                
                }


                
            }





        }


        function DefineRightClickEVENT() {

            $(".selected").contextMenu({
                menuSelector: "#contextMenuAbsence",
                menuSelected: function (invokedOn, selectedMenu) {

                    //e.cancelBubble = true;
                    var Obj = invokedOn[0];

                  //  alert($(Obj).attr("id"));



                    var MenuId = selectedMenu[0].id;

                    switch (MenuId) {
                        case "li1": 
                            OpenShyaPartani(Obj,1);
                            break;
                        case "li2":
                            OpenShyaPartani(Obj,2);
                            break;

                        default:
                            break;


                    }

                }
            });

        }
        

        function OpenShyaPartani(Obj,Type) {

            var HourId = $(Obj).attr("id");



           $("#spTitleName").text( "הגדרות שהייה ל" +  getDayAndHour(HourId));
            

            $("#ModalShya").modal();
            
        }


    </script>
</asp:Content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="Server">
 
    <div class="col-md-12">
        <div class="row dvWeek">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        &nbsp;בחירת מורה 
                    </h3>
                </div>
                <div class="panel-body">
                  <div class="col-md-6">
                        <input type="text" class="form-control typeahead" spellcheck="false" autocomplete="off"
                            placeholder="חיפוש לפי שם או שם משפחה">
                    </div>
                    
                    
                    <div class="col-md-2">
                        <div class="btn btn-info btn-round" onclick="OpenUpdateTeacher(1)">
                            <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>עדכן מורה</span>
                        </div>
                    </div>

                        <div class="col-md-2" >
                        <div class="btn btn-primary btn-round" onclick="OpenUpdateTeacher(2)">
                            <i class="glyphicon glyphicon-plus"></i>&nbsp; <span>הוסף מורה</span>
                        </div>
                    </div>

                        <div class="col-md-2" style="text-align: left">
                        <div class="btn btn-danger btn-round" onclick="OpenUpdateTeacher(3)">
                            <i class="glyphicon glyphicon-remove"></i>&nbsp; <span>מחק מורה</span>
                        </div>
                    </div>

                
                </div>
                 </div>
        </div>
    </div>
 
    <div class="col-md-12" id="dvAllDays">
        <div class="row dvWeek">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        &nbsp; שעות למורה- <span class="spTeacherName"></span>
                    </h3>
                </div>
                <div class="panel-body">
                    <div class="col-md-10">
                        <h5 style="font-style:italic">
                             בחר שעות ע"י לחיצה וגרירה , לביטול לחץ וגרור שוב.</h5>
                    </div>
                    <div class="col-md-2" style="text-align: left">
                        <div class="btn btn-info btn-round" style="margin: 1px;">
                            סה"כ שעות לימוד  <span class="badge" id="spTotals">0</span>
                        </div>
                    </div>
                    <div class="dvDaysCotainer">
                        <div class="col-md-2">
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    <h3 class="panel-title">
                                        &nbsp; יום ראשון
                                    </h3>
                                </div>
                                <div class="panel-body" id="dv1">
                                   
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    <h3 class="panel-title">
                                        &nbsp; יום שני
                                    </h3>
                                </div>
                                <div class="panel-body" id="dv2">
                                   
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    <h3 class="panel-title">
                                        &nbsp; יום שלישי
                                    </h3>
                                </div>
                                <div class="panel-body" id="dv3">
                                   
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    <h3 class="panel-title">
                                        &nbsp; יום רביעי
                                    </h3>
                                </div>
                                <div class="panel-body" id="dv4">
                                    
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    <h3 class="panel-title">
                                        &nbsp; יום חמישי
                                    </h3>
                                </div>
                                <div class="panel-body" id="dv5">
                                  
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    <h3 class="panel-title">
                                        &nbsp; יום שישי
                                    </h3>
                                </div>
                                <div class="panel-body" id="dv6">
                                 
                                </div>
                            </div>
                        </div>
                        <div class="clear">
                            &nbsp;</div>
                    </div>
                   <%-- <div class="col-md-10">
                    </div>
                    <div class="col-md-2" style="text-align: left">
                        <div class="btn btn-info btn-round" onclick="SaveData()">
                            <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>שמור שינויים</span>
                        </div>
                    </div>--%>
                </div>
            </div>
        </div>
    </div>
  
   <%-- חלון מודלי של מורה --%>
    <div class="modal fade" id="ModalTeacher" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header label-info">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title" id="spModalTitle">
                       
                    </h4>
                </div>
                <div class="modal-body" id="Div14">
                   
                   
                    <div class="col-md-6">
                        <div class="form-group">
                            <input type="text" placeholder="שם פרטי" id="txtFirstName" name="txtFirstName"
                                class="form-control">
                        </div>
                    </div>
                   
                    <div class="col-md-6">
                        <div class="form-group">
                            <input type="text" placeholder="שם משפחה" id="txtLastName" name="txtLastName"
                                class="form-control">
                        </div>
                    </div>
                   

                   <div class="col-md-6">
                        <div class="form-group">
                            <input type="text" placeholder="אימייל" id="txtEmail" name="txtEmail"
                                class="form-control">
                        </div>
                    </div>
                   
                   
                    <div class="col-md-6" >
                     <div class="form-group">
                        <select id="ddlTafkid" class="form-control">
                            <option value="0">-- בחר תפקיד --</option>
                        </select>
                        </div>
                    </div>
                   
                    <div class="col-md-12" style="text-align: left">
                        <button type="button" class="btn btn-info btn-round" onclick="SaveData()">
                            <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>עדכן פרטי מורה</span>
                        </button>
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

    <%-- חלון מודלי של שהייה --%>
    <div class="modal fade" id="ModalShya" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header label-info">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title">
                       <span id="spTitleName"></span>
                    </h4>
                </div>
                <div class="modal-body" id="Div13">
                  
                    <div class="col-md-5">
                        <select id="ddlShyaGroup" class="form-control">
                            <option value="0">-- בחר קבוצה --</option>
                        </select>
                        
                    </div>
                    <div class="col-md-4">
                        
                         <input id="Text2" class="form-control" placeholder="קבוצה חדשה" type="text" />
                    </div>

                   <div class="col-md-2">
                        <button type="button" class="btn btn-danger btn-round" onclick="SaveHariga()">
                            <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>מחק קבוצה </span>
                        </button>
                    </div>
                   


                     <div class="clear">
                        &nbsp;</div>


                    <div class="col-md-12" >
                     <%--   <textarea placeholder="טקסט חופשי" class="form-control" id="txtFreeHariga" name="txtFreeHariga"></textarea>--%>
                       <select id="Select1" class="form-control">
                            <option value="0">מורים</option>
                        </select>
                     
                  
                    </div>


                      <div class="clear">
                        &nbsp;</div>

                    <div class="col-md-12" style="text-align: left">
                        <button type="button" class="btn btn-info btn-round" onclick="SaveHariga()">
                            <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>שמור </span>
                        </button>
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


     <ul id="contextMenuAbsence" class="dropdown-menu dropdown-menu-right" role="menu"
        style="display: none;">
        <li><a id="li1" tabindex="-1" href="#">הגדרת שהייה</a></li>
        <li><a id="li2" tabindex="-1" href="#">הגדרת פרטני </a></li>
        <li class="divider"></li>
        <li><a tabindex="-1" href="#">סגור</a></li>
    </ul>
</asp:content>
