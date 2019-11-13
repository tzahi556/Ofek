using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;

/// <summary>
/// Summary description for SendEmail
/// </summary>
public static class SendEmail
{
    //public SendEmail()
    //{
    //    //
    //    // TODO: Add constructor logic here
    //    //
    //}


    public static void SendEmailExecute(string Area,string WorkerName, string ShiftCode,string Date,
        string Creator, string Reason, string Comment, string AddEmail1, string AddEmail2, string OrgUnitCode)
    {
        SmtpClient SmtpServer = new SmtpClient();
        MailMessage actMSG = new MailMessage();
        SmtpServer.Host = "EX-ASHDOD.paz.local";
        SmtpServer.Port = 25;
        SmtpServer.UseDefaultCredentials = false;

        string mail_user = "wrk_mirkam";
        string mail_pass = "mp123$";
        string ManagerName = "";

        SmtpServer.Credentials = new System.Net.NetworkCredential(mail_user, mail_pass);


        actMSG.IsBodyHtml = true;



        actMSG.Subject = "קריאה מיוחדת - " + Area + " - " + WorkerName;
        actMSG.Body = String.Format("{0}", "<div  style='direction:rtl; font-family: Arial, Helvetica, sans-serif;'>"
                                            + " שלום רב, " + ManagerName + "<br>"
                                           // + "היום הגיע תאריך סיום משוער למעקף שהגדרת בתאריך - <b>" + WriteDate + "</b><br><br>"
                                            + "<b><u> להלן פרטי קריאה מיוחדת: </u></b><br><br>"

                                            + "<b>תאריך: </b>" + Date + "<br>" 
                                            + "<b>אזור: </b>" + Area + "<br>"
                                            + "<b>משמרת: </b>" + ShiftCode + "<br>"
                                            + "<b>שם עובד: </b>" + WorkerName + "<br>"
                                            + "<b>יוזם: </b>" + Creator + "<br>"
                                            + "<b>סיבה: </b>" + Reason + "<br>"
                                            
                                            + "<b>הערות: </b>" + Comment + "<br><br>"
                                            + "<font style='color:red;'>מייל זה הינו אוטמטי ולא ניתן להשבה!</font>"
                                            + "</div><br>");

      
       
        actMSG.To.Add("hzachiel@pazar.co.il");
        
        actMSG.To.Add("eavivit@pazar.co.il");



        // *********************** פרודקשן *****************
        
        //actMSG.To.Add("Mavner@pazar.co.il");
        
        //// אזורים ללא תומר
        //if (OrgUnitCode != "20000011" && OrgUnitCode !="20000016" && OrgUnitCode !="20000017")  
        //{
        //    actMSG.To.Add("mtomer@pazar.co.il");

        //}


        //if (!string.IsNullOrEmpty(AddEmail1))
        //{
        //    actMSG.To.Add(AddEmail1);
        //}


        //if (!string.IsNullOrEmpty(AddEmail2))
        //{
        //    actMSG.To.Add(AddEmail2);
        //}

        // *********************** פרודקשן *****************


        actMSG.From = new MailAddress("wrk_mirkam@pazar.co.il");

        SmtpServer.Send(actMSG);
        actMSG.Dispose();
    }
}