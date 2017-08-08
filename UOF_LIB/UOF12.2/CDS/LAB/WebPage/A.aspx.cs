using Ede.Uof.Utility.Page;
using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_LAB_WebPage_A : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Dialog.Open2(btnOpen , "~/CDS/LAB/WebPage/B.aspx" , "", 800,600 , Dialog.PostBackType.AfterReturn );
    }
    protected void btnOpen_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(Dialog.GetReturnValue()))
        {
            txtReturnValue.Text = Dialog.GetReturnValue();
        }
    }
}