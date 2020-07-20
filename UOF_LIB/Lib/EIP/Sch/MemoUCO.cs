using Ede.Uof.EIP.Schedule.Memorandum;
using Lib.EIP.Sch.Info;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.EIP.Sch
{
    public  class MemoUCO
    {
        /// <summary>
        /// 新增備忘
        /// </summary>
        /// <param name="info"></param>
        public void CreateMemo(MemoInfo info)
        {
            MemorandumManagementUCO uco = new MemorandumManagementUCO();

            //Ede.Uof.EIP.Organization.Util.UserTime.SetZone("").FromUi(DateTime.Now).ToDb();
            
            MemorandumDataSet ds = new MemorandumDataSet();
            MemorandumDataSet.MemorandumRow dr = ds.Memorandum.NewMemorandumRow();
            dr.ALL_DAY = info.ALL_DAY;//是否全天
            dr.CREATE_TIME = info.CREATE_TIME;//建立時間
            dr.CREATE_USER = info.CREATE_USER;//建立者
            dr.DESCRIPTION = info.DESCRIPTION;//說明
            dr.END_TIME = info.END_TIME;//結束時間
            dr.MEMO_GUID = System.Guid.NewGuid().ToString();//NEW GUID
            dr.OWNER = info.OWNER;//備忘擁有者
            dr.PERSONAL_TYPE = PersonalType.Display.ToString(); 
            dr.REMINDER_TIME = info.REMINDER_TIME;//提醒時間
            dr.REPEAT_GUID = "";
            dr.START_TIME = info.START_TIME;//開始時間
            dr.SUBJECT = info.SUBJECT;//標題

            ds.Memorandum.Rows.Add(dr);
            uco.CreateMemorandum(ds);

        }
    }
}
