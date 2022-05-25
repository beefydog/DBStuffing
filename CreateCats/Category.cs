namespace CreateCats;

public class Category
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int ParentId { get; set; }
    public bool Active { get; set; }

    //parameters
    public readonly string p_Id = "@Id";
    public readonly string p_Name = "@Name";
    public readonly string p_ParentId = "@ParentId";
    public readonly string p_Active = "@Active";
    public readonly string p_NewId = "@NewId";
}
