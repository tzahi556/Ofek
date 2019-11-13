<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!-- Viewport metatags -->
    <meta name="HandheldFriendly" content="true" />
    <meta name="MobileOptimized" content="320" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <!-- iOS webapp metatags -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <!-- iOS webapp icons -->
    <link rel="apple-touch-icon-precomposed" href="assets/images/ios/fickle-logo-72.png" />
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/images/ios/fickle-logo-72.png" />
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/images/ios/fickle-logo-114.png" />
    <!-- TODO: Add a favicon -->
    <link rel="shortcut icon" href="assets/images/ico/fab.ico">
    <title>מערכת אופק -לוגין</title>
    <!--Page loading plugin Start -->
    <link rel="stylesheet" href="assets/css/rtl-css/plugins/pace-rtl.css">
    <script src="assets/js/pace.min.js"></script>

   
   
    <script src="assets/js/lib/jquery-1.11.min.js" type="text/javascript"></script>
    
 



    <!-- Page loading plugin End -->
    <!-- Plugin Css Put Here -->
    <link href="assets/css/bootstrap-rtl.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/plugins/bootstrap-switch.min.css">
    <link rel="stylesheet" href="assets/css/plugins/ladda-themeless.min.css">
    <link href="assets/css/plugins/humane_themes/bigbox.css" rel="stylesheet">
    <link href="assets/css/plugins/humane_themes/libnotify.css" rel="stylesheet">
    <link href="assets/css/plugins/humane_themes/jackedup.css" rel="stylesheet">
    <!-- Plugin Css End -->
    <!-- Custom styles Style -->
    <link href="assets/css/rtl-css/style-rtl.css" rel="stylesheet">
    <!-- Custom styles Style End-->
    <!-- Responsive Style For-->
    <link href="assets/css/rtl-css/responsive-rtl.css" rel="stylesheet">
 
    <script type="text/javascript">

        var OrgUnitCode = "";

        $(document).ready(function () {



        });




        function LogMeIn() {

            var Password = $("#txtPassword").val();
            var UserName = $("#txtUserName").val();
            var data = Ajax("User_GetUserEnter", "UserName=" + UserName + "&Password=" + Password);
           

            if (data[0]) {

                if (data[0].APISessionId == "") {

                    $("#spEnterAlert").text("בעית תקשורת, אנא פנה למנהל מערכת");
                    $("#spEnterAlert").show();
                    return;

                }

                
                if (data[0].RoleId=="1")
                    location.href = "ControlAdmin/School.aspx";
                if (data[0].RoleId == "2")
                    location.href = "Control/Dashboard.aspx";
            }



            else {

                $("#spEnterAlert").show();

            }

        }



        function Ajax(sp, params) {
            var json = "";
            $.ajax({
                type: "POST",
                url: "WebService.asmx/" + sp,

                data: params,
                async: false,
                dataType: "json",
                success: function (data) {

                    json = data;
                },

                error: function (request, status, error) {
                    json = (error);
                }

            });
            return json;

        }





        //         function setCookie(cname, cvalue, exminutes) {
        //             var d = new Date();
        //             d.setTime(d.getTime() + (exminutes * 24 * 60 * 60 * 1000));
        //             var expires = "expires=" + d.toUTCString();
        //             document.cookie = cname + "=" + cvalue + "; " + expires;
        //         }


    </script>



</head>
<body class="login-screen">
    <section>
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-12">
                    <div class="login-box" style="background:white">
                        <div class="login-content">
                            <!--  <div class="login-user-icon">-->
                            <!-- <i class="glyphicon glyphicon-user"></i>-->
                            <img src="assets/images/logo.png" height="100px" />
                            <!--</div>-->                            
                            <h3>
                                אופק- מערכת ניהול חשמל </h3>
                        </div>
                        <div class="login-form">
                            <form id="form-login" action="#" class="form-horizontal ls_form">
                            <div class="input-group ls-group-input">
                                <input class="form-control" type="text" id="txtUserName" placeholder="שם משתמש">
                                <span class="input-group-addon"><i class="fa fa-user"></i></span>
                            </div>
                            <div class="input-group ls-group-input">
                                <input type="password" placeholder="סיסמא" id="txtPassword" name="password" class="form-control" value="">
                                <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                            </div>
                           
                            <div class="input-group ls-group-input login-btn-box">
                                <div class="btn ls-dark-btn ladda-button col-md-12 col-sm-12 col-xs-12" onclick="LogMeIn();" data-style="slide-down">
                                    <span class="ladda-label"><i class="fa fa-key"></i> הכנס</span>
                                </div>
                              
                            </div>



                              <span id="spEnterAlert" style="color:red;font-weight:bold;display:none">שם משתמש או סיסמא שגויים</span>



                            </form>
                        </div>
                   
                    </div>
                </div>
            </div>
            <p class="copy-right big-screen hidden-xs hidden-sm">
                <span>&#169;</span> שילה התוכנות <span class="footer-year">2016</span>
            </p>
         </div>

    </section>
</body>
</html>
