using Ede.Uof.EIP.SystemInfo;
using Ede.Uof.Utility.Page;
using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Dynamic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

public partial class CDS_Form_Default : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            RadDatePicker radDateStart = (RadDatePicker)toolBar.FindItemByValue("Keyword").FindControl("radDateStart");
            RadDatePicker radDateEnd = (RadDatePicker)toolBar.FindItemByValue("Keyword").FindControl("radDateEnd");

            radDateStart.SelectedDate = DateTime.Today.AddDays(-7);
            radDateEnd.SelectedDate = DateTime.Today;
            BindGrid();
        }
    }

    private void BindGrid()
    {
        RadDatePicker radDateStart = (RadDatePicker)toolBar.FindItemByValue("Keyword").FindControl("radDateStart");
        RadDatePicker radDateEnd = (RadDatePicker)toolBar.FindItemByValue("Keyword").FindControl("radDateEnd");
        string userGuid = Current.UserGUID;
        YJ.Lib.SimulationUCO uco = new YJ.Lib.SimulationUCO();
        DataTable dt = uco.GetSimulationFormDT(radDateStart.SelectedDate.Value, radDateEnd.SelectedDate.Value, userGuid);
        grid.DataSource = dt;
        grid.DataBind();
    }
    protected void toolBar_ButtonClick(object sender, Telerik.Web.UI.RadToolBarEventArgs e)
    {
        BindGrid();
    }
    protected void grid_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grid.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    protected void grid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView row = (DataRowView)e.Row.DataItem;
            LinkButton lbtnFormNbr = (LinkButton)e.Row.FindControl("lbtnFormNbr");

            ExpandoObject param = new { TASK_ID=row["TASK_ID"].ToString() }.ToExpando();

            Dialog.Open2(lbtnFormNbr, "~WKF/FormUse/ViewForm.aspx", "", 1024, 768, Dialog.PostBackType.None, param);
        }
    }
}