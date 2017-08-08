using Ede.Uof.Utility.Configuration;
using Ede.Uof.Utility.Page;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_TEST_Default : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        Setting setting = new Setting();
      //  var bytes = Ede.Uof.Utility.Doc.DocConvertHelper.UrlToImage(setting ["SiteUrl"]+ "/Test/Upload.aspx", 0);

       var bytes = Ede.Uof.Utility.Doc.DocConvertHelper.UrlToImage("http://172.16.3.13/UOF_NANPAO_TRAINING/CDS/TEST/Upload.aspx", 0);

       // var bytes = Ede.Uof.Utility.Doc.DocConvertHelper.UrlToImage("http://www.google.com", 0);
        //
        //AddWatermarkToPdfWithWpf 
        //     var byte2 = WatermarkHelper.

        Response.Clear();
        Response.ClearHeaders();
        Response.ClearContent();
        Response.AddHeader("content-disposition", string.Format("{0};filename=\"{1}\"", "attachment", string.Format("123.png")));
        Response.ContentType = "application/download";
        Response.BinaryWrite(bytes);
        Response.End();
    }
}