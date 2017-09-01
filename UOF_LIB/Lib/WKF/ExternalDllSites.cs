using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml;


namespace Lib.WKF
{
    public class ExternalDllSites
    {
        public List<ExternalDllSite> Sites { get; set; }


        public ExternalDllSites()
        {
            Sites = new List<ExternalDllSite>();
        }
        public string  ConvertToXML()
        {
            XDocument xDoc = new XDocument();
            XElement returnValueElement = new XElement("Return");
            if (Sites.Count == 0)
            {
                XElement emptyFlowElement = new XElement("EmptyFlow");
                returnValueElement.Add(emptyFlowElement);
            }
            else
            {
                int siteSeq = 0;
                XElement flowElement = new XElement("Flow");
                foreach (var site in Sites)
                {
                    XElement siteElement = new XElement("Site" , 
                                                new XAttribute("order", siteSeq.ToString()),
                                                new XAttribute("signType" , (int) site.SignType    ));

                    XElement signersElement = new XElement("Signers");

                    foreach (var signer in site.Signers)
                    {
                        XElement signerElement = new XElement("Signer",
                            new XAttribute("account", signer));

                        signersElement.Add(signerElement);
                    }

                    XElement altertsElement = new XElement("Alerts");
                    foreach (var alert in site.Alerts)
                    {
                        XElement alertElement = new XElement("Alert",
       new XAttribute("account", alert));


                        altertsElement.Add(alertElement);

                    }

                    siteElement.Add(signersElement);
                    siteElement.Add(altertsElement);
                    siteSeq++;

                    flowElement.Add(siteElement);
                }

                returnValueElement.Add(flowElement);
            }


            return returnValueElement.ToString();
        }

    
    }

    public class ExternalDllSite
    {
        public List<string> Signers { get; set; }
        public List<string> Alerts { get; set; }

    
        public SignType SignType { get; set; }

        public ExternalDllSite()
        {
            Signers = new List<string>();
            Alerts = new List<string>();
        }
    }


    public enum SignType
    {
        General = 0,
        Or=1,
        And=2
    }
}
