using Ede.Uof.Utility.Page;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

public partial class CDS_LAB_TwoColumn : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((Master_TwoColumn)this.Master).LeftTitle = lblTitle.Text;
            BindTree();
        }
    }

    private void BindTree()
    {
        DB db = new DB();

        DataTable dt = db.GetCategory();

        foreach(DataRow dr in dt.Rows)
        {
            RadTreeNode node = new RadTreeNode(dr["CategoryName"].ToString(), dr["CategoryID"].ToString());
            node.ImageUrl=   "~/Common/Images/Icon/icon_m82.gif";
            TreeView1.Nodes.Add(  node);
        }


    }
    protected void TreeView1_SelectedNodeChanged(object sender, EventArgs e)
    {

    }
    protected void TreeView1_NodeClick(object sender, RadTreeNodeEventArgs e)
    {
        BindGrid();
    }

    private void BindGrid()
    {
        DB db= new DB();
        DataTable dt = db.GetProduct(TreeView1.SelectedValue);

        GridView1.DataSource = dt;
        GridView1.DataBind();
        
    }
}

class DB : Ede.Uof.Utility.Data.BasePersistentObject
{
    public DataTable GetCategory()
    {
        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["connectionstringTONORTHWND"].ConnectionString;

        m_db = new Ede.Uof.Utility.Data.DatabaseHelper(conn);

        DataTable dt = new DataTable();

        string cmdTxt = @"SELECT  [CategoryID]
      ,[CategoryName]
      ,[Description]
  FROM [dbo].[Categories]";

        dt.Load(this.m_db.ExecuteReader(cmdTxt));

        return dt;


    }

    public DataTable GetProduct(string categoryId)
    {
        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["connectionstringTONORTHWND"].ConnectionString;

        m_db = new Ede.Uof.Utility.Data.DatabaseHelper(conn);

        DataTable dt = new DataTable();

        string cmdTxt = @"SELECT [ProductID]
      ,[ProductName]
      ,[SupplierID]
      ,[CategoryID]
      ,[QuantityPerUnit]
      ,[UnitPrice]
      ,[UnitsInStock]
      ,[UnitsOnOrder]
      ,[ReorderLevel]
      ,[Discontinued]
  FROM [dbo].[Products]";

        dt.Load(this.m_db.ExecuteReader(cmdTxt));

        return dt;

    }

}