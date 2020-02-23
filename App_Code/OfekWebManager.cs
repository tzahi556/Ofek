using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OleDb;
using System.Data;
using SendAndReadDataFromFatek.ErrorManagers;
using SendAndReadDataFromFatek;

public class OfekWebManager
{
    private static OfekWebManager instance;
    public static int DEFAULT_MAX_NUMBER_OF_CLASSES = 8;
    public OleDbConnection conn = new OleDbConnection();
    public FatekConnection FatekObj;

    public bool Reversed = false; // האם תתבצע תצוגה הפוכה

    //  public static string IP = "";

    public static OfekWebManager Instance
    {
        get
        {
            //if (instance == null)
            //    instance = new OfekWebManager(IP);
            return instance;
        }
    }


    public OfekWebManager(string IP)
    {

        //String connection = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=|DataDirectory|\\ScheduleDB.accdb;Persist Security Info=True";
        //conn.ConnectionString = connection;
        //conn.Open();
        //DataSet ds = new DataSet();
        //string sql = "Select * FROM Configuration Where ID=2 Or ID=3 ORDER BY ID";
        //OleDbDataAdapter adapter = new OleDbDataAdapter(sql, conn);
        //adapter.Fill(ds);
        //DataTable dt = ds.Tables[0];


        //string InstanceIP = dt.Rows[0][2].ToString();

        //// טיפול בתצוגה הופכית
        //try
        //{
        //    Reversed = (dt.Rows[1][2].ToString() == "true") ? true : false;
        //}
        //catch(Exception ex){

        //}

        //if (InstanceIP == "")
        //{
        //    FatekObj = FatekConnection.LastOpenedConnection;

        //}
        //else
        //{
        FatekObj = new FatekConnection(InterchangeableConnections.InterchangeableConnection.ConnectionType.UDP, IP, 500);
        // }
    }


    public List<DateList> getAllDatesLists()
    {
        DataSet ds = new DataSet();
        string sql = "Select * FROM PLC";
        OleDbDataAdapter adapter = new OleDbDataAdapter(sql, conn);
        adapter.Fill(ds);
        DataTable dt = ds.Tables[0];
        return getDateListsFromTable(dt);

    }


    public List<DateToSendClass> getAllDateTimesByClass(int classNum)
    {

        DataSet dsLooz = new DataSet();
        string sqlLooz = "Select * FROM Loozs Where IsSelect=1";
        OleDbDataAdapter adapterLooz = new OleDbDataAdapter(sqlLooz, conn);
        adapterLooz.Fill(dsLooz);
        DataTable dtLooz = dsLooz.Tables[0];

        string LoozId = "0";
        if (dtLooz.Rows.Count > 0)
        {

            LoozId = dtLooz.Rows[0]["Id"].ToString();

        }



        DataSet ds = new DataSet();
        string sql = "Select Schedule.* FROM Schedule,ClassesDictionary WHERE Schedule.LoozId=" + LoozId + " and  Schedule.Class=" + classNum + " AND ClassesDictionary.ClassNumber=" + classNum +
            " AND ((((Schedule.Tag is null) OR (Schedule.Tag='') OR (Schedule.Tag='Default'))) AND ((ClassesDictionary.CurrentTag is null) OR (ClassesDictionary.CurrentTag='') OR (ClassesDictionary.CurrentTag='Default')) OR (Schedule.Tag = ClassesDictionary.CurrentTag))";
        OleDbDataAdapter adapter = new OleDbDataAdapter(sql, conn);
        adapter.Fill(ds);
        DataTable dt = ds.Tables[0];
        List<DateToSendClass> ans = new List<DateToSendClass>();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            DataRow dr = dt.Rows[i];
            DateToSendClass d = new DateToSendClass();
            d.ClassNumber = classNum;
            d.Day = (DayOfWeek)int.Parse(dr["Day"].ToString());
            d.Hour = int.Parse(dr["Hour"].ToString());
            d.Minute = int.Parse(dr["Minute"].ToString());
            d.ShouldTurnOn = int.Parse(dr["On"].ToString()) == 1;
            d.DBId = int.Parse(dr["ID"].ToString());
            ans.Add(d);
        }
        ans.Sort(DateToSendClass.simpleDatesComparison);
        return ans;

    }
    public void saveDates(int classNum, string saveName)
    {
        string selectSQL = "SELECT CurrentTagSchedule.Hour,CurrentTagSchedule.Minute,CurrentTagSchedule.Day,CurrentTagSchedule.Class,CurrentTagSchedule.On FROM CurrentTagSchedule WHERE CurrentTagSchedule.Class=" + classNum;
        OleDbDataAdapter ada = new OleDbDataAdapter(selectSQL, conn);
        DataSet ds = new DataSet();
        ada.Fill(ds);
        DataTable dt = ds.Tables[0];
        foreach (DataRow dr in dt.Rows)
        {
            string insertSQL = "INSERT INTO Schedule ([Hour],[Minute],[Day],[Class],[On],[Tag]) VALUES (" +
                dr["Hour"].ToString() + "," +
                dr["Minute"].ToString() + "," +
                dr["Day"].ToString() + "," +
                dr["Class"].ToString() + "," +
                dr["On"].ToString() + "," +
                "'" + saveName + "')";

            OleDbCommand cmd = new OleDbCommand(insertSQL, conn);
            cmd.ExecuteNonQuery();
        }

        string updateSQL = "UPDATE [ClassesDictionary] SET CurrentTag=@Value1 WHERE ClassNumber=@ClassValue";
        OleDbCommand updateCommand = new OleDbCommand(updateSQL, conn);
        updateCommand.Parameters.Add(new OleDbParameter("@Value1", saveName));
        updateCommand.Parameters.Add(new OleDbParameter("@ClassValue", classNum));
        updateCommand.ExecuteNonQuery();


    }
    public void saveDatesForList(int listId, string saveName)
    {
        Dictionary<int, string> classes = getDateListClasses(listId);
        foreach (int classId in classes.Keys)
        {
            saveDates(classId, saveName);
        }
    }
    public void loadDates(int classNum, string loadName)
    {
        string updateSQL = "UPDATE [ClassesDictionary] SET CurrentTag='" + loadName + "' WHERE ClassNumber=" + classNum;

        OleDbCommand cmd = new OleDbCommand(updateSQL, conn);
        cmd.ExecuteNonQuery();
        sendDatesToPLC(classNum);
    }
    public void loadDateList(int listId, string loadName)
    {
        Dictionary<int, string> classes = getDateListClasses(listId);
        foreach (int classId in classes.Keys)
        {
            loadDates(classId, loadName);
        }
    }
    public List<string> getAllSavedNamesForList(int listId)
    {
        List<string> ans = new List<string>();
        string sql = "SELECT Distinct Schedule.TAG FROM ClassesDictionary,Schedule WHERE Schedule.Class=ClassesDictionary.ClassNumber AND ClassesDictionary.PLC=" + listId;
        DataSet ds = new DataSet();
        OleDbDataAdapter adapter = new OleDbDataAdapter(sql, conn);
        adapter.Fill(ds);
        ans.Add("Default");
        foreach (DataRow item in ds.Tables[0].Rows)
        {
            string temp = item.ItemArray[0].ToString();
            if (!(temp == "" || temp == "Default"))
            {
                ans.Add(temp);
            }
        }
        return ans;
    }
    public List<string> getAllSavedNamesForClass(int classId)
    {
        List<string> ans = new List<string>();
        string sql = "SELECT Distinct Schedule.TAG FROM ClassesDictionary,Schedule WHERE Schedule.Class=ClassesDictionary.ClassNumber AND Schedule.Class=" + classId;
        DataSet ds = new DataSet();
        OleDbDataAdapter adapter = new OleDbDataAdapter(sql, conn);
        adapter.Fill(ds);
        ans.Add("Default");
        foreach (DataRow item in ds.Tables[0].Rows)
        {
            string temp = item.ItemArray[0].ToString();
            if (!(temp == "" || temp == "Default"))
            {
                ans.Add(temp);
            }
        }
        return ans;
    }
    public List<DateToSendClass> addDateToList(int classNum, DateToSendClass d)
    {
        // צחי הוסיף עדכון עם לוז נבחר
        DataSet ds1 = new DataSet();
        string sql1 = "Select top 1 Id FROM Loozs where IsSelect=1";
        OleDbDataAdapter adapter1 = new OleDbDataAdapter(sql1, conn);
        adapter1.Fill(ds1);
        DataTable dt = ds1.Tables[0];
        string LoozId = dt.Rows[0][0].ToString();

        DataSet ds = new DataSet();
        string tag = "Default";
        string getTagSql = "Select CurrentTag FROM ClassesDictionary WHERE ClassNumber=" + classNum;
        OleDbDataAdapter adapter = new OleDbDataAdapter(getTagSql, conn);
        adapter.Fill(ds);
        string temp = ds.Tables[0].Rows[0].ItemArray[0].ToString();
        if (temp != "") tag = temp;
        string sql = "INSERT INTO SCHEDULE ([Hour],[Minute],[Day],[Class],[On],[Tag],[LoozId]) VALUES (" + d.Hour + "," + d.Minute + "," + (int)d.Day + "," + classNum + "," + (d.ShouldTurnOn ? 1 : 0) + ",'" + tag + "'," + LoozId + " )";
        OleDbCommand cmd = new OleDbCommand(sql, conn);
        cmd.ExecuteNonQuery();
        return getAllDateTimesByClass(classNum); //returns the updated list
    }

    public Dictionary<int, String> getDateListClasses(int dateListID)
    {
        DataSet ds = new DataSet();
        string sql = "Select * FROM ClassesDictionary WHERE PLC=" + dateListID.ToString() + " ORDER BY ClassNumber";
        OleDbDataAdapter adapter = new OleDbDataAdapter(sql, conn);
        adapter.Fill(ds);
        Dictionary<int, string> classes = new Dictionary<int, string>();
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            classes.Add((int)dr["ClassNumber"], dr["ClassName"].ToString());
        }
        return classes;
    }
    public List<ClassStatus> getDateListClassesStatus(int id)
    {
        DateList dl = getAllDatesLists().Find(p => p.ID == id);
        if (dl == null) return null;
        return getDateListClassesStatus(dl);
    }
    public DateList getDateList(int id)
    {
        return getAllDatesLists().Find(p => p.ID == id);
    }
    public List<ClassStatus> getForceStatus(int id)
    {
        DateList dl = getAllDatesLists().Find(p => p.ID == id);
        if (dl == null) return null;
        List<ClassStatus> ans = new List<ClassStatus>();
        Dictionary<int, String> classNames = getDateListClasses(dl.ID);
        for (int i = 0; i < classNames.Count; i++)
        {

            ClassStatus cs = new ClassStatus();
            cs.ClassNum = classNames.Keys.ElementAt(i);
            cs.Name = classNames[cs.ClassNum];
            cs.ForceStatus = getClassForceStatus(cs.ClassNum);
            ans.Add(cs);
        }
        return ans;
    }

    public List<ClassStatus> getDateListClassesStatus(DateList dl)
    {
        List<ClassStatus> ans = new List<ClassStatus>();
        Dictionary<int, String> classNames = getDateListClasses(dl.ID);
        bool[] status = dl.getClassesStatus(Math.Max(classNames.Count, 1));
        for (int i = 0; i < classNames.Count; i++)
        {

            ClassStatus cs = new ClassStatus();
            cs.ClassNum = classNames.Keys.ElementAt(i);
            cs.Name = classNames[cs.ClassNum];
            cs.Status = (Reversed) ? !status[i] : status[i];
            cs.ForceStatus = getClassForceStatus(cs.ClassNum);

            //חזרה למצב הקודם
            if (cs.ForceStatus > 20 && !cs.Status)
            {
                string CurrentStatus = changedClassForceStatusFromPrev(cs.ClassNum);
                cs.ForceStatus = Int32.Parse(CurrentStatus);
                bool[] statusTemp = dl.getClassesStatus(Math.Max(classNames.Count, 1));
                cs.Status = (Reversed) ? !statusTemp[i] : statusTemp[i];
            }

            ans.Add(cs);
        }
        return ans;
    }
    private List<DateList> getDateListsFromTable(DataTable dt)
    {
        List<DateList> ans = new List<DateList>();
        foreach (DataRow dr in dt.Rows)
        {
            DateList dl = new DateList();
            dl.Name = dr["PLC_NAME"].ToString();
            dl.DiscretePosition = (int)dr["DiscretePosition"];
            dl.StartPosition = (int)dr["StartPosition"];
            dl.NotificationPosition = (int)dr["NotificationPosition"];
            dl.ID = (int)dr["ID"];
            ans.Add(dl);
        }
        return ans;
    }
    //public List<DateToSendClass> getDatesList(int dateListId, int classId, DayOfWeek theDay)
    //{
    //    DateList dl = getDateList(dateListId);
    //    return dl.getRealDates(DEFAULT_MAX_NUMBER_OF_CLASSES).FindAll(p => p.ClassNumber == classId && p.Day == theDay);

    //}
    public List<DateToSendClass> getDatesList(int classId)
    {
        List<DateToSendClass> ls = new List<DateToSendClass>();
        string sql = "SELECT * FROM ClassesDictionary WHERE ClassNumber=" + classId.ToString();
        OleDbDataAdapter dbCmd = new OleDbDataAdapter(sql, conn);
        DataTable classesDataTable = new DataTable();
        dbCmd.Fill(classesDataTable);
        if (classesDataTable.Rows.Count == 0)
            return ls;
        DataRow classDataRow = classesDataTable.Rows[0];
        int startAddress = int.Parse(classDataRow["StartAddress"].ToString());
        int endAddress = int.Parse(classDataRow["EndAddress"].ToString());
#if DEBUG


            ls = FatekObj.getDatesInShortFormat(startAddress, FatekConnection.getAreaByLetter(classDataRow["MemoryType"].ToString()), endAddress - startAddress + 1);

            //  ls = FatekConnection.LastOpenedConnection
            //   .getDatesInShortFormat(startAddress, FatekConnection.getAreaByLetter(classDataRow["MemoryType"].ToString()), endAddress - startAddress + 1);
#else
        Random r = new Random();
        for (int i = 0; i <= 6; i++)
        {
            int oldValue = 0;
            for (int j = 0; j < 6; j++)
            {
                DateToSendClass d = new DateToSendClass();
                oldValue = r.Next(oldValue + 1, 12 + 2 * j);
                d.Hour = oldValue;
                d.Minute = (int)i;
                d.ShouldTurnOn = (j % 2 == 0);
                d.ClassNumber = classId;
                d.Day = (DayOfWeek)i;
                d.DBId = 0;
                ls.Add(d);
            }
        }
#endif

        ls.Sort(DateToSendClass.simpleDatesComparison);
        return ls;


        //DateList dl = getDateList(dateListId);
        //return dl.getRealDates(DEFAULT_MAX_NUMBER_OF_CLASSES).FindAll(p => p.ClassNumber == classId);

    }

    public int getClassForceStatus(int classNum)
    {
        string getStatSQL = "SELECT StaticAction FROM ClassesDictionary WHERE [ClassNumber]=" + classNum;
        DataTable statData = new DataTable();
        OleDbDataAdapter getStatCmd = new OleDbDataAdapter(getStatSQL, conn);
        getStatCmd.Fill(statData);
        if ((statData.Rows.Count > 0) && (!DBNull.Value.Equals(statData.Rows[0]["StaticAction"])))
        {
            return (int)statData.Rows[0]["StaticAction"];
        }
        else return 0;
    }


    private void AddToListForForce(ref List<DateToSendClass> ls, int classNum, bool IsOn, DateTime t)
    {
        DateToSendClass d = new DateToSendClass();
        //    DateTime t = DateTime.Now;
        d.Day = (DayOfWeek)t.DayOfWeek;//DayOfWeek.Sunday;
        d.Hour = t.Hour;
        d.Minute = t.Minute;
        d.ShouldTurnOn = IsOn;
        d.ClassNumber = classNum;
        //   ls = new List<DateToSendClass>();
        ls.Add(d);
    }

    public bool sendEliorTest(int endAddress, int startAddress, bool IsON)
    {
        List<DateToSendClass> ls;
        ls = new List<DateToSendClass>();

        AddToListForForce(ref ls, 103, IsON, DateTime.Now);
        //AddToListForForce(ref ls, 103, IsON, DateTime.Now.AddMinutes(1));

        short[] dataToWrite = new short[endAddress - startAddress + 1];

        for (int i = 0; i < ls.Count; i++)
        {
            dataToWrite[i] = ls[i].NoClassBuffer;
        }

        FatekObj.writeBuffer(dataToWrite, startAddress, FatekConnection.getAreaByLetter("R"));
        return true;
    }

    public bool sendDatesToPLC(int classNum)
    {
        List<DateToSendClass> ls;
        ls = new List<DateToSendClass>();
        int forceStat = getClassForceStatus(classNum);
        if (forceStat == 1 || forceStat == -1)
        {

            AddToListForForce(ref ls, classNum, (forceStat == 1), DateTime.Now);
            AddToListForForce(ref ls, classNum, (forceStat == 1), DateTime.Now.AddMinutes(1));


            //d = new DateToSendClass();
            //t = DateTime.Now.AddMinutes(1);
            //d.Day = (DayOfWeek)t.DayOfWeek;//DayOfWeek.Sunday;
            //d.Hour = t.Hour;
            //d.Minute = t.Minute;
            //d.ShouldTurnOn = (forceStat == 1);
            //d.ClassNumber = classNum;
            //// ls = new List<DateToSendClass>();
            //ls.Add(d);

        }

        if (forceStat == 0)
        {
            ls = getAllDateTimesByClass(classNum);
        }


        if (forceStat > 20)
        {

            int CastHours = forceStat - 20;


            AddToListForForce(ref ls, classNum, true, DateTime.Now);
            AddToListForForce(ref ls, classNum, true, DateTime.Now.AddMinutes(1));
            AddToListForForce(ref ls, classNum, false, DateTime.Now.AddHours(CastHours));
            //AddToListForForce(ref ls, classNum, false, DateTime.Now.AddHours(CastHours).AddMinutes(1)); 

        }





        string sql = "Select ClassNumber,ClassName,PLC,StartAddress,EndAddress,MemoryType.Type as MemoryType FROM ClassesDictionary,MemoryType WHERE ClassNumber=" + classNum + " AND ClassesDictionary.MemoryType=MemoryType.ID";
        DataTable classData = new DataTable();
        OleDbDataAdapter dbCmd = new OleDbDataAdapter(sql, conn);
        dbCmd.Fill(classData);
        if (classData.Rows.Count == 0)
        {
            ErrorManager.Instance.addError(new NotFoundInDBError(NotFoundInDBError.DBObjects.Class));
            return false;
        }
        DataRow classDataRow = classData.Rows[0];
        int startAddress = int.Parse(classDataRow["StartAddress"].ToString());
        int endAddress = int.Parse(classDataRow["EndAddress"].ToString());
        if (startAddress + ls.Count > endAddress)
        {
            ErrorManager.Instance.addError(new TriedToWriteTooManyDatesError(classNum));
            return false;
        }
        short[] dataToWrite = new short[endAddress - startAddress + 1];

        for (int i = 0; i < ls.Count; i++)
        {
            dataToWrite[i] = ls[i].NoClassBuffer;
        }
#if DEBUG
            try
            {
                // FatekConnection.LastOpenedConnection.writeBuffer(dataToWrite, startAddress, FatekConnection.getAreaByLetter(classDataRow["MemoryType"].ToString()));
                FatekObj.writeBuffer(dataToWrite, startAddress, FatekConnection.getAreaByLetter(classDataRow["MemoryType"].ToString()));
                return true;
            }
            catch (Exception exc)
            {
                ErrorManager.Instance.addError(new FailedToWriteDataToPLCError(exc.Message));
                return false;
            }
#endif

        return true;
    }





    public void deleteDate(int dateId)
    {
        string sql = "DELETE FROM SCHEDULE WHERE [ID]=" + dateId;
        OleDbCommand cmd = new OleDbCommand(sql, conn);
        cmd.ExecuteNonQuery();
    }
    public void updateDate(int dateId, DateToSendClass d)
    {
        string sql = "UPDATE SCHEDULE SET " +
            "Hour=" + d.Hour + ",Minute=" + d.Minute + ",Day=" + (int)d.Day + ",On=" + (d.ShouldTurnOn ? 1 : 0) +
            " WHERE [ID]=" + dateId;
        OleDbCommand cmd = new OleDbCommand(sql, conn);
        cmd.ExecuteNonQuery();
    }

    public bool changedClassForceStatus(int classId, int stat)
    {

        string AddedSql = "";
        if (stat < 2)
        {

            AddedSql = ",CurrentStatus=" + stat;

        }

        string sql = "UPDATE ClassesDictionary SET " +
            "StaticAction=" + stat + AddedSql + " WHERE [ClassNumber]=" + classId;
        OleDbCommand cmd = new OleDbCommand(sql, conn);
        cmd.ExecuteNonQuery();
        return sendDatesToPLC(classId);
    }


    // שינוי ועדכון זמן הקודם שהיה לפני הדלקה אוטמטי
    public string changedClassForceStatusFromPrev(int classId)
    {
        DataSet ds = new DataSet();
        string CurrentStatusSql = "Select CurrentStatus FROM ClassesDictionary WHERE ClassNumber=" + classId;
        OleDbDataAdapter adapter = new OleDbDataAdapter(CurrentStatusSql, conn);
        adapter.Fill(ds);
        string CurrentStatus = ds.Tables[0].Rows[0].ItemArray[0].ToString();

        if (string.IsNullOrEmpty(CurrentStatus)) CurrentStatus = "0";

        string sql = "UPDATE ClassesDictionary SET " +
            "StaticAction=" + CurrentStatus + "  WHERE [ClassNumber]=" + classId;
        OleDbCommand cmd = new OleDbCommand(sql, conn);
        cmd.ExecuteNonQuery();
        sendDatesToPLC(classId);

        return CurrentStatus;
    }

    #region Looz

    public List<DateList> getLoozs()
    {
        DataSet ds = new DataSet();
        string sql = "Select * FROM Loozs Order by IsSelect desc";
        OleDbDataAdapter adapter = new OleDbDataAdapter(sql, conn);
        adapter.Fill(ds);
        DataTable dt = ds.Tables[0];
        //  return getDateListsFromTable(dt);


        List<DateList> ans = new List<DateList>();
        foreach (DataRow dr in dt.Rows)
        {
            DateList dl = new DateList();
            dl.Name = dr["Name"].ToString();

            dl.ID = (int)dr["Id"];
            ans.Add(dl);
        }
        return ans;


    }

    // שינוי ועדכון זמן הקודם שהיה לפני הדלקה אוטמטי
    public void setLoozChoose(int LoozId)
    {
        DataSet ds = new DataSet();
        string CurrentStatusSql = "Update Loozs Set IsSelect=0";

        OleDbCommand command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();

        CurrentStatusSql = " Update Loozs Set IsSelect=1 where Id=" + LoozId;
        command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();

        // שולף את כל אלו שהם על שעון ומעדכן
        //  ds = new DataSet();

        UpdatePlcFROMCurrentLooz();



        //


        //adapter.Fill(ds);
        //string CurrentStatus = ds.Tables[0].Rows[0].ItemArray[0].ToString();

        //if (string.IsNullOrEmpty(CurrentStatus)) CurrentStatus = "0";

        //string sql = "UPDATE ClassesDictionary SET " +
        //    "StaticAction=" + CurrentStatus + "  WHERE [ClassNumber]=" + classId;
        //OleDbCommand cmd = new OleDbCommand(sql, conn);
        //cmd.ExecuteNonQuery();
        //sendDatesToPLC(classId);

        //return CurrentStatus;
    }

    public void UpdatePlcFROMCurrentLooz()
    {
        DataSet ds = new DataSet();
        string sql = "Select ClassNumber FROM ClassesDictionary where StaticAction=0";
        OleDbDataAdapter adapter = new OleDbDataAdapter(sql, conn);
        adapter.Fill(ds);
        DataTable dt = ds.Tables[0];

        foreach (DataRow item in dt.Rows)
        {
            int classNum = Int32.Parse(item["ClassNumber"].ToString());
            sendDatesToPLC(classNum);
        }
    }

    public void setNewLooz(string NewLooz, int SourceLoozId)
    {
        DataSet ds = new DataSet();
        string CurrentStatusSql = " Update Loozs Set IsSelect=0";

        OleDbCommand command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();



        CurrentStatusSql = "Insert Into Loozs(Id,Name,IsSelect) select MAX(Id) + 1,'" + NewLooz + "',1 from Loozs"; //+ " Then 1 else 0 end";

        command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();


        CurrentStatusSql = "Insert Into Schedule([Hour],[Minute],[Day],[Class],[On],[Tag],[LoozId]) select [Hour],[Minute],[Day],[Class],[On],[Tag],(select Max(Id) from Loozs) from Schedule where LoozId=" + SourceLoozId; //+ " Then 1 else 0 end";

        command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();


        UpdatePlcFROMCurrentLooz();



    }

    public void deleteLooz(int LoozId)
    {
        DataSet ds = new DataSet();
        string CurrentStatusSql = " delete from Loozs where Id=" + LoozId.ToString() + ";";

        OleDbCommand command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();

        CurrentStatusSql = " Update Loozs Set IsSelect=1 where Id=0";

        command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();


        CurrentStatusSql = " delete from Schedule where LoozId=" + LoozId.ToString() + ";";

        command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();

        UpdatePlcFROMCurrentLooz();


    }

    public void copyBetweenStation(int SourceClassId, int DestClassId)
    {

        //   System.Threading.Thread.Sleep(500);

        DataSet dsLooz = new DataSet();
        string sqlLooz = "Select * FROM Loozs Where IsSelect=1";
        OleDbDataAdapter adapterLooz = new OleDbDataAdapter(sqlLooz, conn);
        adapterLooz.Fill(dsLooz);
        DataTable dtLooz = dsLooz.Tables[0];

        string LoozId = "0";
        if (dtLooz.Rows.Count > 0)
        {

            LoozId = dtLooz.Rows[0]["Id"].ToString();

        }


        string CurrentStatusSql = " delete from Schedule where Class=" + DestClassId.ToString() + " and LoozId=" + LoozId.ToString();

        OleDbCommand command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();

        //מעדכן אותו שיעבוד על לו"ז
        CurrentStatusSql = " Update ClassesDictionary Set StaticAction=0 where ClassNumber=" + DestClassId.ToString() + ";";
        command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();


        CurrentStatusSql = "Insert Into Schedule([Hour],[Minute],[Day],[Class],[On],[Tag],[LoozId]) select [Hour],[Minute],[Day]," + DestClassId.ToString()
            + ",[On],[Tag],[LoozId] from Schedule where Class=" + SourceClassId + " and LoozId=" + LoozId.ToString(); //+ " Then 1 else 0 end";
        command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();


        UpdatePlcFROMCurrentLooz();


    }

    public void copyBetweenDays(int SourceDayId, int DestDayId, int ClassId)
    {


        DataSet dsLooz = new DataSet();
        string sqlLooz = "Select * FROM Loozs Where IsSelect=1";
        OleDbDataAdapter adapterLooz = new OleDbDataAdapter(sqlLooz, conn);
        adapterLooz.Fill(dsLooz);
        DataTable dtLooz = dsLooz.Tables[0];

        string LoozId = "0";
        if (dtLooz.Rows.Count > 0)
        {

            LoozId = dtLooz.Rows[0]["Id"].ToString();

        }





        string CurrentStatusSql = " delete from Schedule where LoozId=" + LoozId + " and Class=" + ClassId.ToString() +
                                    " and Day= " + DestDayId.ToString() + ";";

        OleDbCommand command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();




        CurrentStatusSql = "Insert Into Schedule([Hour],[Minute],[Day],[Class],[On],[Tag],[LoozId])"
                                        + " select [Hour],[Minute]," + DestDayId + ",[Class],[On],[Tag],[LoozId] from Schedule"
                                        + " where Class=" + ClassId.ToString() + " and Day=" + SourceDayId + " and LoozId=" + LoozId.ToString(); //+ " Then 1 else 0 end";
        command = new OleDbCommand(CurrentStatusSql, conn);
        command.ExecuteNonQuery();


        UpdatePlcFROMCurrentLooz();


    }




    #endregion

    ///***********************************************************
    public bool SendConnectToFatek(DataTable dt)
    {

       
        List<DateToSendClass> ls;
        ls = new List<DateToSendClass>();

        int startAddress = Int32.Parse(dt.Rows[0]["UStartRigster"].ToString());
        int endAddress = Int32.Parse(dt.Rows[0]["UEndRigster"].ToString());
        int UStatus = Int32.Parse(dt.Rows[0]["UStatus"].ToString());
        int UStaticOnHour = (dt.Rows[0]["UStaticOnHour"] == null || dt.Rows[0]["UStaticOnHour"].ToString() == "") ? 0 : Int32.Parse(dt.Rows[0]["UStaticOnHour"].ToString());

        if (UStatus != 2)
        {
            AddToListForForceFatek(ref ls, UStaticOnHour, UStatus, DateTime.Now);
            AddToListForForceFatek(ref ls, UStaticOnHour, UStatus, DateTime.Now.AddMinutes(1));
        }
        else
        {
            ls = GetAllDatesTimes(dt);
        }

        short[] dataToWrite = new short[endAddress - startAddress + 1];

        for (int i = 0; i < ls.Count; i++)
        {
            dataToWrite[i] = ls[i].NoClassBuffer;
        }



        FatekObj.writeBuffer(dataToWrite, startAddress, FatekConnection.getAreaByLetter("R"));
        return true;
    }

    private void AddToListForForceFatek(ref List<DateToSendClass> ls, int uStaticOnHour, int uStatus, DateTime t)
    {

        if (uStatus == 0)
        {
            DateToSendClass d = new DateToSendClass();
            d.Day = (DayOfWeek)t.DayOfWeek;
            d.Hour = t.Hour;
            d.Minute = t.Minute;
            d.ShouldTurnOn = false;
            ls.Add(d);

        }

        if (uStatus == 1 && uStaticOnHour == 0)
        {
            DateToSendClass d = new DateToSendClass();
            d.Day = (DayOfWeek)t.DayOfWeek;
            d.Hour = t.Hour;
            d.Minute = t.Minute;
            d.ShouldTurnOn = true;
            ls.Add(d);
        }

        if (uStatus == 1 && uStaticOnHour != 0)
        {
            DateToSendClass d = new DateToSendClass();
            d.Day = (DayOfWeek)t.DayOfWeek;
            d.Hour = t.Hour;
            d.Minute = t.Minute;
            d.ShouldTurnOn = true;
            ls.Add(d);

            t = t.AddHours(uStaticOnHour);
            d = new DateToSendClass();
            d.Day = (DayOfWeek)t.DayOfWeek;
            d.Hour = t.Hour;
            d.Minute = t.Minute;
            d.ShouldTurnOn = false;
            ls.Add(d);
        }

    }

    public List<DateToSendClass> GetAllDatesTimes(DataTable dt)
    {

       
        List<DateToSendClass> ans = new List<DateToSendClass>();
        for (int i = 0; i < dt.Rows.Count; i++)
        {

            DataRow dr = dt.Rows[i];
            if (dr["UConnectLoozId"] == null || dr["UConnectLoozId"].ToString()=="") continue;

            TimeSpan time = TimeSpan.Parse(dr["Time"].ToString());

            DateToSendClass d = new DateToSendClass();
          
            d.Day = (DayOfWeek)(int.Parse(dr["DayId"].ToString()) - 1);

            d.Hour = int.Parse(time.Hours.ToString());
            d.Minute = int.Parse(time.Minutes.ToString());
            d.ShouldTurnOn = Convert.ToBoolean(dr["Status"].ToString());
          //  d.DBId = int.Parse(dr["ID"].ToString());
            ans.Add(d);
        }
        ans.Sort(DateToSendClass.simpleDatesComparison);
        return ans;

    }


    public bool[] GetAllStatuses(int maxNumberOfClasses)
    {

        return FatekObj.getClassDiscretesStatus(0, maxNumberOfClasses);

    }



}

