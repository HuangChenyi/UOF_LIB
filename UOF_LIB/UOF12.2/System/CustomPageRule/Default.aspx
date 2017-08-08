<%@ Page Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" Inherits="System_CustomHomepage_Default" Title=""
    Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Default.aspx.cs" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <Fast:Grid ID="Grid3" runat="server" DataKeyNames="WEBPART_ID" AutoGenerateCheckBoxColumn="False"
        AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False" Width="60%" OnRowDataBound="Grid3_RowDataBound"
        AllowSorting="True" EnhancePager="True" PageSize="15" DefaultSortDirection="Ascending"
        EmptyDataText="沒有資料" KeepSelectedRows="False"
        meta:resourcekey="Grid3Resource2" CustomDropDownListPage="False" SelectedRowColor="" UnSelectedRowColor=""   >
        <ExportExcelSettings AllowExportToExcel="False"></ExportExcelSettings>
        <Columns>
            <asp:BoundField Visible="False" DataField="WEBPART_ID" meta:resourcekey="BoundFieldResource1" />
            <asp:BoundField HeaderText="面板名稱" meta:resourcekey="BoundFieldResource2" >
                <HeaderStyle Wrap="False" />
            </asp:BoundField>
            <asp:TemplateField HeaderText="內部是否啟用" meta:resourcekey="TemplateFieldResource2">
                <ItemTemplate>
                    <asp:UpdatePanel runat="server" ID="UpdatePanel3" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:CheckBox runat="server" AutoPostBack="True" ID="cbEnable" WEBPART_ID='<%# Eval("WEBPART_ID")%>'
                                Checked='<%# Eval("ENABLE") %>' OnCheckedChanged="cbEnable_CheckedChanged" meta:resourcekey="cbEnableResource2"></asp:CheckBox>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="cbEnable" EventName="CheckedChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </ItemTemplate>
                <HeaderStyle Wrap="False" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="內部是否允許關閉" meta:resourceKey="TemplateFieldResource1">
                <ItemTemplate>
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:CheckBox ID="cbAllowClose" runat="server" AutoPostBack="True" Checked='<%# Eval("ALLOW_CLOSE") %>' meta:resourcekey="cbAllowCloseResource1" OnCheckedChanged="cbAllowClose_CheckedChanged" WEBPART_ID='<%# Eval("WEBPART_ID")%>' />
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="cbAllowClose" EventName="CheckedChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </ItemTemplate>
                <HeaderStyle Wrap="False" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="外部是否啟用" meta:resourceKey="TemplateFieldResource3">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:UpdatePanel ID="UpdatePanel4" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:CheckBox ID="cbMemberEnable" runat="server" AutoPostBack="true" WEBPART_ID='<%# Eval("WEBPART_ID")%>' Checked='<%# Eval("ENABLE_MEMBER") %>' OnCheckedChanged="cbMemberEnable_CheckedChanged" />
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="cbMemberEnable" EventName="CheckedChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </ItemTemplate>
                <HeaderStyle Wrap="False" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="外部是否允許關閉" meta:resourceKey="TemplateFieldResource4">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:CheckBox ID="cbAllowCloseMember" runat="server" AutoPostBack="True" Checked='<%# Eval("ALLOW_CLOSE_MEMBER") %>' WEBPART_ID='<%# Eval("WEBPART_ID")%>' OnCheckedChanged="cbAllowCloseMember_CheckedChanged" />
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="cbAllowCloseMember" EventName="CheckedChanged" />
                        </Triggers>
                    </asp:UpdatePanel>
                </ItemTemplate>
                <HeaderStyle Wrap="False" />
            </asp:TemplateField>
        </Columns>
        <EnhancePagerSettings FirstAltImageUrl="" FirstImageUrl="" LastAltImage="" LastImageUrl=""
            NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass="" PageNumberCssClass=""
            PageNumberCurrentCssClass="" PageRedirectCssClass="" PreviousAltImageUrl="" PreviousImageUrl=""
            ShowHeaderPager="True" />
    </Fast:Grid>
    <asp:Label ID="lblApply" runat="server" Text="此天氣預測資料來自中央氣象局RSS，欲開啟此面板請務必向台灣中央氣象局填寫使用申請書。"
        Visible="False" meta:resourcekey="lblApplyResource1"></asp:Label>
</asp:Content>
