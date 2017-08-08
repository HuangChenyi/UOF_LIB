using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ede.Uof.Utility.Page.Common;
using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.EIP.Schedule.Meeting;
using Ede.Uof.EIP.Schedule.Work;
using Ede.Uof.Utility.Configuration;
using Ede.Uof.Utility.FileCenter.V3;
using Ede.Uof.EIP.SystemInfo;
using Ede.Uof.Utility.Page;

public partial class CDS_Choice_Default3 : BasePage
{
    MeetingManagementUCO mmDataUCO = new MeetingManagementUCO();
    InquiryManagementUCO inquiryUco = new InquiryManagementUCO();
    protected void Page_Load(object sender, EventArgs e)
    {
        ((Master_DialogMasterPage)this.Master).Button1OnClick += new Master_DialogMasterPage.ButtonOnClickHandler(EIP_Calendar_CreateMoreMeeting_Button1OnClick);
        ((Master_DialogMasterPage)this.Master).Button2Text = string.Empty;
        UC_BtnChoiceOnce1.EditButtonOnClick += new Common_ChoiceCenter_UC_BtnChoiceOnce.ButtonOnClickHandler(UC_BtnChoiceOnce1_EditButtonOnClick);
        UC_FileCenter.ModuleName = Module.EIP;
        if (!IsPostBack)
        {
            UC_RepeatRange1.InitControl();

            UC_BtnChoiceOnce1.ButtonText = lblChair.Text;

            lbOwnerGuid.Text = "admin";
            SetCreatorUserName(User.Identity.Name);
            SetChairName(lbOwnerGuid.Text);
            SetDefaultData();
        }
    }

    private void SetDefaultData()
    {
        hfCurrentUser.Value = Current.UserGUID;

        if (Request["Date"] != null)
        {
            DateTime initDate = Convert.ToDateTime(Request["Date"]);
            rdpDateStart.SelectedDate = initDate;
            rtpTimeStart.SelectedDate = initDate;
            rtpTimeEnd.SelectedDate = initDate.AddHours(1);
        }
        else
        {
            DateTimeOffset initDate = UserTime.SetZone(hfCurrentUser.Value).GetNowForUi();
            rdpDateStart.SelectedDate = initDate.Date;
            rtpTimeStart.SelectedDate = initDate.DateTime;
            rtpTimeEnd.SelectedDate = initDate.AddHours(1).DateTime;
        }

        Setting setting = new Setting();
        lblMeetingRepeatLimit.Visible = false;
        if (!string.IsNullOrEmpty(setting["EnableMeetingLimit"]))
        {
            if (bool.Parse(setting["EnableMeetingLimit"]))
            {
                UC_RepeatRange1.SetMaxDay = Convert.ToInt32(setting["MeetingRepeatLimit"]);

                lblMeetingRepeatLimit.Visible = true;
                if (Convert.ToInt32(setting["MeetingRepeatLimit"]) != 0)
                    lblMeetingRepeatLimit.Text = string.Format(lblMsg1.Text, setting["MeetingRepeatLimit"]);
                else if (Convert.ToInt32(setting["MeetingRepeatLimit"]) == 0)
                    lblMeetingRepeatLimit.Text = lblMsg2.Text;
                lblMeetingRepeatLimit.ForeColor = System.Drawing.Color.Blue;
            }
        }
    }

    void EIP_Calendar_CreateMoreMeeting_Button1OnClick()
    {
        if (Save())
        {
            Dialog.SetReturnValue2("CreateMeeting");
        }
    }

    private bool Save()
    {
        if (lblSelChair.Text == string.Empty || lblSelChairGUID.Text == string.Empty)
        {
            cvCheckChair.IsValid = false;
            return false;
        }

        if (UC_ChoiceList1.UserSet.Items.Count == 0)
        {
            CustomValidator1.IsValid = false;
            return false;
        }

        if (rdpDateStart.SelectedDate == null)
        {
            CustomValidator4.IsValid = false;
            return false;
        }

        if (rtpTimeStart.SelectedDate != null && rtpTimeEnd.SelectedDate != null)
        {

            if (rtpTimeEnd.SelectedTime.Value < rtpTimeStart.SelectedTime.Value)
            {
                CustomValidator7.IsValid = false;
                return false;
            }
        }

        if (UC_RepeatRange1.RepeatType == 0)
        {
            CustomValidator8.IsValid = false;
            return false;
        }

        string orignalChair = "";
        MeetingDataSet meetingDs = new MeetingDataSet();
        string repeatGuid = InsertRepeatData(meetingDs);
        MeetingDataSet.MeetingRow meetingRow = meetingDs.Meeting.NewMeetingRow();
        string meetingGuid = Guid.NewGuid().ToString();
        meetingRow.MEETING_GUID = meetingGuid;
        meetingRow.CREATE_USER = hfCurrentUser.Value;
        meetingRow.CREATE_TIME = UserTime.SetZone(hfCurrentUser.Value).GetNowForDb();
        meetingRow.OWNER = lbOwnerGuid.Text;
        meetingRow.SUBJECT = txbSubject.Text;
        meetingRow.DESCRIPTION = txbDescription.Text;
        meetingRow.LOCATION = txbLocation.Text;
        meetingRow.IS_LIVE_MEETING = false;
        meetingRow.VIRTUAL_MEETING_ID = string.Empty;
        meetingRow.USER_SET = UC_ChoiceList1.XML;
        meetingRow.CONTACT_PERSON = UC_ChoiceList3.XML;
        if (string.IsNullOrEmpty(lblSelChairGUID.Text))
            meetingRow.SetCHAIRNull();
        else
            meetingRow.CHAIR = lblSelChairGUID.Text;

        meetingRow.SetREAL_ATTEND_USERNull();
        if (UC_FileCenter.GetCurrentFileCount() <= 0)
            meetingRow.SetFILE_GROUP_IDNull();
        else
            meetingRow.FILE_GROUP_ID = UC_FileCenter.FileGroupId;

        DateTime startDate = DateTime.Parse(rdpDateStart.SelectedDate.Value.ToShortDateString() + " " + rtpTimeStart.SelectedDate.Value.ToShortTimeString());
        DateTime endDate = DateTime.Parse(rdpDateStart.SelectedDate.Value.ToShortDateString() + " " + rtpTimeEnd.SelectedDate.Value.ToShortTimeString());
        meetingRow.START_TIME = UserTime.SetZone(hfCurrentUser.Value).FromUi(startDate).ToDb();
        meetingRow.END_TIME = UserTime.SetZone(hfCurrentUser.Value).FromUi(endDate).ToDb();

        if (lbOwnerGuid.Text != orignalChair || orignalChair == meetingRow.OWNER)
        {
            meetingRow.PERSONAL_TYPE = UC_PrivateEvent1.SelectedValue;
            if (UC_RemindTime1.SelectedItem == 1)
            {
                int addMinutes = Convert.ToInt32(UC_RemindTime1.SelectedRemindTime);
                meetingRow.REMINDER_TIME = meetingRow.START_TIME.AddMinutes(-addMinutes);
            }
            else
            {
                meetingRow.SetREMINDER_TIMENull();
            }
        }
        meetingRow.USE_BORROW_ROOM = "N";
        meetingRow.REPEAT_GUID = repeatGuid;
        meetingRow.IS_REPEAT = "N";

        //會議開始前幾分鐘發通知(NULL或空白為立即通知)
        int? noticeminute = null;
        if (rbNoticeBefore.Checked)
        {
            meetingRow.NOTICE_MINUTE = Convert.ToInt16(ddlNoticeTime.SelectedValue);
            noticeminute = Convert.ToInt16(ddlNoticeTime.SelectedValue);
        }

        meetingDs.Meeting.Rows.Add(meetingRow);
        UC_FileCenter.SubmitChanges();
        mmDataUCO.CreateMeeting(meetingDs);
        lbMeetingGuid.Text = meetingRow.MEETING_GUID;

        MeetingDataSet getMeetingDS = mmDataUCO.GetSingleMeeting(meetingGuid);
        //UC_Repeart_Range的結束日期沒有時間格式, 因為跟工作,備忘...等共用, 處理週期的方式不太相同, 所以在個別頁面自行處理RepeatDate
        MeetingDataSet getRepeatRangeDS = mmDataUCO.GetMeetingRepeatRangeData(hfCurrentUser.Value, startDate, UC_RepeatRange1.RepeatDate);
        foreach (MeetingDataSet.RepeatMeetingRow row in getRepeatRangeDS.RepeatMeeting.Rows)
        {
            DateTime dateOffset = UserTime.SetZone(Current.UserGUID).FromDb(row.START_TIME).ToDateTime().Date;
            if (row.START_TIME > meetingRow.START_TIME && dateOffset <= UC_RepeatRange1.RepeatDate)
            {
                MeetingDataSet tonewMeetingDS = new MeetingDataSet();
                MeetingDataSet.MeetingRow oneRow = (MeetingDataSet.MeetingRow)getMeetingDS.Meeting.Rows[0];
                MeetingDataSet.MeetingRow batchRow = tonewMeetingDS.Meeting.NewMeetingRow();
                batchRow.ItemArray = oneRow.ItemArray;
                batchRow.MEETING_GUID = Guid.NewGuid().ToString();
                batchRow.START_TIME = row.START_TIME;
                batchRow.END_TIME = row.END_TIME;
                batchRow.REPEAT_GUID = string.Empty;
                batchRow.IS_REPEAT = "Y";
                if (!meetingRow.IsREMINDER_TIMENull())
                    batchRow.REMINDER_TIME = meetingRow.REMINDER_TIME;

                tonewMeetingDS.Meeting.Rows.Add(batchRow);
                mmDataUCO.CreateMeeting(tonewMeetingDS);
            }
        }
        mmDataUCO.UpdateMeetingRepeatStatus(meetingGuid, "Y");
        if (lbOwnerGuid.Text != hfCurrentUser.Value)
        {
            string createUser = hfCurrentUser.Value;
            DateTime meetStartDate = DateTime.Parse(rdpDateStart.SelectedDate.Value.ToShortDateString() + " " + rtpTimeStart.SelectedDate.Value.ToShortTimeString());
            DateTime meetEndDate = DateTime.Parse(rdpDateStart.SelectedDate.Value.ToShortDateString() + " " + rtpTimeEnd.SelectedDate.Value.ToShortTimeString());
            mmDataUCO.SendNewMeetingMessageByOther(UserTime.SetZone(hfCurrentUser.Value).FromUi(meetStartDate).ToDb(), UserTime.SetZone(hfCurrentUser.Value).FromUi(meetEndDate).ToDb(), txbSubject.Text, txbDescription.Text, createUser, lbOwnerGuid.Text, noticeminute, meetingGuid);
        }
        return true;



    }

    /// <summary>
    /// 新增批次會議資料
    /// </summary>
    /// <param name="workDS"></param>
    /// <returns></returns>
    private string InsertRepeatData(MeetingDataSet meetingDS)
    {
        string repeatGuid = Guid.NewGuid().ToString();
        MeetingDataSet.RepeatRow reapeatRow;
        switch ((int)UC_RepeatRange1.RepeatType)
        {
            case 1://每日
                reapeatRow = meetingDS.Repeat.NewRepeatRow();
                reapeatRow.REPEAT_GUID = repeatGuid;
                reapeatRow.REPEAT_TYPE = RepeatType.EveryDay.ToString();
                reapeatRow.IS_EXPIRE = true;
                reapeatRow.EXPIRE_DATE = UC_RepeatRange1.RepeatDate;
                meetingDS.Repeat.Rows.Add(reapeatRow);
                break;
            case 2: //每週
                reapeatRow = meetingDS.Repeat.NewRepeatRow();
                reapeatRow.REPEAT_GUID = repeatGuid;
                reapeatRow.REPEAT_TYPE = RepeatType.EveryWeek.ToString();
                reapeatRow.IS_EXPIRE = true;
                reapeatRow.EXPIRE_DATE = UC_RepeatRange1.RepeatDate;
                meetingDS.Repeat.Rows.Add(reapeatRow);
                MeetingDataSet.RepeatWeekRow RWR = meetingDS.RepeatWeek.NewRepeatWeekRow();
                RWR.REPEAT_GUID = repeatGuid;
                int[] dayarry = UC_RepeatRange1.WeekDayArray;
                if (dayarry != null)
                {
                    for (int i = 0; i < dayarry.Length; i++)
                    {
                        if (dayarry[i] == 0)
                            RWR.SUNDAY = true;
                        else if (dayarry[i] == 1)
                            RWR.MONDAY = true;
                        else if (dayarry[i] == 2)
                            RWR.TUESDAY = true;
                        else if (dayarry[i] == 3)
                            RWR.WEDNESDAY = true;
                        else if (dayarry[i] == 4)
                            RWR.THURSDAY = true;
                        else if (dayarry[i] == 5)
                            RWR.FRIDAY = true;
                        else
                            RWR.SATURDAY = true;
                    }

                    RWR.INTERVAL_WEEKS = (int)UC_RepeatRange1.WeekInterval;
                    meetingDS.RepeatWeek.Rows.Add(RWR);
                }
                break;
            case 3://每月
                reapeatRow = meetingDS.Repeat.NewRepeatRow();
                reapeatRow.REPEAT_GUID = repeatGuid;
                reapeatRow.REPEAT_TYPE = RepeatType.EveryMonth.ToString();
                reapeatRow.IS_EXPIRE = true;
                reapeatRow.EXPIRE_DATE = UC_RepeatRange1.RepeatDate;
                meetingDS.Repeat.Rows.Add(reapeatRow);
                MeetingDataSet.RepeatMonthRow RMR = meetingDS.RepeatMonth.NewRepeatMonthRow();
                RMR.REPEAT_GUID = repeatGuid;
                if (UC_RepeatRange1.MonthRepeatSetting == 1)
                {
                    RMR.IS_THE_SAME_DAY = true;
                }
                else
                {
                    RMR.IS_THE_SAME_DAY = false;
                    RMR.ORDERS = (int)UC_RepeatRange1.MonthWeekOrder;
                    RMR.WEEK_DAY = (int)UC_RepeatRange1.MonthWeekDay;
                }
                meetingDS.RepeatMonth.Rows.Add(RMR);
                break;
        }
        mmDataUCO.CreateRepeatRangeData(meetingDS);

        return repeatGuid;
    }

    /// <summary>
    /// 選主席
    /// </summary>
    /// <param name="choiceResult"></param>
    void UC_BtnChoiceOnce1_EditButtonOnClick(string[] choiceResult)
    {
        if (choiceResult.Length >= 1)
        {
            if (!string.IsNullOrEmpty(choiceResult[0]))
            {
                UserUCO userUCO = new UserUCO();
                EBUser ebUser = userUCO.GetEBUser(choiceResult[0]);
                lblSelChair.Text = ebUser.Name;
                lblSelChairGUID.Text = choiceResult[0];
            }
            else
            {
                cvCheckChair.IsValid = false;
                lblSelChair.Text = string.Empty;
                lblSelChairGUID.Text = string.Empty;
            }
        }
    }

    /// <summary>
    /// 建立人員
    /// </summary>
    /// <param name="userGuid">登入者GUID</param>
    private void SetCreatorUserName(string userGuid)
    {
        UserUCO userData = new UserUCO();
        EBUser user = userData.GetEBUser(userGuid);
        lbCreateUser.Text = user.DisplayNameWithLink;
        lbUserGuid.Text = userGuid;
    }
    /// <summary>
    /// 主席
    /// </summary>
    /// <param name="userGuid">登入者GUID</param>
    private void SetChairName(string userGuid)
    {
        lblSelChairGUID.Text = userGuid;
        UserUCO userUCO = new UserUCO();
        EBUser ebUser = userUCO.GetEBUser(userGuid);
        lblSelChair.Text = ebUser.Name;
    }
}