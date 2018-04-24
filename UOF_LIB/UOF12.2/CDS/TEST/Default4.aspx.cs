using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.Utility.Page;
using Lib.Organization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_TEST_Default4 : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        OrganizationPlus orgP = new OrganizationPlus();
        string groupId = orgP.getDeptGuid(TextBox1.Text);
        UserSet userSet = new UserSet();
        UserSetGroup userSetGroup = new UserSetGroup();
        userSetGroup.GROUP_ID = groupId;

        TextBox2.Text = groupId;
        TextBox3.Text = userSetGroup.GetGroupName();

    }
}