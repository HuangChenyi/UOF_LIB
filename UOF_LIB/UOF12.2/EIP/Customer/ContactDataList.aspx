<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="EIP_Customer_ContactDataList" Title="聯絡人清單" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="ContactDataList.aspx.cs" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function RadToolBar1ButtonClicking(sender, args) {
            var key = args.get_item().get_value();
            switch (key) {
                case "btnAdd":
                    args.set_cancel(true);
                    $uof.dialog.open2("~/EIP/Customer/ContactEdit.aspx", args.get_item(), "<%=lblAddContact.Text%>", 725, 650, OpenDialogResult, { "Mode": "Insert", "CustID": "<%=Request["CUSTOMER_ID"]%>" });
                    break;
                case "btnDelete":
                    var CheckedData = $uof.fastGrid.getChecked('<%= grd.ClientID %>');
                    if (CheckedData == "") {
                        alert("<%= lblhiddenDelete.Text %>");
                        args.set_cancel(true);
                        return;
                    }
                    else {
                        var deletedata = [CheckedData];
                        var haveAccount = $uof.pageMethod.sync("CheckHaveAccount", deletedata);
                        if (haveAccount == "true") {
                            if (!window.confirm('<%=lblDelHaveAccountConfirmMsg.Text %>')) {
                                args.set_cancel(true);
                            }
                        }
                        else {
                            if (!window.confirm('<%=Ede.Uof.Utility.Page.Common.Resource.GetResource("Common","ConfirmDelete") %>')) {
                                args.set_cancel(true);
                            }
                        }
                    }
                    break;
                case "btnCreate":
                    var CheckedData = $uof.fastGrid.getChecked('<%= grd.ClientID %>');
                    var CustID = '<%=Request["CUSTOMER_ID"] %>';
                    if (CheckedData == "") {
                        alert("<%= lblhiddenCreate.Text %>");
                        args.set_cancel(true);
                        return;
                    }
                    args.set_cancel(true);
                    $uof.dialog.open2("~/EIP/Customer/CreateExternalAccountByBat.aspx", args.get_item(), "", 700, 520, CreareDialogResult, { "CONTACT_ID": CheckedData, "CustID": CustID });
                    break;
            }
        }
        function OpenDialogResult(returnValue) {
            if (typeof (returnValue) === "undefined" || returnValue === null) {
                return false;
            }
            else
                return true;
        }

        function CreareDialogResult(returnValue) {
            if (typeof (returnValue) === "undefined" || returnValue === "AlreadyCreate" || returnValue === null) {
                if (returnValue === "AlreadyCreate") {
                    alert("<%= lblAlreadyCreate.Text %>");
                    }
                    return false;
                }
                else {
                    return true;
                }
            }
    </script>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <telerik:RadToolBar ID="RadToolBar1" runat="server" Width="100%" OnButtonClick="RadToolBar1_OnButtonClick" OnClientButtonClicking="RadToolBar1ButtonClicking">
                <Items>
                    <telerik:RadToolBarButton runat="server" Text="新增聯絡人" Value="btnAdd"
                        CheckedImageUrl="~/Common/Images/Icon/icon_m59.gif"
                        DisabledImageUrl="~/Common/Images/Icon/icon_m59.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m59.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m59.gif"
                        meta:resourcekey="RadToolBarAddResource1">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" Text="刪除聯絡人" Value="btnDelete"
                        CheckedImageUrl="~/Common/Images/Icon/icon_m03.gif"
                        DisabledImageUrl="~/Common/Images/Icon/icon_m03.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m03.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m03.gif"
                        meta:resourcekey="RadToolBarDeleteResource1">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" Text="建立外部會員帳號" Value="btnCreate"
                        CheckedImageUrl="~/Common/Images/Icon/icon_m59.gif"
                        DisabledImageUrl="~/Common/Images/Icon/icon_m59.gif"
                        HoveredImageUrl="~/Common/Images/Icon/icon_m59.gif"
                        ImageUrl="~/Common/Images/Icon/icon_m59.gif"
                        meta:resourcekey="RadToolBarCreateResource1">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton IsSeparator="true" Value="sp"></telerik:RadToolBarButton>
                </Items>
            </telerik:RadToolBar>
            <Fast:Grid ID="grd" runat="server" DataKeyNames="CONTACT_ID" AllowSorting="True"
                AutoGenerateCheckBoxColumn="True" AutoGenerateColumns="False"
                DataKeyOnClientWithCheckBox="True"
                EnhancePager="True" PageSize="15"
                AllowPaging="True" Width="100%"
                OnRowDataBound="grd_RowDataBound"
                DefaultSortDirection="Ascending">
                <EnhancePagerSettings
                    ShowHeaderPager="True" FirstAltImageUrl="" FirstImageUrl="" LastAltImage=""
                    LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass=""
                    PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass=""
                    PreviousAltImageUrl="" PreviousImageUrl="" />
                <ExportExcelSettings AllowExportToExcel="False" />
                <Columns>
                    <asp:TemplateField HeaderText="姓名" meta:resourcekey="TemplateFieldResource1">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" Text='<%# Eval("CONTACT_NAME") %>' ID="lbtn" OnClick="lbtn_Click"
                                meta:resourcekey="lbtnResource1"></asp:LinkButton>

                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="false" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="sex" HeaderText="性別" meta:resourcekey="BoundFieldResource1">
                        <HeaderStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="DEPARTMENT" HeaderText="單位" meta:resourcekey="BoundFieldResource2">
                        <HeaderStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="TITLE" HeaderText="職稱" meta:resourcekey="BoundFieldResource3">
                        <HeaderStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="電話" meta:resourcekey="TemplateFieldResource2">
                        <ItemTemplate>
                            <asp:HyperLink ID="hlTEL" runat="server" Text='<%# Eval("TEL") %>' Target="CalltoFrame"></asp:HyperLink>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="false" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="EXT_NUM" HeaderText="分機" meta:resourcekey="BoundFieldResource5">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="false" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="手機" meta:resourcekey="TemplateFieldResource3">
                        <ItemTemplate>
                            <asp:HyperLink ID="hlMobile" runat="server" Text='<%# Eval("MOBILE_PHONE") %>' Target="CalltoFrame"></asp:HyperLink>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="false" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="EMAIL" HeaderText="電子郵件" meta:resourcekey="BoundFieldResource7" />
                    <asp:BoundField DataField="EBACCOUNT" HeaderText="外部會員帳號"
                        meta:resourcekey="BoundFieldResource8">
                        <HeaderStyle Wrap="False" />
                    </asp:BoundField>
                </Columns>
            </Fast:Grid>
            <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" MaximumRowsParameterName="intMaxRows"
                OldValuesParameterFormatString="original_{0}" SelectCountMethod="GetContactDataSetByCustID_Count"
                SelectMethod="GetContactDataSetByCustID" SortParameterName="strSortExpression" StartRowIndexParameterName="intStartIndex"
                TypeName="Ede.Uof.EIP.Customer.UCO.CUSContactUCO" EnablePaging="True">
                <SelectParameters>
                    <asp:Parameter Name="CustID" Type="String" />
                    <asp:Parameter Name="intStartIndex" Type="Int32" />
                    <asp:Parameter Name="intMaxRows" Type="Int32" />
                    <asp:Parameter Name="strSortExpression" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Label ID="lblhiddenDelete" runat="server" Text="沒有挑選要刪除的項目" Visible="False" meta:resourcekey="lblhiddenDeleteResource1"></asp:Label>
    <asp:Label ID="lblAddContact" runat="server" Text="新增聯絡人" Visible="False" meta:resourcekey="lblAddContactResource1"></asp:Label>
    <asp:Label ID="lblEdit" runat="server" Text="修改聯絡人資料" Visible="False" meta:resourcekey="lblEditResource1"></asp:Label>
    <asp:Label ID="lblContact" runat="server" Text="瀏覽聯絡人資料" Visible="False" meta:resourcekey="lblContactResource1"></asp:Label>
    <asp:Label ID="lblMale" runat="server" Text="男" Visible="False" meta:resourcekey="lblMaleResource1"></asp:Label>
    <asp:Label ID="lblFemale" runat="server" Text="女" Visible="False" meta:resourcekey="lblFemaleResource1"></asp:Label>
    <asp:Label ID="lblhiddenCreate" runat="server" Text="沒有挑選要建立的項目" Visible="False" meta:resourcekey="lblhiddenCreateResource1"></asp:Label>
    <asp:Label ID="lblAlreadyCreate" runat="server" Text="挑選的項目裡已有建立外部會員帳號,請選擇尚未建立帳號的項目" Visible="False" meta:resourcekey="lblAlreadyCreateResource1"></asp:Label>
    <asp:Label ID="lblDelHaveAccountConfirmMsg" runat="server" Text="挑選的項目裡已有建立外部會員帳號，確定要刪除嗎?" Visible="False" meta:resourcekey="lblDelHaveAccountConfirmMsgResource1"></asp:Label>
    <iframe id="CalltoFrame" name="CalltoFrame" height="0" width="0"></iframe>
</asp:Content>

