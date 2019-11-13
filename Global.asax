<%@ Application Language="C#" %>

<script RunAt="server">

    private static CacheItemRemovedCallback OnCacheRemove = null;
    void Application_Start(object sender, EventArgs e)
    {

        // Code that runs on application startup
     //   AddTask("DoStuff", 40);
        //  AddTask("DoStuff", 43200);//12 שעות
        //    JobScheduler.Start();
    }



    private void AddTask(string name, int seconds)
    {
        OnCacheRemove = new CacheItemRemovedCallback(CacheItemRemoved);
        HttpRuntime.Cache.Insert(name, seconds, null,
            DateTime.Now.AddSeconds(seconds), Cache.NoSlidingExpiration,
            CacheItemPriority.NotRemovable, OnCacheRemove);
    }


    public void CacheItemRemoved(string k, object v, CacheItemRemovedReason r)
    {
        // do stuff here if it matches our taskname, like WebRequest
        // re-add our task so it recurs
        //  System.Data.DataTable dt = Dal.ExeSp("inserttest");

        //if (HttpContext.Current.Session["IsExist"] == null)
        //{
        //    string ff = "dffd";
        //}


        WebService SchedularU = new WebService();
        SchedularU.Control_GetAllUConnectSchedular();

        //  WebService.Control_GetAllUConnectSchedular();
        //System.Diagnostics.Debugger.Break();

        AddTask(k, Convert.ToInt32(v));
    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e)
    {



        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }

</script>
