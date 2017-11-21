using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Lib.EIP.SMS
{
    public class SMSUCO
    {
        public void SendSmsMessage(string SenderGuid, string Name, string Phone, string Subject, string Content, DateTimeOffset SendTime)
        {
            Ede.Uof.EIP.SMS.SMSUCO uco = new Ede.Uof.EIP.SMS.SMSUCO();

            uco.SendMessage(SenderGuid, CombineUserList(Name,Phone), SendTime, Subject,Content,true);
        }

        string CombineUserList(string Name , string Phone)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml("<UserList><Source id=\"Employ\"/><Source id=\"AddressBook\"/><Source id=\"Customer\"/><Source id=\"Manual\"/></UserList>");
            doc.SelectSingleNode("/UserList/Source[@id=\"Employ\"]").InnerXml = "<UserSet/>";
            doc.SelectSingleNode("/UserList/Source[@id=\"Customer\"]").InnerXml = "<UserSet/>";
            doc.SelectSingleNode("/UserList/Source[@id=\"AddressBook\"]").InnerXml = "<UserSet/>";

            doc.SelectSingleNode("/UserList/Source[@id=\"Manual\"]").InnerXml = GetManualXML(Name,Phone);
            return doc.OuterXml;
        }

        string GetManualXML(string Name, string Phone)
        {
            //  string[] rows = txtManual.Text.Split(System.Environment.NewLine.ToCharArray(), StringSplitOptions.RemoveEmptyEntries);

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml("<PersonList></PersonList>");





            XmlElement userElement = xmlDoc.CreateElement("Person");
            XmlAttribute nameAttribute = xmlDoc.CreateAttribute("name");
            XmlAttribute phoneAttribute = xmlDoc.CreateAttribute("phone");


            nameAttribute.Value = Name;

            phoneAttribute.Value = Phone;


            userElement.Attributes.Append(nameAttribute);
            userElement.Attributes.Append(phoneAttribute);


            XmlElement root = xmlDoc.DocumentElement;
            root.AppendChild(userElement);



            return xmlDoc.OuterXml;
        }
    }
}
