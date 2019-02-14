using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.EIP.Schedule.Devolve;
using Ede.Uof.EIP.Schedule.Work;
using Lib.EIP.Sch.Info;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.EIP.Sch
{
    public class DevolveUCO
    {
        public void CreateDevolve(DevolveInfo info)
        {
            DevolveManagementUCO dmData = new DevolveManagementUCO();

            DevolveDataSet devolveDs = null;
            DevolveDataSet.DevolveRow row = null;


            devolveDs = new DevolveDataSet();
            row = devolveDs.Devolve.NewDevolveRow();

            row.CREATE_TIME = info.CREATE_TIME;
            row.CREATE_USER = info.CREATE_USER;
            row.OWNER = info.OWNER;
            row.DEVOLVE_GUID = Guid.NewGuid().ToString();


            row.SOURCE_TYPE = DevolveSourceType.Self.ToString();



            row.SUBJECT = info.SUBJECT;
            row.DESCRIPTION = info.DESCRIPTION;

     

            row.USER_SET = info.USER_SET;
            row.COMP_INFO_USER_SET = info.COMP_INFO_USER_SET;
            row.DIRECTOR = info.DIRECTOR;
            row.WORK_STATE = WorkState.NotYetBegin.ToString();

            row.SetFILE_GROUP_IDNull();


          

            row.START_TIME = info.START_TIME;
            row.END_TIME = info.END_TIME;

            //row.REPEAT_GUID = "";//選擇週期,先把週期寫入
            // row.IS_REPEAT = "N";//是否重複週期
           // row.All_Day = false;


            devolveDs.Devolve.Rows.Add(row);
            dmData.CreateDevolve(devolveDs);

            return;
        }
    }
}
