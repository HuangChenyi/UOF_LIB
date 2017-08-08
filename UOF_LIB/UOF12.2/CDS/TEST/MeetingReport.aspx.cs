using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Ede.Uof.Common.ChoiceCenter;
using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.Utility.Page;
using Ede.Uof.Utility.Page.Common;
using JGlobalLibs;
using Telerik.Web.UI;

/// <summary>
/// 會議查詢報表
/// </summary>
public partial class CDS_Jcic_MeetingReport : BasePage
{
    /// <summary>
    /// 資料庫連通字串
    /// </summary>
    private string ConnectionString;

    /// <summary>
    /// 本次登入的使用者是會議報表管理員
    /// </summary>
    private bool IsAdministrator = false;

    /// <summary>
    /// 本次登入使用者掌管部門的GROUP_ID
    /// </summary>
    private string Superior_GroupId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        ConnectionString = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString;

        /*
         * 報表查詢條件
         * 1. 最高權限, 所有記錄都可以瀏覽, 個人資料 OPTION6 = meet
         * 2. 自己的會議, 瀏覽自己召開或自己有參與的會議
         * 3. 下屬的會議, 如果自己是主要部門主管, 瀏覽下屬召開或下屬有參與的會議
         */

        // 檢查當前登入使用者是否有權限
        UserUCO userUco = new UserUCO();
        EBUser user = userUco.GetEBUser(Page.User.Identity.Name); // 取出當前登入的user
        EmployeeDepartment userDep = user.GetEmployeeDepartment(DepartmentOfUser.Major);
        if (userDep != null)
        {
            if (UOFUtils.CheckIsDeptSuperior(Page.User.Identity.Name, userDep.Department.GroupId)) // 是主要部門主管
            {
                this.Superior_GroupId = userDep.Department.GroupId;
            }
        }
        // 判斷是否報表管理員
        this.IsAdministrator = !string.IsNullOrEmpty(user.Option6) ? user.Option6.Trim() == "meet" : false;

        if (!Page.IsPostBack)
        {
            base.AddSiteMapNode("<font color='red'>會議查詢</font>");

            rdpBeginDate.SelectedDate = DateTime.Now; // 設定開始日期為今天
            rdpEndDate.SelectedDate = DateTime.Now; // 設定結束日期為今天

            // 準備會議室清單
            DataTable tbResult = new DataTable(); // 準備儲存可用的會議室
            tbResult.Columns.AddRange(new DataColumn[] 
            {
                new DataColumn("NAME", typeof(string)),
                new DataColumn("PLANT_GUID", typeof(string))
            });
            DataRow emptyRow = tbResult.NewRow();
            emptyRow["NAME"] = "--請選擇--";
            emptyRow["PLANT_GUID"] = "";
            tbResult.Rows.Add(emptyRow);
            // 查詢可用的會議室
            using (SqlConnection Connection = new SqlConnection(ConnectionString))
            {
                Connection.Open();
                using (SqlDataAdapter sda = new SqlDataAdapter(@"    
                    SELECT *
                      FROM (SELECT A.*
                              FROM TB_EIP_PLANT AS A,
                                   TB_EIP_PLANT_CLASS AS B
                             WHERE A.CLASS_GUID = B.CLASS_GUID
                               AND B.IS_MEETINGROOM = 'Y') AS C
                     ORDER BY C.NAME
                ", Connection))
                using (DataSet ds = new DataSet())
                {
                    try
                    {
                        sda.Fill(ds);
                        foreach (DataRow row in ds.Tables[0].Rows)
                        {
                            DataRow nRow = tbResult.NewRow();
                            nRow["NAME"] = row["NAME"];
                            nRow["PLANT_GUID"] = row["PLANT_GUID"];
                            tbResult.Rows.Add(nRow);
                        }
                    }
                    catch { }
                }
            }
            ddlRooms.DataTextField = "NAME";
            ddlRooms.DataValueField = "PLANT_GUID";
            ddlRooms.SelectedValue = "";
            ddlRooms.DataSource = tbResult;
            ddlRooms.DataBind();

            ddlRooms2.DataTextField = "NAME";
            ddlRooms2.DataValueField = "PLANT_GUID";
            ddlRooms2.SelectedValue = "";
            ddlRooms2.DataSource = tbResult;
            ddlRooms2.DataBind();

            // 預設行事曆格式
            rmpMain.SelectedIndex = 1;
        }

        this.RefreshMeetings();
        this.RefreshMeetings2();
    }

    /// <summary>
    /// 重整會議查詢表格
    /// </summary>
    private void RefreshMeetings()
    {
        DataTable tblResult = new DataTable();
        tblResult.Columns.AddRange(new DataColumn[] 
        {
            new DataColumn("MEETING_GUID", typeof(string)),
            new DataColumn("NAME", typeof(string)),
            new DataColumn("MEETING_TYPE", typeof(string)),
            new DataColumn("CHAIRMAN", typeof(string)),
            new DataColumn("SUBJECT", typeof(string)),
            new DataColumn("START_TIME", typeof(string)),
            new DataColumn("END_TIME", typeof(string)),
            new DataColumn("PARTICIPANTS", typeof(string)),
            new DataColumn("VIEW_DETAIL", typeof(bool))
        });
        if (ddlRooms.SelectedValue == "") // 有挑選會議室
        {
            using (SqlDataAdapter sda = new SqlDataAdapter(@"
                SELECT *
                  FROM (SELECT A.*,
                               C.NAME,
                               B.PLANT_GUID,
                               C.CLASS_GUID,
                               D.IS_MEETINGROOM, ISNULL((SELECT NAME
                                                           FROM TB_EB_USER
                                                          WHERE USER_GUID = A.CHAIR), '') AS 'CHAIRMAN'
                          FROM (SELECT *
                                  FROM TB_EIP_SCH_MEETING
                                 WHERE CONVERT(DATETIME, SWITCHOFFSET(START_TIME, DATEPART(TZ, SYSDATETIMEOFFSET()))) BETWEEN @BEGINDATE AND @ENDDATE) AS A,
                               TB_EIP_PLANT_BORR_DET AS B,
                               TB_EIP_PLANT AS C,
                               TB_EIP_PLANT_CLASS AS D
                         WHERE A.BORROW_GUID = B.BORROW_GUID
                           AND C.PLANT_GUID = B.PLANT_GUID
                           AND D.CLASS_GUID = C.CLASS_GUID) AS E
                 WHERE E.IS_MEETINGROOM = 'Y'
                ORDER BY NAME
            ", ConnectionString))
            using (DataSet ds = new DataSet())
            {
                sda.SelectCommand.Parameters.AddWithValue("@BEGINDATE", rdpBeginDate.SelectedDate.Value.ToString("yyyy/MM/dd") + " 00:00:00.000");
                sda.SelectCommand.Parameters.AddWithValue("@ENDDATE", rdpEndDate.SelectedDate.Value.ToString("yyyy/MM/dd") + " 23:59:59.999");
                try
                {
                    sda.Fill(ds);
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        // 判斷目前是否有權限可以瀏覽這筆資料
                        bool hasPermission = false; // 瀏覽權限
                        bool hasBrowser = false; // 允許瀏覽
                        if (IsAdministrator) // 如果是最高權限
                        {
                            hasPermission = true;
                            hasBrowser = true;
                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(this.Superior_GroupId)) // 如果不是最高權限, 但是是部門主管
                            {
                                // 條件3, 有下屬的會議
                                string CHAIRMAN = (string)row["CHAIR"]; // 取出主席
                                string PARTICIPANTS = (string)row["USER_SET"]; // 取出參與者
                                // 主席的主要部門是否跟登入者相同
                                UserUCO userUco = new UserUCO(); // 建立使用者管理員物件
                                EBUser chairUser = userUco.GetEBUser(CHAIRMAN); // 取得主席的EBUser物件
                                EmployeeDepartment dep = (chairUser != null) ? chairUser.GetEmployeeDepartment(DepartmentOfUser.Major) : null; // 取得主席的主要部門物件
                                if (dep != null && // 有主要部門
                                    dep.Department.GroupId == this.Superior_GroupId) // 而且主要部門跟登入者的一致
                                {
                                    hasPermission = true; // 設定有權限
                                    hasBrowser = true;
                                }
                                if (!hasPermission) // 如果判斷主席是否下屬, 並沒有獲得瀏覽權限
                                {
                                    // 參與者中是否有人的主要部門跟登入者相同
                                    UserSet userSet = new UserSet(); // 建立UserSet物件
                                    userSet.SetXML(PARTICIPANTS); // 建立參與者的UserSet物件
                                    for (int i = 0; i < userSet.Items.Count; i++) // 巡覽所有參與者
                                    {
                                        UserSetUser item = userSet.Items[i] as UserSetUser; // 取出一個參與者UserSet
                                        EBUser partUser = userUco.GetEBUser(item.USER_GUID); // 取得該參與者的EBUser物件
                                        EmployeeDepartment itemDep = (partUser != null) ? partUser.GetEmployeeDepartment(DepartmentOfUser.Major) : null; // 取得該參與者的主要部門物件
                                        if (itemDep != null && // 有主要部門
                                            itemDep.Department.GroupId == this.Superior_GroupId) // 而且主要部門跟登入者的一致
                                        {
                                            hasPermission = true; // 設定有權限
                                            hasBrowser = true;
                                        }
                                    }
                                }
                            }
                            if (!hasPermission) // 如果經過條件3還是沒有權限
                            {
                                // 條件2, 有自己的存在
                                string CHAIRMAN = (string)row["CHAIR"]; // 取出主席
                                string PARTICIPANTS = (string)row["USER_SET"]; // 取出參與者
                                if (CHAIRMAN.IndexOf(Page.User.Identity.Name) >= 0 || // 自己是主席
                                    PARTICIPANTS.IndexOf(Page.User.Identity.Name) >= 0) // 自己有參與
                                {
                                    hasPermission = true;
                                    hasBrowser = true;
                                }
                                else
                                {
                                    hasBrowser = true;
                                }
                            }
                        }
                        if (hasPermission || hasBrowser) // 如果有權限
                        {
                            DataRow nRow = tblResult.NewRow();
                            nRow["MEETING_GUID"] = row["MEETING_GUID"];
                            nRow["NAME"] = row["NAME"];
                            nRow["VIEW_DETAIL"] = hasPermission;
                            // 準備會議類別
                            using (StreamReader reader = new StreamReader(new MemoryStream(Encoding.UTF8.GetBytes((string)row["DESCRIPTION"]))))
                            {
                                string buffer = reader.ReadLine();
                                while (buffer != null)
                                {
                                    buffer = buffer.Trim();
                                    if (buffer.StartsWith("會議類別："))
                                    {
                                        nRow["MEETING_TYPE"] = buffer.Substring(5).Trim();
                                        break;
                                    }
                                    buffer = reader.ReadLine();
                                }
                            }
                            nRow["CHAIRMAN"] = row["CHAIRMAN"];
                            nRow["SUBJECT"] = row["SUBJECT"];
                            nRow["START_TIME"] = ((DateTimeOffset)row["START_TIME"]).ToLocalTime().ToString("yyyy/MM/dd HH:mm:ss");
                            nRow["END_TIME"] = ((DateTimeOffset)row["END_TIME"]).ToLocalTime().ToString("yyyy/MM/dd HH:mm:ss");
                            nRow["PARTICIPANTS"] = row["USER_SET"];
                            tblResult.Rows.Add(nRow);
                        }
                    }
                }
                catch { }
            }
        }
        else // 有挑選會議室
        {
            using (SqlDataAdapter sda = new SqlDataAdapter(@"
                SELECT *
                  FROM (SELECT A.*,
                               C.NAME,
                               B.PLANT_GUID,
                               C.CLASS_GUID,
                               D.IS_MEETINGROOM, ISNULL((SELECT NAME
                                                           FROM TB_EB_USER
                                                          WHERE USER_GUID = A.CHAIR), '') AS 'CHAIRMAN'
                          FROM (SELECT *
                                  FROM TB_EIP_SCH_MEETING
                                 WHERE CONVERT(DATETIME, SWITCHOFFSET(START_TIME, DATEPART(TZ, SYSDATETIMEOFFSET()))) BETWEEN @BEGINDATE AND @ENDDATE) AS A,
                               TB_EIP_PLANT_BORR_DET AS B,
                               TB_EIP_PLANT AS C,
                               TB_EIP_PLANT_CLASS AS D
                         WHERE A.BORROW_GUID = B.BORROW_GUID
                           AND B.PLANT_GUID = @PLANT_GUID
                           AND C.PLANT_GUID = B.PLANT_GUID
                           AND D.CLASS_GUID = C.CLASS_GUID) AS E
                 WHERE E.IS_MEETINGROOM = 'Y'
                ORDER BY NAME
            ", ConnectionString))
            using (DataSet ds = new DataSet())
            {
                sda.SelectCommand.Parameters.AddWithValue("@PLANT_GUID", ddlRooms.SelectedValue);
                sda.SelectCommand.Parameters.AddWithValue("@BEGINDATE", rdpBeginDate.SelectedDate.Value.ToString("yyyy/MM/dd") + " 00:00:00.000");
                sda.SelectCommand.Parameters.AddWithValue("@ENDDATE", rdpEndDate.SelectedDate.Value.ToString("yyyy/MM/dd") + " 23:59:59.999");
                try
                {
                    sda.Fill(ds);
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        // 判斷目前是否有權限可以瀏覽這筆資料
                        bool hasPermission = false;
                        bool hasBrowser = false; // 允許瀏覽
                        if (IsAdministrator) // 如果是最高權限
                        {
                            hasPermission = true;
                            hasBrowser = true;
                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(this.Superior_GroupId)) // 如果不是最高權限, 但是是部門主管
                            {
                                // 條件3, 有下屬的會議
                                string CHAIRMAN = (string)row["CHAIR"]; // 取出主席
                                string PARTICIPANTS = (string)row["USER_SET"]; // 取出參與者
                                // 主席的主要部門是否跟登入者相同
                                UserUCO userUco = new UserUCO(); // 建立使用者管理員物件
                                EBUser chairUser = userUco.GetEBUser(CHAIRMAN); // 取得主席的EBUser物件
                                EmployeeDepartment dep = (chairUser != null) ? chairUser.GetEmployeeDepartment(DepartmentOfUser.Major) : null; // 取得主席的主要部門物件
                                if (dep != null && // 有主要部門
                                    dep.Department.GroupId == this.Superior_GroupId) // 而且主要部門跟登入者的一致
                                {
                                    hasPermission = true; // 設定有權限
                                    hasBrowser = true;
                                }
                                if (!hasPermission) // 如果判斷主席是否下屬, 並沒有獲得瀏覽權限
                                {
                                    // 參與者中是否有人的主要部門跟登入者相同
                                    UserSet userSet = new UserSet(); // 建立UserSet物件
                                    userSet.SetXML(PARTICIPANTS); // 建立參與者的UserSet物件
                                    for (int i = 0; i < userSet.Items.Count; i++) // 巡覽所有參與者
                                    {
                                        UserSetUser item = userSet.Items[i] as UserSetUser; // 取出一個參與者UserSet
                                        EBUser partUser = userUco.GetEBUser(item.USER_GUID); // 取得該參與者的EBUser物件
                                        EmployeeDepartment itemDep = (partUser != null) ? partUser.GetEmployeeDepartment(DepartmentOfUser.Major) : null; // 取得該參與者的主要部門物件
                                        if (itemDep != null && // 有主要部門
                                            itemDep.Department.GroupId == this.Superior_GroupId) // 而且主要部門跟登入者的一致
                                        {
                                            hasPermission = true; // 設定有權限
                                            hasBrowser = true;
                                        }
                                    }
                                }
                            }
                            if (!hasPermission) // 如果經過條件3還是沒有權限
                            {
                                // 條件2, 有自己的存在
                                string CHAIRMAN = (string)row["CHAIR"]; // 取出主席
                                string PARTICIPANTS = (string)row["USER_SET"]; // 取出參與者
                                if (CHAIRMAN.IndexOf(Page.User.Identity.Name) >= 0 || // 自己是主席
                                    PARTICIPANTS.IndexOf(Page.User.Identity.Name) >= 0) // 自己有參與
                                {
                                    hasPermission = true;
                                    hasBrowser = true;
                                }
                                else
                                {
                                    hasBrowser = true;
                                }
                            }
                        }
                        if (hasPermission || hasBrowser) // 如果有權限或者允許瀏覽
                        {
                            DataRow nRow = tblResult.NewRow();
                            nRow["MEETING_GUID"] = row["MEETING_GUID"];
                            nRow["NAME"] = row["NAME"];
                            nRow["VIEW_DETAIL"] = hasPermission;
                            // 準備會議類別
                            using (StreamReader reader = new StreamReader(new MemoryStream(Encoding.UTF8.GetBytes((string)row["DESCRIPTION"]))))
                            {
                                string buffer = reader.ReadLine();
                                while (buffer != null)
                                {
                                    buffer = buffer.Trim();
                                    if (buffer.StartsWith("會議類別："))
                                    {
                                        nRow["MEETING_TYPE"] = buffer.Substring(5).Trim();
                                        break;
                                    }
                                    buffer = reader.ReadLine();
                                }
                            }
                            nRow["CHAIRMAN"] = row["CHAIRMAN"];
                            nRow["SUBJECT"] = row["SUBJECT"];
                            nRow["START_TIME"] = ((DateTimeOffset)row["START_TIME"]).ToLocalTime().ToString("yyyy/MM/dd HH:mm:ss");
                            nRow["END_TIME"] = ((DateTimeOffset)row["END_TIME"]).ToLocalTime().ToString("yyyy/MM/dd HH:mm:ss");
                            nRow["PARTICIPANTS"] = row["USER_SET"];
                            tblResult.Rows.Add(nRow);
                        }
                    }
                }
                catch { }
            }
        }
        gvMain.DataSource = tblResult;
        gvMain.DataBind();
    }

    /// <summary>
    /// 重整會議查詢表格
    /// </summary>
    private void RefreshMeetings2()
    {
        if (!rypMain.SelectedDate.HasValue) rypMain.SelectedDate = DateTime.Now;
        int lastDay = DateTime.Parse(rypMain.SelectedDate.Value.AddMonths(1).ToString("yyyy/MM") + "/01").AddDays(-1).Day;
        DataTable rowsAvails = null;
        DateTime dtBegin = DateTime.Parse(rypMain.SelectedDate.Value.ToString("yyyy/MM") + "/01 00:00:00.000");
        DateTime dtEnd = DateTime.Parse(rypMain.SelectedDate.Value.ToString("yyyy/MM") + string.Format("/{0:D2} 23:59:59.999", lastDay));
        using (SqlDataAdapter sda = new SqlDataAdapter(@"
                SELECT *
                  FROM (SELECT A.*,
                               C.NAME,
                               B.PLANT_GUID,
                               ISNULL((SELECT TOP 1 [NAME]
                                         FROM TB_EIP_PLANT
                                        WHERE PLANT_GUID = B.PLANT_GUID), '') AS 'PLANT_NAME', -- 查詢會議室名稱
                               C.CLASS_GUID,
                               D.IS_MEETINGROOM, ISNULL((SELECT NAME
                                                           FROM TB_EB_USER
                                                          WHERE USER_GUID = A.CHAIR), '') AS 'CHAIRMAN'
                          FROM (SELECT *
                                  FROM TB_EIP_SCH_MEETING
                                 WHERE CONVERT(DATETIME, SWITCHOFFSET(START_TIME, DATEPART(TZ, SYSDATETIMEOFFSET()))) BETWEEN @BEGINDATE AND @ENDDATE) AS A,
                               TB_EIP_PLANT_BORR_DET AS B,
                               TB_EIP_PLANT AS C,
                               TB_EIP_PLANT_CLASS AS D
                         WHERE A.BORROW_GUID = B.BORROW_GUID
                           AND C.PLANT_GUID = B.PLANT_GUID
                           AND D.CLASS_GUID = C.CLASS_GUID) AS E
                 WHERE E.IS_MEETINGROOM = 'Y'
                ORDER BY NAME
            ", ConnectionString))
        using (DataSet ds = new DataSet())
        {
            sda.SelectCommand.Parameters.AddWithValue("@BEGINDATE", dtBegin);
            sda.SelectCommand.Parameters.AddWithValue("@ENDDATE", dtEnd);
            try
            {
                sda.Fill(ds);
                rowsAvails = SQLUtils.CloneTableStructure(ds.Tables[0]); // 複製查詢結果資料表結構
                rowsAvails.Columns.Add("_START_TIME", typeof(DateTime)); // 增加兩個時間日期欄位, 準備轉換原本的START_TIME/END_TIME(DateTimeOffset)
                rowsAvails.Columns.Add("_END_TIME", typeof(DateTime));
                rowsAvails.Columns.Add("DISPLAY", typeof(string)); // 記錄要顯示在行事曆上的資訊
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    // 判斷目前是否有權限可以瀏覽這筆資料
                    bool hasPermission = false;
                    bool hasBrowser = false; // 只能瀏覽
                    if (IsAdministrator) // 如果是最高權限
                    {
                        hasPermission = true;
                        hasBrowser = true;
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(this.Superior_GroupId)) // 如果不是最高權限, 但是是部門主管
                        {
                            // 條件3, 有下屬的會議
                            string CHAIRMAN = (string)row["CHAIR"]; // 取出主席
                            string PARTICIPANTS = (string)row["USER_SET"]; // 取出參與者
                            // 主席的主要部門是否跟登入者相同
                            UserUCO userUco = new UserUCO(); // 建立使用者管理員物件
                            EBUser chairUser = userUco.GetEBUser(CHAIRMAN); // 取得主席的EBUser物件
                            EmployeeDepartment dep = (chairUser != null) ? chairUser.GetEmployeeDepartment(DepartmentOfUser.Major) : null; // 取得主席的主要部門物件
                            if (dep != null && // 有主要部門
                                dep.Department.GroupId == this.Superior_GroupId) // 而且主要部門跟登入者的一致
                            {
                                hasPermission = true; // 設定有權限
                                hasBrowser = true;
                            }
                            if (!hasPermission) // 如果判斷主席是否下屬, 並沒有獲得瀏覽權限
                            {
                                // 參與者中是否有人的主要部門跟登入者相同
                                UserSet userSet = new UserSet(); // 建立UserSet物件
                                userSet.SetXML(PARTICIPANTS); // 建立參與者的UserSet物件
                                for (int i = 0; i < userSet.Items.Count; i++) // 巡覽所有參與者
                                {
                                    UserSetUser item = userSet.Items[i] as UserSetUser; // 取出一個參與者UserSet
                                    EBUser partUser = userUco.GetEBUser(item.USER_GUID); // 取得該參與者的EBUser物件
                                    EmployeeDepartment itemDep = (partUser != null) ? partUser.GetEmployeeDepartment(DepartmentOfUser.Major) : null; // 取得該參與者的主要部門物件
                                    if (itemDep != null && // 有主要部門
                                        itemDep.Department.GroupId == this.Superior_GroupId) // 而且主要部門跟登入者的一致
                                    {
                                        hasPermission = true; // 設定有權限
                                        hasBrowser = true;
                                    }
                                }
                            }
                        }
                        if (!hasPermission) // 如果經過條件3還是沒有權限
                        {
                            // 條件2, 有自己的存在
                            string CHAIRMAN = (string)row["CHAIR"]; // 取出主席
                            string PARTICIPANTS = (string)row["USER_SET"]; // 取出參與者
                            if (CHAIRMAN.IndexOf(Page.User.Identity.Name) >= 0 || // 自己是主席
                                PARTICIPANTS.IndexOf(Page.User.Identity.Name) >= 0) // 自己有參與
                            {
                                hasPermission = true;
                                hasBrowser = true;
                            }
                            else
                            {
                                hasBrowser = true;
                            }
                        }
                    }
                    if (hasPermission || hasBrowser) // 如果有權限或者允許瀏覽
                    {
                        DataRow nRow = null; // 新DataRow
                        if (ddlRooms2.SelectedIndex == 0) // 沒挑選會議室
                        {
                            nRow = SQLUtils.CloneTableRow(rowsAvails, row); // 複製這一筆資料列供後續顯示
                            // 轉換時間日期
                            nRow["_START_TIME"] = ((DateTimeOffset)nRow["START_TIME"]).LocalDateTime;
                            nRow["_END_TIME"] = ((DateTimeOffset)nRow["END_TIME"]).LocalDateTime;
                        }
                        else // 有挑選會議室
                        {
                            if (row["PLANT_GUID"] != Convert.DBNull && // 是指定的會議室
                                (string)row["PLANT_GUID"] == ddlRooms2.SelectedValue)
                            {
                                nRow = SQLUtils.CloneTableRow(rowsAvails, row); // 複製這一筆資料列供後續顯示
                                // 轉換時間日期
                                nRow["_START_TIME"] = ((DateTimeOffset)nRow["START_TIME"]).LocalDateTime;
                                nRow["_END_TIME"] = ((DateTimeOffset)nRow["END_TIME"]).LocalDateTime;
                            }
                        }

                        string[] parts = ((string)nRow["DESCRIPTION"]).Split('\n'); // 拆解說明欄位為陣列
                        string type = parts.Length > 0 ? parts[0].Trim() : ""; // 取出第一個可能為會議類別

                        if (!string.IsNullOrEmpty(type)) // 如果有取到會議類別
                        {
                            parts = type.Split('：'); // 使用冒號來拆解陣列
                            type = parts.Length > 0 ? parts[1].Trim() : type; // 取得冒號後的文字
                        }

                        // 組合要顯示在行事曆上的字串
                        nRow["DISPLAY"] = string.Format("{0:HH:mm}｜{1}｜{2}｜{3}", nRow["_START_TIME"], nRow["PLANT_NAME"], type, nRow["CHAIRMAN"]);
                    }
                }
            }
            catch { }
        }

        rscMain.DataSource = rowsAvails;
        rscMain.DataKeyField = "MEETING_GUID";
        rscMain.DataDescriptionField = "DISPLAY";
        rscMain.DataSubjectField = "SUBJECT";
        rscMain.DataStartField = "_START_TIME";
        rscMain.DataEndField = "_END_TIME";
        rscMain.DataBind();
    }

    /// <summary>
    /// 會議查詢表格資料呈現事件
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvMain_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridViewRow gr = e.Row;
        if (gr.RowType == DataControlRowType.DataRow)
        {
            DataTable thisTable = gvMain.DataSource as DataTable;
            DataRow thisRow = thisTable.Rows[gr.RowIndex];
            LinkButton lbDetail = gr.FindControl("lbDetail") as LinkButton;

            if ((bool)thisRow["VIEW_DETAIL"])
            {
                Dialog.Open2(lbDetail, "~/EIP/Calendar/CreateMeeting.aspx?MeetingGuid=" + (string)thisRow["MEETING_GUID"], "會議記錄詳細資料", 960, 720, Dialog.PostBackType.None);
            }
            else
            {
                lbDetail.Enabled = false;
            }
        }
    }

    /// <summary>
    /// 開始日期變更事件
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void rdpBeginDate_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
    {
        this.RefreshMeetings();
    }

    /// <summary>
    /// 結束日期變更事件
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void rdpEndDate_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
    {
        this.RefreshMeetings();
    }

    /// <summary>
    /// 會議室下拉盒變更事件
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlRooms_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.RefreshMeetings();
    }

    /// <summary>
    /// 會議室下拉盒2變更事件
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlRooms2_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.RefreshMeetings2();
    }

    /// <summary>
    /// 頁籤點擊事件
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void rtsMain_TabClick(object sender, Telerik.Web.UI.RadTabStripEventArgs e)
    {
        switch (e.Tab.Text)
        {
            case "表格格式":
                rmpMain.SelectedIndex = 0;
                break;
            case "月曆格式":
                rmpMain.SelectedIndex = 1;
                break;
        }
    }

    /// <summary>
    /// 年月挑選物件變更事件
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void rypMain_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
    {
        this.RefreshMeetings2();
    }

    /// <summary>
    /// 會議申請按鈕按下事件
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void lbRaiseMeetingApply_Click(object sender, EventArgs e)
    {
        string formId = UOFUtils.GetFormGUID("會議申請單");
        Response.Redirect(string.Format("~/WKF/FormUse/PersonalBox/ApplyFormList.aspx?formId={0}&fillFormDirectly=true", formId));
    }
}