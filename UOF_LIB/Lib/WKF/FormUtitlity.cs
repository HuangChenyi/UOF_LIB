using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Lib.WKF
{
    public class FormUtitlity
    {
        public XmlDocument XmlDoc { get; set; }

        public XmlElement GetFormInfoXmlCode(string formversionId, string urgentLevel)
        {



            //urgentLevel 緊急程度0:緊急 1:急 2:普通

            XmlElement formElement = XmlDoc.CreateElement("Form");
            formElement.SetAttribute("formVersionId", formversionId);
            formElement.SetAttribute("urgentLevel", urgentLevel);


            return formElement;

        }

        public XmlElement GetApplicantXmlCode(string applicant, string groupId, string titleId, string common, string filePath)
        {


            XmlElement applicantElement = XmlDoc.CreateElement("Applicant");

            //<!--account:申請者UOF帳號 groupId部門代號(可不填) jobTitleId:職稱代號(可不填)-->
            applicantElement.SetAttribute("account", applicant);
            applicantElement.SetAttribute("groupId", groupId);
            applicantElement.SetAttribute("jobTitleId", titleId);

            //申請者意見
            XmlElement commentElement = XmlDoc.CreateElement("Comment");
            commentElement.InnerText = common;

            applicantElement.AppendChild(commentElement);

            if (filePath != "")
            {

                XmlElement appachElement = XmlDoc.CreateElement("Attach");
                appachElement.SetAttribute("IsNeedTransfer", "true");
                appachElement.SetAttribute("IsDeleteTemp", "true");

                //如果多個附件請加入多個AttachItem
                XmlElement attachItemElement = XmlDoc.CreateElement("AttachItem");
                //放置檔案路徑(appSettings/wkfFileTransferTemp)
                attachItemElement.SetAttribute("filePath", filePath);

                appachElement.AppendChild(attachItemElement);
                applicantElement.AppendChild(appachElement);

            }
            return applicantElement;
        }
    }
    
}
