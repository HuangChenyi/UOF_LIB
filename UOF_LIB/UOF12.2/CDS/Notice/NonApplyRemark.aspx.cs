using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.Utility.Page;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_Notice_NonApplyRemark : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string userGuid = Request["USER_GUID"];
        UserUCO userUCO = new UserUCO();
        EBUser ebUser = userUCO.GetEBUser(userGuid);
        lblName.Text = ebUser.Name;
        lblDate.Text = Request["DATE"];
    }
    protected void toolBar_ButtonClick(object sender, Telerik.Web.UI.RadToolBarEventArgs e)
    {
        if (e.Item.Value == "Send")
        {
            UCO uco = new UCO();
            uco.InsertNoApplyData(Request["USER_GUID"], Request["DATE"], txtRemmark.Text);
            ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(), string.Format("alert('{0}');", lblSend.Text), true);
        }
    }
}

public class UCO
{

    PO m_PO = new PO();

    public void InsertNoApplyData(string userGuid, string date, string remark)
    {
        m_PO.InsertNoApplyData(userGuid, date, remark);
    }


}

public class PO :Ede.Uof.Utility.Data.BasePersistentObject
{

    internal void InsertNoApplyData(string userGuid, string date, string remark)
    {
        string cmdTxt = @"DELETE TB_WRIGLEY_NOTIC_REMRAK WHERE
                        USER_GUID=@USER_GUID AND [DATE]=DATE
                            GO
                        INSERT INTO TB_WRIGLEY_NOTIC_REMRAK
                        @USER_GUID,@DATE,@REMARK";

        this.m_db.AddParameter("USER_GUID", userGuid);
        this.m_db.AddParameter("DATE", date);
        this.m_db.AddParameter("REMARK", remark);

        this.m_db.ExecuteNonQuery(cmdTxt);

    }
}