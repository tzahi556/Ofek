using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;


/// <summary>
/// Summary description for UControlAPI
/// </summary>
public class UControlAPI
{
    public UControlAPI()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public string GetSessionId()
    {

        try
        {

            var json = //new JArray(
                    new JObject(
                        //  new JProperty("name", "student1"),
                        new JProperty("auth",
                                //   new JArray(
                                new JObject(
                                    new JProperty("command", "api.authenticate"),
                                    new JProperty("params",
                                            //   new JArray(
                                            new JObject(
                                                new JProperty("username", "tzahi556@gmail.com"),
                                                new JProperty("password", "jadekia556@")
                                                )
                                        //   )
                                        )

                                )
                            )
                    // )
                    //)
                    );


            string responseData = TelitAPI(json.ToString());

            JToken token = JObject.Parse(responseData);

            string sessionId = (string)token.SelectToken("auth.params.sessionId");

            return sessionId;

        }
        catch (Exception ex)
        {

            return "";
        }

    }

    public string TelitAPI(string Json)
    {

        try
        {

            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create("https://api.devicewise.com/api");
            string postString = Json.ToString();//"{\"auth\":{\"command\":\"api.authenticate\",\"params\":{\"username\":\"tzahi556@gmail.com\",\"password\":\"jadekia556@\"}}}";

            System.Net.ServicePointManager.Expect100Continue = false;
            CookieContainer cookies = new CookieContainer();
            webRequest.Method = "POST";
            webRequest.CookieContainer = cookies;
            webRequest.ContentLength = postString.Length;
            webRequest.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8";

            StreamWriter requestWriter = new StreamWriter(webRequest.GetRequestStream());
            requestWriter.Write(postString);
            requestWriter.Close();

            StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());
            string responseData = responseReader.ReadToEnd();

            responseReader.Close();
            webRequest.GetResponse().Close();


            return responseData;

        }
        catch (Exception ex)
        {
            return "";


        }

    }

    public string IsSessionExist(string sess)
    {


        try
        {


            JToken token;
            dynamic Json;
            string resp = "";


            Json = new JObject();
            Json.auth = new JObject(new JProperty("sessionId", sess));
            Json.Add("1", (new JObject(new JProperty("command", "thing.find"),
                       new JProperty("params", new JObject(new JProperty("key", "9"))))));
           

            resp = this.TelitAPI(Json.ToString());
            token = JObject.Parse(resp);

            //for (int i = 1; i <= token.Count(); i++)
            //{
            //    //string Value = "";
            //    //string IsConnect = (string)token[i.ToString()].SelectToken("..connected");

            //    //if (IsOnline && ColName != "UCommKey")
            //    //{
            //    //    Value = (string)token[i.ToString()].SelectToken("params.properties.status.value");
            //    //}

            //    //dt.Rows[i - 1]["Value"] = (Value == null) ? "" : Value;
            //    //dt.Rows[i - 1]["IsConnect"] = (IsConnect == null) ? "False" : IsConnect;

            //}
            return resp;
        }
        catch (Exception ex)
        {

            return "0";

        }




    }
}


//{
//    "1": {
//        "command" : "session.find",
//        "params" : {
//            "id": "112233445566778899"
//        }
//    }
//}
