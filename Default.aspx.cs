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

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        UControlAPI api = new UControlAPI();

        string sess = api.GetSessionId();



        // הדלקה כרגע
        dynamic Json = new JObject();
        Json.auth = new JObject(new JProperty("sessionId", sess));
        Json.Add("1", (new JObject(new JProperty("command", "method.exec"),
            new JProperty("params", new JObject(new JProperty("thingKey", "899720203753622046"),
                                                new JProperty("method", "ctu"),
                                                 new JProperty("params",

                                                 new JObject(

                                                     new JProperty("ctu", "id(8) rlyoutcngopen drnplss(10)")
                                                     )
                                                 )
                                                )))));


        //id(8) rlyoutcngopen drnplss(10)

        //string resp = api.TelitAPI(Json.ToString());


        //// הדלקה כרגע
        //dynamic Json = new JObject();
        //Json.auth = new JObject(new JProperty("sessionId", sess));
        //Json.Add("1", (new JObject(new JProperty("command", "alarm.publish"),
        //    new JProperty("params", new JObject(new JProperty("thingKey", "rly_22"),
        //                                        new JProperty("key", "alarm"),
        //                                          new JProperty("state", "1")
        //                                        )))));

        //string resp = api.TelitAPI(Json.ToString());

        // קריאת מצב נתון

        //dynamic Json = new JObject();
        //Json.auth = new JObject(new JProperty("sessionId", sess));

        //for (int i = 0; i < 3; i++)
        //{
        //    Json.Add(i.ToString(), (new JObject(new JProperty("command", "alarm.current"),
        //    new JProperty("params", new JObject(new JProperty("thingKey", "rly_2" + i.ToString()), new JProperty("key", "alarm"))))));

        //}





        string resp = api.TelitAPI(Json.ToString());
        JToken token = JObject.Parse(resp);

        foreach (var item in token)
        {
            string res = (string)item.SelectToken("..state");
        }

      

        //   string json = "{\"auth\":{\"sessionId\":\"584542d93447634334324f45\"},\"1\":{\"command\":\"alarm.current\",\"params\":{\"thingKey\":\"rly_22\",\"key\":\"alarm\"}}}";
    }


    private void ConvertJsonStringToObject(string responseData)
    {
        //  JavaScriptSerializer serializer = new JavaScriptSerializer();
        //  dynamic d = serializer.Deserialize(responseData, typeof(object));
        JToken token = JObject.Parse(responseData);


        string sessionId = (string)token.SelectToken("auth.params.sessionId");



        //  var json_serializer = new JavaScriptSerializer();
        // var AuthObj = Newtonsoft.JsonConvert.DeserializeObject<List<Auth.RootObject>>(responseData);


    }
}

// {"auth":{"success":true,"params":{"orgKey":"UCONTROLWIRELESS1","sessionId":"5843e341435566765753626c"}}}
