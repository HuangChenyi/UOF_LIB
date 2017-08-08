using Ede.Uof.Utility.Page;
using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_WKF_Fields_SignPad : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

       ((Master_MobileMasterPage)this.Master).Button2Text =lblClear.Text ;
       ((Master_MobileMasterPage)this.Master).Button2ClientOnClick = "DoClear";
       ((Master_MobileMasterPage)this.Master).Button1AutoCloseWindow = false;
       ((Master_MobileMasterPage)this.Master).Button1ClientOnClick = "DoSave";
       ((Master_MobileMasterPage)this.Master).Button1OnClick += CDS_WKF_Fields_SignPad_Button1OnClick;

       ScriptManager.RegisterStartupScript(this.Page, GetType(), Guid.NewGuid().ToString(),
string.Format("setTimeout(function(){{setImg(); }}, 100);"),
true);
    }

    void CDS_WKF_Fields_SignPad_Button1OnClick()
    {
        Dialog.SetReturnValue2(txtImgTemp.Text);
        Dialog.Close(this.Page);
    }
}