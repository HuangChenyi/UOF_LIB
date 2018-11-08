using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.EIP.Sch.Info
{
    /// <summary>
    /// 會議資訊
    /// </summary>
    public class MettingInfo
    {
        /// <summary>
        /// 會議ID
        /// </summary>
        public string MEETING_GUID { get;set;}
        /// <summary>
        /// 建立者GUID
        /// </summary>
        public string CREATE_USER { get;set;}

       
        /// <summary>
        /// 擁有者
        /// </summary>
        public string OWNER { get;set;}
        /// <summary>
        /// 主旨
        /// </summary>
        public string SUBJECT { get;set;}
        /// <summary>
        /// 說明
        /// </summary>
        public string DESCRIPTION { get;set;}
        /// <summary>
        /// 地點
        /// </summary>
        public string LOCATION { get;set;}
        /// <summary>
        /// 是否為線上會議
        /// </summary>
        public bool IS_LIVE_MEETING { get;set;}
        /// <summary>
        /// 線上會議ID
        /// </summary>
        public string VIRTUAL_MEETING_ID { get;set;}
        /// <summary>
        /// 會議預計與會人員USERSET
        /// </summary>
        public string USER_SET { get; set; }

        /// <summary>
        /// 會議主席USERGUID
        /// </summary>
        public string CHAIR { get; set; }
        /// <summary>
        /// 附件GUID
        /// </summary>
        public string FILE_GROUP_ID { get; set; }
      
        /// <summary>
        /// 開始時間
        /// </summary>
        public DateTimeOffset START_TIME { get; set; }

        /// <summary>
        /// 結束時間
        /// </summary>
        public DateTimeOffset END_TIME { get; set; }

        /// <summary>
        /// 會議聯絡人UESRSET
        /// </summary>
        public string CONTACT_PERSON { get; set; }
    } 

    /// <summary>
    /// 備忘資訊
    /// </summary>
    public class MemoInfo
    {
        /// <summary>
        /// 是否全天
        /// </summary>
        public bool ALL_DAY { get; set; }
        /// <summary>
        /// 建立時間
        /// </summary>
        public bool CREATE_TIME { get; set; }
        /// <summary>
        /// 建立者
        /// </summary>
        public bool CREATE_USER { get; set; }
        /// <summary>
        /// 說明
        /// </summary>
        public bool DESCRIPTION { get; set; }

        /// <summary>
        /// 結束時間
        /// </summary>
        public bool END_TIME { get; set; }

        /// <summary>
        /// 備忘擁有者
        /// </summary>
        public bool OWNER { get; set; }
       
        /// <summary>
        /// 提醒時間
        /// </summary>
        public bool REMINDER_TIME { get; set; }
        ///

        /// <summary>
        /// 開始時間
        /// </summary>
        public bool START_TIME { get; set; }
        /// <summary>
        /// 標題
        /// </summary>
        public bool SUBJECT { get; set; }





        //dr.ALL_DAY//是否全天

        //dr.CREATE_TIME//建立時間
        //dr.CREATE_USER//建立者
        //dr.DESCRIPTION"";//說明
        //dr.END_TIME=//結束時間
        //dr.MEMO_GUID//NEW GUID
        //dr.OWNER //
        //dr.PERSONAL_TYPE = "Display";
        //dr.REMINDER_TIME//
        //dr.REPEAT_GUID=""
        //dr.START_TIME//
        //dr.SUBJECT//

    }
}
