using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TestConsole
{
    class Program
    {

        /// <summary> 
        /// 經緯度取得行政區 
        /// </summary> 
        /// <returns></returns> 
        public static string latLngToChineseDistrict(params double[] latLng)
        {
            string result = string.Empty;//要回傳的字串 
            string url =
                 "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + string.Join(",", latLng) + "&sensor=true";
            string json = String.Empty;
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(url);
            //指定語言，否則Google預設回傳英文 
            request.Headers.Add("Accept-Language", "zh-tw");
            using (var response = request.GetResponse())
            {
                using (StreamReader sr = new StreamReader(response.GetResponseStream()))
                {
                    json = sr.ReadToEnd();
                }
            }

            return json;
            //GoogleGeocodingAPI.RootObject rootObj = JsonConvert.DeserializeObject<GoogleGeocodingAPI.RootObject>(json);

            //result = rootObj.results[0].address_components
            //    .Where(c => c.types[0] == "locality" && c.types[1] == "political").FirstOrDefault().long_name;

            //return result;

        }

        /// <summary> 
        /// 經緯度轉中文地址：https://developers.google.com/maps/documentation/geocoding/?hl=zh-TW#ReverseGeocoding 
        /// </summary> 
        /// <param name="latLng"></param> 
        public static string latLngToChineseAddress(params double[] latLng)
        {
            string url =
                 "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + string.Join(",", latLng) + "&sensor=true";
            string json = String.Empty;
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(url);
            //指定語言，否則Google預設回傳英文 
            request.Headers.Add("Accept-Language", "zh-tw");
            using (var response = request.GetResponse())
            {
                using (StreamReader sr = new StreamReader(response.GetResponseStream()))
                {
                    json = sr.ReadToEnd();
                }
            }

            return json;
         //   GoogleGeocodingAPI.RootObject rootObj = JsonConvert.DeserializeObject<GoogleGeocodingAPI.RootObject>(json);

            //  return rootObj.results[0].formatted_address;

        }

        static void Main(string[] args)
        {

            //double lat = Convert.ToDouble("25.0392");//緯度
            //double lng = Convert.ToDouble("121.525");//經度
            //string result = latLngToChineseAddress(lat, lng);
            //Console.Write(result);

            //return;

            FormJsonObj obj = new FormJsonObj();

            string str = "<Request>\n    <RequestMethod>CreateForm</RequestMethod>\n    <LogOnInfo>\n    <SenderIP>192.168.146.42</SenderIP>\n    <ReceiverIP>192.168.1.167</ReceiverIP>\n    <EFSiteName>EFGP</EFSiteName>\n    <EFLogonID>MIS</EFLogonID>\n    <OrgUnitID>MIS</OrgUnitID>\n    <TPServerIP>192.168.1.162</TPServerIP>\n    <TPServerEnv>toptest</TPServerEnv>\n    </LogOnInfo>\n    <RequestContent>\n    <Form>\n    <Language>Big5</Language>\n    <PlantID>IGS00</PlantID>\n    <ProgramID>apmt420</ProgramID>\n    <SourceFormID>PR1</SourceFormID>\n    <SourceFormNum>PR1-1811150001</SourceFormNum>\n   <FormCreatorID>A061225B</FormCreatorID>\n    <FormOwnerID>A061225B</FormOwnerID>\n    <ContentText>\n    <title>請購單維護作業</title>\n    <head>\n       <pmk01 type=\"0\">PR1-1811150001</pmk01>\n       <pmk02 type=\"0\">REG:原物料請購</pmk02>\n       <pmk03 type=\"1\">0</pmk03>\n       <pmk04 type=\"0\">18/11/15</pmk04>\n       <pmk05 type=\"0\"></pmk05>\n       <pmk09 type=\"0\"></pmk09>\n       <pmk10 type=\"0\"> </pmk10>\n       <pmk11 type=\"0\"> </pmk11>\n       <pmk12 type=\"0\">A061225B</pmk12>\n       <pmk13 type=\"0\">MIS</pmk13>\n       <pmk14 type=\"0\"></pmk14>\n       <pmk15 type=\"0\"></pmk15>\n       <pmk16 type=\"0\"></pmk16>\n       <pmk17 type=\"0\"></pmk17>\n       <pmk20 type=\"0\"></pmk20>\n       <pmk21 type=\"0\"></pmk21>\n       <pmk22 type=\"0\"></pmk22>\n       <pmk30 type=\"0\"></pmk30>\n       <pmk41 type=\"0\"></pmk41>\n       <pmk42 type=\"1\"></pmk42>\n       <pmk43 type=\"1\">0.0000</pmk43>\n       <pmk45 type=\"0\">Y</pmk45>\n       <pmc03 type=\"0\"></pmc03>\n       <pma02 type=\"0\"></pma02>\n       <oah02 type=\"0\"></oah02>\n       <gen02 type=\"0\">廖慧岑</gen02>\n       <gem02 type=\"0\">資管部</gem02>\n       <gem02_2 type=\"0\"></gem02_2>\n       <gen02_2 type=\"0\"></gen02_2>\n       <pmc03_2 type=\"0\"></pmc03_2>\n       <gec07 type=\"0\"></gec07>\n       <pmk40 type=\"0\"></pmk40>\n       <pja02 type=\"0\"></pja02>\n    </head>\n    <body id='pml_file_1' >\n      <record>\n       <pml02 type=\"1\">1</pml02>\n       <pml24 type=\"0\"></pml24>\n       <pml25 type=\"1\"></pml25>\n       <pml04 type=\"0\">6612-00020001</pml04>\n       <pml041 type=\"0\">EXTRA DRAW III(WIRE)</pml041>\n       <ima021 type=\"0\">PCB IC板底(傳統)+IGS外殼+(0.9M+1.5M)*1(ROHS)</ima021>\n       <pml07 type=\"0\">PCS</pml07>\n       <pmlud07 type=\"1\">1.000</pmlud07>\n       <pml20 type=\"1\">                 11</pml20>\n       <pml21 type=\"1\">                  0</pml21>\n       <pml35 type=\"0\">18/11/15</pml35>\n       <pml34 type=\"0\">18/11/15</pml34>\n       <pml33 type=\"0\">18/11/15</pml33>\n       <pml41 type=\"0\"></pml41>\n       <pml190 type=\"0\">N</pml190>\n       <pml191 type=\"0\"></pml191>\n       <pml192 type=\"0\">N</pml192>\n       <pml12 type=\"0\"></pml12>\n       <pml121 type=\"0\"></pml121>\n       <pml122 type=\"0\"></pml122>\n       <pml67 type=\"0\">MIS</pml67>\n       <pml90 type=\"0\"></pml90>\n       <pml40 type=\"0\">1211</pml40>\n       <pml401 type=\"0\"></pml401>\n       <pml31 type=\"1\"></pml31>\n       <pml31t type=\"1\"></pml31t>\n       <pml06 type=\"0\"></pml06>\n       <pml38 type=\"0\">Y</pml38>\n       <pml11 type=\"0\">N</pml11>\n       <pmlud02 type=\"0\"></pmlud02>\n       <pmlud03 type=\"0\"></pmlud03>\n      </record>\n      <record>\n       <pml02 type=\"1\">2</pml02>\n       <pml24 type=\"0\"></pml24>\n       <pml25 type=\"1\"></pml25>\n       <pml04 type=\"0\">6612-00020001</pml04>\n       <pml041 type=\"0\">EXTRA DRAW III(WIRE)</pml041>\n       <ima021 type=\"0\">PCB IC板底(傳統)+IGS外殼+(0.9M+1.5M)*1(ROHS)</ima021>\n       <pml07 type=\"0\">PCS</pml07>\n       <pmlud07 type=\"1\">2.000</pmlud07>\n       <pml20 type=\"1\">                 12</pml20>\n       <pml21 type=\"1\">                  0</pml21>\n       <pml35 type=\"0\">19/03/28</pml35>\n       <pml34 type=\"0\">18/11/15</pml34>\n       <pml33 type=\"0\">18/11/15</pml33>\n       <pml41 type=\"0\"></pml41>\n       <pml190 type=\"0\">N</pml190>\n       <pml191 type=\"0\"></pml191>\n       <pml192 type=\"0\">N</pml192>\n       <pml12 type=\"0\"></pml12>\n       <pml121 type=\"0\"></pml121>\n       <pml122 type=\"0\"></pml122>\n       <pml67 type=\"0\">MIS</pml67>\n       <pml90 type=\"0\"></pml90>\n       <pml40 type=\"0\">1211</pml40>\n       <pml401 type=\"0\"></pml401>\n       <pml31 type=\"1\"></pml31>\n       <pml31t type=\"1\"></pml31t>\n       <pml06 type=\"0\"></pml06>\n       <pml38 type=\"0\">Y</pml38>\n       <pml11 type=\"0\">N</pml11>\n       <pmlud02 type=\"0\"></pmlud02>\n       <pmlud03 type=\"0\"></pmlud03>\n      </record>\n      <record>\n       <pml02 type=\"1\">3</pml02>\n       <pml24 type=\"0\"></pml24>\n       <pml25 type=\"1\"></pml25>\n       <pml04 type=\"0\">6612-00020001</pml04>\n       <pml041 type=\"0\">EXTRA DRAW III(WIRE)</pml041>\n       <ima021 type=\"0\">PCB IC板底(傳統)+IGS外殼+(0.9M+1.5M)*1(ROHS)</ima021>\n       <pml07 type=\"0\">PCS</pml07>\n       <pmlud07 type=\"1\">3.000</pmlud07>\n       <pml20 type=\"1\">                 13</pml20>\n       <pml21 type=\"1\">                  0</pml21>\n       <pml35 type=\"0\">19/03/28</pml35>\n       <pml34 type=\"0\">19/03/28</pml34>\n       <pml33 type=\"0\">19/03/28</pml33>\n       <pml41 type=\"0\"></pml41>\n       <pml190 type=\"0\">N</pml190>\n       <pml191 type=\"0\"></pml191>\n       <pml192 type=\"0\">N</pml192>\n       <pml12 type=\"0\"></pml12>\n       <pml121 type=\"0\"></pml121>\n       <pml122 type=\"0\"></pml122>\n       <pml67 type=\"0\">MIS</pml67>\n       <pml90 type=\"0\"></pml90>\n       <pml40 type=\"0\">1211</pml40>\n       <pml401 type=\"0\"></pml401>\n       <pml31 type=\"1\"></pml31>\n       <pml31t type=\"1\"></pml31t>\n       <pml06 type=\"0\"></pml06>\n       <pml38 type=\"0\">Y</pml38>\n       <pml11 type=\"0\">N</pml11>\n       <pmlud02 type=\"0\"></pmlud02>\n       <pmlud03 type=\"0\"></pmlud03>\n      </record>\n    </body>\n    <memo>\n      <record>\n        <pmo04>1:在後</pmo04>\n        <pmo05>1</pmo05>\n        <pmo06>TEST111</pmo06>\n      </record>\n      <record>\n        <pmo04>1:在後</pmo04>\n        <pmo05>2</pmo05>\n        <pmo06>TEST222</pmo06>\n      </record>\n    </memo>    <attachment>\n        <document type=\"HTTP\" desc=\"181115TEST\" content=\"DOC-16108-20181115-122842.txt\" filename=\"TEST.txt\" owner=\"A061225B\"  />\n        <document type=\"URL\" desc=\"1122-00002600 AFE-2020-黑色飾網.pdf\" content=\"\\\\tiptop\\IMA_File\\1122-00002600\\1122-00002600 AFE-2020-黑色飾網.pdf\" filename=\"\" owner=\"A061225B\"  />\n        <document type=\"TXT\" desc=\"181115TXT\" content=\"181115TXT\" filename=\"\" owner=\"A061225B\"  />\n    </attachment>\n   </ContentText>\n  </Form>\n </RequestContent>\n</Request>";

            XDocument doc = XDocument.Parse(str);


            GetVersionXML(doc);





            //隱藏欄位
            FieldJsonObj field = new FieldJsonObj() { FieldID = "PlantID", Width = "", Height = "" };
            obj.HiddenColumns.Add(field);
            field = new FieldJsonObj() { FieldID = "ProgramID", Width = "", Height = "" };
            obj.HiddenColumns.Add(field);
            field = new FieldJsonObj() { FieldID = "SourceFormID", Width = "", Height = "" };
            obj.HiddenColumns.Add(field);
            field = new FieldJsonObj() { FieldID = "SourceFormNum", Width = "", Height = "" };
            obj.HiddenColumns.Add(field);

            //表單Header欄位
            foreach (var node in doc.Element("Request").Element("RequestContent").Element("Form").Element("ContentText").Element("head").Elements())
            {
                ColumnsJsonObj col = new ColumnsJsonObj();
                field = new FieldJsonObj() { FieldID = node.Name.LocalName, Width = "", Height = "" };
                col.Columns.Add(field);

                obj.Rows.Add(col);
            }

            //表單Detail欄位
            foreach (var node in doc.Element("Request").Element("RequestContent").Element("Form").Element("ContentText").Elements("body"))
            {
                ColumnsJsonObj col = new ColumnsJsonObj();
                field = new FieldJsonObj() { FieldID = node.Attribute("id").Value, Width = "", Height = "" };
                col.Columns.Add(field);

                obj.Rows.Add(col);
            }

            //LAY OUT
            //  Console.WriteLine(JsonConvert.SerializeObject(obj).ToString());

           Console.Write(  GetVersionXML(doc));
        }

        private static string GetVersionXML(XDocument doc)
        {
            string hiddenFieldStr = "<FieldItem fieldId=\"A02\" fieldName=\"BB\" fieldSeq=\"6\" fieldType=\"hiddenField\" fieldRemark=\"\" DisplayLength=\"0\" DecimalPoint=\"0\" displayFieldName=\"True\" externalData=\"\" wsUrl=\"\" wsMethod=\"\" wsAuth=\"\" wsAccount=\"\" wsPassword=\"\" wsSystemValueSend=\"\" wsFormValueSend=\"\" wsGetBeforeTime=\"\" wsVariation=\"\" delFlag=\"True\" />";
            string singleLineFieldStr = @"
  <FieldItem fieldId=""A01"" fieldName=""AA"" fieldSeq=""4"" fieldType=""singleLineText"" fieldRemark="""" DisplayLength=""0"" DecimalPoint=""0"" displayFieldName=""True"" externalData=""False"" wsUrl="""" wsMethod="""" wsAuth=""False"" wsAccount="""" wsPassword="""" wsSystemValueSend="""" wsFormValueSend="""" wsGetBeforeTime=""False"" wsVariation=""False"" delFlag=""True"" fieldLength=""50"" fieldDefault="""" fieldModify=""yes"">
    <fieldControlData fieldControlFlag=""yes"" />
    <fieldModifyData Flag=""accede"" />
    <allowApplicentUser Flag=""False"" />
    <allowOtherUser Flag=""False"" />
    <visibleControl Flag=""NoLimit"" />
    <visibleUser Flag=""&lt;UserSet&gt;&lt;/UserSet&gt;"" Filler=""False"" />
  </FieldItem>";

            string numberFieldStr = @"
  <FieldItem fieldId=""amount"" fieldName=""金額"" fieldSeq=""3"" fieldType=""numberText"" fieldRemark="""" DisplayLength=""0"" DecimalPoint=""0"" displayFieldName=""True"" externalData=""False"" wsUrl="""" wsMethod="""" wsAuth=""False"" wsAccount="""" wsPassword="""" wsSystemValueSend="""" wsFormValueSend="""" wsGetBeforeTime=""False"" wsVariation=""False"" delFlag=""True"" fieldRangeMin=""0"" fieldRangeMax=""9999999"" fieldDefault="""" fieldModify=""yes"" EnabledDecimalPoint=""False"">
    <fieldControlData fieldControlFlag=""no"" />
    <fieldModifyData Flag=""accede"" />
    <allowApplicentUser Flag=""False"" />
    <allowOtherUser Flag=""False"" />
    <visibleControl Flag=""NoLimit"" />
    <visibleUser Flag=""&lt;UserSet&gt;&lt;/UserSet&gt;"" Filler=""False"" />
  </FieldItem>
";

            string dataGridFieldStr = @"
 <FieldItem fieldId=""A03"" fieldName=""CC"" fieldSeq=""5"" fieldType=""dataGrid"" fieldRemark="""" DisplayLength=""0"" DecimalPoint=""0"" displayFieldName=""True"" externalData="""" wsUrl="""" wsMethod="""" wsAuth="""" wsAccount="""" wsPassword="""" wsSystemValueSend="""" wsFormValueSend="""" wsGetBeforeTime="""" wsVariation="""" delFlag=""True"" DataGridWidth=""0"">
    <dataGrid>
    </dataGrid>
    <fieldModifyData Flag=""accede"" />
    <allowApplicentUser Flag=""False"" />
    <allowOtherUser Flag=""False"" />
    <fieldControlData fieldControlFlag=""yes"" />
    <visibleControl Flag=""NoLimit"" />
    <visibleUser Flag=""&lt;UserSet&gt;&lt;/UserSet&gt;"" Filler=""False"" />
  </FieldItem>
";

            string dataGridSingleLineFieldStr = @"
  <DataGridItem fieldId=""A031"" fieldName=""C1"" fieldSeq=""0"" fieldType=""singleLineText"" fieldRemark="""" DisplayLength=""0"" DecimalPoint=""0"" displayFieldName=""True"" externalData=""False"" wsUrl="""" wsMethod="""" wsAuth=""False"" wsAccount="""" wsPassword="""" wsSystemValueSend="""" wsFormValueSend="""" wsGetBeforeTime=""False"" wsVariation=""False"" delFlag=""True"" fieldLength=""50"" fieldDefault="""" fieldModify=""yes"">
        <fieldControlData fieldControlFlag=""yes"" />
        <fieldModifyData Flag=""accede"" />
        <allowApplicentUser Flag=""False"" />
        <allowOtherUser Flag=""False"" />
        <visibleControl Flag=""NoLimit"" />
        <visibleUser Flag=""&lt;UserSet&gt;&lt;/UserSet&gt;"" Filler=""False"" />
      </DataGridItem>
";

            string dataGridNumberFieldStr = @"
 <DataGridItem fieldId=""A032"" fieldName=""CCC"" fieldSeq=""1"" fieldType=""numberText"" fieldRemark="""" DisplayLength=""0"" DecimalPoint=""0"" displayFieldName=""True"" externalData=""False"" wsUrl="""" wsMethod="""" wsAuth=""False"" wsAccount="""" wsPassword="""" wsSystemValueSend="""" wsFormValueSend="""" wsGetBeforeTime=""False"" wsVariation=""False"" delFlag=""True"" fieldRangeMin=""0"" fieldRangeMax=""999999"" fieldDefault="""" fieldModify=""yes"" EnabledDecimalPoint=""False"">
        <fieldControlData fieldControlFlag=""yes"" />
        <fieldModifyData Flag=""accede"" />
        <allowApplicentUser Flag=""False"" />
        <allowOtherUser Flag=""False"" />
        <visibleControl Flag=""NoLimit"" />
        <visibleUser Flag=""&lt;UserSet&gt;&lt;/UserSet&gt;&#xD;&#xA;"" Filler=""False"" />
      </DataGridItem>
";


            XElement xe = new XElement("VersionField");
            int fieldseq = 0;
            //表單Header欄位
            foreach (var node in doc.Element("Request").Element("RequestContent").Element("Form").Element("ContentText").Element("head").Elements())
            {
                XElement field = null;
                switch(node.Attribute("type").Value)
                {
                    case "0":
                        field = XElement.Parse(singleLineFieldStr);
                        break;
                    case "1":
                        field = XElement.Parse(numberFieldStr);
                        break;
                }

                field.Attribute("fieldId").Value = node.Name.LocalName;
                field.Attribute("fieldName").Value = node.Name.LocalName;
                field.Attribute("fieldSeq").Value = fieldseq.ToString();
                fieldseq++;

                xe.Add(field);
            }

            //表單明細欄位
            foreach (var node in doc.Element("Request").Element("RequestContent").Element("Form").Element("ContentText").Elements("body"))
            {
                XElement field = XElement.Parse(dataGridFieldStr);

                field.Attribute("fieldId").Value = node.Attribute("id").Value;
                field.Attribute("fieldName").Value = node.Attribute("id").Value;
                int detailfieldseq = 0;
                foreach (var detailNode in node.Element("record").Elements())
                {
                    XElement detailField = null;
                    switch (detailNode.Attribute("type").Value)
                    {
                        case "0":
                            detailField = XElement.Parse(dataGridSingleLineFieldStr);
                            break;
                        case "1":
                            detailField = XElement.Parse(dataGridNumberFieldStr);
                            break;
                    }

                    detailField.Attribute("fieldId").Value = node.Name.LocalName;
                    detailField.Attribute("fieldName").Value = node.Name.LocalName;
                    detailField.Attribute("fieldSeq").Value = detailfieldseq.ToString();
                    detailfieldseq++;

                    field.Element("dataGrid").Add(detailField);
                }

                xe.Add(field);

            }

            return xe.ToString();
        }
    }

    public class FormJsonObj
    {
        public List<FieldJsonObj> HiddenColumns { get; set; }
        public List<ColumnsJsonObj> Rows { get; set; }

        public FormJsonObj() {
            HiddenColumns = new List<FieldJsonObj>();
            Rows = new List<ColumnsJsonObj>();
        }
    }

    public class ColumnsJsonObj
    {
        public List<FieldJsonObj> Columns {get;set;}

        public ColumnsJsonObj()
        {
            Columns = new List<FieldJsonObj>();
        }
    }

    public class FieldJsonObj
    {
        public string VersionField { get;set;}
        public string FieldID { get;set;}
        public string Width { get;set;}
        public string Height { get; set; }

    }



}
