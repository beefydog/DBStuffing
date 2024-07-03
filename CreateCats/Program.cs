using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CreateCats;

class Program
{
    static async Task Main(string[] args)
    {
        IConfiguration config = new ConfigurationBuilder().AddJsonFile("appsettings.json", true, true).AddUserSecrets<Program>().Build();     
        DBConn = config.GetConnectionString("DBConn");

        Console.WriteLine("Running Insertions. This can take up to 20 seconds.");
        await GenerateCategories();
        Console.WriteLine("Completed. Press any key to exit.");
        Console.ReadKey();
    }

    public static string DBConn { get; set; }

    public static List<Category> Cats = [];

    public static readonly int LevelStop = 9;
    public static readonly int CatsPerLevel = 6;
    public static int CurrentId = 1;

    /// <summary>
    /// Generate categories with subcategories stopping when LevelStop levels deep
    /// </summary>
    static async Task GenerateCategories()
    {
        CreateCats(0, "Category", 0);
        await DB.Categories_Insert_Bulk_Async(Cats);
    }

    /// <summary>
    /// Recursively called method that creates CatsPerLevel categories for every category up to [LevelStop]-1 levels deep,
    /// This is to test SQL queries with millions of records.
    /// </summary>
    /// <param name="ParentId"></param>
    /// <param name="CatName"></param>
    /// <param name="Level"></param>
    static void CreateCats(int ParentId, string CatName, int Level)
    {
        Level++;
        if (Level == LevelStop) return;
        for (int i = 0; i < CatsPerLevel; i++)
        {
            Category c = new()
            {
                Name = CatName + GetLetter(i),
                ParentId = ParentId,
                Active = true,
                Id = CurrentId
            };
            Cats.Add(c);
            int NewId = CurrentId;
            CurrentId++;
            CreateCats(NewId, c.Name, Level);
        }
    }

    public static string GetLetter(int code)
    {
        return char.ConvertFromUtf32(code + 65);
    }

}