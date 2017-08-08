<%@ Page Title="線上刷卡IP維護" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" Inherits="CDS_HR_Punch_PunchIPRange" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="PunchIPRange.aspx.cs" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Assembly="System.Web.Extensions" Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register Src="../../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<script id="punchJS" type="text/javascript">
    function RadToolBarButtonClicking(sender, args) {
        var key = args.get_item().get_value();
        switch (key) {
            case "ADDIP":
                args.set_cancel(true);
                $uof.dialog.open2("~/EIP/Duty/Punch/PunchIPRangeEdit.aspx", args.get_item(), '<%=lblDiagTitleAdd.Text %>', 300, 250, openDialogResult);

                break;
            case "DELIP":
                if (!confirm('<%=lblDelIPConfirm.Text %>')) {
                    args.set_cancel(true);
                }
                break;
        }
    }

    function openDialogResult(returnValue)
    {
        if (returnValue === '' || returnValue === null)
            return false;
        else
            return true;
    }

</script>    
    <telerik:RadTabStrip ID="rdTabs" runat="server" SelectedIndex="0" MultiPageID="rdMultiPage">
        <Tabs>
            <telerik:RadTab runat="server" Text="特殊人員" PageViewID="pageView1"  Selected="True">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="刷卡IP維護" PageViewID="pageView2">
            </telerik:RadTab>
        </Tabs>
    </telerik:RadTabStrip>
    <telerik:RadMultiPage ID="rdMultiPage" runat="server" SelectedIndex="0">
        <telerik:RadPageView ID="pageView1" runat="server" Width="100%">
            <table style="width: 100%">
                <tr>
                    <td>
                        <asp:Label ID="Label1" runat="server" Text="說明：特殊人員不受刷卡IP範圍的限制。" CssClass="SizeMemo" meta:resourcekey="Label1Resource1"></asp:Label>
                    </td>
                </tr>
            </table>
            <table style="width: 100%">
                <tr>
                    <td>
                        <uc1:UC_ChoiceList ID="SelectUser" runat="server" TreeHeight="500px" />
                    </td>
                </tr>
            </table>
        </telerik:RadPageView>
        <telerik:RadPageView ID="pageView2" runat="server" Width="100%">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <ContentTemplate>                  
                    <table style="width: 500px; height: 100%;">
                        <tr>
                            <td valign="top">
                                        <telerik:RadToolBar ID="RadToolBar1" runat="server" Width="500px" OnButtonClick="RadToolBar1_OnButtonClick" OnClientButtonClicking="RadToolBarButtonClicking" >
                                            <Items>
                                                <telerik:RadToolBarButton runat="server" Text="新增" Value="ADDIP"
                                                    CheckedImageUrl="~/Common/Images/Icon/icon_m02.gif"
                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m02.gif"
                                                    HoveredImageUrl="~/Common/Images/Icon/icon_m02.gif"
                                                    ImageUrl="~/Common/Images/Icon/icon_m02.gif"
                                                    meta:resourcekey="RadToolBarADDIPResource1">
                                                </telerik:RadToolBarButton>
                                                <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>
                                                <telerik:RadToolBarButton runat="server" Text="刪除" Value="DELIP"
                                                    CheckedImageUrl="~/Common/Images/Icon/icon_m03.gif"
                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m03.gif"
                                                    HoveredImageUrl="~/Common/Images/Icon/icon_m03.gif"
                                                    ImageUrl="~/Common/Images/Icon/icon_m03.gif"
                                                    meta:resourcekey="RadToolBarDELIPResource1">
                                                </telerik:RadToolBarButton>
                                                <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>
                                            </Items>
                                        </telerik:RadToolBar>
                                        <Fast:Grid ID="IPGrid" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateCheckBoxColumn="True"
                                            AutoGenerateColumns="False"  DataKeyNames="INDEX"
                                            DataKeyOnClientWithCheckBox="True" DefaultSortDirection="Ascending" EmptyDataText="沒有資料"
                                            EnableModelValidation="True" EnhancePager="True" OnPageIndexChanging="IPGrid_PageIndexChanging"
                                            OnRowDataBound="IPGrid_RowDataBound" PageSize="15"  
                                             KeepSelectedRows="False" 
                                            meta:resourcekey="IPGridResource1">
                                            <EnhancePagerSettings
                                                ShowHeaderPager="False" />
                                            <ExportExcelSettings AllowExportToExcel="False" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="IP(起)" meta:resourcekey="TemplateFieldResource1">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lbtnBegin" runat="server" Text='<%# Bind("BEGIN") %>' 
                                                            meta:resourcekey="lbtnBeginResource1"></asp:LinkButton>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="150px" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="END" HeaderText="IP(訖)" 
                                                    meta:resourcekey="BoundFieldResource1">
                                                    <HeaderStyle Width="150px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="REMARK" HeaderText="備註" 
                                                    meta:resourcekey="BoundFieldResource2" >
                                                <ItemStyle Width="200px" />
                                                </asp:BoundField>
                                            </Columns>
                                        </Fast:Grid>
                                    </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </telerik:RadPageView>
    </telerik:RadMultiPage>
    <br />
    <asp:Label ID="lblDiagTitleAdd" runat="server" Text="新增IP範圍" Visible="False" meta:resourcekey="lblDiagTitleAddResource1"></asp:Label>
    <asp:Label ID="lblDiagTitleEdit" runat="server" Text="維護IP範圍" Visible="False" meta:resourcekey="lblDiagTitleEditResource1"></asp:Label>
    <asp:Label ID="lblDelIPConfirm" runat="server" Text="確定要刪除選取的IP嗎？" Visible="False"
        meta:resourcekey="lblDelIPConfirmResource1"></asp:Label>
    <asp:Label ID="Label2" runat="server" Text="特殊人員" Visible="False" 
        meta:resourcekey="Label2Resource1"></asp:Label>
    <asp:Label ID="Label3" runat="server" Text="刷卡IP維護" Visible="False" 
        meta:resourcekey="Label3Resource1"></asp:Label>
</asp:Content>
