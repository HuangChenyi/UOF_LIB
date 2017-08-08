using Ede.Uof.Utility.Page;
using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_LAB_WebPage_B :  BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((Master_DialogMasterPage)this.Master).Button1AutoCloseWindow = false;
        ((Master_DialogMasterPage)this.Master).Button2Text = "";
        ((Master_DialogMasterPage)this.Master).Button1OnClick += CDS_LAB_WebPage_B_Button1OnClick;
    }

    void CDS_LAB_WebPage_B_Button1OnClick()
    {
        Dialog.SetReturnValue2(txtReturnValue.Text);
        Dialog.Close(this);
    }
}