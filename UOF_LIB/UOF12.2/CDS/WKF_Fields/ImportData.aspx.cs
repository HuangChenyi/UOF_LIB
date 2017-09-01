using Ede.Uof.Utility.Page;
using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_WKF_Fields_ImportData : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((Master_DialogMasterPage)this.Master).Button2Text = "";
        ((Master_DialogMasterPage)this.Master).Button1OnClick += CDS_WKF_Fields_ImportData_Button1OnClick;
    }

    private void CDS_WKF_Fields_ImportData_Button1OnClick()
    {
        // CloseDialog
        UC_FileCenter.SubmitChanges();
        Dialog.SetReturnValue2(UC_FileCenter.FileGroupId);
        Dialog.Close(this);

    }
}