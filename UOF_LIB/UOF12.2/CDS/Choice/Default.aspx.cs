using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.Utility.Page.Common;

public partial class CDS_Choice_Default : Ede.Uof.Utility.Page.BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        UC_ChoiceList1.EditButtonOnClick += UC_ChoiceList1_EditButtonOnClick;
        UC_ChoiceList2.EditButtonOnClick += UC_ChoiceList2_EditButtonOnClick;

    






    }

    void UC_ChoiceList2_EditButtonOnClick(Ede.Uof.EIP.Organization.Util.UserSet userSet)
    {
        TextBox2.Text = userSet.GetXML();
    }

    void UC_ChoiceList1_EditButtonOnClick(Ede.Uof.EIP.Organization.Util.UserSet userSet)
    {
        TextBox1.Text = userSet.GetXML();
    }
}