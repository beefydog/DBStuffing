using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;


namespace CreateCats;

public class DB
{
    private static string GetDBConn()
    {
        return Program.DBConn;
    }

    public static string LastErrorMsg = string.Empty;

    /// <summary>
    /// SQL Bulk Copy - fastest method for doing this 
    /// </summary>
    /// <param name="cats"></param>
    public static async Task Categories_Insert_Bulk_Async(List<Category> cats)
    {
        using SqlBulkCopy copy = new(GetDBConn());
        Category cat = new();
        copy.DestinationTableName = "dbo.Category";
        copy.BulkCopyTimeout = 60; //60 seconds timeout - should be plenty
        try
        {
            DataTable dt = ToDataTable(cats);
            await copy.WriteToServerAsync(dt);
        }
        catch (Exception ex)
        {
            LastErrorMsg = ex.Message;
            throw;
        }
    }


    // general purpose method to create datatables from lists - not my code, but clever
    // courtesty of https://iqcode.com/code/csharp/c-list-to-datatable
    private static DataTable ToDataTable<T>(List<T> items)
    {
        DataTable dataTable = new(typeof(T).Name);

        //Get all the properties
        PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
        foreach (PropertyInfo prop in Props)
        {
            //Defining type of data column gives proper data table 
            var type = (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>) ? Nullable.GetUnderlyingType(prop.PropertyType) : prop.PropertyType);
            //Setting column names as Property names
            dataTable.Columns.Add(prop.Name, type);
        }
        foreach (T item in items)
        {
            var values = new object[Props.Length];
            for (int i = 0; i < Props.Length; i++)
            {
                //inserting property values to datatable rows
                values[i] = Props[i].GetValue(item, null);
            }
            dataTable.Rows.Add(values);
        }

        return dataTable;
    }
}



