using Ede.Uof.Utility.Page;
using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_WKF_Fields_UI_UploadImg : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((Master_DialogMasterPage)this.Master).Button2Text = "";
        ((Master_DialogMasterPage)this.Master).Button1AutoCloseWindow = false;
        ((Master_DialogMasterPage)this.Master).Button1OnClick += CDS_WKF_Fields_UI_UploadImg_Button1OnClick;

        if (!IsPostBack)
        {
            this.UC_FileCenter.LoadByFileGroup(Request["fileGroupId"]);
        }

    }

    void CDS_WKF_Fields_UI_UploadImg_Button1OnClick()
    {
        UC_FileCenter.SubmitChanges();
        Dialog.SetReturnValue2(this.UC_FileCenter.FileGroupId);
        Dialog.Close(this);

    }
}