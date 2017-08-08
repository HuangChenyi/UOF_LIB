using Ede.Uof.Utility.FileCenter.V3;
using Ede.Uof.WKF.Engine;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class CDS_TEST_Upload : System.Web.UI.Page
{
    public string themePath = "";
    protected void Page_Load(object sender, EventArgs e)
    {
//        <Form formVersionId="c086d68b-6f8c-4c13-999c-ef8a2439079b">
//  <Applicant userGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" account="Tony" name="Tony" />
//  <FormFieldValue>
//    <FieldItem fieldId="NO" fieldValue="WKF170400004" realValue="" />
//    <FieldItem fieldId="A02" fieldValue="辦公桌椅組" realValue="" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="" />
//    <FieldItem fieldId="A03" fieldValue="越南" realValue="" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="" />
//    <FieldItem fieldId="A04" fieldValue="QQ" realValue="" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="" />
//    <FieldItem fieldId="A05" fieldValue="小黃" realValue="" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="" />
//    <FieldItem fieldId="A06" fieldValue="RD" realValue="" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="" />
//    <FieldItem fieldId="A01" ConditionValue="" realValue="">
//      <FieldValue fieldGroupId="65b616de-ba1c-4a5e-9372-47c4c3111878" content="AAAAAAAAAAAAAAA" />
//    </FieldItem>
//    <FieldItem fieldId="A07" ConditionValue="" realValue="">
//      <FieldValue fieldGroupId="d4ceb539-5579-42ec-b3ec-48a72cf2ee54" content="BBBBBBBBBBBBBBBBBB" />
//    </FieldItem>
//    <FieldItem fieldId="A08" fillerName="Tony" fillerUserGuid="c496e32b-0968-4de5-95fc-acf7e5a561c0" fillerAccount="Tony" fillSiteId="">
//      <DataGrid>
//        <Row order="0">
//          <Cell fieldId="A081" fieldValue="AA" realValue="" customValue="" />
//          <Cell fieldId="A082" fieldValue="99" realValue="" customValue="" />
//          <Cell fieldId="A083" fieldValue="88" realValue="" customValue="" />
//          <Cell fieldId="A084" fieldValue="77" realValue="" customValue="" />
//          <Cell fieldId="A085" fieldValue="87" realValue="" customValue="" />
//        </Row>
//      </DataGrid>
//    </FieldItem>
//  </FormFieldValue>
//</Form>


        string taskId = Request["taskId"];

        Task task = new Task(taskId);

        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(task.CurrentDocXml);

        lblA02.Text = xmlDoc.SelectSingleNode("./Form/FormFieldValue/FieldItem[@fieldId='A02']").Attributes["fieldValue"].Value;
        lblA03.Text = xmlDoc.SelectSingleNode("./Form/FormFieldValue/FieldItem[@fieldId='A03']").Attributes["fieldValue"].Value;
        lblA04.Text = xmlDoc.SelectSingleNode("./Form/FormFieldValue/FieldItem[@fieldId='A04']").Attributes["fieldValue"].Value;
        lblA05.Text = xmlDoc.SelectSingleNode("./Form/FormFieldValue/FieldItem[@fieldId='A05']").Attributes["fieldValue"].Value;
        lblA06.Text = xmlDoc.SelectSingleNode("./Form/FormFieldValue/FieldItem[@fieldId='A06']").Attributes["fieldValue"].Value;
        // lblA07.Text = xmlDoc.SelectSingleNode("./Form/FormFieldValue/FieldItem[@fieldId='A07']").Attributes["fieldValue"].Value;


        FileGroup fg = FileCenter.GetFileGroup(xmlDoc.SelectSingleNode("./Form/FormFieldValue/FieldItem[@fieldId='A01']/FieldValue").Attributes["fieldGroupId"].Value);
        if (fg != null && fg.Count == 1)
        {
            imgA01.ImageUrl = "~/Common/FileCenter/ShowImage.aspx?id=" + fg[0].Id;
        }

        lblA01Content.Text = xmlDoc.SelectSingleNode("./Form/FormFieldValue/FieldItem[@fieldId='A01']/FieldValue").Attributes["content"].Value;

        fg = FileCenter.GetFileGroup(xmlDoc.SelectSingleNode("./Form/FormFieldValue/FieldItem[@fieldId='A07']/FieldValue").Attributes["fieldGroupId"].Value);
        if (fg != null && fg.Count == 1)
        {
            imgA07.ImageUrl = "~/Common/FileCenter/ShowImage.aspx?id=" + fg[0].Id;
        }
        lblA07Content.Text = xmlDoc.SelectSingleNode("./Form/FormFieldValue/FieldItem[@fieldId='A01']/FieldValue").Attributes["content"].Value;
       // Label1.Text = "2112";

        DataTable dt = new DataTable();
        dt.Columns.Add("A081");
        dt.Columns.Add("A082");
        dt.Columns.Add("A083");
        dt.Columns.Add("A084");
        dt.Columns.Add("A085");

        XmlNodeList nodtLst =  xmlDoc.SelectNodes("./Form/FormFieldValue/FieldItem[@fieldId='A08']/DataGrid/Row");

        foreach (XmlNode node in nodtLst)
        {
            DataRow dr = dt.NewRow();

            dr["A081"] = node.SelectSingleNode("./Cell[@fieldId='A081']").Attributes["fieldValue"].Value;
            dr["A082"] = node.SelectSingleNode("./Cell[@fieldId='A082']").Attributes["fieldValue"].Value;
            dr["A083"] = node.SelectSingleNode("./Cell[@fieldId='A083']").Attributes["fieldValue"].Value;
            dr["A084"] = node.SelectSingleNode("./Cell[@fieldId='A084']").Attributes["fieldValue"].Value;
            dr["A085"] = node.SelectSingleNode("./Cell[@fieldId='A085']").Attributes["fieldValue"].Value;

            dt.Rows.Add(dr);
        }


        GridView1.DataSource = dt;
        GridView1.DataBind();
    }
}