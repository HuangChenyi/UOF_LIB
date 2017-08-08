using Aspose.Cells;
using Ede.Uof.EIP.Duty;
using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.EIP.Security;
using Ede.Uof.Utility.Configuration;
using Ede.Uof.Utility.Page;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_Default2 : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //資料來源為結算
        //免刷卡人員??
        //TABLE NAME??
  
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        UCO uco = new UCO();
        //c06dcb6e-dfcf-4714-adaf-8bead49b6731
        //11521b7d-9dae-415f-822b-e4ea73ee4e8d
        //9dbf9b61-b1f6-4874-8d06-fc157b390e9c
       

        DataTable dt = new DataTable();
        dt.Columns.Add("USER_GUID");//員工
        dt.Columns.Add("USER_NAME");//員工
        dt.Columns.Add("DATE");//日期
        dt.Columns.Add("WORK_HOURS");//應有工時
        dt.Columns.Add("WORK_TIME");//簽到
        dt.Columns.Add("OFF_TIME");//簽退
        dt.Columns.Add("LEAVE_TIME");//請假時間
        dt.Columns.Add("LEAVE_HOURS");//請假時數
        dt.Columns.Add("PUNCH_HOUR");//刷卡工時 
        dt.Columns.Add("IS_ABSENT");//是否曠職
        dt.Columns.Add("NEED_PUNCH");//補刷卡
        dt.Columns.Add("NEED_LEAVE");//需請假
        dt.Columns.Add("NEED_OVERTIME");//需加班

        UserSet userSet = new UserSet();
        //UserSetGroup userSetGroup = new UserSetGroup();
        //userSetGroup.GROUP_ID = "Company";
        // userSetGroup.IS_DEPTH = true;
        // userSet.Items.Add(userSetGroup);

        UserSetUser user = new UserSetUser();
        user.USER_GUID = "9dbf9b61-b1f6-4874-8d06-fc157b390e9c";
        userSet.Items.Add(user);
        DataTable userDt = userSet.GetUsers();
        RoleAdminUCO roleUCO = new RoleAdminUCO();
        UserSet onPunchUserSet = new UserSet();
        onPunchUserSet.SetXML( roleUCO.QueryRoleAdmin("DutyProjectUser"));

        foreach (DataRow userDr in userDt.Rows)
        {
            string userGuid = userDr["USER_GUID"].ToString();

            //免刷人員不處理
            if (onPunchUserSet.Contains(userGuid))
            {
                continue;
            }


            DataTable Dt = uco.GetPunchData(userGuid);

            //大於一筆才是異常
            if (Dt.Rows.Count > 0)
            {
                string msg = "";
                msg += @"<table style = ""border: solid; border - width: 1px"" >";
                msg += @"   <tr>";
                msg += @"       <td style = ""border: solid; border - width: 1px"" >日期</td>";
                msg += @"       <td style = ""border: solid; border - width: 1px"" >應有工時</td>";
                msg += @"       <td style = ""border: solid; border - width: 1px"" >簽到時間</td>";
                msg += @"       <td style = ""border: solid; border - width: 1px"" >簽退時間</td>";
                msg += @"       <td style = ""border: solid; border - width: 1px"" >請假時間</td>";
                msg += @"       <td style = ""border: solid; border - width: 1px"" >請假時數</td>";
                msg += @"       <td style = ""border: solid; border - width: 1px"" >實際工時</td>";
                msg += @"       <td style = ""border: solid; border - width: 1px"" >補刷卡單</td>";
                msg += @"       <td style = ""border: solid; border - width: 1px"" >請假申請</td>";
                msg += @"       <td colspan=""2"" style = ""border: solid; border - width: 1px"" >加班申請</td>";
                msg += @"   </tr>";

                foreach (DataRow dr in Dt.Rows)
                {
                    dt.Rows.Add(dr.ItemArray);

                    Setting setting = new Setting();

                    string emptyCell = "";

                    for (int i = 0; i < 10; i++)
                    {
                        emptyCell += "&nbsp;";
                    }

                    string punchURL = emptyCell;
                    string leaveURL = emptyCell;
                    string overTimeURL = emptyCell;
                    string noApplyUR = emptyCell;
                    string siteUrl = setting["SiteUrl"];
                    if (Convert.ToBoolean(dr["NEED_PUNCH"]))
                    {
                        punchURL = string.Format("<a href='{0}' target='_blank' >補刷</a>",
                            siteUrl + "/" + "/WKF/FormUse/PersonalBox/ApplyFormList.aspx?fillFormDirectly=true&formId=PunchForm");
                    }

                    if (Convert.ToBoolean(dr["NEED_LEAVE"]))
                    {
                        leaveURL = string.Format("<a href='{0}' target='_blank' >請假單</a>",
                            siteUrl + "/" + "/WKF/FormUse/PersonalBox/ApplyFormList.aspx?formId=LeaveForm&fillFormDirectly=true");
                    }

                    if (Convert.ToBoolean(dr["NEED_OVERTIME"]))
                    {
                        overTimeURL = string.Format("<a href='{0}' target='_blank' >加班單3.0</a>",
                            siteUrl + "/" + "/WKF/FormUse/PersonalBox/ApplyFormList.aspx?formId=OvertimeFormV3&fillFormDirectly=true");
                        noApplyUR = string.Format("<a href='{0}' target='_blank' >不申請</a>",
                                    siteUrl + "/" +
                                    string.Format("/CDS/Notice/NonApplyRemark.aspx?USER_GUID={0}&DATE={1}", user, HttpUtility.UrlEncode( 
                                    Convert.ToDateTime( dr["DATE"]).ToString("yyyy/MM/dd"))
                                    )
                                    
                                    );
                    }

                    msg += string.Format(@"   <tr>");
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px"" >{0}</td>", dr["DATE"]);
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px"" >{0}</td>", dr["WORK_HOURS"]);
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px"" >{0}</td>", dr["WORK_TIME"]);
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px"" >{0}</td>", dr["OFF_TIME"]);
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px"" >{0}</td>", dr["LEAVE_TIME"]);
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px"" >{0}</td>", dr["LEAVE_HOURS"]);
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px"" >{0}</td>", dr["PUNCH_HOUR"]);
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px"" >{0}</td>", punchURL);
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px"" >{0}</td>", leaveURL);
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px""  >{0}</td>", noApplyUR);
                    msg += string.Format(@"       <td style = ""border: solid; border - width: 1px""  >{0}</td>", overTimeURL);
                    msg += string.Format(@"   </tr>");
                }




                msg += @"</table>";

                Ede.Uof.EIP.PrivateMessage.PrivateMessageUCO msgUCO = new Ede.Uof.EIP.PrivateMessage.PrivateMessageUCO();
                msgUCO.SendOneNewMessage("admin", "工時異常通知" + Dt.Rows[0]["USER_NAME"].ToString()  , msg, "admin");

            }


        }

        Grid1.DataSource = dt;
        Grid1.DataBind();

        if (dt.Rows.Count > 0)
        {

            dt.Columns.RemoveAt(12);
            dt.Columns.RemoveAt(11);
            dt.Columns.RemoveAt(10);
            dt.Columns.RemoveAt(9);
            dt.Columns.RemoveAt(8);
            dt.Columns.RemoveAt(7);
            dt.Columns.RemoveAt(6);
            dt.Columns.RemoveAt(0);

            dt.Columns[0].Caption = "姓名";
            dt.Columns[1].Caption = "日期";
            dt.Columns[2].Caption = "班表工時";
            dt.Columns[3].Caption = "上班卡";
            dt.Columns[4].Caption = "下班卡";

            Setting setting = new Setting();
            Workbook excel = Ede.Uof.Utility.ExcelHelper.GetAsposeWorkbook();
            excel.Worksheets[0].Cells.ImportDataTable(dt, true, "A1");
            excel.Save(setting["WrigleyNoticOverExportPath"] +"\\" + DateTime.Now.ToString("yyyyMMddHHmmss") +".xls");
         
        }



    }
}


public class UCO
{

    PO m_PO = new PO();

    /// <summary>
    /// 取得時間格式
    /// </summary>
    /// <param name="time"></param>
    /// <returns></returns>
    private string GetTime(int time)
    {
        if (time >= 1440)
        {
            time = time - 1440;
        }

        if (time <0)
        {
            time = time+1440;
        }

        return string.Format("{0}:{1}", (time / 60).ToString("d2"), (time % 60).ToString("d2"));
    }

    /// <summary>
    /// 取得刷卡異常資訊
    /// </summary>
    /// <param name="userGuid"></param>
    /// <returns></returns>
    internal DataTable GetPunchData(string userGuid)
    {

        
        Setting setting = new Setting();
        int WrigleyNoticeDay = Convert.ToInt32(setting["WrigleyNoticeDay"]);
        decimal WrigleyNoticOverHours = Convert.ToDecimal(setting["WrigleyNoticOverHours"]);

        DataTable dt = new DataTable();
        dt.Columns.Add("USER_GUID");//員工
        dt.Columns.Add("USER_NAME");//員工
        dt.Columns.Add("DATE");//日期
        dt.Columns.Add("WORK_HOURS");//應有工時
        dt.Columns.Add("WORK_TIME");//簽到
        dt.Columns.Add("OFF_TIME");//簽退
        dt.Columns.Add("LEAVE_TIME");//請假時間
        dt.Columns.Add("LEAVE_HOURS");//請假時數
        dt.Columns.Add("PUNCH_HOUR");//刷卡工時 
        dt.Columns.Add("IS_ABSENT");//是否曠職
        dt.Columns.Add("NEED_PUNCH");//補刷卡
        dt.Columns.Add("NEED_LEAVE");//需請假
        dt.Columns.Add("NEED_OVERTIME");//需加班

        DutyUCO dutyUCO = new DutyUCO();

        
        for (int i = -WrigleyNoticeDay - 1; i <= -1; i++)
        {
            DataRow dr = dt.NewRow();
            DateTime date = DateTime.Today.AddDays(i);

            string status = m_PO.GetWorkStatus(userGuid, date); 

            DutyDataSet ds = dutyUCO.GetUserTimeTable(userGuid, date.Year, date.Month, date.Day);

            if (ds != null && ds.UserTimeTable.Rows.Count > 0)
            {
                DutyDataSet.UserTimeTableRow timeDr = (DutyDataSet.UserTimeTableRow)ds.UserTimeTable.Rows[0];

                if (timeDr.WORK_HOUR > 0)
                {
                    
                   
                }
                else
                {
           
                    
                }

                dr["WORK_HOURS"] = timeDr.WORK_HOUR.ToString();

            }
            else
            { 
                //沒班表視為假日
          
                dr["WORK_HOURS"] = "0";
            }

            int? workTime = m_PO.GetPunchTime(userGuid, date.Year, date.Month, date.Day, "Work");
            int? offTime = m_PO.GetPunchTime(userGuid, date.Year, date.Month, date.Day, "Off");

            dr["USER_GUID"] = userGuid;
            dr["USER_NAME"] = new UserUCO().GetEBUser(userGuid).Name;
            dr["DATE"] = date.ToString("yyyy/M/dd");
            dr["PUNCH_HOUR"] = m_PO.GetPunchWorkHours(userGuid, date).ToString("#0.##"); ;

            //曠職  就要補刷和請假
            if (IsAbesnt(userGuid, date))
            {
                dr["IS_ABSENT"] = true;
                dr["NEED_PUNCH"] = true;//補刷卡
                dr["NEED_LEAVE"] = true;//需請假

            }
            else
            {
                dr["IS_ABSENT"] = false;
                dr["NEED_PUNCH"] = false;//補刷卡
                dr["NEED_LEAVE"] = false;//需請假
            }


            //沒簽到退一律補刷(?)
            if (workTime == null)
            {
                dr["WORK_TIME"] = "未簽到";
                dr["NEED_PUNCH"] = "true";
            }
            else
            {
                dr["WORK_TIME"] = GetTime(workTime.Value);
            }


            if (offTime == null)
            {
                dr["OFF_TIME"] = "未簽退";
                dr["NEED_PUNCH"] = "true";
            }
            else
            {
                dr["OFF_TIME"] = GetTime(offTime.Value);
            }

            DataTable leaveDt = m_PO.GetLeaveInfo(userGuid, date);
            
            for (int index = 0; index < leaveDt.Rows.Count; index++)
            {
                dr["LEAVE_TIME"] += Ede.Uof.EIP.Organization.Util.UserTime.SetZone("admin").FromDb(
                     DateTimeOffset.Parse(leaveDt.Rows[index]["START_TIME"].ToString()),

                     DateTimeOffset.Parse(leaveDt.Rows[index]["END_TIME"].ToString())).ToTimeString();

                if (index != dt.Rows.Count - 1)
                {
                    dr["LEAVE_TIME"] += "\r\n";
                }


                   // totalHours+=
            }

            dr["LEAVE_HOURS"] = m_PO.GetLeaveHours(userGuid, date).ToString("#0.##");

            dr["NEED_OVERTIME"] = false;

            //當天是否有加班
            bool IsOverTime = m_PO.GetOverTimeinfo(userGuid, date).Rows.Count > 0 ? true : false;

            if (Convert.ToDecimal(dr["WORK_HOURS"]) == 0)
            {
                //假日

                //有刷卡記錄就又沒加班 就要申請
                if (dr["OFF_TIME"].ToString() != "未簽退" || dr["WORK_TIME"].ToString() != "未簽到")
                {
                    if(!IsOverTime)
                        dr["NEED_OVERTIME"] = true;
                }
                
                
                //假日不用提醒補刷
                dr["NEED_PUNCH"] = false;//補刷卡
            }
            else
            { 
                //平日

                //如果沒申請加班  刷卡工時+請假 > 班表工時要提醒加班

                if (!IsOverTime && (WrigleyNoticOverHours) <=
                    (Convert.ToDecimal(dr["PUNCH_HOUR"]) + Convert.ToDecimal(dr["LEAVE_HOURS"])) -
                    Convert.ToDecimal(dr["WORK_HOURS"]))
                {
                    dr["NEED_OVERTIME"] = true;
                }

        
                //正常不用補刷卡
                if (status == "N")
                {
                    dr["NEED_PUNCH"] = false;
                }

            }
    
             

            //有異常才要加入
                if (Convert.ToBoolean(dr["NEED_OVERTIME"]) || Convert.ToBoolean(dr["NEED_PUNCH"]) || Convert.ToBoolean(dr["NEED_LEAVE"]))
                {
                    dt.Rows.Add(dr);
                }
        }


        return dt;



    }

    //A曠職B遲到又曠職
    public bool IsAbesnt(string userGuid, DateTime date)
    {
        string status = m_PO.GetWorkStatus(userGuid, date);

        if (status == "A" || status == "B")
        {
            return true; 

        }

        return false;
    }
}


public class PO :Ede.Uof.Utility.Data.BasePersistentObject
{

    /// <summary>
    /// 取得當日請假時數
    /// </summary>
    /// <param name="userGuid"></param>
    /// <param name="date"></param>
    /// <returns></returns>
    public decimal GetLeaveHours(string userGuid, DateTime date)
    {
        string cmdTxt = @"SELECT SUM([COUNT]) FROM TB_EIP_DUTY_STATISTICS
WHERE (SELECT LEA_CODE FROM TB_EIP_DUTY_LEAVE WHERE LEA_CODE=CODE  ) IS NOT NULL
AND USER_GUID=@USER_GUID AND DATE=@DATE ";

        this.m_db.AddParameter("DATE", date);
        this.m_db.AddParameter("USER_GUID", userGuid);

        object obj = this.m_db.ExecuteScalar(cmdTxt);

        if (obj == null || obj == DBNull.Value)
        {
            return 0;
        }
        
        return Convert.ToDecimal(obj);
    }


    /// <summary>
    /// 取得加班資訊
    /// </summary>
    /// <param name="userGuid"></param>
    /// <param name="date"></param>
    /// <returns></returns>
    public DataTable GetOverTimeinfo(string userGuid, DateTime date)
    {
        string cmdTxt = @"
SELECT START_TIME,END_TIME , HOURS ,DAYS  FROM TB_EIP_DUTY_RPT_SRC
WHERE APPLICANT=@APPLICANT AND FORM_CODE IN ('OVE','OVEB','OVET' )AND 
( ( START_TIME <=@START_TIME AND END_TIME >=@END_TIME)
OR
 (START_TIME >=@START_TIME AND START_TIME <=@END_TIME)
 OR
 (END_TIME >=@START_TIME AND END_TIME <=@END_TIME)
)

";

        this.m_db.AddParameter("APPLICANT", userGuid);
        this.m_db.AddParameter("START_TIME", date);
        this.m_db.AddParameter("END_TIME", date.AddDays(1));

        DataTable dt = new DataTable();
        dt.Load(this.m_db.ExecuteReader(cmdTxt));

        return dt;
    }

    /// <summary>
    /// 取得請假資訊
    /// </summary>
    /// <param name="userGuid"></param>
    /// <param name="date"></param>
    /// <returns></returns>
    public DataTable GetLeaveInfo(string userGuid, DateTime date)
    {
        string cmdTxt = @"
SELECT START_TIME,END_TIME , HOURS ,DAYS  FROM TB_EIP_DUTY_RPT_SRC
WHERE APPLICANT=@APPLICANT AND FORM_CODE='LEA'AND 
( ( START_TIME <=@START_TIME AND END_TIME >=@END_TIME)
OR
 (START_TIME >=@START_TIME AND START_TIME <=@END_TIME)
 OR
 (END_TIME >=@START_TIME AND END_TIME <=@END_TIME)
)

";

        this.m_db.AddParameter("APPLICANT", userGuid);
        this.m_db.AddParameter("START_TIME", date);
        this.m_db.AddParameter("END_TIME", date.AddDays(1));

        DataTable dt = new DataTable();
        dt.Load(this.m_db.ExecuteReader(cmdTxt));

        return dt;
    }

    /// <summary>
    /// 找到工作狀態
    /// </summary>
    /// <param name="userGuid"></param>
    /// <param name="date"></param>
    /// <returns></returns>
    public string GetWorkStatus(string userGuid, DateTime date)
    {
        string cmdTxt = @"
SELECT  [STATUS]  FROM TB_EIP_DUTY_RPT_ABN_PUNCH
WHERE DATE = @DATE
AND USER_GUID=@USER_GUID";

        this.m_db.AddParameter("DATE" , date);
        this.m_db.AddParameter("USER_GUID", userGuid);


        object obj = this.m_db.ExecuteScalar(cmdTxt);

        if (obj == null || obj == DBNull.Value)
        {
            return "";
        }

        return obj.ToString();

    }



    /// <summary>
    /// 取得刷卡工時
    /// </summary>
    /// <param name="userGuid"></param>
    /// <param name="date"></param>
    /// <returns></returns>
    public decimal GetPunchWorkHours(string userGuid, DateTime date)
    {
        string cmdTxt = @"
SELECT  PUN_WORK_HOURS  FROM TB_EIP_DUTY_RPT_ABN_PUNCH
WHERE DATE = @DATE
AND USER_GUID=@USER_GUID";

        this.m_db.AddParameter("DATE" , date);
        this.m_db.AddParameter("USER_GUID", userGuid);


        object obj = this.m_db.ExecuteScalar(cmdTxt);

        if (obj == null || obj == DBNull.Value)
        {
            return 0;
        }

        return Convert.ToDecimal(obj);

    }

    /// <summary>
    /// 取得取卡時間
    /// </summary>
    /// <param name="userGuid"></param>
    /// <param name="year"></param>
    /// <param name="month"></param>
    /// <param name="day"></param>
    /// <param name="v"></param>
    /// <returns></returns>
    internal int? GetPunchTime(string userGuid, int year, int month, int day, string type)
    {
        string cmdTxt = @"
SELECT TIME FROM TB_EIP_PUNCH
WHERE  USER_GUID=@USER_GUID AND 
YEAR=@YEAR
AND MONTH=@MONTH
AND DAY=@DAY
AND [TYPE]=@TYPE";

        this.m_db.AddParameter("USER_GUID", userGuid);
        this.m_db.AddParameter("YEAR", year);
        this.m_db.AddParameter("MONTH", month);
        this.m_db.AddParameter("DAY", day);
        this.m_db.AddParameter("TYPE", type);

        object obj = this.m_db.ExecuteScalar(cmdTxt);

        if (obj == null || obj == DBNull.Value)
        {
            return null;
        }

        return Convert.ToInt32(obj);
    }
}