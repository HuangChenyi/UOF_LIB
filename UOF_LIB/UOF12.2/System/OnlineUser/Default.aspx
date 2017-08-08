<%@ Page Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" Inherits="System_OnlineUser_Default" Title="線上使用者管理"
    Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" CodeBehind="Default.aspx.cs" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <telerik:RadToolBar ID="RadToolBar1" runat="server" Width="100%" OnButtonClick="RadToolBar1_ButtonClick">
        <Items>
            <telerik:RadToolBarButton runat="server" DisabledImageUrl="~/Common/Images/Icon/icon_m39.gif"
                HoveredImageUrl="~/Common/Images/Icon/icon_m39.gif" ImageUrl="~/Common/Images/Icon/icon_m39.gif"
                Value="Search" CheckedImageUrl="~/Common/Images/Icon/icon_m39.gif"
                Text="更新名單" meta:resourcekey="RadButtonRefreshResource1">
            </telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" IsSeparator="True">
            </telerik:RadToolBarButton>
        </Items>
    </telerik:RadToolBar>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <Fast:Grid ID="Grid1" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="False"
                DataSourceID="ObjectDataSource1" AutoGenerateColumns="False" DataKeyNames="userGuid,ip"
                OnPageIndexChanging="Grid1_PageIndexChanging" OnRowCommand="Grid1_RowCommand"
                OnRowDataBound="Grid1_RowDataBound" AllowPaging="True" DataKeyOnClientWithCheckBox="False">
                <Columns>
                    <asp:TemplateField HeaderText="使用者" SortExpression="userGUID" meta:resourcekey="TemplateFieldResource1">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("userGUID") %>' ID="Label1" meta:resourceKey="Label1Resource1"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="IP" DataField="ip" SortExpression="ip" />
                    <asp:TemplateField HeaderText="最後要求時間" SortExpression="requestTime">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("requestTime") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblRequestTime" runat="server" Text='<%# Bind("requestTime") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="使用模組" SortExpression="module" meta:resourcekey="TemplateFieldResource2">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Bind("module") %>' ID="Label2" meta:resourceKey="Label2Resource1"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField CommandName="kick" Text="強制登出" meta:resourcekey="ButtonFieldResource1" />
                </Columns>
            </Fast:Grid>
            <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetOnlineUsers" TypeName="Ede.Uof.Utility.OnlineManagement.OnlineUser"></asp:ObjectDataSource>
            <asp:HiddenField ID="hfCurrentUser" runat="server" />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="RadToolBar1" EventName="ButtonClick" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
