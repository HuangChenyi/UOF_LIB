using Ede.Uof.Utility.Page;
using Lib.WKF;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_TEST_Default3 : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("AA");

            dt.Rows.Add(new object[] { "AAAA" });
            dt.Rows.Add(new object[] { "BBBB" });
            dt.Rows.Add(new object[] { "CCCC" });

            Grid1.DataSource = dt;
            Grid1.DataBind();

            ExternalDllSites sites = new ExternalDllSites();

            ExternalDllSite site1 = new ExternalDllSite();
            site1.Signers.Add("Tony");
            site1.Signers.Add("May");

            ExternalDllSite site2 = new ExternalDllSite();
            site1.Signers.Add("Woodman");
            site1.Alerts.Add("Wang");

            sites.Sites.Add(site1);
            sites.Sites.Add(site2);

            sites.ConvertToXML();
            // sites.Sites.Add()

        }
    }

    protected void Grid1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            DataRowView row = (DataRowView)e.Row.DataItem;

            DropDownList DropDownList1 = (DropDownList)e.Row.FindControl("DropDownList1");
            DropDownList1.AutoPostBack = true;
       

            for (int i = 0; i < 5; i++)
            {
                DropDownList1.Items.Add(new ListItem(row["AA"].ToString()+i.ToString()));
            }

        }
    }


    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        int gridRowIndex = ((GridViewRow)((DropDownList)(sender)).NamingContainer).RowIndex;

        DropDownList DropDownList1 = (DropDownList)Grid1.Rows[gridRowIndex].FindControl("DropDownList1");
        DropDownList DropDownList2= (DropDownList)Grid1.Rows[gridRowIndex].FindControl("DropDownList2");


        DropDownList2.Items.Clear();
        for (int i = 0; i < 5; i++)
        {
            DropDownList2.Items.Add(new ListItem(DropDownList1.SelectedValue + i.ToString()));
        }
    }
}