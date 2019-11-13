<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true"
    CodeFile="TeacherClass.aspx.cs" Inherits="Config_TeacherClass" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
  
    <script type="text/javascript">

        var mydata;


        $(document).ready(function () {

            mydata = Ajax("Gen_GetTable", "TableName=SchoolHours&Condition=ConfigurationId=" + ConfigurationId);
            InitSelectableNGN(mydata, "HourId");

        });


        function SaveData() {

            Ajax("School_UpdateConfigHours", "Hours=" + arr);
            bootbox.alert("המידע נשמר בהצלחה");

        }

     

      



    </script>
</asp:Content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="Server">
   

     <div class="col-md-12">
        <div class="row dvWeek">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        &nbsp;הגדרת שעות פרונטלי 
                    </h3>
                </div>
                <div class="panel-body">
                 <div class="col-md-3">
                       
                        <div class="input-group ls-group-input">
                         <span class="input-group-addon spDateIcon"> שעות פרונטליות</span>
                            <input type="text" id="txtFrontali" class="form-control">
                           
                        </div>
                    </div>
                
                </div>
                 </div>
        </div>
    </div>

</asp:content>
