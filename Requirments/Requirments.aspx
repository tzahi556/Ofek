<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true"
    CodeFile="Requirments.aspx.cs" Inherits="Requirments_Requirments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!--bootstrap validation Library Script End-->
    <!--Demo form validation  Script Start-->
    <script type="text/javascript">

        var mydata;


        var OrgUnitCode = "";

        $(document).ready(function () {

            InitFormValidation("fmrReqDetails");
            GetComboItems("Codes", "TableId=5", "#ddlArea", "ValueCode", "ValueDesc");
            GetComboItems("Codes", "TableId=7", "#ddlShift", "ValueCode", "ValueDesc");
            GetComboItems("Codes", "TableId=1", "#ddlDayCode", "ValueCode", "ValueDesc");
            InitDateTimePickerPlugin('#txtStartDate,#txtEndDate', getDateTimeNowFormat(), 0);
            FillData();

            $("#ddlArea").change(function () {
                FillData();
            });

        });

        function FillData() {

            $("#dvReqContainer").html("");
            OrgUnitCode = $('#ddlArea').val();
           // OrgUnitCode = $('#ddlArea').val();
           
            $(".spAreaName").text($('#ddlArea option:selected').text());
            $("#ddlQualification").html('<option value="">-- בחר --</option>');

          //  GetComboItems("Codes", "TableId=2 And AddedValue3=" + OrgUnitCode, "#ddlQualification", "ValueCode", "ValueDesc");

            var QualificationData = Ajax("Requirments_GetQualificationData", "OrgUnitCode=" + OrgUnitCode);
            $("#ddlQualification").append(GetComboItemsByData(QualificationData, "ValueCode", "ValueDesc"));
            $("#ddlQualification").append('<option value="99999999"> הדרכה ללא כישור </option>');

            mydata = Ajax("Requirments_GetRequiremntsByArea", "OrgUnitCode=" + OrgUnitCode);


            //var Area = "";
            var ReqHtml = "";
            for (var i = 0; i < mydata.length; i++) {

                ReqHtml = $("#dvReqTemplate").html();
                ReqHtml = ReqHtml.replace("@RequirementDescTable", mydata[i].MainDesc);
                ReqHtml = ReqHtml.replace("@DayDesc", mydata[i].DayDesc);
                ReqHtml = ReqHtml.replace("@ShiftDesc", mydata[i].ShiftDesc);
                ReqHtml = ReqHtml.replace(/@QualificationDesc/g, mydata[i].QualificationDesc);
                ReqHtml = ReqHtml.replace(/@EmpQuantity/g, mydata[i].EmpQuantity);
                ReqHtml = ReqHtml.replace("@ObligatoryAssignmentTable", (mydata[i].ObligatoryAssignment == 1) ? "כן" : "לא");
                ReqHtml = ReqHtml.replace("@ObligatoryCheckTable", (mydata[i].ObligatoryCheck == 1) ? "כן" : "לא");


                ReqHtml = ReqHtml.replace("@Dates", mydata[i].Dates);
                ReqHtml = ReqHtml.replace("@Seq", mydata[i].Seq);


                ReqHtml = ReqHtml.replace(/@RequirementId/g, mydata[i].RequirementId);
                ReqHtml = ReqHtml.replace("@DateTypeCode", mydata[i].DateTypeCode);
                ReqHtml = ReqHtml.replace("@RequirementType", mydata[i].RequirementType);
                
                ReqHtml = ReqHtml.replace("@ShiftCode", mydata[i].ShiftCode);
                ReqHtml = ReqHtml.replace("@QualificationCode", mydata[i].QualificationCode);
                ReqHtml = ReqHtml.replace("@RequirementAbb", mydata[i].RequirementAbb);

                ReqHtml = ReqHtml.replace("@ObligatoryAssignment", mydata[i].ObligatoryAssignment);
                ReqHtml = ReqHtml.replace("@ObligatoryCheck", mydata[i].ObligatoryCheck);
                ReqHtml = ReqHtml.replace("@IsAssignAuto", mydata[i].IsAssignAuto);

                
                ReqHtml = ReqHtml.replace("@BeginDate", mydata[i].BeginDate);
                ReqHtml = ReqHtml.replace("@EndDate", mydata[i].EndDate);

                ReqHtml = ReqHtml.replace("@RequirementDesc", mydata[i].RequirementDesc);











                $("#dvReqContainer").append(ReqHtml);


            }


        }

        var SelectedRequirementId = "";
        function EditRequirement(RequirementId, DateTypeCode, ShiftCode, QualificationCode, EmpQuantity,Seq ,
                RequirementDesc, RequirementAbb, ObligatoryAssignment, ObligatoryCheck, BeginDate, EndDate, RequirementType, IsAssignAuto) {


           // alert(RequirementType);
            SelectedRequirementId = RequirementId;

            $('#fmrReqDetails').validationEngine('hideAll');

            $("#txtEmpQuantity").mask(GetMaskCharByNumber("8"));

            $("#txtRequirementDesc").val(RequirementDesc);
            $("#ddlQualification").val(QualificationCode);

            $("#ddlDayCode").val(DateTypeCode);
            $("#ddlShift").val(ShiftCode);
            $("#txtEmpQuantity").val(EmpQuantity);
            $("#ddlRequirmentType").val("");
            if (RequirementType!="null") {
             //   RequirementType = "";
                $("#ddlRequirmentType").val(RequirementType);
            }


            $("#txtRequirementAbb").val((RequirementAbb != "null") ? RequirementAbb : "");
            $("#txtSeq").val(Seq);
            
            $("#txtStartDate").val(BeginDate);
            $("#txtEndDate").val(EndDate);

            
            $("#chIsAuto").prop('checked', (ObligatoryAssignment == "true") ? true : false);
            $("#chIsMustCheck").prop('checked', (ObligatoryCheck == "true") ? true : false);
            $("#chIsAssignAuto").prop('checked', (IsAssignAuto == "true") ? true : false);
            
            $("#spReqDesc").text((RequirementDesc) ? RequirementDesc : "דרישה חדשה");
            
            if (!RequirementId) {
                $("#txtStartDate").val(getDateTimeNowFormat());
                $("#txtEndDate").val("31.12.9999");

                EnableDisableControls(false);

            } 
            else 
            {

                EnableDisableControls(true);

            }







           



            $("#ModalEdit").modal();
        }

        function EnableDisableControls(IsDisable) {
            $("#txtStartDate,#txtEndDate,#txtRequirementDesc,#ddlQualification,#ddlDayCode,#ddlShift,#ddlRequirmentType").prop("disabled", IsDisable);

        }

        function SaveDataTODB() {

            var form = $("#fmrReqDetails");
            var IsValid = form.validationEngine('validate');


            if (IsValid) {



                EnableDisableControls(false);

                var strPost = form.serialize();
               
                Ajax("Requirments_SetRequiremntsTODB", strPost + "&RequirementId=" + SelectedRequirementId + "&OrgUnitCode=" + OrgUnitCode);
                $("#ModalEdit").modal('hide');
                FillData();

            }

        }

        function DeleteRequirement(RequirementId) {

            bootbox.confirm("האם אתה בטוח שברצונך למחוק את הדרישה?", function (result) {
                if (result) {
                    Ajax("Requirments_DeleteRequiremnts", "RequirementId=" + RequirementId);
                    FillData();
                }

            });

          
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="col-md-12">
        <div class="row">
            <div class="panel panel-info" style="margin: 2px">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <i class="glyphicon glyphicon-th-list"></i>&nbsp; דרישות לאזור
                    </h3>
                </div>
                <div class="panel-body" style="padding: 8px">
                    <div class="col-md-4">
                        <span class="help-block m-b-none">אזור</span>
                        <select id="ddlArea" class="form-control">
                        </select>
                    </div>
                    <div class="col-md-2">
                        <span class="help-block m-b-none">&nbsp; </span>
                        <button type="button" class="btn btn-info btn-round" onclick="FillData()">
                            <i class="glyphicon glyphicon-search"></i>&nbsp; <span class="btnAssign">חפש </span>
                        </button>
                    </div>
                    <%--  <form id="formID"  method="post" action="">
                        <input type="text" id="Text1" class="form-control validate[required] text-input">
                        <div class="submit btn-primary btn" type="submit" name="submit" onclick="SaveDataTODB()">Save</div>
                    </form>--%>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-12">
        <div class="row">
            <div class="panel panel-info" style="margin: 2px">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <i class="glyphicon glyphicon-th-list"></i>&nbsp; דרישות ל - <span class="spAreaName">
                        </span>
                    </h3>
                </div>
                <div class="panel-body" style="padding: 0px">
                    <br />
                    <div>
                        <div class="col-md-3 dvRequireTitle">
                            תאור דרישה
                        </div>
                        <div class="col-md-1 dvRequireTitle">
                            סוג יום
                        </div>
                        <div class="col-md-1 dvRequireTitle">
                            משמרת
                        </div>
                        <div class="col-md-2 dvRequireTitle">
                            כישור נדרש
                        </div>
                        <%--<div class="col-md-1 dvRequireTitle">
                            כ.עובדים
                        </div>--%>
                        <div class="col-md-1 dvRequireTitle">
                            אוטמטי?
                        </div>
                        <div class="col-md-1 dvRequireTitle">
                            בדיקה?
                        </div>
                        <div class="col-md-2 dvRequireTitle">
                          תאריכים
                        </div>
                        <div class="col-md-1 dvRequireTitle">
                           &nbsp;
                        </div>
                        <div id="dvReqContainer" class="dvPanelReq clear">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-12">
        <div class="row" style="padding: 4px">
            <div class="btn btn-primary" onclick='EditRequirement("", "","", "", "", "", "","", "","","", "","","")'>
                <i class="fa fa-plus-circle"></i>&nbsp;הוסף דרישה חדשה
            </div>
        </div>
    </div>
    <%-- חלון מודלי של הגדרת דרישה--%>
    <div class="modal fade" id="ModalEdit" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header label-info">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;</button>
                    <h4 class="modal-title">
                        <span id="spReqDesc"></span>
                    </h4>
                </div>
                <div class="modal-body" id="Div8">
                    <form id="fmrReqDetails" method="post" action="">
                    <div class="col-md-3">
                        <span class="help-block m-b-none">שם דרישה:</span>
                    </div>
                    <div class="col-md-9">
                        <input type="text" id="txtRequirementDesc" name="txtRequirementDesc" class="form-control validate[required] text-input">
                    </div>
                    <div class="clear">
                        &nbsp;</div>
                    <div class="col-md-3">
                        <span class="help-block m-b-none">כישור נדרש:</span>
                    </div>
                    <div class="col-md-9">
                        <select id="ddlQualification" name="ddlQualification" class="form-control validate[required]">
                          
                        </select>
                    </div>
                    <div class="clear">
                        &nbsp;</div>
                    <div class="col-md-3">
                        <span class="help-block m-b-none">סוג יום:</span>
                    </div>
                    <div class="col-md-4">
                        <select id="ddlDayCode" name="ddlDayCode" class="form-control validate[required]">
                            <option value="">-- בחר --</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                        <span class="help-block m-b-none">משמרת:</span>
                    </div>
                    <div class="col-md-4">
                        <select id="ddlShift" name="ddlShift" class="form-control validate[required]">
                            <option value="">-- בחר --</option>
                        </select>
                    </div>
                    <div class="clear">
                        &nbsp;</div>
                    <div class="col-md-3">
                        <span class="help-block m-b-none">כמות עובדים:</span>
                    </div>
                    <div class="col-md-4">
                        <div class="input-group ls-group-input">
                            <input type="text" id="txtEmpQuantity" name="txtEmpQuantity" class="form-control validate[required] text-input">
                        </div>
                    </div>
                   
                    <div class="col-md-1">
                        <span class="help-block m-b-none">סימון:</span>
                    </div>
                    <div class="col-md-4">
                        <div class="input-group ls-group-input">
                            <input type="text" id="txtRequirementAbb" name="txtRequirementAbb" class="form-control">
                        </div>
                    </div>


                     <div class="clear">
                        &nbsp;</div>

                       <div class="col-md-3">
                        <span class="help-block m-b-none">הדרכות/ע.חריגה:</span>
                    </div>
                    <div class="col-md-4">
                        <select id="ddlRequirmentType" name="ddlRequirmentType" class="form-control">
                            <option value="">-- בחר --</option>
                             <option value="1">עבודה חריגה</option>
                              <option value="2">הדרכות פנים</option>

                        </select>
                    </div>


                      <div class="col-md-1">
                        <span class="help-block m-b-none">סדר:</span>
                    </div>
                    <div class="col-md-4">
                        <div class="input-group ls-group-input">
                            <input type="text" id="txtSeq" name="txtSeq" class="form-control text-input">
                        </div>
                    </div>




                    <div class="clear">
                        &nbsp;</div>
                    <div class="col-md-3">
                        <span class="help-block m-b-none">תאריך התחלה:</span>
                    </div>
                    <div class="col-md-4">
                        <div class="input-group ls-group-input">
                            <input type="text" id="txtStartDate" name="txtStartDate" class="form-control">
                            <span class="input-group-addon spDateIcon"><i class="fa fa-calendar"></i></span>
                        </div>
                    </div>
                    <div class="col-md-1">
                        <span class="help-block m-b-none">סיום:</span>
                    </div>
                    <div class="col-md-4">
                        <div class="input-group ls-group-input">
                            <input type="text" id="txtEndDate" name="txtEndDate" class="form-control">
                            <span class="input-group-addon spDateIcon"><i class="fa fa-calendar"></i></span>
                        </div>
                    </div>
                    <div class="clear">
                        &nbsp;</div>
                  
                  
                  
                    <div class="col-md-4" style="padding-right: 35px;">
                        <label class="checkbox">
                            <input type="checkbox" id="chIsAuto" name="chIsAuto" value="1">האם שיבוץ אוטמטי?
                        </label>
                    </div>
                   
                   
                   
                    <div class="col-md-4">
                        <label class="checkbox">
                            <input type="checkbox" id="chIsMustCheck" name="chIsMustCheck" value="1">האם חובת
                            בדיקת תקינות?
                        </label>
                    </div>

                     <div class="col-md-3">
                        <label class="checkbox">
                            <input type="checkbox" id="chIsAssignAuto" name="chIsAssignAuto" value="1">ללא שיבוץ אנשים
                           
                        </label>
                    </div>


                    <div class="col-md-6">
                        &nbsp;
                    </div>
                    <div class="col-md-6" style="text-align: left">
                        <div class="btn btn-info btn-round" onclick="SaveDataTODB()">
                            <i class="glyphicon glyphicon-edit"></i>&nbsp; <span>עדכן</span>
                        </div>
                    </div>
                    </form>
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
    <div id="dvReqTemplate" style="display: none">
        <div class="col-md-3 dvRequireDetails">
            @RequirementDescTable
        </div>
        <div class="col-md-1 dvRequireDetails">
            @DayDesc
        </div>
        <div class="col-md-1 dvRequireDetails">
            @ShiftDesc
        </div>
        <div class="col-md-2 dvRequireDetailsOver" title="@QualificationDesc">
            @QualificationDesc
        </div>
       <%-- <div class="col-md-1 dvRequireDetails">
            @EmpQuantity
        </div>--%>
        <div class="col-md-1 dvRequireDetails">
            @ObligatoryAssignmentTable
        </div>
        <div class="col-md-1 dvRequireDetails">
            @ObligatoryCheckTable
        </div>

        <div class="col-md-2 dvRequireDetails">
            @Dates
        </div>
        <div class="col-md-1 dvRequireDetails">
           
            <div class="btn btn-primary btn-xs" style="width: 45%" onclick='EditRequirement("@RequirementId", "@DateTypeCode","@ShiftCode", "@QualificationCode", "@EmpQuantity","@Seq", "@RequirementDesc", "@RequirementAbb","@ObligatoryAssignment", "@ObligatoryCheck","@BeginDate", "@EndDate","@RequirementType","@IsAssignAuto")'>
                ערוך</div>
       
            <div class="btn btn-danger btn-xs" style="width: 45%" onclick='DeleteRequirement("@RequirementId")'>
               מחק</div>
        </div>




        <%--<div class="btn btn-primary btn-xs" onclick="EditRequirement('@RequirementId, '@DateTypeCode','@ShiftCode', '@QualificationCode', '@EmpQuantity', '@RequirementDesc', '@RequirementAbb','@ObligatoryAssignment', '@ObligatoryCheck','@BeginDate', '@EndDate')">
                <i class="fa fa-edit"></i>&nbsp;ערוך</div>
        --%>
    </div>
    <%-- <script src="../assets/js/pages/formValidation.js"></script>--%>
</asp:Content>
