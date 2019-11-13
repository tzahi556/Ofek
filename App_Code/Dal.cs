using System;
using System.Security.Principal;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Data.SqlClient;
using System.Net.NetworkInformation;
using System.Data;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Net;
using System.Text;
using System.Collections.ObjectModel;
using System.IO;
using System.Xml;



public class Dal
{

    // Internal Parameters
    private string _dbEnviromentName;
    private string _dbServerName;
    private string _dbDataBaseName;
    private string _dbintegratedSecurity;
    private string _dbIdentityUser;

    //   public static string _dbConnectionString = "Data Source=.;Initial Catalog=yosef;User ID=sa;Password=kaka";

    public static string _dbConnectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["dbDataConnectionString"].ToString();

    public static int ExecuteNonQuery(string sql)
    {
        int rowsAffected = 0;
        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);
        SqlCommand MySqlCommand = new SqlCommand(sql, mySqlConnection);
        mySqlConnection.Open();
        rowsAffected = MySqlCommand.ExecuteNonQuery();
        mySqlConnection.Close();
        return rowsAffected;
    }

    // Oren 15/09/2010
    /// <summary>
    /// Executs sql commant.
    /// </summary>
    /// <param name="updateCommand"></param>
    public static int ExecuteNonQuery(SqlCommand updateCommand)
    {
        int rowsAffected = 0;
        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);
        updateCommand.Connection = mySqlConnection;
        mySqlConnection.Open();
        rowsAffected = updateCommand.ExecuteNonQuery();
        mySqlConnection.Close();
        return rowsAffected;
    }

    public int ExecuteNonQuerySPOneParameter(string storedProcedureName, string stringParameterName, string stringParameterValue)
    {
        int rowsAffected = 0;
        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);

        SqlCommand MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);
        MySqlCommand.CommandType = CommandType.StoredProcedure;
        MySqlCommand.Parameters.AddWithValue(stringParameterName, stringParameterValue);

        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        mySqlConnection.Open();
        rowsAffected = MySqlCommand.ExecuteNonQuery();
        mySqlConnection.Close();

        return rowsAffected;
    }

    // Oren 10/08/2010
    /// <summary>
    /// Exectues a stored procidure against the data base and uses multiple parameters.
    /// The parameters should be privided in the Hashtable in the format of "key" = param name and "Value" = paremeter value.
    /// Note that the type is handled automatically by the sql parameter object.
    /// </summary>
    /// <param name="storedProcedureName"></param>
    /// <param name="Parameters"></param>
    /// <returns></returns>
    public int ExecuteNonQuerySPMultipleParameters_intRowEffected(string storedProcedureName, Hashtable Params)
    {
        int rowsAffected = 0;
        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);
        SqlCommand MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);
        MySqlCommand.CommandType = CommandType.StoredProcedure;

        // Add the parameters if the Params holdes parameters to add.
        if (Params != null && Params.Count > 0)
        {
            foreach (string key in Params.Keys)
            {
                MySqlCommand.Parameters.AddWithValue(key, Params[key]);
            }
        }

        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        mySqlConnection.Open();
        rowsAffected = MySqlCommand.ExecuteNonQuery();
        mySqlConnection.Close();

        return rowsAffected;
    }


    // Oren 10/08/2010
    /// <summary>
    /// Exectues a stored procidure against the data base and uses multiple parameters.
    /// The parameters should be privided in the Hashtable in the format of "key" = param name and "Value" = paremeter value.
    /// Note that the type is handled automatically by the sql parameter object.
    /// </summary>
    /// <param name="storedProcedureName"></param>
    /// <param name="Parameters"></param>
    /// <returns>Returns Guid as string.</returns>
    public string ExecuteScalarSPMultipleParameters_ReturnsString(string storedProcedureName, Hashtable Params, string outputParamName)
    {
        string output = null;
        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);
        SqlCommand MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);
        MySqlCommand.CommandType = CommandType.StoredProcedure;

        // Add the parameters if the Params holdes parameters to add.
        if (Params != null && Params.Count > 0)
        {
            foreach (string key in Params.Keys)
            {
                MySqlCommand.Parameters.AddWithValue(key, Params[key]);
            }
        }

        // Add output parameter
        SqlParameter outP = new SqlParameter(outputParamName, SqlDbType.NVarChar, 50);
        outP.Direction = ParameterDirection.Output;
        MySqlCommand.Parameters.Add(outP);

        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        mySqlConnection.Open();
        MySqlCommand.ExecuteScalar();
        output = outP.Value.ToString();
        mySqlConnection.Close();

        return output;
    }


    // Oren 10/08/2010
    /// <summary>
    /// Returns DataTable from tha current (this) connection.
    /// </summary>
    /// <param name="sqlCommand"></param>
    /// <returns></returns>
    public static DataTable GetDataTable(string sqlCommand)
    {


        using (SqlConnection myConnection = new SqlConnection(_dbConnectionString))
        {
            using (SqlCommand myCommand = new SqlCommand(sqlCommand, myConnection))
            {
                myConnection.Open();
                using (SqlDataReader myReader = myCommand.ExecuteReader())
                {
                    DataTable myTable = new DataTable();
                    myTable.Load(myReader);
                    myConnection.Close();
                    return myTable;
                }
            }
        }
    }

    // Oren 10/08/2010
    /// <summary>
    /// Returns DataTable from the soutce connection and command text provided.
    /// Note that this method is should be used for source connection that can be defrent from the current (this) connection.
    /// </summary>
    /// <param name="sqlCommand"></param>
    /// <param name="sourceConnectionString"></param>
    /// <returns></returns>
    public DataTable GetDataTable(string sqlCommand, string sourceConnectionString)
    {

        using (SqlConnection myConnection = new SqlConnection(sourceConnectionString))
        {
            using (SqlCommand myCommand = new SqlCommand(sqlCommand, myConnection))
            {
                myConnection.Open();
                using (SqlDataReader myReader = myCommand.ExecuteReader())
                {
                    DataTable myTable = new DataTable();
                    myTable.Load(myReader);
                    myConnection.Close();
                    return myTable;
                }
            }
        }
    }

    public static DataTable GetDataTableFromSPNoParameter(string storedProcedureName)
    {
        SqlConnection mySqlConnection;
        try
        {
            mySqlConnection = new SqlConnection(_dbConnectionString);
        }
        catch (Exception ex)
        {
            throw new Exception("Failure to initiate SqlConnection. ConnectionString - " + _dbConnectionString + " Error: " + ex.Message);
        }

        SqlCommand MySqlCommand;
        try
        {
            MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);
            MySqlCommand.CommandType = CommandType.StoredProcedure;
            MySqlCommand.CommandTimeout = 120; // 120 seconds.

        }
        catch (Exception ex)
        {
            throw new Exception("Failure to initiate SqlCommand. Error: " + ex.Message);
        }

        SqlDataAdapter MySqlDataAdapter;
        try
        {
            MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        }
        catch (Exception ex)
        {
            throw new Exception("Failure to initiate SqlDataAdapter. Sql command text: " + MySqlCommand.CommandText + " Error: " + ex.Message);
        }

        DataTable MyDataTable = new DataTable();

        try
        {
            mySqlConnection.Open();
        }
        catch (Exception ex)
        {
            throw new Exception("Failure to open the connection to the data base.  ConnectionString - " + _dbConnectionString + " Error: " + ex.Message);
        }

        try
        {
            MySqlDataAdapter.Fill(MyDataTable);
        }
        catch (Exception ex)
        {
            throw new Exception("Failure to fill the data table.  ConnectionString - " + _dbConnectionString + " Error: " + ex.Message);
        }

        try
        {
            mySqlConnection.Close();
        }
        catch (Exception ex)
        {
            throw new Exception("Failure to close the connection to the data base.  ConnectionString - " + _dbConnectionString + " Error: " + ex.Message);
        }
        return MyDataTable;

    }

    public static DataTable GetDataTableFromSPOneParameter(string storedProcedureName, string stringParameterName, string stringParameterValue)
    {


        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);

        SqlCommand MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);
        MySqlCommand.CommandType = CommandType.StoredProcedure;
        MySqlCommand.Parameters.AddWithValue(stringParameterName, stringParameterValue);

        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        DataTable MyDataTable = new DataTable();

        mySqlConnection.Open();
        MySqlDataAdapter.Fill(MyDataTable);
        mySqlConnection.Close();
        return MyDataTable;

    }

    public DataTable GetDataTableFromSPTwoParameter(string storedProcedureName, string stringParameterOneName, string stringParameterOneValue, string stringParameterTwoName, string stringParameterTwoValue)
    {

        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);

        SqlCommand MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);
        MySqlCommand.CommandType = CommandType.StoredProcedure;
        MySqlCommand.Parameters.AddWithValue(stringParameterOneName, stringParameterOneValue);
        MySqlCommand.Parameters.AddWithValue(stringParameterTwoName, stringParameterTwoValue);

        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        DataTable MyDataTable = new DataTable();

        mySqlConnection.Open();
        MySqlDataAdapter.Fill(MyDataTable);
        mySqlConnection.Close();
        return MyDataTable;



    }

    // Oren 12/10/2010
    /// <summary>
    /// Returns data table from store procidure. If the 'Params' hashtable is not null ans has parameters defined, the sp will use the parameters. 
    /// </summary>
    /// <param name="storedProcedureName"></param>
    /// <param name="Params"></param>
    /// <returns></returns>
    public static DataTable GetDataTableFromSPMultiParameters(string storedProcedureName, Hashtable Params)
    {

        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);

        SqlCommand MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);
        MySqlCommand.CommandType = CommandType.StoredProcedure;

        // Add the parameters if the Params holdes parameters to add.
        if (Params != null && Params.Count > 0)
        {
            foreach (string key in Params.Keys)
            {
                MySqlCommand.Parameters.AddWithValue(key, Params[key]);
            }
        }


        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        DataTable MyDataTable = new DataTable();

        mySqlConnection.Open();
        MySqlDataAdapter.Fill(MyDataTable);
        mySqlConnection.Close();
        return MyDataTable;
    }

    public static DataTable ExeSp(string storedProcedureName, params object[] Params)
    {



        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);


        mySqlConnection.Open();

        SqlCommand MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);

        MySqlCommand.CommandType = CommandType.StoredProcedure;

        SqlCommandBuilder.DeriveParameters(MySqlCommand);


        //SqlParameter sqls = new SqlParameter("ExpertId",Params[0]);

        //MySqlCommand.Parameters.Add(sqls);



        for (int i = 1; i < MySqlCommand.Parameters.Count; i++)
        {

            if (Params[i - 1].ToString() == "" || Params[i - 1].ToString()=="null")
            {
                MySqlCommand.Parameters[i].Value = DBNull.Value;
            }
            else
            {
                MySqlCommand.Parameters[i].Value = Params[i - 1].ToString();
            }

            //   MySqlCommand.Parameters.AddWithValue(parameter, Params[0]);

            // Set value of ith parameter
        }

        //for (int i = 0; i < Params.Length; i++)
        //{

        //    string parameter = Params[i].ToString();

        //    MySqlCommand.Parameters.AddWithValue(MySqlCommand.Parameters[i+1].ToString(), parameter);

        //}

        //SqlParameter parameterReturnValue = new SqlParameter("ReturnValue", SqlDbType.Int, 4);
        //parameterReturnValue.Direction = ParameterDirection.ReturnValue;
        //MySqlCommand.Parameters.Add(parameterReturnValue);




        //foreach (object item in Params)
        //{
        //    MySqlCommand.Parameters.AddWithValue("ExpertId",item);
        //}

        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        DataTable MyDataTable = new DataTable();

        //  mySqlConnection.Open();
        MySqlDataAdapter.Fill(MyDataTable);
        mySqlConnection.Close();
        return MyDataTable;
    }

    public static DataSet ExeDataSetSp(string storedProcedureName, params object[] Params)
    {



        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);


        mySqlConnection.Open();

        SqlCommand MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);

        MySqlCommand.CommandType = CommandType.StoredProcedure;

        SqlCommandBuilder.DeriveParameters(MySqlCommand);


        //SqlParameter sqls = new SqlParameter("ExpertId",Params[0]);

        //MySqlCommand.Parameters.Add(sqls);



        for (int i = 1; i < MySqlCommand.Parameters.Count; i++)
        {

            if (Params[i - 1].ToString() == "" || Params[i - 1].ToString() == "null")
            {
                MySqlCommand.Parameters[i].Value = DBNull.Value;
            }
            else
            {
                MySqlCommand.Parameters[i].Value = Params[i - 1].ToString();
            }

            //   MySqlCommand.Parameters.AddWithValue(parameter, Params[0]);

            // Set value of ith parameter
        }

        //for (int i = 0; i < Params.Length; i++)
        //{

        //    string parameter = Params[i].ToString();

        //    MySqlCommand.Parameters.AddWithValue(MySqlCommand.Parameters[i+1].ToString(), parameter);

        //}

        //SqlParameter parameterReturnValue = new SqlParameter("ReturnValue", SqlDbType.Int, 4);
        //parameterReturnValue.Direction = ParameterDirection.ReturnValue;
        //MySqlCommand.Parameters.Add(parameterReturnValue);




        //foreach (object item in Params)
        //{
        //    MySqlCommand.Parameters.AddWithValue("ExpertId",item);
        //}

        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        DataSet MyDataSet = new DataSet();

        //  mySqlConnection.Open();
        MySqlDataAdapter.Fill(MyDataSet);
        mySqlConnection.Close();
        return MyDataSet;
    }

    public static DataSet GetDataSetFromSPMultiParameters(string storedProcedureName, Hashtable Params)
    {

        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);

        SqlCommand MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);
        MySqlCommand.CommandType = CommandType.StoredProcedure;

        // Add the parameters if the Params holdes parameters to add.
        if (Params != null && Params.Count > 0)
        {
            foreach (string key in Params.Keys)
            {

                MySqlCommand.Parameters.AddWithValue(key, Params[key].ToString().Replace("%27", "'"));
            }
        }


        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        DataSet MyDataSet = new DataSet();

        mySqlConnection.Open();
        MySqlDataAdapter.Fill(MyDataSet);
        mySqlConnection.Close();
        return MyDataSet;
    }

    public static DataTable GetDataTableFromSPMultiParameters(string storedProcedureName, Hashtable Params, out int TotalRec)
    {

        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);

        SqlCommand MySqlCommand = new SqlCommand(storedProcedureName, mySqlConnection);
        MySqlCommand.CommandType = CommandType.StoredProcedure;

        // Add the parameters if the Params holdes parameters to add.
        if (Params != null && Params.Count > 0)
        {
            foreach (string key in Params.Keys)
            {
                MySqlCommand.Parameters.AddWithValue(key, Params[key]);
            }
        }

        SqlParameter prm = new SqlParameter("@TotalRec", SqlDbType.Int);
        prm.Direction = ParameterDirection.Output;
        MySqlCommand.Parameters.Add(prm);


        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(MySqlCommand);
        DataTable MyDataTable = new DataTable();

        mySqlConnection.Open();
        MySqlDataAdapter.Fill(MyDataTable);
        TotalRec = Convert.ToInt32(prm.Value);
        mySqlConnection.Close();
        return MyDataTable;
    }

    #region Sql and SqlCommand Support Functions ...

    /// <summary>
    /// Returns sql insert string with the values part in the format of: @[FieldName], @[FieldName] etc'.
    /// </summary>
    /// <param name="Params">Should hold field names as Keys and Values to be inserted as Key-Value pers.</param>
    /// <param name="TableName"></param>
    /// <returns></returns>
    internal string GetSqlInsertParametersText(Hashtable Params, string TableName)
    {
        if (Params == null || Params.Count == 0)
        {
            return string.Empty;
        }

        StringBuilder strBuilder = new StringBuilder("");

        //Insert into Table  ...
        strBuilder.Append(" INSERT INTO ");
        strBuilder.Append("[" + TableName + "] ");
        strBuilder.Append("( ");

        //Fields ...

        //Iterate through the 'Params' to set the fields section.
        foreach (string key in Params.Keys)
        {
            strBuilder.Append("[" + key + "], ");
        }

        //Remove the last (unnecessary) comma.
        int lastCommaIndex = strBuilder.ToString().LastIndexOf(',');
        strBuilder.Remove(lastCommaIndex, 1);

        strBuilder.Append(" ) ");

        //Values ...
        strBuilder.Append("VALUES ( ");

        // Values...
        foreach (string key in Params.Keys)
        {
            strBuilder.Append("@" + key + ",");
        }

        //Remove the last (unnecessary) comma.
        lastCommaIndex = strBuilder.ToString().LastIndexOf(',');
        strBuilder.Remove(lastCommaIndex, 1);

        //End of query.
        strBuilder.Append(" )");

        return strBuilder.ToString();
    }

    /// <summary>
    /// Returns sql update string with the set values part in the format of: Set [FieldName] = @[FieldName], Set [FieldName] =  @[FieldName] etc'.
    /// </summary>
    /// <param name="Params">Should hold field names as Keys and Values to be inserted as Key-Value pers.</param>
    /// <param name="TableName"></param>
    /// <returns></returns>
    internal string GetSqlUpdateParametersText(Hashtable Params, string TableName, Hashtable WherPartParams)
    {
        if (Params == null || Params.Count == 0)
        {
            return string.Empty;
        }

        StringBuilder strBuilder = new StringBuilder("");

        //Insert into Table  ...
        strBuilder.Append(" UPDATE TABLE ");
        strBuilder.Append("[" + TableName + "] ");
        strBuilder.Append(" \n");


        //Set Fields ...

        // Iterate through the 'Params' to set the fields section.
        foreach (string key in Params.Keys)
        {
            strBuilder.Append(" Set " + key + " = @" + key + ", \n");
        }

        //Remove the last (unnecessary) comma.
        int lastCommaIndex = strBuilder.ToString().LastIndexOf(',');
        strBuilder.Remove(lastCommaIndex, 1);

        // Where Part
        strBuilder.Append(" Where ");
        foreach (string key in WherPartParams.Keys)
        {
            strBuilder.Append(" " + key + " = @" + key + " And");
        }

        //Remove the last (unnecessary) 'And'.
        int lastAndIndex = strBuilder.ToString().LastIndexOf("And");
        strBuilder.Remove(lastCommaIndex, 3);

        return strBuilder.ToString();
    }

    /// <summary>
    /// Retuens 'SqlCommand' with Insert command text with all 'SqlParameters' added.
    /// </summary>
    /// <param name="Params">Should hold field names as Keys and Values to be inserted as Key-Value pers.</param>
    /// <param name="TableName"></param>
    /// <returns></returns>
    internal SqlCommand GetSqlInsertCommand(Hashtable Params, string TableName)
    {
        if (Params == null || Params.Count == 0)
        {
            return null;
        }

        // Sql
        string sql = GetSqlInsertParametersText(Params, TableName);

        // SqlCommand
        SqlCommand comm = new SqlCommand();
        comm.CommandText = sql;

        // SqlParameters
        foreach (string key in Params.Keys)
        {
            comm.Parameters.Add(new SqlParameter(key, Params[key]));
        }

        return comm;
    }

    /// <summary>
    /// Retuens 'SqlCommand' with Update command text with all 'SqlParameters' added.
    /// </summary>
    /// <param name="Params">Should hold field names as Keys and Values to be inserted as Key-Value pers.</param>
    /// <param name="TableName"></param>
    /// <returns></returns>
    internal SqlCommand GetSqlUpdateCommand(Hashtable Params, string TableName, Hashtable WherPartParams)
    {
        if (Params == null || Params.Count == 0)
        {
            return null;
        }

        // Sql
        string sql = GetSqlUpdateParametersText(Params, TableName, WherPartParams);

        // SqlCommand
        SqlCommand comm = new SqlCommand();
        comm.CommandText = sql;

        // SqlParameters
        // Values
        foreach (string key in Params.Keys)
        {
            comm.Parameters.Add(new SqlParameter(key, Params[key]));
        }

        // Where part params
        foreach (string key in WherPartParams.Keys)
        {
            comm.Parameters.Add(new SqlParameter(key, Params[key]));
        }

        return comm;
    }

    #endregion

    #region Data string funcitons ...

    ////Data string funcitons
    //public string GetListFromStoredProcedure(string storedProcedureName, string parameterName, string parameterValue)
    //{
    //    string stringList = string.Empty;
    //    SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);
    //    SqlCommand mySqlCommand = new SqlCommand();
    //    mySqlCommand.Connection = mySqlConnection;
    //    mySqlCommand.CommandText = storedProcedureName;
    //    mySqlCommand.CommandType = System.Data.CommandType.StoredProcedure;
    //    mySqlCommand.Parameters.AddWithValue(parameterName, CleanSQLInput(parameterValue));
    //    SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(mySqlCommand);
    //    mySqlConnection.Open();
    //    DataTable myDataTable = new DataTable();
    //    MySqlDataAdapter.Fill(myDataTable);
    //    mySqlConnection.Close();

    //    foreach (DataRow row in myDataTable.Rows)
    //    {
    //        stringList += (row[0].ToString() + System.Environment.NewLine);
    //    }

    //    return stringList;
    //}

    public string AddNewException(string auditDataGUID, string approver, string expirationDate, string reason)
    {
        string stringList = string.Empty;
        SqlConnection mySqlConnection = new SqlConnection(_dbConnectionString);
        SqlCommand mySqlCommand = new SqlCommand();
        mySqlCommand.Connection = mySqlConnection;
        mySqlCommand.CommandText = "sx_AddException";
        mySqlCommand.CommandType = System.Data.CommandType.StoredProcedure;
        mySqlCommand.Parameters.AddWithValue("@auditDataGUID", auditDataGUID);
        mySqlCommand.Parameters.AddWithValue("@approver", approver);
        mySqlCommand.Parameters.AddWithValue("@ExpirationDateVarchar", expirationDate);
        mySqlCommand.Parameters.AddWithValue("@reason", reason);

        SqlDataAdapter MySqlDataAdapter = new SqlDataAdapter(mySqlCommand);
        mySqlConnection.Open();
        DataTable myDataTable = new DataTable();
        MySqlDataAdapter.Fill(myDataTable);
        mySqlConnection.Close();

        foreach (DataRow row in myDataTable.Rows)
        {
            stringList += (row[0].ToString() + System.Environment.NewLine);
        }

        return stringList;
    }

    #endregion


    //internal static string GridCrud(string sql, Hashtable Params)
    //{

    //    Hashtable hs = new Hashtable();
    //    hs.Add("Query", sql);
    //    hs.Add("page", Params["page"]);
    //    hs.Add("rows", Params["rows"]);
    //    hs.Add("sidx", (string.IsNullOrEmpty(Params["sidx"].ToString()) ? "(select 0)" : Params["sidx"]));
    //    hs.Add("sord", Params["sord"]);

    //    //   {"Class":"Test","MethodName":"kaka","_search":false,"nd":1312986495026,"rows":3,"page":1,"sidx":"Id","sord":"asc"}

    //    int TotalRecords = 0;
    //    DataTable dt = GetDataTableFromSPMultiParameters("sx_PageViewByParam", hs, out TotalRecords);

    //    var list = new Collection<Object> { };

    //    int index = 0;
    //    foreach (DataRow dr in dt.Rows)
    //    {
    //        Dictionary<string, object> result = new Dictionary<string, object>();
    //        foreach (DataColumn dc in dt.Columns)
    //        {
    //            result.Add(dc.ColumnName, dr[dc].ToString());
    //        }

    //        list.Add(result);
    //        index++;
    //    }



    //    int CurrentRows = Convert.ToInt32(Params["rows"]);
    //    var gridData = new
    //    {
    //        total = TotalRecords / CurrentRows + (TotalRecords % CurrentRows > 0 ? 1 : 0),
    //        page = Params["page"],
    //        records = list.Count,
    //        rows = list
    //    };






    //    var jsonSerializer = new JavaScriptSerializer();
    //    string s = jsonSerializer.Serialize(gridData);





    //    return s;
    //}


}




