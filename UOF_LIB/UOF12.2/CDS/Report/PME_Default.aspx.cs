using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ede.Uof.Utility.Page.Common;
using AO.GVC.AOS.Base;
using System.Data;
using AO.GVC.AOS.LAW.PME;
using Ede.Uof.EIP.SystemInfo;
using System.Web.UI.HtmlControls;
using System.Drawing;
using System.Net;
using AO.GVC.Common.GVCCode;
using Ede.Uof.EIP.Organization.Util;
using AO.GVC.Common.Authority;
using System.IO;
using AO.GVC.Common.Base;
using AO.GVC.Common.Utility;
using AO.GVC.Common.GVCData;
using AO.GVC.Report;
using Telerik.Reporting;
using Telerik.Reporting.Processing;
using Ede.Uof.Utility.FileCenter.V3;
using System.Dynamic;

public partial class AOS_LAW_PME_PME_Default : Ede.Uof.Utility.Page.BasePage
{
    PmeUCO tmpPmeUCO = new PmeUCO();
    GvcBaseUCO tmpGvcBaseUCO = new GvcBaseUCO();
    HrBaseUCO tmpHrBaseUCO = new HrBaseUCO();
    CodeUCO tmpCodeUCO = new CodeUCO();
    AuthorityUCO tmpAuthorityUCO = new AuthorityUCO();
    FormDetailDataSet tmpFormDetailDataSet = new FormDetailDataSet();
    string tmpLoginStaffId = string.Empty;
    string tmpLoginHrsDept = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        //AoHrStaffInFo tmpAoHrStaffInFo = tmpHrBaseUCO.GetAoHrStaffInFo(Current.UserGUID, EmployeeType.GVC);//依GVC UserGUID碼取得HR 人員基本資料
        //tmpLoginStaffId = tmpAoHrStaffInFo.STAFF_ID;
        //tmpLoginHrsDept = tmpAoHrStaffInFo.HRS_DEPT;

        this.SetControlsByRole();//依身份設定所有元件的作用
        if (!Page.IsPostBack)
        {
            //if (tmpAoHrStaffInFo != null)
            //{
            //    //UC_HrStaff.SetHrDeptOrStaffCode = tmpAoHrStaffInFo.STAFF_ID;//預設表單申請者
            //    //UC_HrDept.SetHrDeptOrStaffCode = tmpAoHrStaffInFo.HRS_DEPT;//預設申請部門
            //}
            this.SetDefaultValue();

            if (!string.IsNullOrEmpty(Request.QueryString["signStatus"]))
            {
                string SignCode = "";
                if (Request.QueryString["signStatus"] == "A2")
                    SignCode = "C146-010";
                else if (Request.QueryString["signStatus"] == "A3")
                    SignCode = "C146-011";
                else if (Request.QueryString["signStatus"] == "A1")
                    SignCode = "C146-009";
                UC_SignStatus.SetSelectValue(SignCode);
                UC_SignStatus.DataBind();
                this.SearchDatas();//依指定的條件查詢申請資料
            }
        }
        this.RegeditWebImageButtonEven();//註冊事件
    }

    private void SetDefaultValue()
    {
        //時間預設--申請日期
        DateTime dtNow = System.DateTime.Now;
        dtNow = System.DateTime.Now;
        wdcSDATE.SelectedDate = new DateTime(dtNow.Year, dtNow.Month, dtNow.Day).AddDays(-30);
        wdcEDATE.SelectedDate = new DateTime(dtNow.Year, dtNow.Month, dtNow.Day);

        #region 申請國家
        DataTable dt1 = tmpCodeUCO.GetCodeData("CODE_SPC", "C143");//申請國家
        cblEST_CY.Items.Clear();
        foreach (DataRow dr in dt1.Rows)
        {
            cblEST_CY.Items.Add(new ListItem(dr["CODE_DESC"].ToString(), dr["ID"].ToString()));
            cblAPV_CY.Items.Add(new ListItem(dr["CODE_DESC"].ToString(), dr["ID"].ToString()));
        }
        //foreach (ListItem li in cblEST_CY.Items)
        //    li.Selected = true;
        #endregion

        #region 社內技術分類別
        dt1 = tmpCodeUCO.GetCodeData("CODE_SPC", "C144");
        ddlRD_TYPE.Items.Clear();
        ListItem listItem1 = new ListItem();
        listItem1.Text = "All";
        listItem1.Value = "";
        ddlRD_TYPE.Items.Add(listItem1);
        foreach (DataRow dr in dt1.Rows)
            ddlRD_TYPE.Items.Add(new ListItem(dr["CODE_DESC"].ToString(), dr["ID"].ToString()));
        #endregion

        #region 專利等級
        dt1 = tmpCodeUCO.GetCodeData("CODE_SPC", "C145");
        ddlPATENT_LEVEL.Items.Clear();
        listItem1 = new ListItem();
        listItem1.Text = "All";
        listItem1.Value = "";
        ddlPATENT_LEVEL.Items.Add(listItem1);
        foreach (DataRow dr in dt1.Rows)
            ddlPATENT_LEVEL.Items.Add(new ListItem(dr["CODE_DESC"].ToString(), dr["ID"].ToString()));
        #endregion

        #region 設定專利權人
        dt1 = tmpCodeUCO.GetCodeData("CODE_SPC", "C193");
        ddlPATENTEE.Items.Clear();
        listItem1 = new ListItem();
        listItem1.Text = "請選擇";
        listItem1.Value = "";
        ddlPATENTEE.Items.Add(listItem1);
        foreach (DataRow dr in dt1.Rows)
        {
            ddlPATENTEE.Items.Add(new ListItem(dr["CODE_DESC"].ToString(), dr["ID"].ToString()));
        }
        #endregion
    }

    private void RegeditWebImageButtonEven()
    {
        #region 註冊事件

        if (grdForm.Visible)//(匯總)
        {
            //註冊事件 (匯總)
            for (int i = 0; i < grdForm.Rows.Count; i++)
            {
                //申請單號
                LinkButton tmplnkbtFORM_NBR = (LinkButton)grdForm.Rows[i].FindControl("lnkbtFORM_NBR");//申請單號
                tmplnkbtFORM_NBR.Click += new EventHandler(tmplnkbtFORM_NBR_Click);
            }
        }
        #endregion
    }


    /// <summary>
    /// 申請單號
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    void tmplnkbtFORM_NBR_Click(object sender, EventArgs e)
    {
        #region 申請單號
        if (Dialog.GetReturnValue() != null && Dialog.GetReturnValue() != "")
        {
            this.SearchDatas();//依指定的條件查詢資料
        }
        #endregion
    }

     /// <summary>
    /// 依身份設定所有元件的作用
    /// </summary>
    /// <param name="tmpUserGUID">使用者GVC GUID碼</param>
    private void SetControlsByRole()
    {
        #region 依身份設定所有元件的作用
        UltraWebToolbar1.Items.FindItemByValue("btInsert").Enabled = false;//新增
        UltraWebToolbar1.Items.FindItemByValue("btDelete").Enabled = false;//刪除
        UltraWebToolbar1.Items.FindItemByValue("btImport").Enabled = false;//匯入起單
        UltraWebToolbar1.Items.FindItemByValue("btA1APPROVE").Enabled = false;//主管審核
        UltraWebToolbar1.Items.FindItemByValue("btA2APPROVE").Enabled = false;//智權主管同意(A2)
        UltraWebToolbar1.Items.FindItemByValue("btA3APPROVE").Enabled = false;//法智主管同意(A3)
        UltraWebToolbar1.Items.FindItemByValue("btPrint").Enabled = false;//列印付款憑證
        UltraWebToolbar1.Items.FindItemByValue("btA2RETURNA1").Enabled = false;
        UltraWebToolbar1.Items.FindItemByValue("btA3RETURNA2").Enabled = false;
        UltraWebToolbar1.Items.FindItemByValue("IPCImport").Enabled = false;
        UltraWebToolbar1.Items.FindItemByValue("FEEImport").Enabled = false;
        UltraWebToolbar1.Items.FindItemByValue("E1Export").Enabled = false;

        cblIS_E1.Enabled = false;

        if (tmpHrBaseUCO.IsHaveRolePower("AOSPME_Applicant", Current.UserGUID))//是否有 申請單起單者(AOSPME_Applicant)角色權限
        {
            UltraWebToolbar1.Items.FindItemByValue("btInsert").Enabled = true;//新增
            UltraWebToolbar1.Items.FindItemByValue("btDelete").Enabled = true;//刪除
            UltraWebToolbar1.Items.FindItemByValue("btImport").Enabled = true;//匯入起單
            UltraWebToolbar1.Items.FindItemByValue("btA1APPROVE").Enabled = true;//主管審核
        }

        if (tmpHrBaseUCO.IsHaveRolePower("AOSIPRSuperior", Current.UserGUID))
        {
            UltraWebToolbar1.Items.FindItemByValue("btA2APPROVE").Enabled = true;//智權主管同意(A2)
            UltraWebToolbar1.Items.FindItemByValue("btA2RETURNA1").Enabled = true;
        }

        if (tmpHrBaseUCO.IsHaveRolePower("AOSLAWSuperior", Current.UserGUID))
        {
            UltraWebToolbar1.Items.FindItemByValue("btA3APPROVE").Enabled = true;//法智主管同意(A3)
            UltraWebToolbar1.Items.FindItemByValue("btA3RETURNA2").Enabled = true;
        }

        if (tmpHrBaseUCO.IsHaveRolePower("AOSLAWProcedure", Current.UserGUID))
        {
            UltraWebToolbar1.Items.FindItemByValue("btA2APPROVE").Enabled = true;//智權主管同意(A2)
            UltraWebToolbar1.Items.FindItemByValue("btA3APPROVE").Enabled = true;//法智主管同意(A3)
            UltraWebToolbar1.Items.FindItemByValue("btPrint").Enabled = true;//列印付款憑證
            cblIS_E1.Enabled = true;
        }

        if (tmpHrBaseUCO.IsHaveRolePower("AOSIPRHandler", Current.UserGUID))
        {
            UltraWebToolbar1.Items.FindItemByValue("IPCImport").Enabled = true;
            UltraWebToolbar1.Items.FindItemByValue("FEEImport").Enabled = true;
            UltraWebToolbar1.Items.FindItemByValue("E1Export").Enabled = true;
        }
        #endregion
    }
    
    /// <summary>
    ///　依設定條件查詢申請資料
    /// </summary>
    private QueryObj SetFilter()//依設定條件查詢申請資料
    {
        #region 依指定的條件查詢申請資料
        QueryObj tmpQueryObj = new QueryObj();

        UserSet userSet;
        if (!String.IsNullOrEmpty(UC_FormApplicant.XML))//申請人
        {
            userSet = new UserSet();
            userSet.SetXML(UC_FormApplicant.XML);
            if (userSet.GetUsers().Rows.Count > 0)
            {
                List<string> listA_GVCUSERGUID = new List<string>();
                foreach (DataRow row in userSet.GetUsers().Rows)
                {
                    listA_GVCUSERGUID.Add(row["USER_GUID"].ToString());
                }
                tmpQueryObj.A_GVCUSERGUID_List = listA_GVCUSERGUID;
            }
        }

        if (!string.IsNullOrEmpty(txtFormApplicant.Text.Trim()))
            tmpQueryObj.A_Filter = txtFormApplicant.Text.Trim();//申請者姓名或帳號

        if (!string.IsNullOrEmpty(wdcSDATE.SelectedDate.ToString()))//申請日期-起
            tmpQueryObj.SDATE = DateTime.Parse(wdcSDATE.SelectedDate.Value.ToString("yyyy/MM/dd") + " 00:00:00");

        if (!string.IsNullOrEmpty(wdcEDATE.SelectedDate.ToString()))//申請日期-止
            tmpQueryObj.EDATE = DateTime.Parse(wdcEDATE.SelectedDate.Value.ToString("yyyy/MM/dd") + " 23:59:59");

        if (!string.IsNullOrEmpty(txtFORM_NBR_START.Text.Trim()))//申請單號-起
            tmpQueryObj.FORM_NBR_START = txtFORM_NBR_START.Text.Trim();

        if (!string.IsNullOrEmpty(txtFORM_NBR_END.Text.Trim()))//申請單號-止
            tmpQueryObj.FORM_NBR_END = txtFORM_NBR_END.Text.Trim();

        if (!string.IsNullOrEmpty(txtWKF_FORM_NBR_START.Text.Trim()))//表單單號-起
            tmpQueryObj.WKF_FORM_NBR_START = txtWKF_FORM_NBR_START.Text.Trim();

        if (!string.IsNullOrEmpty(txtWKF_FORM_NBR_END.Text.Trim()))//表單單號-止
            tmpQueryObj.WKF_FORM_NBR_END = txtWKF_FORM_NBR_END.Text.Trim();

        if (ddlSignStatus.SelectedValue != "ALL")
            tmpQueryObj.SIGN_STATUS_DDL = ddlSignStatus.SelectedValue;//簽核狀態-DropDownList

        tmpQueryObj.SIGN_STATUS_UC = UC_SignStatus.Spec;//簽核狀態-UserControl

        //if (!String.IsNullOrEmpty(UC_A_DEPT_GUID.XML))//申請部門
        //{
        //    userSet = new UserSet();
        //    userSet.SetXML(UC_A_DEPT_GUID.XML);
        //    if (userSet.GetUsers().Rows.Count > 0)
        //    {
        //        List<string> listA_DEPT_GUID = new List<string>();
        //        foreach (DataRow row in userSet.GetUsers().Rows)
        //        {
        //            listA_DEPT_GUID.Add(row["USER_GUID"].ToString());
        //        }
        //        tmpQueryObj.A_DEPT_GUID_List = listA_DEPT_GUID;
        //    }
        //}

        #region==申請者部門==
        //[申請者部門]挑選後的部門
        UserSet DeptUs = new UserSet();
        DeptUs.SetXML(UC_A_DEPT_GUID.UserSet.GetXML());
        UserSetGroup[] userSetGroup = DeptUs.Items.GetGroupArray();

        if (userSetGroup.Length > 0)
        {
            string GVCDept = "";
            for (int i = 0; i < userSetGroup.Length; i++)
            {
                GVCDept += userSetGroup[i].GROUP_ID + ",";
            }
            GVCDept = GVCDept.Remove(GVCDept.LastIndexOf(","));
            tmpQueryObj.A_DEPT_GUID_List = GVCDept;
        }
        #endregion

        if (!String.IsNullOrEmpty(UC_APPROVE_E1.XML))//評估者(E1)
        {
            userSet = new UserSet();
            userSet.SetXML(UC_APPROVE_E1.XML);
            if (userSet.GetUsers().Rows.Count > 0)
            {
                List<string> listE1_GVCUSERGUID = new List<string>();
                foreach (DataRow row in userSet.GetUsers().Rows)
                {
                    listE1_GVCUSERGUID.Add(row["USER_GUID"].ToString());
                }
                tmpQueryObj.APPROVE_E1_List = listE1_GVCUSERGUID;
            }
        }

        if (!string.IsNullOrEmpty(txtAPPROVE_E1.Text.Trim()))
            tmpQueryObj.E1_Filter = txtAPPROVE_E1.Text.Trim();//評估者(E1)姓名或帳號

        //if (!String.IsNullOrEmpty(UC_E1_DEPT_GUID.XML))//評估部門(GVC)
        //{
        //    userSet = new UserSet();
        //    userSet.SetXML(UC_E1_DEPT_GUID.XML);
        //    if (userSet.GetUsers().Rows.Count > 0)
        //    {
        //        List<string> listE1_DEPT_GUID = new List<string>();
        //        foreach (DataRow row in userSet.GetUsers().Rows)
        //        {
        //            listE1_DEPT_GUID.Add(row["USER_GUID"].ToString());
        //        }
        //        tmpQueryObj.E1_DEPT_GUID_List = listE1_DEPT_GUID;
        //    }
        //}
        #region==評估部門(GVC)==
        UserSet DeptUsE1 = new UserSet();
        DeptUsE1.SetXML(UC_E1_DEPT_GUID.UserSet.GetXML());
        UserSetGroup[] userSetGroupE1 = DeptUsE1.Items.GetGroupArray();

        if (userSetGroupE1.Length > 0)
        {
            List<string> listE1_DEPT_GUID = new List<string>();
            for (int i = 0; i < userSetGroupE1.Length; i++)
                listE1_DEPT_GUID.Add(userSetGroupE1[i].GROUP_ID);
            tmpQueryObj.E1_DEPT_GUID_List = listE1_DEPT_GUID;
        }
        #endregion

        if (!wdcREQUEST_SDATE.IsEmpty)// 期望回覆日期 -起
            tmpQueryObj.REQUEST_SDATE = DateTime.Parse(wdcREQUEST_SDATE.SelectedDate.Value.ToString("yyyy/MM/dd") + " 00:00:00");

        if (!wdcREQUEST_EDATE.IsEmpty)// 期望回覆日期 -止
            tmpQueryObj.REQUEST_EDATE = DateTime.Parse(wdcREQUEST_EDATE.SelectedDate.Value.ToString("yyyy/MM/dd") + " 23:59:59");

        if (!wdcAP_SDATE.IsEmpty)// 結案日期 -起
            tmpQueryObj.AP_SDATE = DateTime.Parse(wdcAP_SDATE.SelectedDate.Value.ToString("yyyy/MM/dd") + " 00:00:00");

        if (!wdcAP_EDATE.IsEmpty)// 結案日期 -止
            tmpQueryObj.AP_EDATE = DateTime.Parse(wdcAP_EDATE.SelectedDate.Value.ToString("yyyy/MM/dd") + " 23:59:59");

        if (!wdcPRINT_SDATE.IsEmpty)// 列印日期 -起
            tmpQueryObj.PRINT_SDATE = DateTime.Parse(wdcPRINT_SDATE.SelectedDate.Value.ToString("yyyy/MM/dd") + " 00:00:00");

        if (!wdcPRINT_EDATE.IsEmpty)// 列印日期 -止
            tmpQueryObj.PRINT_EDATE = DateTime.Parse(wdcPRINT_EDATE.SelectedDate.Value.ToString("yyyy/MM/dd") + " 23:59:59");

        if (!string.IsNullOrEmpty(txtPATENT_NAME.Text.Trim()))//專利名稱
            tmpQueryObj.PATENT_NAME = txtPATENT_NAME.Text.Trim();

        if (!string.IsNullOrEmpty(txtINVENTOR.Text.Trim()))//發明人
            tmpQueryObj.INVENTOR = txtINVENTOR.Text.Trim();

        if (!string.IsNullOrEmpty(txtINVENT_DEPT.Text.Trim()))//發明單位
            tmpQueryObj.INVENT_DEPT = txtINVENT_DEPT.Text.Trim();

        //申請國家-CheckBoxList
        List<string> listEST_CY = new List<string>();
        for (int i = 0; i < cblEST_CY.Items.Count; i++)
        {
            if (cblEST_CY.Items[i].Selected)
                listEST_CY.Add(cblEST_CY.Items[i].Value);
        }
        tmpQueryObj.EST_CY_CEL = listEST_CY;

        if (!string.IsNullOrEmpty(txtEST_CY_DESC.Text.Trim()))//申請國家-其他說明
            tmpQueryObj.EST_CY_DESC = txtEST_CY_DESC.Text.Trim();

        //已獲准國家-CheckBoxList
        List<string> listAPV_CY = new List<string>();
        for (int i = 0; i < cblAPV_CY.Items.Count; i++)
        {
            if (cblAPV_CY.Items[i].Selected)
                listAPV_CY.Add(cblAPV_CY.Items[i].Value);
        }
        tmpQueryObj.APV_CY_CEL = listAPV_CY;

        if (!string.IsNullOrEmpty(txtAPV_CY_DESC.Text.Trim()))//已獲准國家-其他說明
            tmpQueryObj.APV_CY_DESC = txtAPV_CY_DESC.Text.Trim();

        if (!string.IsNullOrEmpty(txtEPS_NO.Text.Trim()))//社內編號/證書號
            tmpQueryObj.EPS_NO = txtEPS_NO.Text.Trim();

        if (!string.IsNullOrEmpty(txtCERTIFICATE_NO.Text.Trim()))//證書號
            tmpQueryObj.CERTIFICATE_NO = txtCERTIFICATE_NO.Text.Trim();

        if (ddlRD_TYPE.SelectedValue != "")
            tmpQueryObj.RD_TYPE_DDL = ddlRD_TYPE.SelectedValue;//社內技術分類別-DropDownList

        if (!string.IsNullOrEmpty(txtRD_TYPE_DESC.Text.Trim()))//社內技術分類別
            tmpQueryObj.RD_TYPE_DESC = txtRD_TYPE_DESC.Text.Trim();

        if (!string.IsNullOrEmpty(txtIPC_CODE.Text.Trim()))//國際分類號
            tmpQueryObj.IPC_CODE = txtIPC_CODE.Text.Trim();

        if (!string.IsNullOrEmpty(txtCITE_CODE.Text.Trim()))//引用號碼
            tmpQueryObj.CITE_CODE = txtCITE_CODE.Text.Trim();

        if (!string.IsNullOrEmpty(txtPA_CITE_CODE.Text.Trim()))//被引用號碼 
            tmpQueryObj.PA_CITE_CODE = txtPA_CITE_CODE.Text.Trim();

        if (!string.IsNullOrEmpty(txtCITE_CODE_NUM.Text.Trim()))//引用次數
            tmpQueryObj.CITE_CODE_NUM = txtCITE_CODE_NUM.Text.Trim();

        if (!string.IsNullOrEmpty(txtPA_CITE_CODE_NUM.Text.Trim()))//被引用次數 
            tmpQueryObj.PA_CITE_CODE_NUM = txtPA_CITE_CODE_NUM.Text.Trim();

        if (ddlCDESC.SelectedValue != "")
            tmpQueryObj.CDESC_DDL = ddlCDESC.SelectedValue;// 維護意見 -DropDownList

        //維護意見-CheckBoxList
        List<string> listCOPINION = new List<string>();
        for (int i = 0; i < cblCOPINION.Items.Count; i++)
        {
            if (cblCOPINION.Items[i].Selected)
                listCOPINION.Add(cblCOPINION.Items[i].Value);
        }
        tmpQueryObj.COPINION_CEL = listCOPINION;

        if (ddlPATENT_LEVEL.SelectedValue != "")
            tmpQueryObj.PATENT_LEVEL_DDL = ddlPATENT_LEVEL.SelectedValue;//專利等級-DropDownList

        if (!string.IsNullOrEmpty(txtPATENT_LEVEL_DESC.Text.Trim()))//專利等級
            tmpQueryObj.PATENT_LEVEL_DESC = txtPATENT_LEVEL_DESC.Text.Trim();

        //是否已列印-CheckBoxList
        List<string> listIS_PRINT = new List<string>();
        for (int i = 0; i < cblIS_PRINT.Items.Count; i++)
        {
            if (cblIS_PRINT.Items[i].Selected)
                listIS_PRINT.Add(cblIS_PRINT.Items[i].Value);
        }
        tmpQueryObj.IS_PRINT_CEL = listIS_PRINT;

        if (!wdcPAY_SDATE.IsEmpty)
            tmpQueryObj.PAY_SDATE = DateTime.Parse(wdcPAY_SDATE.SelectedDate.Value.ToString("yyyy/MM/dd") + " 00:00:00");

        if (!wdcPAY_EDATE.IsEmpty)
            tmpQueryObj.PAY_EDATE = DateTime.Parse(wdcPAY_EDATE.SelectedDate.Value.ToString("yyyy/MM/dd") + " 23:59:59");

        if (!string.IsNullOrEmpty(txtPAY_AGE.Text.Trim()))//繳費年次
            tmpQueryObj.PAY_AGE = txtPAY_AGE.Text.Trim();

        if (ddlPATENTEE.SelectedValue != "")
            tmpQueryObj.PATENTEE_DDL = ddlPATENTEE.SelectedValue;//專利權人

        #endregion 
        return tmpQueryObj;
    }

     /// <summary>
    ///　依指定的條件查詢申請資料
    /// </summary>
    private void SearchDatas()//依指定的條件查詢申請資料
    {
        //設定條件
        QueryObj tmpQueryObj = SetFilter();

        //依指定的條件查詢申請資料
        DataTable tmpDataTable = tmpPmeUCO.GetDatasByCondition(tmpQueryObj);//依指定的條件查詢申請資料

        if (tmpDataTable != null)
        {
            if (!string.IsNullOrEmpty(Convert.ToString(ViewState["SortGrid_1"])) && tmpDataTable.Rows.Count > 0)
                tmpDataTable.DefaultView.Sort = Convert.ToString(ViewState["SortGrid_1"]);

            grdForm.DataSource = tmpDataTable.DefaultView;
            grdForm.DataBind();

            if (grdForm.Rows.Count > 0)//收閤或開啟“查詢條件”區塊
                WebPanel1.Items[0].Expanded = false;
            else
                WebPanel1.Items[0].Expanded = true;
        }
        else
            WebPanel1.Items[0].Expanded = true;
    }

    protected void UltraWebToolbar1_ButtonClicked(object sender, Telerik.Web.UI.RadToolBarEventArgs e)
    {
        #region 查詢
        if (e.Item.Value == "btQuery")//查詢
        {
            this.SearchDatas();//依指定的條件查詢申請資料
        }
        #endregion

        #region 新增
        if (e.Item.Value == "btInsert")//新增
        {
            if (Dialog.GetReturnValue() != null && Dialog.GetReturnValue() != "" && Dialog.GetReturnValue() == "ReLoad")
                this.SearchDatas();//依指定的條件查詢申請資料
        }
        #endregion

        #region 刪除
        if (e.Item.Value == "btDelete")//刪除
        {
            System.Collections.Specialized.IOrderedDictionary[] iKey = this.grdForm.GetSelectedRowsKeys(); //取得複合key 
            if (iKey.Length == 0)
            {
                //您勾選欲刪除的申請單號!!
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('" + lblNoSelectDelMsg.Text + "');", true);
                return;
            }
            else
            {
                List<string> tmpDeleteFormNbrList = new List<string>();
                string tmpErrorFormNbrInFo = string.Empty;
                for (int i = 0; i < iKey.Length; i++)
                {
                    if (iKey[i]["SIGN_STATUS"].ToString() == "NA")//簽核狀態="NA"才可以刪除
                        tmpDeleteFormNbrList.Add(iKey[i]["FORM_NBR"].ToString());
                    else tmpErrorFormNbrInFo += iKey[i]["FORM_NBR"].ToString() + ",";
                }

                if (tmpDeleteFormNbrList.Count == 0)//如果簽核的資料沒有NA的，則不可以刪除
                {
                    //您勾選欲刪除的申請單號{簽核狀態需為新增(NA)}
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('" + string.Format(lblNoneNASelectDelMsg.Text, tmpErrorFormNbrInFo) + "');", true);
                    return;
                }
                else
                {
                    //依申請單號List刪除相關資料
                    if (tmpPmeUCO.DeleteFormAndDetail(tmpDeleteFormNbrList))//依申請單號List刪除相關資料
                    {
                        //成功刪除指定的申請單資料!!
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('" + lblDeleteOk.Text + "');", true);

                        this.SearchDatas();//依指定的條件查詢申請資料
                    }
                    else
                    {
                        //刪除指定的申請單資料失敗!!
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('" + lblDeleteError.Text + "');", true);
                        return;
                    }
                }
            }
        }
        #endregion

        #region==主管審核==
        if (e.Item.Value == "btA1APPROVE")//主管審核
        {
            if (grdForm.Rows.Count == 0)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('無送簽資料!!');", true);
                return;
            }
            else
            {
                int idx = Request.Url.AbsoluteUri.IndexOf(Request.ApplicationPath);
                string serviceUri = Request.Url.AbsoluteUri.Substring(0, idx); // 伺服器 URL
                string applicationUri = serviceUri + Request.ApplicationPath; // 應用程式 Context URL
                for (int i = 0; i < grdForm.Rows.Count; i++)
                {
                    string formNbr = grdForm.DataKeys[i].Values["FORM_NBR"].ToString();
                    string signStatus = grdForm.DataKeys[i].Values["SIGN_STATUS"].ToString();
                    string A_UserGuid = grdForm.DataKeys[i].Values["A_GVCUSERGUID"].ToString();
                    string A1Opinion = grdForm.DataKeys[i].Values["A1_OPINION"].ToString();
                    string wkfFormNbr = grdForm.DataKeys[i].Values["WKF_FORM_NBR"].ToString();
                    string TaskId = grdForm.DataKeys[i].Values["TASK_ID"].ToString();
                    if (signStatus == "A1" && A_UserGuid == Current.User.UserGUID && !string.IsNullOrEmpty(A1Opinion.Trim()))
                    {
                        tmpPmeUCO.UpdateSignStatus(formNbr, "A2", TBNameEnum.TB_AOS_LAW_PME_FORM, "A1", "");
                        CreateSignLog(formNbr, "A1", wkfFormNbr, TaskId);
                        //[主管審核]：送出通知給智權主管(L1)進行審核
                        tmpFormDetailDataSet = tmpPmeUCO.GetDataByKey(formNbr);//依申請單號取得相關資料
                        tmpPmeUCO.SendL1Msg(tmpFormDetailDataSet, applicationUri);
                    }                        
                }
            }
            this.SearchDatas();//依指定的條件查詢申請資料
        }
        #endregion

        #region==智權主管同意(A2)==
        if (e.Item.Value == "btA2APPROVE")//智權主管同意(A2)
        {
            System.Collections.Specialized.IOrderedDictionary[] iKey = this.grdForm.GetSelectedRowsKeys();
            if (iKey.Length == 0)
            {
                //您並未勾選任何記錄!!
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('" + lblNoCheck.Text + "');", true);
                return;
            }
            else
            {
                int idx = Request.Url.AbsoluteUri.IndexOf(Request.ApplicationPath);
                string serviceUri = Request.Url.AbsoluteUri.Substring(0, idx); // 伺服器 URL
                string applicationUri = serviceUri + Request.ApplicationPath; // 應用程式 Context URL
                List<string> tmpSelectFormNbrList = new List<string>();
                string tmpErrorFormNbrInFo = string.Empty;

                for (int i = 0; i < iKey.Length; i++)
                {
                    if (iKey[i]["SIGN_STATUS"].ToString() != "A2" || iKey[i]["A1_OPINION"].ToString().Trim() != "P")
                    {
                        tmpSelectFormNbrList.Add(iKey[i]["FORM_NBR"].ToString());
                        tmpErrorFormNbrInFo += iKey[i]["FORM_NBR"].ToString() + ",";
                    }
                }

                if (tmpSelectFormNbrList.Count > 0)
                {
                    //您所勾選的資料簽核狀態須為智權主管審核(A2)且承辦意見(A1)之維護結果 須為P(續繳)!!
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('" + string.Format(lblA2Error.Text, tmpErrorFormNbrInFo) + "');", true);
                    return;
                }
                else
                {
                    for (int i = 0; i < iKey.Length; i++)
                    {
                        if ((iKey[i]["SIGN_STATUS"].ToString() == "A2" && iKey[i]["A1_OPINION"].ToString().Trim() == "P"))
                        {
                            tmpPmeUCO.UpdateSignStatus(iKey[i]["FORM_NBR"].ToString(), "A3", TBNameEnum.TB_AOS_LAW_PME_FORM, "A2", "P");
                            CreateSignLog(iKey[i]["FORM_NBR"].ToString(), "A2", iKey[i]["WKF_FORM_NBR"].ToString(), iKey[i]["TASK_ID"].ToString());
                            //[智權主管同意(A2)]：依勾選之申請單號，送出通知給法智主管(L2)進行審核
                            tmpFormDetailDataSet = tmpPmeUCO.GetDataByKey(iKey[i]["FORM_NBR"].ToString());//依申請單號取得相關資料
                            tmpPmeUCO.SendL2Msg(tmpFormDetailDataSet, applicationUri);
                        }
                    }
                }                
            }
            this.SearchDatas();//依指定的條件查詢申請資料
        }
        #endregion

        #region==法智主管同意(A3)==
        if (e.Item.Value == "btA3APPROVE")//法智主管同意(A3)
        {
            System.Collections.Specialized.IOrderedDictionary[] iKey = this.grdForm.GetSelectedRowsKeys();
            if (iKey.Length == 0)
            {
                //您並未勾選任何記錄!!
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('" + lblNoCheck.Text + "');", true);
                return;
            }
            else
            {
                int idx = Request.Url.AbsoluteUri.IndexOf(Request.ApplicationPath);
                string serviceUri = Request.Url.AbsoluteUri.Substring(0, idx); // 伺服器 URL
                string applicationUri = serviceUri + Request.ApplicationPath; // 應用程式 Context URL
                List<string> tmpSelectFormNbrList = new List<string>();
                string tmpErrorFormNbrInFo = string.Empty;

                for (int i = 0; i < iKey.Length; i++)
                {
                    if (iKey[i]["SIGN_STATUS"].ToString() != "A3" || iKey[i]["A2_OPINION"].ToString().Trim() != "P")
                    {
                        tmpSelectFormNbrList.Add(iKey[i]["FORM_NBR"].ToString());
                        tmpErrorFormNbrInFo += iKey[i]["FORM_NBR"].ToString() + ",";
                    }
                }

                if (tmpSelectFormNbrList.Count > 0)
                {
                    //您所勾選的資料簽核狀態須為法智主管審核(A3)且智權主管意見(A2)之維護結果須為P(續繳)!!
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('" + string.Format(lblA3Error.Text, tmpErrorFormNbrInFo) + "');", true);
                    return;
                }
                else
                {
                    for (int i = 0; i < iKey.Length; i++)
                    {
                        if ((iKey[i]["SIGN_STATUS"].ToString() == "A3" && iKey[i]["A2_OPINION"].ToString().Trim() == "P"))
                        {
                            tmpPmeUCO.UpdateSignStatus(iKey[i]["FORM_NBR"].ToString(), "A4", TBNameEnum.TB_AOS_LAW_PME_FORM, "A3", "P");
                            CreateSignLog(iKey[i]["FORM_NBR"].ToString(), "A3", iKey[i]["WKF_FORM_NBR"].ToString(), iKey[i]["TASK_ID"].ToString());
                            //[法智主管同意(A3)]：依勾選之申請單號，送出通知給智權承辦確認(A4)進行審核
                            tmpFormDetailDataSet = tmpPmeUCO.GetDataByKey(iKey[i]["FORM_NBR"].ToString());//依申請單號取得相關資料
                            tmpPmeUCO.SendA4Msg(tmpFormDetailDataSet, applicationUri);
                        }
                    }
                }
            }
            this.SearchDatas();//依指定的條件查詢申請資料
        }
        #endregion

        #region 列印付款憑證
        if (e.Item.Value == "btPrint")
        {
            //設定條件
            QueryObj tmpQueryObj = SetFilter();
            string fileName = "Payment.pdf";
            RemoveReport(fileName);

            DataSet ds = new DataSet();
            //呼叫資料
            ds = tmpPmeUCO.GetDataByKey(tmpQueryObj);
            List<string> returnList = new List<string>();
            if (ds.Tables["TB_AOS_LAW_PME_FORM"] != null && ds.Tables["TB_AOS_LAW_PME_FORM"].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables["TB_AOS_LAW_PME_FORM"].Rows.Count; i++)
                {
                    DataRow dr = ds.Tables["TB_AOS_LAW_PME_FORM"].Rows[i];
                    if (!string.IsNullOrEmpty(dr["FORM_NBR1"].ToString())) returnList.Add(dr["FORM_NBR1"].ToString());
                    if (!string.IsNullOrEmpty(dr["FORM_NBR2"].ToString())) returnList.Add(dr["FORM_NBR2"].ToString());
                    if (!string.IsNullOrEmpty(dr["FORM_NBR3"].ToString())) returnList.Add(dr["FORM_NBR3"].ToString());
                }
                if (tmpPmeUCO.UpdatePrintDate(returnList))//更新列印日期
                {
                    PmeRpt prReport = new PmeRpt(ds, (cblIS_E1.Checked) ? true : false);
                    InstanceReportSource instanceReportSource = new InstanceReportSource();
                    instanceReportSource.ReportDocument = prReport;

                    ReportProcessor reportProcessor = new ReportProcessor();
                    RenderingResult result = reportProcessor.RenderReport("PDF", instanceReportSource, null);
                    byte[] buffer = result.DocumentBytes;
                    string StoragePath = System.Configuration.ConfigurationManager.AppSettings["FileStorageFolder"] + "FileCenter\\" + "EIP\\";
                    System.IO.FileStream pdfFile = new System.IO.FileStream(StoragePath + fileName, System.IO.FileMode.CreateNew, System.IO.FileAccess.ReadWrite, System.IO.FileShare.None);
                    pdfFile.Write(buffer, 0, buffer.Length);
                    byte[] data = new byte[pdfFile.Length];

                    BinaryReader r = new BinaryReader(pdfFile);
                    r.BaseStream.Seek(0, SeekOrigin.Begin);    //将文件指针设置到文件开
                    data = r.ReadBytes((int)r.BaseStream.Length);
                    //存檔Ede.Uof.Utility.FileCenter

                    //Ede.Uof.Utility.FileCenter.V1.FileGroup fileGroup = new Ede.Uof.Utility.FileCenter.V1.FileGroup();
                    //fileGroup.AddFile(data, fileName, "GVC", "application/pdf");
                    //fileGroup.Update();
                    FileGroup PMEFileGroup = new FileGroup(Guid.NewGuid().ToString());
                    PMEFileGroup.AddFile(data, fileName, Module.CDS, "application/vnd.ms-excel", Current.UserGUID, "AOS\\LAW\\PME", false);
                    PMEFileGroup.SaveChanges(Current.UserGUID, Current.UserIPAddress);
                    pdfFile.Close();

                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), " OpenFormMaintain('" + PMEFileGroup.Id + "'); ", true);
                }
            }
        }
        #endregion

        #region==A2退回A1==
        if (e.Item.Value == "btA2RETURNA1")//A2退回A1
        {
            System.Collections.Specialized.IOrderedDictionary[] iKey = this.grdForm.GetSelectedRowsKeys();
            if (iKey.Length == 0)
            {
                //您並未勾選任何記錄!!
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('" + lblNoCheck.Text + "');", true);
                return;
            }
            else
            {
                int idx = Request.Url.AbsoluteUri.IndexOf(Request.ApplicationPath);
                string serviceUri = Request.Url.AbsoluteUri.Substring(0, idx); // 伺服器 URL
                string applicationUri = serviceUri + Request.ApplicationPath; // 應用程式 Context URL
                List<string> tmpSelectFormNbrList = new List<string>();
                string tmpErrorFormNbrInFo = string.Empty;

                for (int i = 0; i < iKey.Length; i++)
                {
                    if (iKey[i]["SIGN_STATUS"].ToString() == "A2")
                    {
                        tmpPmeUCO.UpdateSignStatus(iKey[i]["FORM_NBR"].ToString(), "A1", TBNameEnum.TB_AOS_LAW_PME_FORM, "", "");
                        //[A2退回A1]：依勾選之申請單號，送出通知給A1
                        tmpFormDetailDataSet = tmpPmeUCO.GetDataByKey(iKey[i]["FORM_NBR"].ToString());//依申請單號取得相關資料
                        tmpPmeUCO.A2SendA1Msg(tmpFormDetailDataSet, applicationUri);
                    }
                }
            }
            this.SearchDatas();//依指定的條件查詢申請資料
        }
        #endregion

        #region==A3退回A2==
        if (e.Item.Value == "btA3RETURNA2")//A3退回A2
        {
            System.Collections.Specialized.IOrderedDictionary[] iKey = this.grdForm.GetSelectedRowsKeys();
            if (iKey.Length == 0)
            {
                //您並未勾選任何記錄!!
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "alert('" + lblNoCheck.Text + "');", true);
                return;
            }
            else
            {
                int idx = Request.Url.AbsoluteUri.IndexOf(Request.ApplicationPath);
                string serviceUri = Request.Url.AbsoluteUri.Substring(0, idx); // 伺服器 URL
                string applicationUri = serviceUri + Request.ApplicationPath; // 應用程式 Context URL
                List<string> tmpSelectFormNbrList = new List<string>();
                string tmpErrorFormNbrInFo = string.Empty;

                for (int i = 0; i < iKey.Length; i++)
                {
                    if (iKey[i]["SIGN_STATUS"].ToString() == "A3")
                    {
                        tmpPmeUCO.UpdateSignStatus(iKey[i]["FORM_NBR"].ToString(), "A2", TBNameEnum.TB_AOS_LAW_PME_FORM, "", "");                        
                        //[A3退回A2]：依勾選之申請單號，送出通知給A2
                        tmpFormDetailDataSet = tmpPmeUCO.GetDataByKey(iKey[i]["FORM_NBR"].ToString());//依申請單號取得相關資料
                        tmpPmeUCO.A3SendA2Msg(tmpFormDetailDataSet, applicationUri);
                    }
                }
            }
            this.SearchDatas();//依指定的條件查詢申請資料
        }
        #endregion

        #region 匯出RD評估資料
        if (e.Item.Value == "E1Export")
        {
            //設定條件
            QueryObj tmpQueryObj = SetFilter();
            #region 美君Sharon修改呼叫Excel匯出的方式 AO 2011/5/27
            string stSampleFilePath;
            int idx = Request.Url.AbsoluteUri.IndexOf(Request.ApplicationPath);
            string serviceUri = Request.Url.AbsoluteUri.Substring(0, idx); // 伺服器 URL
            string applicationUri = serviceUri + Request.ApplicationPath; // 應用程式 Context URL

            stSampleFilePath = Request.MapPath("~/AOS/LAW/PME/PME_ExportSample.xls");
            tmpPmeUCO.ExportExcel(tmpQueryObj, stSampleFilePath, Request.MapPath("~/AOS/LAW/PME/"));

            string downloadPathExcel = applicationUri + "/AOS/LAW/PME/CVT/" + Current.UserGUID + "/" + Current.UserGUID + ".xls";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), Guid.NewGuid().ToString(), "var o = document.getElementById('ExportFrame'); o.src = '" + downloadPathExcel + "';", true);
            #endregion
        }
        #endregion
    }

    private void RemoveReport(string fileName)
    {
        string path = System.Configuration.ConfigurationManager.AppSettings["FileStorageFolder"] + "FileCenter\\" + "EIP\\" + fileName;

        if (System.IO.File.Exists(path))
        {
            System.IO.File.Delete(path);
        }
    }

    /// <summary>
    /// 函式說明：寫入新舊Sign Log
    /// </summary>
    /// <param name="applyTask"> ApplyTask </param>
    /// <param name="FormNbr"> 採購單單號 </param>
    /// <param name="siteCode"> SiteCode </param>
    /// <remarks>
    ///  * 新 增 者： 美君Sharon(2012/9/24 下午 02:13 )
    ///  * 修 改 者： 
    ///  * 修 改 者： 
    ///  * 修 改 者： 
    /// </remarks>
    protected void CreateSignLog(string FormNbr, string siteCode, string wkfFormNbr, string TaskId)
    {
        //寫入TB_GVC_FORM_SIGN
        SignUCO signUCO = new SignUCO();
        FormSignObj tmpFormSignObj = new FormSignObj();
        tmpFormSignObj.SIGN_GUID = Guid.NewGuid().ToString();
        tmpFormSignObj.FORM_NBR = FormNbr;
        tmpFormSignObj.EXTERNAL_TASK_ID = string.Empty;
        tmpFormSignObj.DOC_NBR = wkfFormNbr;
        tmpFormSignObj.SIGN_USER = Current.UserGUID;
        tmpFormSignObj.TASK_ID = TaskId;
        tmpFormSignObj.SITE_ID = siteCode;
        tmpFormSignObj.CREATE_DATE = DateTime.Now.ToString();
        tmpFormSignObj.CREATE_FROM = Current.UserIPAddress;
        tmpFormSignObj.CREATOR = Current.UserGUID;
        tmpFormSignObj.MODIFY_DATE = DateTime.Now.ToString();
        tmpFormSignObj.MODIFY_FROM = Current.UserIPAddress;
        tmpFormSignObj.MODIFIER = Current.UserGUID;
        signUCO.InsertGvcFormSign_AO(tmpFormSignObj, TBSignNameEnum.TB_AOS_LAW_PME_FORM_SIGN);
    }

    protected void grdForm_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdForm.PageIndex = e.NewPageIndex;

        this.SearchDatas();//依指定的條件查詢 資料
    }
    protected void grdForm_Sorting(object sender, GridViewSortEventArgs e)
    {
        string sort = Convert.ToString(ViewState["SortGrid_1"]);
        string newSort = string.Empty;
        if (sort.StartsWith(e.SortExpression))
        {
            newSort = (sort == e.SortExpression + " ASC") ? e.SortExpression + " DESC" : e.SortExpression + " ASC";
        }
        else
        {
            newSort = e.SortExpression + " ASC";
        }

        ViewState["SortGrid_1"] = newSort;
        this.SearchDatas();//依指定的條件查詢 資料
    }
    protected void grdForm_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView rowView = (DataRowView)e.Row.DataItem;
            #region==CheckBox權限控管==
            AuthorityUCO m_authorityUCO = new AuthorityUCO();
            string status = Convert.ToString(rowView["SIGN_STATUS"]);

            HtmlInputCheckBox cbx = (HtmlInputCheckBox)e.Row.FindControl("CheckBox");

            if (m_authorityUCO.CheckUserHaveRolePower("AOSPME_Applicant", Ede.Uof.EIP.SystemInfo.Current.UserGUID))
            {
                //起單者(AOSPME_Applicant)，可刪除申請者為自己的明細且簽核狀態為{”NA”}才可刪除
                if ((status == "NA") && Convert.ToString(rowView["A_GVCUSERGUID"]) == Ede.Uof.EIP.SystemInfo.Current.UserGUID)
                    cbx.Visible = true;
                else
                    cbx.Visible = false;
            }
            else
                cbx.Visible = false;

            if (m_authorityUCO.CheckUserHaveRolePower("AOSIPRSuperior", Ede.Uof.EIP.SystemInfo.Current.UserGUID) ||
                m_authorityUCO.CheckUserHaveRolePower("AOSLAWProcedure", Ede.Uof.EIP.SystemInfo.Current.UserGUID))
            {
                //智權主管(AOSIPRSuperior)及法智程序(AOSLAWProcedure)才可點選
                if ((status == "A2"))
                    cbx.Visible = true;
                else
                    cbx.Visible = false;
            }
            //else
            //    cbx.Visible = false;

            if (m_authorityUCO.CheckUserHaveRolePower("AOSLAWSuperior", Ede.Uof.EIP.SystemInfo.Current.UserGUID) ||
                m_authorityUCO.CheckUserHaveRolePower("AOSLAWProcedure", Ede.Uof.EIP.SystemInfo.Current.UserGUID))
            {
                //法智主管(AOSLAWSuperior)及法智程序(AOSLAWProcedure)才可點選
                if ((status == "A3"))
                    cbx.Visible = true;
                else
                    cbx.Visible = false;
            }
            //else
            //    cbx.Visible = false;

            #endregion

            #region==申請單號==
            LinkButton tmplnkbtFORM_NBR = (LinkButton)e.Row.FindControl("lnkbtFORM_NBR");
            tmplnkbtFORM_NBR.Text = rowView["FORM_NBR"].ToString();
            //string[] parsMaintain = new string[2];
            ////狀態為NA且[申請者為登入者]才可維護
            //if (rowView["SIGN_STATUS"].ToString() == "NA" && (rowView["A_GVCUSERGUID"].ToString() == Current.UserGUID))
            //    parsMaintain[0] = string.Format("Mode={0}", "Update");//NA未起單時，是修改模式
            //else parsMaintain[0] = string.Format("Mode={0}", "View");//其他狀態都是維護模式
            //parsMaintain[1] = string.Format("FORM_NBR={0}", rowView["FORM_NBR"].ToString());
            //Dialog.Open(tmplnkbtFORM_NBR, "~/AOS/LAW/PME/PME_Maintain.aspx", lblTitle_MainTain.Text, 1080, 768, Dialog.PostBackType.AfterReturn, parsMaintain);
            string paramMode = "";
            if (rowView["SIGN_STATUS"].ToString() == "NA" && (rowView["A_GVCUSERGUID"].ToString() == Current.User.UserGUID))
                paramMode = "Update";//NA未起單時，是修改模式
            else paramMode = "View";//其他狀態都是維護模式
            ExpandoObject paramObj = new
            {
                Mode = paramMode,
                FORM_NBR = rowView["FORM_NBR"].ToString(),
            }.ToExpando();
            Dialog.Open2(tmplnkbtFORM_NBR, "~/AOS/LAW/PME/PME_Maintain.aspx", lblTitle_MainTain.Text, 1080, 768, Dialog.PostBackType.AfterReturn, paramObj);
            #endregion

            #region==表單單號==
            LinkButton lbtnWKFFormNbr = (LinkButton)e.Row.FindControl("lnkbtWKF_FORM_NBR");//表單單號
            if (rowView["TASK_ID"] != null && !string.IsNullOrEmpty(rowView["TASK_ID"].ToString().Trim()))//已正常產生流程
            {
                lbtnWKFFormNbr.Text = rowView["WKF_FORM_NBR"].ToString().Trim();
                //Dialog.Open(lbtnWKFFormNbr, "~/WKF/FormUse/ViewForm.aspx", "", 800, 768, Dialog.PostBackType.AfterReturn, string.Format("TASK_ID={0}", rowView["TASK_ID"].ToString()));
                ExpandoObject paramObj1 = new
                {
                    TASK_ID = rowView["TASK_ID"].ToString(),
                }.ToExpando();
                Dialog.Open2(lbtnWKFFormNbr, "~/WKF/FormUse/ViewForm.aspx", "", 800, 768, Dialog.PostBackType.AfterReturn, paramObj1);
            }
            else//尚未產生流程
                lbtnWKFFormNbr.Enabled = false;//表單單號(尚未產生流程-不能按)
            #endregion

            #region 單據上傳附檔
            ImageButton ibtnFile = (ImageButton)e.Row.FindControl("ibtnFile");
            Ede.Uof.Utility.FileCenter.V1.FileCenterModel fileCenter2 = new Ede.Uof.Utility.FileCenter.V1.FileCenterModel();
            if (rowView["FILE_GROUP_ID"].ToString() != "")
            {
                //DataTable supplierDt = fileCenter2.GetFileCollection(rowView["FILE_GROUP_ID"].ToString()).Tables[0];//取得檔案資訊
                //if (supplierDt.Rows.Count != 0)
                FileGroup fileGroup = FileCenter.GetFileGroup(rowView["FILE_GROUP_ID"].ToString());
                if (fileGroup != null)
                {
                    //Dialog.Open(ibtnFile, "~/GVC/Purchase/QI/DownloadFile.aspx", lblDownload.Text, 500, 300, Dialog.PostBackType.None, string.Format("FileGroupID={0}", rowView["FILE_GROUP_ID"].ToString()));
                    paramObj = new
                    {
                        FileGroupID = rowView["FILE_GROUP_ID"].ToString(),
                    }.ToExpando();
                    Dialog.Open2(ibtnFile, "~/AOS/LAW/PME/DownloadFile.aspx", lblDownload.Text, 500, 300, Dialog.PostBackType.None, paramObj);
                }
                else
                    ibtnFile.Visible = false;
            }
            else
                ibtnFile.Visible = false;
            #endregion

            #region 已獲淮國家
            Label tmplbAPV_CY_DESC = (Label)e.Row.FindControl("lbAPV_CY_DESC");
            if (!string.IsNullOrEmpty(rowView["APV_CY"].ToString().Trim()))
            {
                string APV_CY_DESC = "";
                string[] spiltString = rowView["APV_CY"].ToString().Split(',');
                for (int i = 0; i < spiltString.Length; i++)
                {
                    APV_CY_DESC += tmpCodeUCO.GetGvcCode("C143", spiltString[i].Trim()) + ",";
                }
                tmplbAPV_CY_DESC.Text = APV_CY_DESC.ToString().TrimEnd(',');
            }
            if (!string.IsNullOrEmpty(rowView["APV_CY_DESC"].ToString().Trim()))
            {
                tmplbAPV_CY_DESC.Text = tmplbAPV_CY_DESC.Text + "-" + rowView["APV_CY_DESC"].ToString().Trim();
            }
            #endregion

            #region 參考費用
            Label tmplbREF_DESC = (Label)e.Row.FindControl("lbREF_DESC");
            if (!string.IsNullOrEmpty(rowView["REF_AMT"].ToString().Trim()))
                tmplbREF_DESC.Text = rowView["REF_CURR_DESC"].ToString() + " " + rowView["REF_AMT"].ToString();
            #endregion

            #region 付款費用
            Label tmplbPAY_DESC = (Label)e.Row.FindControl("lbPAY_DESC");
            if (!string.IsNullOrEmpty(rowView["PAY_AMT"].ToString().Trim()) && rowView["PAY_AMT"].ToString().Trim() != "0")
                tmplbPAY_DESC.Text = rowView["PAY_CURR_DESC"].ToString() + " " + rowView["PAY_AMT"].ToString();
            #endregion
        }
    }

    protected void grdForm_BeforeExport(object sender, Ede.Uof.Utility.Component.BeforeExportEventArgs e)
    {
        QueryObj tmpQueryObj = SetFilter();
        DataTable tmpDT = tmpPmeUCO.GetDatasByCondition(tmpQueryObj);
        if (!string.IsNullOrEmpty(Convert.ToString(ViewState["SortGrid_1"])) && tmpDT.Rows.Count > 0)
            tmpDT.DefaultView.Sort = Convert.ToString(ViewState["SortGrid_1"]);
        e.Datasource = tmpDT;
    }

    protected void ddlCDESC_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCDESC.SelectedIndex == 0)
            cblCOPINION.Items.Clear();
        else if (ddlCDESC.SelectedIndex == 1)
        {
            cblCOPINION.Items.Clear();
            cblCOPINION.Items.Add(new ListItem("續繳", "P"));
            cblCOPINION.Items.Add(new ListItem("放棄", "C"));
            //cblCOPINION.Items.Add(new ListItem("全部", "ALL"));
            //foreach (ListItem li in cblCOPINION.Items)
            //    li.Selected = true;
        }
        else if (ddlCDESC.SelectedIndex == 2 || ddlCDESC.SelectedIndex == 3 || ddlCDESC.SelectedIndex == 4)
        {
            cblCOPINION.Items.Clear();
            cblCOPINION.Items.Add(new ListItem("續繳", "P"));
            cblCOPINION.Items.Add(new ListItem("讓與", "T"));
            cblCOPINION.Items.Add(new ListItem("放棄", "C"));
            cblCOPINION.Items.Add(new ListItem("其他", "O"));
            //cblCOPINION.Items.Add(new ListItem("全部", "ALL"));
            //foreach (ListItem li in cblCOPINION.Items)
            //    li.Selected = true;
        }
        else if (ddlCDESC.SelectedIndex == 5)
        {
            cblCOPINION.Items.Clear();
            cblCOPINION.Items.Add(new ListItem("續繳", "P"));
            cblCOPINION.Items.Add(new ListItem("讓與-續繳", "B"));
            cblCOPINION.Items.Add(new ListItem("讓與-放棄", "G"));
            cblCOPINION.Items.Add(new ListItem("放棄", "C"));
            //cblCOPINION.Items.Add(new ListItem("全部", "ALL"));
            //foreach (ListItem li in cblCOPINION.Items)
            //    li.Selected = true;
        }
    }
}