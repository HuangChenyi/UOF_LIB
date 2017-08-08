using Ede.Uof.Utility.Page;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_MSG_Default : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        UC_ChoiceList.EditButtonOnClick += UC_ChoiceList_EditButtonOnClick;
    }

    void UC_ChoiceList_EditButtonOnClick(Ede.Uof.EIP.Organization.Util.UserSet userSet)
    {
       // throw new NotImplementedException();
    }
    protected void btnSend_Click(object sender, EventArgs e)
    {
        Ede.Uof.EIP.PrivateMessage.PrivateMessageUCO uco = new Ede.Uof.EIP.PrivateMessage.PrivateMessageUCO();
        uco.SendNewMessage("admin", txtSubject.Text,
            Ede.Uof.Utility.EditorHelper.
            ConvertEditorContentForMessage(UC_HtmlEditor.Content),
            UC_ChoiceList.XML);



    }
}