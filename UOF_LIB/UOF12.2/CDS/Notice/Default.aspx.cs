using Ede.Uof.Utility.Configuration;
using Ede.Uof.Utility.Page;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_Notice_Default : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        { 
            Setting setting= new Setting();

            if (!string.IsNullOrEmpty(setting["WrigleyNoticeDay"]))
            {
                rnumDay.Value = Convert.ToDouble(setting["WrigleyNoticeDay"]);

            }
            else
            {
                rnumDay.Value = 14;
            }


            if (!string.IsNullOrEmpty(setting["WrigleyNoticOverHours"]))
            {
                rnumHours.Value = Convert.ToDouble(setting["WrigleyNoticOverHours"]);

            }
            else
            {
                rnumHours.Value = 1;
            }

            txtPath.Text = setting["WrigleyNoticOverExportPath"];
        }
    }
    protected void toolBar_ButtonClick(object sender, Telerik.Web.UI.RadToolBarEventArgs e)
    {
        if (e.Item.Value == "Save")
        {Setting
             setting = new Setting();

            setting["WrigleyNoticOverHours"] = rnumHours.Value.ToString();
            setting["WrigleyNoticeDay"] = rnumDay.Value.ToString();
            setting["WrigleyNoticOverExportPath"] = txtPath.Text;
        }
    }
}