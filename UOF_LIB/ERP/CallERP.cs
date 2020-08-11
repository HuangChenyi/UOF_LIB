using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERP
{
    public class CallERP
    {

        public string TIPTOPGateWay(string xml)
        {
            GetTTGateWay.TIPTOPServiceGateWayPortTypeClient tt = new GetTTGateWay.TIPTOPServiceGateWayPortTypeClient();
            return tt.TIPTOPGateWay(xml);
        }
    }


}
