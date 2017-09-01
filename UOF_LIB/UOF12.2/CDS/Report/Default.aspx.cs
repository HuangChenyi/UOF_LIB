using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.Utility.FileCenter.V3;
using Ede.Uof.Utility.Page;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Training.Trigger;

public partial class CDS_Report_Default : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

        UserSet userSet = new UserSet();
        UserSetGroup group = new UserSetGroup();
        group.GROUP_ID = "Company";
        group.IS_DEPTH = true;
        userSet.Items.Add(group);
        Report1 rp1 = new Report1();
        //rp1.
        // rp1.ReportParameters[""]
        Telerik.Reporting.TextBox t = (Telerik.Reporting.TextBox)rp1.Items[0].Items[1];

        Telerik.Reporting.Table tb = (Telerik.Reporting.Table)rp1.Items[0].Items["table1"];

        tb.DataSource = userSet.GetUsers();
   
        t.Value = DateTime.Today.ToString("yyyy/MM.dd");
        ReportViewer1.ReportSource = rp1;
        ReportViewer1.DataBind();


    

    }
}