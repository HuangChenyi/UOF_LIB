using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Ede.Uof.WKF.Design;
using System.Collections.Generic;
using Ede.Uof.WKF.Utility;
using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.WKF.Design.Data;
using Ede.Uof.WKF.VersionFields;
using System.Xml;
using System.Dynamic;
using Ede.Uof.Utility.Page.Common;
using Ede.Uof.Utility.FileCenter.V3;
public partial class WKF_OptionalFields_showImg : WKF_FormManagement_VersionFieldUserControl_VersionFieldUC
{

	#region ==============公開方法及屬性==============
    //表單設計時
	//如果為False時,表示是在表單設計時
    private bool m_ShowGetValueButton = true;
    public bool ShowGetValueButton
    {
        get { return this.m_ShowGetValueButton; }
        set { this.m_ShowGetValueButton = value; }
    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
		//這裡不用修改
		//欄位的初始化資料都到SetField Method去做
        SetField(m_versionField);
    }    

    /// <summary>
    /// 外掛欄位的條件值
    /// </summary>
    public override string ConditionValue
    {
        get
        {
			//回傳字串
			//此字串的內容將會被表單拿來當做條件判斷的值
			return String.Empty;
        }
    }

    /// <summary>
    /// 是否被修改
    /// </summary>
    public override bool IsModified
    {
        get
        {
			//請自行判斷欄位內容是否有被修改
			//有修改回傳True
			//沒有修改回傳False
			return false;
        }
    }

    /// <summary>
    /// 查詢顯示的標題
    /// </summary>
    public override string DisplayTitle
    {
        get
        {
			//表單查詢或WebPart顯示的標題
			//回傳字串
            return String.Empty;
        }
    }

    /// <summary>
    /// 訊息通知的內容
    /// </summary>
    public override string Message
    {
        get
        {
			//表單訊息通知顯示的內容
			//回傳字串
            return String.Empty;
        }
    }


    /// <summary>
    /// 真實的值
    /// </summary>
    public override string RealValue
    {
        get
        {
            //回傳字串
			//取得表單欄位簽核者的UsetSet字串
            //內容必須符合EB UserSet的格式
			return String.Empty;
        }
        set
        {
			//這個屬性不用修改
            base.m_fieldValue = value;
        }
    }


    /// <summary>
    /// 欄位的內容
    /// </summary>
    public override string FieldValue
    {
        get
        {
            //回傳字串
			//取得表單欄位填寫的內容

            XmlDocument xmlDoc = new XmlDocument();
            XmlElement fieldValueElement = xmlDoc.CreateElement("FieldValue");

            fieldValueElement.SetAttribute("fieldGroupId", UC_FileCenter.FileGroupId);
            fieldValueElement.SetAttribute("content" , txtContent.Text);
            return fieldValueElement.OuterXml;
        }
        set
        {
			//這個屬性不用修改
            base.m_fieldValue = value;
        }
    }

    /// <summary>
    /// 是否為第一次填寫
    /// </summary>
    public override bool IsFirstTimeWrite
    {
        get
        {
            //這裡請自行判斷是否為第一次填寫
            return false;
        }
        set
        {
            //這個屬性不用修改
            base.IsFirstTimeWrite = value;
        }
    }

    /// <summary>
    /// 顯示時欄位初始值
    /// </summary>
    /// <param name="versionField">欄位集合</param>
    public override void SetField(Ede.Uof.WKF.Design.VersionField versionField)
    {
        FieldOptional fieldOptional = versionField as FieldOptional;

        if (fieldOptional != null)
        {

            CustomValidator1.ClientValidationFunction = "ClientValidate_" + fieldOptional.FieldID;

            if (!string.IsNullOrEmpty(fieldOptional.FieldValue))
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(fieldOptional.FieldValue);
                XmlNode node = xmlDoc.SelectSingleNode("./FieldValue");

                if (!IsPostBack)
                {
                    UC_FileCenter.LoadByFileGroup(node.Attributes["fieldGroupId"].Value);
                }
                    txtContent.Text = node.Attributes["content"].Value;
                    lblContent.Text = node.Attributes["content"].Value;
                            }
            else
            {
                if (!IsPostBack)
                {
                    UC_FileCenter.LoadByFileGroup(System.Guid.NewGuid().ToString());
                    UC_FileCenter.SubmitChanges();
                }
            }

            ShowImage();

            ExpandoObject fileParams = new
            {
                fileGroupId = UC_FileCenter.FileGroupId,
            }.ToExpando();

            Dialog.Open2(LinkButton1, "~/CDS/WKF_Fields/UI/UploadImg.aspx", "", 800, 400, Dialog.PostBackType.AfterReturn, fileParams);


            switch (fieldOptional.FieldMode)
            { 
                case FieldMode.View:
                case FieldMode.Print:
                case FieldMode.Signin:
                    txtContent.Visible = false;
                    lblContent.Visible = true;
                    LinkButton1.Visible = false;
                    break;
            }


            #region ==============屬性說明==============『』
			//fieldOptional.IsRequiredField『是否為必填欄位,如果是必填(True),如果不是必填(False)』
			//fieldOptional.DisplayOnly『是否為純顯示,如果是(True),如果不是(False),一般在觀看表單及列印表單時,屬性為True』
			//fieldOptional.HasAuthority『是否有填寫權限,如果有填寫權限(True),如果沒有填寫權限(False)』
			//fieldOptional.FieldValue『如果已有人填寫過欄位,則此屬性為記錄其內容』
			//fieldOptional.FieldDefault『如果欄位有預設值,則此屬性為記錄其內容』
			//fieldOptional.FieldModify『是否允許修改,如果允許(fieldOptional.FieldModify=FieldModifyType.yes),如果不允許(fieldOptional.FieldModify=FieldModifyType.no)』
			//fieldOptional.Modifier『如果欄位有被修改過,則Modifier的內容為EBUser,如果沒有被修改過,則會等於Null』
            #endregion

            #region ==============如果有修改，要顯示修改者資訊==============
            if (fieldOptional.Modifier != null)
            {
                lblModifier.Visible = true;
                lblModifier.ForeColor = System.Drawing.Color.FromArgb(0x52, 0x52, 0x52);
                lblModifier.Text = String.Format("( {0} )", fieldOptional.Modifier.Name);
            } 
            #endregion
        }
    }
    protected void LinkButton1_Click(object sender, EventArgs e)
    {
      
        if (!string.IsNullOrEmpty(Dialog.GetReturnValue()))
        {
            UC_FileCenter.LoadByFileGroup(Dialog.GetReturnValue());
        }

        ShowImage();

    }

    private void ShowImage()
    {
        FileGroup fg = FileCenter.GetFileGroup(UC_FileCenter.FileGroupId);
        if (fg != null && fg.Count == 1)
        {
            img.ImageUrl = "~/Common/FileCenter/ShowImage.aspx?id=" + fg[0].Id;
        }
    }
}