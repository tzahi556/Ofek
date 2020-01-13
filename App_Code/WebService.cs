using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.ServiceModel.Web;
using System.Web.Script.Serialization;
using System.Collections;
using System.Text;
using System.Web.Security;
using System.Activities.Statements;

using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

/// <summary>
/// Summary description for WebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    public WebService()
    {


    }





    #region General





    [WebMethod]

    public void Gen_GetTable()
    {

        string TableName = GetParams("TableName");
        string Condition = GetParams("Condition");

        DataTable dt = Dal.ExeSp("Gen_GetTable", TableName, Condition);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }

    [WebMethod]
    public void Gen_DeleteTable()
    {
        string TableName = GetParams("TableName");
        string ColName = GetParams("ColName");
        string Val = GetParams("Val");

        DataTable dt = Dal.ExeSp("Gen_DeleteTable", TableName, ColName, Val);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }

    [WebMethod]
    public void Gen_SetTable()
    {
        string TableName = GetParams("TableName");
        string UpdateString = GetParams("UpdateString");
        string InsertValues = GetParams("InsertValues");
        string Id = GetParams("Id");
        string IdVal = GetParams("IdVal");

        DataTable dt = Dal.ExeSp("Gen_SetTable", TableName, UpdateString, InsertValues, Id, IdVal);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }


    #endregion

    #region User

    [WebMethod]
    public void User_GetUserEnter()
    {

        string UserName = GetParams("UserName");
        string Password = GetParams("Password");

        UControlAPI api = new UControlAPI();

        string sess = api.GetSessionId();

        DataTable dt = Dal.ExeSp("User_GetUserEnter", UserName, Password);


        if (dt.Rows.Count > 0)
        {
            HttpCookie cookie = new HttpCookie("UserData");
            cookie["UserId"] = dt.Rows[0]["UserId"].ToString();
            cookie["RoleId"] = dt.Rows[0]["RoleId"].ToString();
            // cookie["ConfigurationId"] = dt.Rows[0]["ConfigurationId"].ToString();
            cookie["UserName"] = Server.UrlEncode(dt.Rows[0]["UserName"].ToString());

            //School Name
            cookie["SchoolId"] = Server.UrlEncode(dt.Rows[0]["SchoolId"].ToString());
            cookie["Name"] = Server.UrlEncode(dt.Rows[0]["Name"].ToString());
            cookie["APISessionId"] = sess;


            // FormsAuthentication.RedirectFromLoginPage(dt.Rows[0]["UserName"].ToString(), true);

            cookie.Expires = DateTime.Now.AddYears(90);
            HttpContext.Current.Response.Cookies.Add(cookie);

        }

        dt.Columns.Add("APISessionId");
        dt.Rows[0]["APISessionId"] = sess;
        //  SessionOfWebTelit = sess;
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }


    #endregion

    #region Control






    [WebMethod]
    public void Control_GetUserCommandData()
    {
        UControlAPI api = new UControlAPI();
        DataTable dt = Dal.ExeSp("Control_GetUserCommandData", HttpContext.Current.Request.Cookies["UserData"]["UserId"], HttpContext.Current.Request.Cookies["UserData"]["SchoolId"]);



        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }



    [WebMethod]
    public void Control_GetUserDataByUCommand()
    {
        string UCommandId = GetParams("UCommandId");
        DataSet ds = Dal.ExeDataSetSp("Control_GetUserDataByUCommand", UCommandId);
        DataTable dtCommand = ds.Tables[0];
        DataTable dt = ds.Tables[1];



        //UControlAPI api = new UControlAPI();

        //DataTable dtResult = GetStatusObjFromTELIT(dtCommand, api, "UCommKey", true);
        //string IsConnect = dtResult.Rows[0]["IsConnect"].ToString();
        //if (IsConnect != "True")
        //{

        //    HttpContext.Current.Response.Write(ConvertDataTabletoString(dtResult));
        //    return;
        //}


       // dt = GetStatusObjFromTELIT(dt, api, "UConnKey", true);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }
    [WebMethod]
    public void Control_GetConnectLooz()
    {

        string UConnectId = GetParams("UConnectId");
        DataTable dt = Dal.ExeSp("Control_GetConnectLooz", UConnectId);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }

    [WebMethod]
    public void Control_SetConnectLooz()
    {

        string UConnectId = GetParams("UConnectId");
        string DayId = GetParams("DayId");
        string Time = GetParams("Time");
        string Status = GetParams("Status");//(GetParams("Status") == "0") ? false : true;

        DataTable dt = Dal.ExeSp("Control_SetConnectLooz", UConnectId, DayId, Time, Status);

        // Control_GetLoozForUpdateUcontrol("0", UConnectId, DayId);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }
    [WebMethod]
    public void Control_SetCopyConnectLoozToManyConnects()
    {
        string SourceId = GetParams("UConnectSourceId");
        string TargetId = GetParams("UConnectTargetId");
        DataTable dt = Dal.ExeSp("Control_SetCopyConnectLoozToManyConnects", SourceId, TargetId);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }
    [WebMethod]
    public void Control_SetUserConnectStatus()
    {

        string LoozOrTemp = GetParams("LoozOrTemp");
        string UtempStart = GetParams("UtempStart");
        string UtempEnd = GetParams("UtempEnd");
        string UConnectId = GetParams("UConnectId");


        DataTable dt = Dal.ExeSp("Control_SetUserConnectStatus", UConnectId, LoozOrTemp, UtempStart, UtempEnd);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }




    [WebMethod]
    public void Control_DeleteConnectLooz()
    {

        string UConnectLoozId = GetParams("UConnectLoozId");
        string UConnectId = GetParams("UConnectId");
        string DayId = GetParams("DayId");

        DataTable dt = Dal.ExeSp("Control_DeleteConnectLooz", UConnectLoozId);
        // Control_GetLoozForUpdateUcontrol("0", UConnectId, DayId);

        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }
    [WebMethod]
    public void Control_SetConnectAutoAction()
    {

        string UConnectId = GetParams("UConnectId");
        string UStatus = GetParams("UStatus");
        string UStaticOnHour = GetParams("UStaticOnHour");
        DataTable dt = Dal.ExeSp("Control_SetConnectAutoAction", UConnectId, UStatus, UStaticOnHour);
        SetActionTOUControl(dt, UStatus, UStaticOnHour, "");


        //if (dt.Rows[0]["UConnType"].ToString() == "2")// אם מדובר במזגן פולסים תתן עוד אחד לעורר 
        //{

        //    //Task.Delay(3000);


        //    System.Threading.Thread.Sleep(3000);


        //   // SyncMethod();

        //    SetActionTOUControl(dt, UStatus, UStaticOnHour, "");
        //}

        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }

    private async void SyncMethod()
    {
        await System.Threading.Tasks.Task.Delay(3000);
    }



    //[WebMethod]
    //public void Control_GetLoozForUpdateUcontrol(string UCommandId,string UConnectId, string DayId)
    //{

    //    //string UCommandId = GetParams("UStatus");
    //    //string UConnectId = GetParams("UConnectId");
    //   // string DayId = "2";//GetParams("UStaticOnHour");

    //    string TimeRes = "";
    //    DataTable dt = Dal.ExeSp("Control_GetLoozForUpdateUcontrol", UCommandId, UConnectId, DayId);
    //    foreach (DataRow row in dt.Rows)
    //    {
    //        int Counter = 1;
    //        TimeRes = "";
    //        string Times = row["Times"].ToString();
    //        string[] ArrayTimes = Times.Split(',');
    //        for (int i = 0; i < ArrayTimes.Length; i++)
    //        {



    //            string Time = ArrayTimes[i];
    //            if (string.IsNullOrEmpty(Time)) break;

    //            string onoff = Time.Trim().Substring(0,1);
    //            if (onoff == "1")
    //            {

    //                Time = Time.Replace(onoff + "-", "").Replace(":", "");
    //                string endTime = GetNextValue(ArrayTimes,ref i,"1");
    //                if (string.IsNullOrEmpty(endTime))
    //                {
    //                    endTime = "2400";
    //                }
    //                TimeRes += " ts" + (Counter).ToString() + "(" + Time.Trim() + ")("+ endTime + ") ";
    //                Counter++;
    //            }
    //            if (onoff == "0")
    //            {

    //                Time = Time.Replace(onoff + "-", "").Replace(":", "");

    //                TimeRes += " ts" + (Counter).ToString() + "(2400)(" + Time.Trim() + ") ";
    //                Counter++;
    //            }


    //        }

    //        for (int j = Counter; j < 11; j++)
    //        {
    //            TimeRes += " ts" + (j).ToString() + "(2400)(2400) ";
    //        }

    //        if(!string.IsNullOrEmpty(TimeRes))
    //        row["Times"] = " rlytmsupdate wd("+ DayId + ",)" +  TimeRes;

    //    }

    //    SetActionTOUControl(dt, "20", "", "Times");
    //    HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    //}

    private string GetNextValue(string[] arrayTimes, ref int i, string onoff)
    {

        for (int j = i; j < arrayTimes.Length; j++)
        {
            string Time = arrayTimes[j];
            string onofftime = Time.Trim().Substring(0, 1);
            if (onoff == "1" && onofftime == "0")
            {
                i = j;
                return (Time.Replace(onofftime + "-", "").Replace(":", "")).Trim();

            }

            //if (onoff == "0" && onofftime == "0")
            //{
            //    i = j;
            //    return Time.Replace(onofftime + "-", "").Replace(":", "");

            //}

        }


        return "";

    }

    // [WebMethod]


    public static string SessionOfWebTelit = "";

    [WebMethod]
    public void Control_GetAllUConnectSchedular()
    {
        try
        {
            DataTable dt = Dal.ExeSp("Control_GetAllUConnectSchedular");
            if (dt.Rows.Count > 0)
            {
                UControlAPI api = new UControlAPI();

                DataTable UDepDataTable = new DataTable();
                // בדיקה אם יש תלויים כגון חיישן
                var UDepDataRows = dt.Select("UConnIdDep is not null");
                if (UDepDataRows.Length != 0)
                {

                    UDepDataTable = UDepDataRows.CopyToDataTable();

                    GetStateObjFromTELIT(UDepDataTable, api, "UConnKeyDep"); // כגון dig_226


                    for (int i = 0; i < UDepDataTable.Rows.Count; i++)
                    {
                        string val = UDepDataTable.Rows[i]["Value"].ToString();//  ערך מהיחידה המקושרת כגון טמפ
                                                                               // חיישן אקבל כאן 0 או 1
                                                                               // טמפרטורה אקבל כאן 19.2

                        string status = UDepDataTable.Rows[i]["status"].ToString();// המצב המבוקש מדטהבייס
                        string UConnectId = UDepDataTable.Rows[i]["UConnectId"].ToString();
                        string LastStatus = UDepDataTable.Rows[i]["LastStatus"].ToString();
                        string UConnType = UDepDataTable.Rows[i]["UConnType"].ToString();// סוג יחידה מתח או מזגן פולסים
                        string UConnTypeDep = UDepDataTable.Rows[i]["UConnTypeDep"].ToString();// חיישן 4 טמפ 3
                        string UtempStart = UDepDataTable.Rows[i]["UtempStart"].ToString();
                        string UtempEnd = UDepDataTable.Rows[i]["UtempEnd"].ToString();



                        if (status == "1")// חסר לבדוק מצב מזגן
                        {
                            // במידה ומדובר בחיישן והערך נשאר כמקודם אל תעשה שום פקודה 
                            // אם מדובר בטמפרטורה תבדוק אם זה בטווח
                            if (
                                (UConnTypeDep == "4" && val == LastStatus)
                                ||
                                (UConnTypeDep == "3" && IsValTempOutRange(val, UtempStart, UtempEnd))
                                )
                            {
                                var rows = dt.Select("UConnectId = " + UConnectId);
                                rows[0].Delete();
                                dt.AcceptChanges();
                            }
                            else
                            {
                                Dal.ExeSp("Control_UpdateStatus", UConnectId, "1");

                            }

                        }
                        else
                        {

                            Dal.ExeSp("Control_UpdateStatus", UConnectId, "0");

                        }


                    }
                }// end UDepDataTable





                string resp = SetActionTOUControl(dt, "", "", "Action", "1");

                if (resp.Contains("Authentication session is invalid"))
                {

                    SessionOfWebTelit = api.GetSessionId();

                    SetActionTOUControl(dt, "", "", "Action", "1");

                }

                //// את המתאמים שידרתי והערתי את הבקר , עכשיו לעשות עוד פקודה
                //UDepDataRows = UDepDataTable.Select("UConnType=2"); // אך ורק מזגן פולסים
                //if (UDepDataRows.Count() > 0)
                //{
                //    //המתנה 3 שניות אחרי שעוררתי את היחידה
                //    System.Threading.Thread.Sleep(3000);
                //    resp = SetActionTOUControl(UDepDataRows.CopyToDataTable(), "", "", "Action", "1");
                //}
            }
        }
        catch (Exception ex)
        {


        }
    }

    private bool IsValTempOutRange(string val, string utempStart, string utempEnd)
    {
        float valF = ConvertStrToFloat(val);
        float utempStartF = ConvertStrToFloat(utempStart);
        float utempEndF = ConvertStrToFloat(utempEnd);

        if (valF > utempEndF || valF < utempStartF)
            return true;
        return false;

    }

    private DataTable GetStateObjFromTELIT(DataTable dt, UControlAPI api, string ColName)
    {

        dt.Columns.Add("Value");


        try
        {
            JToken token;
            dynamic Json;
            string resp = "";


            Json = new JObject();
            Json.auth = new JObject(new JProperty("sessionId", HttpContext.Current.Request.Cookies["UserData"]["APISessionId"].ToString()));

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                Json.Add((i + 1).ToString(), (new JObject(new JProperty("command", "thing.find"),
                       new JProperty("params", new JObject(new JProperty("key", dt.Rows[i][ColName].ToString()))))));
            }

            resp = api.TelitAPI(Json.ToString());
            token = JObject.Parse(resp);
            string Value = "";
            for (int i = 1; i <= token.Count(); i++)
            {

                string connType = dt.Rows[i - 1]["UConnTypeDep"].ToString();

                // אם מדובר בחיישן
                //   if (connType == "4")
                //     Value = (string)token[i.ToString()].SelectToken("params.alarms.alarm.state");

                // אם מדובר בטמפרטורה
                // if (connType == "3")
                Value = (string)token[i.ToString()].SelectToken("params.properties.status.value");

                dt.Rows[i - 1]["Value"] = Value;

            }

        }
        catch (Exception ex)
        {

        }

        return dt;
    }

    public string SetActionTOUControl(DataTable dt, string uStatus, string uStaticOnHour, string FieldNameForAction, string se = "0")
    {
        string Action = "";

        string Pulses = "200";

        switch (uStatus)
        {
            case "1":
                if (string.IsNullOrEmpty(uStaticOnHour) || uStaticOnHour == "0")
                {
                    //אם מדובר המזגן העובד לפי פולסים
                    if (dt.Rows[0]["UConnType"].ToString() == "2")
                    {
                        Action = "rlyoutcngopen drnplsms(" + Pulses + ")";

                    }
                    else
                    {
                        Action = "rlyoutcngopen fixed";
                    }
                }
                else
                {
                    //אם מדובר המזגן העובד לפי פולסים
                    if (dt.Rows[0]["UConnType"].ToString() == "2")
                    {
                        Action = "rlyoutcngopen drnplsms(" + Pulses + ")";
                    }
                    else
                    {
                        int SecOpen = Convert.ToInt32(uStaticOnHour) * 3600;
                        Action = "rlyoutcngopen drnplss(" + SecOpen.ToString() + ")";
                    }
                }

                break;
            case "0":
                //אם מדובר המזגן העובד לפי פולסים
                if (dt.Rows[0]["UConnType"].ToString() == "2")
                {
                    Action = "rlyoutcngopen drnplsms(" + Pulses + ")";
                }
                else
                {
                    Action = "rlyoutcngclose fixed";
                }
                break;

            case "2":
                return "0";//Action = "rlyoutcngclose fixed";
                           // break;
        }

        UControlAPI api = new UControlAPI();


        JToken token;
        dynamic Json;
        string resp = "";



        Json = new JObject();

        if (se == "0")
        {
            Json.auth = new JObject(new JProperty("sessionId", HttpContext.Current.Request.Cookies["UserData"]["APISessionId"].ToString()));
        }
        else
        {
            Json.auth = new JObject(new JProperty("sessionId", SessionOfWebTelit));

        }



        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (!string.IsNullOrEmpty(FieldNameForAction))
            {

                Action = dt.Rows[i][FieldNameForAction].ToString();
                if (string.IsNullOrEmpty(Action))
                {
                    break;

                }

            }


            Json.Add((i + 1).ToString(), (new JObject(new JProperty("command", "method.exec"),
                     new JProperty("params", new JObject(new JProperty("thingKey", dt.Rows[i]["UCommKey"].ToString()),
                                                new JProperty("method", "ctu"),
                                                 new JProperty("params",
                                                 new JObject(
                                                     new JProperty("ctu", "id(" + dt.Rows[i]["UConnId"].ToString() + ")" + Action)
                                                     )
                                                 )
                                                )))));
        }

        resp = api.TelitAPI(Json.ToString());

        return resp;

    }

    private bool ConvertStrToInt(string uStaticOnHour)
    {
        int number;

        bool result = Int32.TryParse(uStaticOnHour, out number);
        if (result)
        {
            return true;
        }

        return false;
    }

    private float ConvertStrToFloat(string Value)
    {
        float number;

        bool result = float.TryParse(Value, out number);
        if (result)
        {
            return number;
        }

        return 0;
    }


    [WebMethod]
    public void Control_SetCopyConnectLooz()
    {
        string UConnectId = GetParams("UConnectId");
        string UConnectSourceId = GetParams("UConnectSourceId");
        string UConnectTargetId = GetParams("UConnectTargetId");
        string Type = GetParams("Type");



        DataTable dt = Dal.ExeSp("Control_SetCopyConnectLooz", UConnectId, UConnectSourceId, UConnectTargetId, Type);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }



    #endregion

    #region Admin
    [WebMethod]
    public void Admin_SetSchoolIdToSession()
    {

        string SchoolId = GetParams("SchoolId");
        string SchoolName = GetParams("SchoolName");

        HttpCookie cookie = null;
        if (HttpContext.Current.Request.Cookies["UserData"] != null)
        {
            cookie = HttpContext.Current.Request.Cookies["UserData"];
            cookie["SchoolId"] = SchoolId;
            cookie["Name"] = Server.UrlEncode(SchoolName);
        }

        

        cookie.Expires = DateTime.Now.AddYears(90);
        HttpContext.Current.Response.Cookies.Add(cookie);
        // cookie["SchoolId"] = SchoolId;

    }
    [WebMethod]
    public void Admin_UpdateTempByConnectId()
    {
        string UConnectId = GetParams("UConnectId");
        string value = GetParams("val");
        DataTable dt = Dal.ExeSp("Admin_UpdateTempByConnectId", UConnectId, value);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }
    [WebMethod]
    public void Admin_SetSchool()
    {

        string SchoolId = GetParams("SchoolId");
        string SchoolName = GetParams("SchoolName");
        string Type = GetParams("Type");

        DataTable dt = Dal.ExeSp("Admin_SetSchool", SchoolId, SchoolName, Type);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }

    [WebMethod]
    public void Admin_GetUCommandBySchoolId()
    {




        DataTable dt = Dal.ExeSp("Admin_GetUCommandBySchoolId", HttpContext.Current.Request.Cookies["UserData"]["SchoolId"].ToString());
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }

    [WebMethod]
    public void Admin_GetUserForSchool()
    {




        DataTable dt = Dal.ExeSp("Admin_GetUserForSchool", HttpContext.Current.Request.Cookies["UserData"]["SchoolId"].ToString());
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }

    [WebMethod]
    public void Admin_SetUsers()
    {

        string FirstName = GetParams("FirstName");
        string LastName = GetParams("LastName");
        string UserName = GetParams("UserName");
        string Password = GetParams("Password");
        string UCommands = GetParams("UCommands");
        string UserId = GetParams("UserId");

        DataTable dt = Dal.ExeSp("Admin_SetUsers", UserId, FirstName, LastName, UserName, Password, UCommands, HttpContext.Current.Request.Cookies["UserData"]["SchoolId"].ToString());
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }

    [WebMethod]
    public void Admin_DeleteUser()
    {


        string UserId = GetParams("UserId");

        DataTable dt = Dal.ExeSp("Admin_DeleteUser", UserId);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }

    [WebMethod]
    public void Admin_SetUCommand()
    {


        string UCommandId = GetParams("UCommandId");
        string UCommIP = GetParams("UCommIP");
        string UCommPORT = GetParams("UCommPORT");
        string UCommandName = GetParams("UCommandName");
       


        DataTable dt = Dal.ExeSp("Admin_SetUCommand", UCommandId, UCommandName, UCommIP, UCommPORT, HttpContext.Current.Request.Cookies["UserData"]["SchoolId"].ToString());
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }
    [WebMethod]
    public void Admin_GetUConnectsBySchoolId()
    {

        string SchoolId = GetParams("SchoolId");

        DataTable dt = Dal.ExeSp("Admin_GetUConnectsBySchoolId", SchoolId);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
    }

    [WebMethod]
    public void Admin_GetUTempConnect()
    {

        string UCommandId = GetParams("UCommandId");

        DataTable dt = Dal.ExeSp("Admin_GetUTempConnect", UCommandId, HttpContext.Current.Request.Cookies["UserData"]["SchoolId"].ToString());
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }

    [WebMethod]
    public void Admin_UCommandRegister()
    {


        string UCommandId = GetParams("UCommandId");
        string Startrigster = GetParams("Startrigster");
        string Jump = GetParams("Jump");
        string Type = GetParams("Type");
       
        // 1 יצירה 
        // 2 מחיקה
        // גרוטקס השקעות

        DataTable dt = Dal.ExeSp("Admin_UCommandRegister", UCommandId, Type, Startrigster, Jump);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }





   // Ajax("Admin_UCommandRegister", "UCommandId=" + SelectedUCommandId + "&Startrigster=&Jump=&Type=2");


    [WebMethod]
    public void Admin_GetCategoryAndConnectByCommand()
    {

        UControlAPI api = new UControlAPI();


        string UCommandId = GetParams("UCommandId");
        bool IsOnline = true;//GetBoolParams("IsOnline");

        DataSet ds = Dal.ExeDataSetSp("Admin_GetCategoryAndConnectByCommand", UCommandId);

        try
        {

            DataTable dtCommand = ds.Tables[0];
            DataTable dt = ds.Tables[1];

            if (IsOnline)
            {

                DataTable dtResult = GetStatusObjFromTELIT(dtCommand, api, "UCommKey", IsOnline);
                string IsConnect = dtResult.Rows[0]["IsConnect"].ToString();
                if (IsConnect != "True" && IsOnline)
                {

                    HttpContext.Current.Response.Write(ConvertDataTabletoString(dtResult));
                    return;
                }

                dt = GetStatusObjFromTELIT(dt, api, "UConnKey", IsOnline);


            }
            HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));
        }
        catch (Exception ex)
        {



        }

    }


    //id(8) rlyoutcngopen drnplss(10)
    private DataTable GetStatusObjFromTELIT(DataTable dt, UControlAPI api, string ColName, bool IsOnline)
    {
        dt.Columns.Add("IsConnect");
        dt.Columns.Add("Value");


        try
        {

            //JToken token;
            //dynamic Json;
            //string resp = "";


            //Json = new JObject();
            //Json.auth = new JObject(new JProperty("sessionId", HttpContext.Current.Request.Cookies["UserData"]["APISessionId"].ToString()));

            //for (int i = 0; i < dt.Rows.Count; i++)
            //{
            //    Json.Add((i + 1).ToString(), (new JObject(new JProperty("command", "thing.find"),
            //           new JProperty("params", new JObject(new JProperty("key", dt.Rows[i][ColName].ToString()))))));
            //}

            //resp = api.TelitAPI(Json.ToString());
            //token = JObject.Parse(resp);

            for (int i = 1; i <= dt.Rows.Count; i++)
            {
                string Value = "";
                string IsConnect = "True";//(string)token[i.ToString()].SelectToken("..connected");

                if (IsOnline && ColName != "UCommKey")
                {
                    Value = "36";//(string)token[i.ToString()].SelectToken("params.properties.status.value");
                }

                dt.Rows[i - 1]["Value"] = (Value == null) ? "" : Value;
                dt.Rows[i - 1]["IsConnect"] = (IsConnect == null) ? "False" : IsConnect;

            }

        }
        catch (Exception ex)
        {

            dt.Rows[0]["IsConnect"] = "sessFalse";

        }

        return dt;
    }


    [WebMethod]
    public void Admin_SetUCategory()
    {


        string UCategoryId = GetParams("UCategoryId");
        string UCommandId = GetParams("UCommandId");
        string UCategoryName = GetParams("UCategoryName");
        string UCategorySeq = GetParams("UCategorySeq");



        DataTable dt = Dal.ExeSp("Admin_SetUCategory", UCategoryId, UCommandId, UCategoryName, UCategorySeq);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }

    [WebMethod]
    public void Admin_SetUConnect()
    {

        
        string UCategoryId = GetParams("UCategoryId");
        string UConnectId = GetParams("UConnectId");


        string UConnectName = GetParams("UConnectName");

        string UStartRigster = GetParams("UStartRigster");
        string UEndRigster = GetParams("UEndRigster");

        string UTempRigester = GetParams("UTempRigester");
        string UConnectSeq = GetParams("UConnectSeq");

        string UConnType = GetParams("UConnType");
       
       //string URlyConnectId = GetParams("URlyConnectId");


        // אם נצירת שבת אין מה לגשת לטליט זה וירטואלי
        //if (UConnType != "5")
        //{
        //    DataTable dtAction = GetDataTableWithAction(UCommKey, UConnId, UConnType);
        //    string res = SetActionTOUControl(dtAction, "", "", "Action");
        //    if (!res.Contains("true"))
        //    {

        //        HttpContext.Current.Response.Write(BuildDataTableForRes("false"));
        //        return;
        //    }

        //}


        DataTable dt = Dal.ExeSp("Admin_SetUConnect", UCategoryId, UConnectId, UConnectName, UEndRigster,
            UConnectSeq, UStartRigster, UConnType, UTempRigester
           );




        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }

    [WebMethod]
    public void Admin_GetUConnectStartEndRegister()
    {


      
        string UCommandId = GetParams("UCommandId");
     


        DataTable dt = Dal.ExeSp("Admin_GetUConnectStartEndRegister", UCommandId);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }


    

    private string BuildDataTableForRes(string resVal)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("res");
        DataRow dr = dt.NewRow();
        dr["res"] = resVal;

        dt.Rows.Add(dr);

        return ConvertDataTabletoString(dt);


    }

    private DataTable GetDataTableWithAction(string uCommKey, string uConnId, string uConnType)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("UCommKey");
        dt.Columns.Add("UConnId");
        dt.Columns.Add("Action");

        DataRow dr = dt.NewRow();

        dr["UCommKey"] = uCommKey;
        dr["UConnId"] = uConnId;


        // אם זה מתח או שמא מזגן פולסים
        if (uConnType == "1" || uConnType == "2")
        {
            dr["Action"] = " rlyprg workmode(4) defout(c)";
            dt.Rows.Add(dr);


            DataRow dr2 = dt.NewRow();

            dr2["UCommKey"] = uCommKey;
            dr2["UConnId"] = uConnId;

            dr2["Action"] = " rlytmsupdate wd(1, 2, 3, 4, 5, 6, 7,) ts1(2400)(2400) ts1(2400)(2400) ts2(2400)(2400) ts3(2400)(2400)"
                        + " ts4(2400)(2400) ts5(2400)(2400) ts6(2400)(2400) ts7(2400)(2400) ts8(2400)(2400) ts9(2400)(2400) ts10(2400)(2400)";

            dt.Rows.Add(dr2);
        }
        // טמפרטורה
        if (uConnType == "3")
        {

            dr["Action"] = " angintprg lgc(o) spmin(20) spmax(25) hys(0.5)  samf(5) timep(10)";
            dt.Rows.Add(dr);

        }

        // חיישן
        if (uConnType == "4")
        {

            dr["Action"] = " digprg workmode(2) inn(1) cnt(3) tml(22) tba(250) timpeen(e) timep(10)";
            dt.Rows.Add(dr);

        }


        return dt;


    }

    [WebMethod]
    public void Admin_DeleteUCategory()
    {

        string UCategoryId = GetParams("UCategoryId");

        DataTable dt = Dal.ExeSp("Admin_DeleteUCategory", UCategoryId);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }
    [WebMethod]
    public void Admin_DeleteUCommand()
    {


        string UCommandId = GetParams("UCommandId");

        DataTable dt = Dal.ExeSp("Admin_DeleteUCommand", UCommandId);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }
    [WebMethod]
    public void Admin_DeleteUConnect()
    {

        string UConnectId = GetParams("UConnectId");
        DataTable dt = Dal.ExeSp("Admin_DeleteUConnect", UConnectId);
        HttpContext.Current.Response.Write(ConvertDataTabletoString(dt));

    }


    #endregion

    private bool GetParamsIfExist(string Param)
    {
        try
        {
            HttpContext.Current.Request.Form[Param].ToString();
            return true;

        }
        catch (Exception ex)
        {


            return false;
        }
    }

    private bool GetBoolParams(string Param)
    {
        try
        {
            return Convert.ToBoolean(HttpContext.Current.Request.Form[Param].ToString());


        }
        catch (Exception ex)
        {


            return false;
        }
    }



    private string GetParamsValueIfExist(string Param)
    {
        try
        {

            return HttpContext.Current.Request.Form[Param].ToString();

        }
        catch (Exception ex)
        {


            return "";
        }
    }

    private string GetParams(string Param)
    {
        return HttpContext.Current.Request.Form[Param].ToString();
    }

    public static string ConvertDataTabletoString(DataTable dt)
    {


        System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
        Dictionary<string, object> row;
        foreach (DataRow dr in dt.Rows)
        {
            row = new Dictionary<string, object>();
            foreach (DataColumn col in dt.Columns)
            {
                row.Add(col.ColumnName, dr[col]);
            }
            rows.Add(row);
        }
        return serializer.Serialize(rows);

    }

}



//Json = new JObject();
//Json.auth = new JObject(new JProperty("sessionId", HttpContext.Current.Request.Cookies["UserData"]["APISessionId"].ToString()));
//Json.Add("1", (new JObject(new JProperty("command", "thing.find"),
//       new JProperty("params", new JObject(new JProperty("key", UCommKey))))));

//resp = api.TelitAPI(Json.ToString());
//token = JObject.Parse(resp);

//string IsConnect = (string)token.SelectToken("..connected");

//if (IsConnect != "True")
//{
//    dtCommand.Rows[0]["UCommandStatus"] = "false";
//    HttpContext.Current.Response.Write(ConvertDataTabletoString(dtCommand));
//    return;
//}
// }
//************************* 
//Json = new JObject();
//Json.auth = new JObject(new JProperty("sessionId", HttpContext.Current.Request.Cookies["UserData"]["APISessionId"].ToString()));

//for (int i = 0; i < dt.Rows.Count; i++)
//{
//    Json.Add((i + 1).ToString(), (new JObject(new JProperty("command", "alarm.current"),
//    new JProperty("params", new JObject(new JProperty("thingKey", dt.Rows[i]["UConnThingKey"].ToString()), 
//    new JProperty("key", "alarm"))))));
//}

//resp = api.TelitAPI(Json.ToString());
//token = JObject.Parse(resp);

//for (int i = 1; i <= token.Count(); i++)
//{
//    string res = (string)token[i.ToString()].SelectToken("..state");

//    dt.Rows[i - 1]["APIStatus"] = (res == null) ? "" : res;

//}