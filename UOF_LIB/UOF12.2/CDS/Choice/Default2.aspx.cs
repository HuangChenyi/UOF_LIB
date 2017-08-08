using Ede.Uof.Utility.Page;
using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_Choice_Default2 : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Dialog.Open2(Button1,"~/CDS/Choice/Default3.aspx" , "" , 800,600, Dialog.PostBackType.None);
    }
}