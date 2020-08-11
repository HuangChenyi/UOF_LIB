using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            ERP.CallERP erp = new ERP.CallERP();
           string result= erp.TIPTOPGateWay(@"<Request>
<RequestMethod>SetStatus</RequestMethod>
<LogOnInfo>
<SenderIP>::1</SenderIP>
<ReceiverIP>192.168.100.30</ReceiverIP>
<EFSiteName>EIP</EFSiteName>
<EFLogonID>T103018</EFLogonID>
<RequestContent>
<ContentText>
<Form>
<ProgramID>apmt420</ProgramID>
<PlantID>LTTW</PlantID>
<SourceFormID>AC01</SourceFormID>
<SourceFormNum>AC01-2006300001</SourceFormNum>
<Date>20/07/28</Date>
<Time>10:13:34</Time>
<Status>3</Status>
<FormCreatorID>T103018</FormCreatorID>
<FormOwnerID>T103018</FormOwnerID>
<TargetFormID>apmt420-請購單</TargetFormID>
<TargetSheetNo>AC01-2006300001</TargetSheetNo>
<Description></Description>
</Form>
</ContentText>
</RequestContent>
</LogOnInfo>
</Request>");
        }
    }
}
