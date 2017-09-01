<%@ Page Title="專利維護評估表-主程式" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="PME_Default.aspx.cs" Inherits="AOS_LAW_PME_PME_Default" %>

<%@ Register assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI" tagprefix="asp" %>
<%@ Register assembly="Ede.Uof.Utility.Component.Grid" namespace="Ede.Uof.Utility.Component" tagprefix="Fast" %>
<%@ Register src="../../UserControl/UC_HrEtClassChoice.ascx" tagname="UC_HrEtClassChoice" tagprefix="uc1" %>
<%@ Register src="../../UserControl/UC_HrDeptOrStaffChoice.ascx" tagname="UC_HrDeptOrStaffChoice" tagprefix="uc2" %>
<%@ Register src="../../UserControl/UC_HrDeptOrStaffChoice.ascx" tagname="UC_HrDeptOrStaffChoice" tagprefix="uc5" %>
<%@ Register src="~/GVC/UserControl/UC_CodeChoiceBySpec.ascx" tagname="UC_CodeChoiceBySpec" tagprefix="uc10" %>
<%@ Register src="../../../Common/ChoiceCenter/UC_ChoiceList.ascx" tagname="UC_ChoiceList" tagprefix="uc6" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        function OpenFormMaintain(fileGroupID) {
            $uof.dialog.open2("~/AOS/LAW/PME/DownloadFile.aspx", "<%=btnBindFile.ClientID %>", "下載檔案", 400, 100, OpenDialogResult, { "FileGroupID": fileGroupID });
        }
        function UltraWebToolbar1(sender, args) {
            //args.get_item().set_enabled(false);
            var value = args.get_item().get_value();
            if (value == "btInsert") //新增
            {
                args.set_cancel(true);
                $uof.dialog.open2("~/AOS/LAW/PME/PME_MainTain.aspx", args.get_item(), "<%=lblTitle_NewForm.Text %>", 1024, 768, OpenDialogResult, { "Mode": "Insert" });
            }
            else if (value == "btDelete") //刪除
            {
                if (!confirm("<%=lbConfirmDelete.Text%>")) {
                    args.set_cancel(true);
                }                
            }
            else if (value == "btImport") //匯入起單
            {
                args.set_cancel(true);
                $uof.dialog.open2("~/AOS/LAW/PME/PME_Import.aspx", args.get_item(), "<%=lblTitle_Import.Text %>", 1024, 768, OpenDialogResult);
            }
            else if (value == "IPCImport") 
            {
                args.set_cancel(true);
                $uof.dialog.open2("~/AOS/LAW/PME/PME_ImportFile.aspx", args.get_item(), "匯入IPC", 600, 300, OpenDialogResult, { "MODE": "IPC" });
            }
            else if (value == "FEEImport")
            {
                args.set_cancel(true);
                $uof.dialog.open2("~/AOS/LAW/PME/PME_ImportFile.aspx", args.get_item(), "匯入費用表", 600, 300, OpenDialogResult, { "MODE": "FEE" });
            }
        }
        function OpenDialogResult(returnValue) {
            if (typeof (returnValue) == "undefined")
                return false;
            else
                return true;
        }
    </script>
    <iframe id="ExportFrame" frameborder="0" width="0" height="0"></iframe>
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <telerik:RadToolBar ID="UltraWebToolbar1" runat="server"
                OnButtonClick="UltraWebToolbar1_ButtonClicked"
                OnClientButtonClicking="UltraWebToolbar1">
                <Items>
                    <telerik:RadToolBarButton
                        DisabledImageUrl="~/Common/Images/Icon/icon_m39.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m39.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m39.gif"
                        CheckedImageUrl="~/Common/Images/Icon/icon_m39.gif"
                        ClickedImageUrl="~/Common/Images/Icon/icon_m39.gif"
                        Value="btQuery" Text="查詢">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton 
                        DisabledImageUrl="~/Common/Images/Icon/icon_m161.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m161.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m161.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m161.gif"
                        Text="新增" Value="btInsert">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton 
                        DisabledImageUrl="~/Common/Images/Icon/icon_m141.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m141.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m141.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m141.gif"
                        Text="刪除" Value="btDelete">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton 
                        DisabledImageUrl="~/Common/Images/Icon/icon_m110.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m110.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m110.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m110.gif"
                        Text="匯入起單" Value="btImport">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton 
                        DisabledImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        Text="主管審核" Value="btA1APPROVE">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />                    
                    <telerik:RadToolBarButton 
                        DisabledImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        Text="智權主管同意(A2)" Value="btA2APPROVE">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton 
                        DisabledImageUrl="~/Common/Images/Icon/icon_m25.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m25.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m25.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m25.gif"
                        Text="A2退回A1" Value="btA2RETURNA1">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton 
                        DisabledImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m53.gif"
                        Text="法智主管同意(A3)" Value="btA3APPROVE">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton 
                        DisabledImageUrl="~/Common/Images/Icon/icon_m25.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m25.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m25.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m25.gif"
                        Text="A3退回A2" Value="btA3RETURNA2">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton 
                        DisabledImageUrl="~/Common/Images/Icon/icon_m160.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m160.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m160.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m160.gif"
                        Text="列印付款憑證" Value="btPrint">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton
                        DisabledImageUrl="~/Common/Images/Icon/icon_m62.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m62.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m62.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m62.gif"
                        Text="匯入IPC" Value="IPCImport">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton
                        DisabledImageUrl="~/Common/Images/Icon/icon_m62.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m62.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m62.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m62.gif"
                        Text="匯入費用表" Value="FEEImport">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                    <telerik:RadToolBarButton
                        DisabledImageUrl="~/Common/Images/Icon/icon_m144.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m144.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m144.gif"
                        FocusedImageUrl="~/Common/Images/Icon/icon_m144.gif"
                        Text="匯出RD評估資料" Value="E1Export">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" />
                </Items>
            </telerik:RadToolBar>
    
            <table class="PopTable" style="width: 723px">
                <tr>
                    <td style="width: 20%" class="PopTableLeftTD">
                        <asp:Label ID="Label34" runat="server" Text="是否帶入主管簽名"></asp:Label>
                    </td>
                    <td style="width: 80%" class="PopTableRightTD">
                        <asp:CheckBox runat="server" ID="cblIS_E1" Text="是"/>
                    </td>
                </tr>
            </table>
            <telerik:RadPanelBar ID="WebPanel1" runat="server" Width="1100">
                <Items>
                    <telerik:RadPanelItem runat="server" Text="查詢條件區" CssClass="TopTableLeftTD" Width="100%"
                        Expanded="true">
                        <ContentTemplate>
                            <table cellspacing="1" class="PopTable" width="100%">
                                <colgroup class="PopTableLeftTD" style="width: 120px"></colgroup>
                                <colgroup class="PopTableRightTD" style="width: 500px"></colgroup>
                                <colgroup class="PopTableLeftTD" style="width: 120px"></colgroup>
                                <colgroup class="PopTableRightTD" style="width: 500px"></colgroup>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label8" runat="server" Text="表單申請者"></asp:Label>
                                    </td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:TextBox ID="txtFormApplicant" runat="server"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <uc6:UC_ChoiceList ID="UC_FormApplicant" runat="server" ExpandToUser="False"
                                                        ChioceType="User" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label6" runat="server" Text="申請日期"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label47" runat="server" Text="起"></asp:Label>
                                        <telerik:RadDatePicker SkinID="AllowEmpty" ID="wdcSDATE" runat="server" NullDateLabel="">
                                        </telerik:RadDatePicker>
                                        <asp:Label ID="Label2" runat="server" Text="~迄"></asp:Label>
                                        <telerik:RadDatePicker SkinID="AllowEmpty" ID="wdcEDATE" runat="server" NullDateLabel="">
                                        </telerik:RadDatePicker>
                                    </td>                                    
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label10" runat="server" Text="申請單號"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label48" runat="server" Text="起"></asp:Label>
                                        <asp:TextBox ID="txtFORM_NBR_START" runat="server" Width="100"></asp:TextBox>
                                        <asp:Label ID="Label49" runat="server" Text="~迄"></asp:Label>
                                        <asp:TextBox ID="txtFORM_NBR_END" runat="server" Width="100"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label58" runat="server" Text="表單單號"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" Text="起"></asp:Label>
                                        <asp:TextBox ID="txtWKF_FORM_NBR_START" runat="server" Width="100"></asp:TextBox>
                                        <asp:Label ID="Label5" runat="server" Text="~迄"></asp:Label>
                                        <asp:TextBox ID="txtWKF_FORM_NBR_END" runat="server" Width="100"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label15" runat="server" Text="評估部門(GVC)"></asp:Label>
                                    </td>
                                    <td>
                                        <uc6:UC_ChoiceList ID="UC_E1_DEPT_GUID" runat="server" ShowMember="False"
                                            ChioceType="Group" ExpandToUser="False" />
                                    </td>
                                    <td>
                                        <asp:Label ID="Label21" runat="server" Text="評估者(E1)"></asp:Label>
                                    </td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:TextBox ID="txtAPPROVE_E1" runat="server"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <uc6:UC_ChoiceList ID="UC_APPROVE_E1" runat="server" ExpandToUser="False"
                                                        ChioceType="User" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label9" runat="server" Text="專利名稱"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPATENT_NAME" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label11" runat="server" Text="期望回覆日期"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" Text="起"></asp:Label>
                                        <telerik:RadDatePicker SkinID="AllowEmpty" ID="wdcREQUEST_SDATE" runat="server" NullDateLabel="">
                                        </telerik:RadDatePicker>
                                        <asp:Label ID="Label3" runat="server" Text="~迄"></asp:Label>
                                        <telerik:RadDatePicker SkinID="AllowEmpty" ID="wdcREQUEST_EDATE" runat="server" NullDateLabel="">
                                        </telerik:RadDatePicker>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label7" runat="server" Text="發明人"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtINVENTOR" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label12" runat="server" Text="發明單位"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtINVENT_DEPT" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label13" runat="server" Text="申請國家"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:CheckBoxList ID="cblEST_CY" runat="server" RepeatDirection="Horizontal">
                                        </asp:CheckBoxList>
                                        <asp:TextBox ID="txtEST_CY_DESC" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label36" runat="server" Text="已獲淮國家"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:CheckBoxList ID="cblAPV_CY" runat="server" RepeatDirection="Horizontal">
                                        </asp:CheckBoxList>
                                        <asp:TextBox ID="txtAPV_CY_DESC" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label14" runat="server" Text="社內編號"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtEPS_NO" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label37" runat="server" Text="證書號"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCERTIFICATE_NO" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label16" runat="server" Text="社內技術分類別"></asp:Label>
                                    </td>
                                    <td>                                        
                                        <asp:TextBox ID="txtRD_TYPE_DESC" runat="server"></asp:TextBox>
                                        <asp:DropDownList ID="ddlRD_TYPE" runat="server"></asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label17" runat="server" Text="國際分類號"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtIPC_CODE" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label18" runat="server" Text="引用號碼"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCITE_CODE" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label19" runat="server" Text="被引用號碼"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPA_CITE_CODE" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label38" runat="server" Text="引用次數"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCITE_CODE_NUM" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label39" runat="server" Text="被引用次數"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPA_CITE_CODE_NUM" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label20" runat="server" Text="維護意見"></asp:Label>
                                    </td>
                                    <td>
                                        <table border="0"><tr>
                                            <td>
                                                <asp:DropDownList ID="ddlCDESC" runat="server" OnSelectedIndexChanged="ddlCDESC_SelectedIndexChanged" AutoPostBack="true">
                                                    <asp:ListItem Value="">請選擇</asp:ListItem>
                                                    <asp:ListItem Value="E1">評估者(E1)</asp:ListItem>
                                                    <asp:ListItem Value="A1">承辦意見(A1)</asp:ListItem>
                                                    <asp:ListItem Value="A2">智權主管意見(A2)</asp:ListItem>
                                                    <asp:ListItem Value="A3">法智主管意見(A3)</asp:ListItem>
                                                    <asp:ListItem Value="A4">最終結果(A4)</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td><asp:CheckBoxList ID="cblCOPINION" runat="server" RepeatDirection="Horizontal"></asp:CheckBoxList></td>
                                        </tr></table>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label22" runat="server" Text="專利等級"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPATENT_LEVEL_DESC" runat="server"></asp:TextBox>
                                        <asp:DropDownList ID="ddlPATENT_LEVEL" runat="server"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label23" runat="server" Text="結案日期"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label24" runat="server" Text="起"></asp:Label>
                                        <telerik:RadDatePicker SkinID="AllowEmpty" ID="wdcAP_SDATE" runat="server" NullDateLabel="">
                                        </telerik:RadDatePicker>
                                        <asp:Label ID="Label25" runat="server" Text="~迄"></asp:Label>
                                        <telerik:RadDatePicker SkinID="AllowEmpty" ID="wdcAP_EDATE" runat="server" NullDateLabel="">
                                        </telerik:RadDatePicker>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label40" runat="server" Text="簽核狀態"></asp:Label>
                                    </td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:DropDownList ID="ddlSignStatus" runat="server"
                                                        meta:resourcekey="ddlSignStatusResource1">
                                                        <asp:ListItem Value="ALL" meta:resourcekey="ListItemResource1">全部</asp:ListItem>
                                                        <asp:ListItem Value="AP" meta:resourcekey="ListItemResource2">已結案</asp:ListItem>
                                                        <asp:ListItem Value="Other" meta:resourcekey="ListItemResource3">未結案</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <uc10:UC_CodeChoiceBySpec ID="UC_SignStatus" runat="server" Multiple="True"
                                                        SetCodeType="C146" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label26" runat="server" Text="是否已列印"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:CheckBoxList ID="cblIS_PRINT" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="Y">已列印</asp:ListItem>
                                            <asp:ListItem Value="N">未列印</asp:ListItem>
                                        </asp:CheckBoxList>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label27" runat="server" Text="列印日期"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label28" runat="server" Text="起"></asp:Label>
                                        <telerik:RadDatePicker SkinID="AllowEmpty" ID="wdcPRINT_SDATE" runat="server" NullDateLabel="">
                                        </telerik:RadDatePicker>
                                        <asp:Label ID="Label29" runat="server" Text="~迄"></asp:Label>
                                        <telerik:RadDatePicker SkinID="AllowEmpty" ID="wdcPRINT_EDATE" runat="server" NullDateLabel="">
                                        </telerik:RadDatePicker>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label30" runat="server" Text="申請者部門"></asp:Label>
                                    </td>
                                    <td>
                                        <uc6:UC_ChoiceList ID="UC_A_DEPT_GUID" runat="server" ShowMember="False"
                                            ChioceType="Group" ExpandToUser="False" />
                                    </td>
                                    <td>
                                        <asp:Label ID="Label31" runat="server" Text="繳費期限"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label32" runat="server" Text="起"></asp:Label>
                                        <telerik:RadDatePicker SkinID="AllowEmpty" ID="wdcPAY_SDATE" runat="server" NullDateLabel="">
                                        </telerik:RadDatePicker>
                                        <asp:Label ID="Label33" runat="server" Text="~迄"></asp:Label>
                                        <telerik:RadDatePicker SkinID="AllowEmpty" ID="wdcPAY_EDATE" runat="server" NullDateLabel="">
                                        </telerik:RadDatePicker>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label35" runat="server" Text="繳費年次"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPAY_AGE" runat="server" Width="60%"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label41" runat="server" Text="專利權人"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlPATENTEE" runat="server"></asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </telerik:RadPanelItem>
                </Items>
            </telerik:RadPanelBar>
                        
            <Fast:Grid ID="grdForm" runat="server"
                AutoGenerateCheckBoxColumn="True" AutoGenerateColumns="False"
                CustomDropDownListPage="False" DataKeyOnClientWithCheckBox="False"
                DefaultSortDirection="Ascending" EmptyDataText="No data found"
                EnableModelValidation="True" EnhancePager="True"
                OnPageIndexChanging="grdForm_PageIndexChanging" OnBeforeExport="grdForm_BeforeExport"
                OnRowDataBound="grdForm_RowDataBound" OnSorting="grdForm_Sorting"
                PageSize="18" SelectedRowColor="" UnSelectedRowColor="" Width="100%"
                DataKeyNames="FORM_NBR,SIGN_STATUS,A_GVCUSERGUID,A1_OPINION,A2_OPINION,WKF_FORM_NBR,TASK_ID" AllowSorting="True" AllowPaging="True">
                <EnhancePagerSettings FirstAltImageUrl="" FirstImageUrl="" LastAltImage=""
                    LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass=""
                    PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass=""
                    PreviousAltImageUrl="" PreviousImageUrl="" ShowHeaderPager="True" />
                <ExportExcelSettings AllowExportToExcel="True" />
                <Columns>
                    <asp:BoundField HeaderText="No." DataField="NO" SortExpression="NO">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="申請單號" SortExpression="FORM_NBR">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkbtFORM_NBR" runat="server"></asp:LinkButton>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="表單單號" SortExpression="WKF_FORM_NBR">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkbtWKF_FORM_NBR" runat="server"></asp:LinkButton>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="簽核狀態" DataField="SIGN_STATUS_DESC" SortExpression="SIGN_STATUS_DESC">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="社內編號/證書號" DataField="EPS_NO" SortExpression="EPS_NO">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="證書號" DataField="CERTIFICATE_NO" SortExpression="CERTIFICATE_NO">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="專利名稱" DataField="PATENT_NAME" SortExpression="PATENT_NAME">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="申請國家" DataField="EST_CY_CODEDESC" SortExpression="EST_CY">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="已獲淮國家" SortExpression="APV_CY">
                        <ItemTemplate>
                            <asp:Label ID="lbAPV_CY_DESC" runat="server"></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="核決意見" DataField="E1_OPINION_DESC" SortExpression="E1_OPINION_DESC">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="專利等級" DataField="PATENT_LEVEL_DESC" SortExpression="PATENT_LEVEL">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="承辦意見(A1)" DataField="A1_OPINION_DESC" SortExpression="A1_OPINION">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="智權主管意見(A2)" DataField="A2_OPINION_DESC" SortExpression="A2_OPINION">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="法智主管意見(A3)" DataField="A3_OPINION_DESC" SortExpression="A3_OPINION">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="最終結果(A4)" DataField="A4_OPINION_DESC" SortExpression="A4_OPINION">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="附件">
                        <ItemTemplate>
                            <asp:ImageButton ID="ibtnFile" runat="server" ImageUrl="~/common/images/icon/icon_m61.gif" />
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="表單申請者" DataField="A_NAME" SortExpression="A_NAME">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="評估者(E1)" DataField="APPROVE_E1_NAME" SortExpression="APPROVE_E1_NAME">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="評估部門(GVC)" DataField="E1_DEPT_GUID_DESC" SortExpression="E1_DEPT_GUID_DESC">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="發明單位" DataField="INVENT_DEPT" SortExpression="INVENT_DEPT">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="發明人" DataField="INVENTOR" SortExpression="INVENTOR">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="繳費年次" DataField="PAY_AGE" SortExpression="PAY_AGE">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="參考費用">
                        <ItemTemplate>
                            <asp:Label ID="lbREF_DESC" runat="server"></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="付款費用">
                        <ItemTemplate>
                            <asp:Label ID="lbPAY_DESC" runat="server"></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="國際分類號" DataField="IPC_CODE" SortExpression="IPC_CODE">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="社內技術分類別" DataField="RD_TYPE_DESC" SortExpression="RD_TYPE_DESC">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="引用次數" DataField="CITE_CODE_NUM" SortExpression="CITE_CODE_NUM">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="引用號碼" DataField="CITE_CODE" SortExpression="CITE_CODE">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="被引用次數" DataField="PA_CITE_CODE_NUM" SortExpression="PA_CITE_CODE_NUM">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="被引用號碼" DataField="PA_CITE_CODE" SortExpression="PA_CITE_CODE">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="APPLY_DATE" HeaderText="申請日期"
                        SortExpression="APPLY_DATE" meta:resourcekey="BoundFieldResource4"
                        DataFormatString="{0:yyyy/MM/dd}">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PAY_DATE" HeaderText="繳費期限"
                        SortExpression="PAY_DATE" meta:resourcekey="BoundFieldResource4"
                        DataFormatString="{0:yyyy/MM/dd}">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="AP_DATE" HeaderText="結案日期"
                        SortExpression="AP_DATE" meta:resourcekey="BoundFieldResource4"
                        DataFormatString="{0:yyyy/MM/dd}">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" HorizontalAlign="Center" />
                    </asp:BoundField>                                        
                    <asp:BoundField DataField="PRINT_DATE" HeaderText="列印日期"
                        SortExpression="PRINT_DATE" meta:resourcekey="BoundFieldResource4"
                        DataFormatString="{0:yyyy/MM/dd}">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="專利權人" DataField="PATENTEE_DESC" SortExpression="A_HRS_DEPT_DESC">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="申請部門" DataField="A_HRS_DEPT_DESC" SortExpression="A_HRS_DEPT_DESC">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <%--<asp:BoundField HeaderText="A1建議/原因" DataField="A1_DESC">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="A2建議/原因" DataField="A2_DESC">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="A3建議/原因" DataField="A3_DESC">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="A4建議/原因" DataField="A4_DESC">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="A4其他" DataField="A4_OTHER">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>--%>
                </Columns>
            </Fast:Grid>
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:Label ID="lbConfirmDelete" runat="server" Text="您確定要刪除所勾選的資料?" Visible="False"></asp:Label>
    <asp:HiddenField ID="havePME_Viewer" runat="server" Value="false" />
    <asp:HiddenField ID="havePME_DocViewer" runat="server" Value="false" />
    <asp:HiddenField ID="haveAOSAID" runat="server" Value="false" />

    <asp:Label ID="lblDeleteOk" runat="server" Text="成功刪除指定的資料!!" Visible="False"></asp:Label>
    <asp:Label ID="lblDeleteError" runat="server" Text="刪除指定的資料失敗!!" Visible="False"></asp:Label>
    <asp:Label ID="lblNoSelectDelMsg" runat="server" Text="您未勾選欲刪除的申請單號!!" Visible="False"></asp:Label>
    <asp:Label ID="lblNoneNASelectDelMsg" runat="server" Text="您勾選欲刪除的申請單號{0}其簽核狀態不為【新增(NA)】!!" Visible="False"></asp:Label>
    <asp:Label ID="lblTitle_NewForm" runat="server" Text="專利維護評估表-新增單據" Visible="False"></asp:Label>
    <asp:Label ID="lblTitle_MainTain" runat="server" Text="專利維護評估表-單據維護" Visible="False"></asp:Label>
    <asp:Label ID="lblTitle_Import" runat="server" Text="專利維護評估表-匯入起單" Visible="False"></asp:Label>
    <asp:Label ID="lblDownload" runat="server" Text="檔案下載" Visible="False" meta:resourcekey="lblDownloadResource1"></asp:Label>
    <asp:Label ID="lblNoCheck" runat="server" Text="您並未勾選任何記錄!!" Visible="false"></asp:Label>
    <asp:Label ID="lblA2Error" runat="server" Text="您所勾選的資料簽核狀態須為智權主管審核(A2)且承辦意見(A1)之維護結果 須為P(續繳)!!" Visible="false"></asp:Label>
    <asp:Label ID="lblA3Error" runat="server" Text="您所勾選的資料簽核狀態須為法智主管審核(A3)且智權主管意見(A2)之維護結果 須為P(續繳)!!" Visible="false"></asp:Label>
    <asp:Label ID="lbDownload" runat="server" Text="下載檔案" Visible="False"></asp:Label>
    <asp:Button ID="btnBindFile" runat="server" Style="display: none" meta:resourcekey="btnBindFileResource1" />
            
</asp:Content>

