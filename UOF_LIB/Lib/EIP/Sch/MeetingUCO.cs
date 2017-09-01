using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.EIP.Schedule.Meeting;
using Ede.Uof.Utility.FileCenter.V3;
using Lib.EIP.Sch.Info;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.EIP.Sch
{
    public class MeetingUCO
    {
        MeetingManagementUCO mmData = new MeetingManagementUCO();

        /// <summary>
        /// 建立行事曆
        /// </summary>
        /// <param name="info"></param>
        public void CreateMeeting(MettingInfo info)
        {
            MeetingDataSet meetingDs = null;
            MeetingDataSet.MeetingRow row = null;
            meetingDs = new MeetingDataSet();
            row = meetingDs.Meeting.NewMeetingRow();

            //不設定借用
            row.MEETING_GUID = info.MEETING_GUID;
            row.CREATE_USER = info.CREATE_USER;
            row.CREATE_TIME = UserTime.GetSystemNowForDb();
            row.OWNER = info.OWNER;

            //主旨
            row.SUBJECT = info.SUBJECT;
            row.DESCRIPTION = info.DESCRIPTION;

            //地點
            row.LOCATION = info.LOCATION;


            //是否為線上會議，
            row.IS_LIVE_MEETING = info.IS_LIVE_MEETING;

            if (row.IsVIRTUAL_MEETING_IDNull() || row.IS_LIVE_MEETING)
            {
                row.VIRTUAL_MEETING_ID = info.VIRTUAL_MEETING_ID;
            }

            row.USER_SET = info.USER_SET;
            row.CONTACT_PERSON = info.CONTACT_PERSON;

            //立即通知
            row.SetNOTICE_MINUTENull();

            //沒有任何密件副本
            row.CC_NOTICE_MAIL = "<UserSet />";
            row.CC_OTHER_MAIL = string.Empty;
            row.BCC_NOTICE_MAIL = "<UserSet />";
            row.BCC_OTHER_MAIL = string.Empty;

            row.CHAIR = info.CHAIR;


            row.SetREAL_ATTEND_USERNull();

            //不上傳附件
            if (!string.IsNullOrEmpty(info.FILE_GROUP_ID))
                row.SetFILE_GROUP_IDNull();
            else
                row.FILE_GROUP_ID = row.FILE_GROUP_ID;

            row.USE_BORROW_ROOM = "N";

            row.START_TIME = row.START_TIME;//開始時間
            row.END_TIME = row.END_TIME;//結束時間

            row.PERSONAL_TYPE = "Display";
            row.SetREMINDER_TIMENull();//不提醒

            row.REPEAT_GUID = string.Empty;
            row.IS_REPEAT = string.Empty;

            meetingDs.Meeting.Rows.Add(row);
            mmData.CreateMeeting(meetingDs);



        
        }
    }
}
