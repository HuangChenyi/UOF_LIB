<%@ Page Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" Inherits="System_Report_LoginLog_NotLoginUser" Title="未登入使用者查詢" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="NotLoginUser.aspx.cs" %>
<%@ Register Assembly="System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="System.Web.UI" TagPrefix="cc1" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
<!--
    function RadToolBar1_NL_ButtonClicking(sender, args) {
        var Key = args.get_item().get_value();
        if (Key == "btnSendMail") {
            var UserType = $("#<%= hidUserType.ClientID%>").val();
            var QueryDate = $("#<%= hidQueryTime.ClientID%>").val();

            args.set_cancel(true);
            if (UserType != null) {
                $uof.dialog.open2("~/System/Report/LoginLog/SendNotLoginUserMail.aspx", args.get_item(), "", 450, 350, function () { return false; },
                    { "QueryDate": QueryDate, "usertype": UserType });
            }
        }
    }
    // -->
    function OnValueChanging(sender, args)
    {
        if (args.get_newValue() == "") {
            args.set_newValue(args.get_oldValue());
        }
    }
    </script>
    <center style="text-align: left">
        <telerik:RadToolBar ID="RadToolBar1" runat="server" Width="100%" 
            OnButtonClick="RadToolBar1_ButtonClick" 
            OnClientButtonClicking="RadToolBar1_NL_ButtonClicking" 
            meta:resourcekey="RadToolBar1Resource1">
            <Items>
                <telerik:RadToolBarButton runat="server" Value="UserType" 
                    meta:resourcekey="RadToolBarButtonResource1">
                    <ItemTemplate>
                        <table>
                            <tr>
                                <td style="padding-left: 2px; padding-right: 1px">
                                    <asp:Label runat="server" Text="會員群組：" meta:resourcekey="TBLabelResource1"></asp:Label></td>
                                <td style="padding-left: 2px; padding-right: 1px">
                                    <asp:DropDownList runat="server" ID="ddlUserType" meta:resourcekey="ddlUserTypeResource1">
                                        <asp:ListItem Value="all" meta:resourcekey="ListItemResource1" Text="全部"></asp:ListItem>
                                        <asp:ListItem Value="Member" meta:resourcekey="ListItemResource2" Text="外部會員"></asp:ListItem>
                                        <asp:ListItem Value="Employee" meta:resourcekey="ListItemResource3" Text="內部會員"></asp:ListItem>
                                    </asp:DropDownList></td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </telerik:RadToolBarButton>
                <telerik:RadToolBarButton runat="server" IsSeparator="True" 
                    meta:resourcekey="RadToolBarButtonResource2">
                </telerik:RadToolBarButton>
                <telerik:RadToolBarButton runat="server" Value="QueryDate" 
                    meta:resourcekey="RadToolBarButtonResource3">
                    <ItemTemplate>
                        <table>
                            <tr>
                                <td style="padding-left: 2px; padding-right: 1px">
                                    <asp:Label runat="server" Text="查詢最後登入日期：" meta:resourcekey="TBLabelResource2"></asp:Label></td>
                                <td style="padding-left: 2px; padding-right: 1px">
                                    <telerik:RadDatePicker ID="rdpQueryDate" runat="server"  
                                        meta:resourcekey="rdpQueryDateResource1">
                                        <Calendar UseColumnHeadersAsSelectors="False" UseRowHeadersAsSelectors="False" >
                                        </Calendar>
                                        <DateInput  LabelWidth="64px"  ClientEvents-OnValueChanging="OnValueChanging"
                                            Width="">
                                        </DateInput>
                                        <DatePopupButton CssClass="" HoverImageUrl="" ImageUrl=""   />
                                    </telerik:RadDatePicker>
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </telerik:RadToolBarButton>
                <telerik:RadToolBarButton runat="server" IsSeparator="True" 
                    meta:resourcekey="RadToolBarButtonResource4">
                </telerik:RadToolBarButton>
                <telerik:RadToolBarButton runat="server" DisabledImageUrl="~/Common/Images/Icon/icon_m39.gif"
                    HoveredImageUrl="~/Common/Images/Icon/icon_m39.gif" ImageUrl="~/Common/Images/Icon/icon_m39.gif"
                    Value="btnQuery" CheckedImageUrl="~/Common/Images/Icon/icon_m39.gif"
                    Text="查詢" meta:resourcekey="TBarButtonResource1">
                </telerik:RadToolBarButton>
                <telerik:RadToolBarButton runat="server" IsSeparator="True" 
                    meta:resourcekey="RadToolBarButtonResource5">
                </telerik:RadToolBarButton>
                <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/EIP/Personal/icon_images/icon_m33.gif" ImageUrl="~/EIP/Personal/icon_images/icon_m33.gif"
                    Value="btnSendMail" CheckedImageUrl="~/EIP/Personal/icon_images/icon_m33.gif" Text="發送郵件" meta:resourcekey="TBarButtonResource4">
                </telerik:RadToolBarButton>
                <telerik:RadToolBarButton runat="server" IsSeparator="True" 
                    meta:resourcekey="RadToolBarButtonResource6">
                </telerik:RadToolBarButton>
            </Items>
        </telerik:RadToolBar>
    </center>
    <center style="text-align: left">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <contenttemplate>           
<%--               <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="114px" ControlToValidate="wdcQueryDate" Display="Dynamic" ErrorMessage="請輸入查詢日期" Font-Size="X-Small" meta:resourceKey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator>--%>
                <fast:grid id="DGList" runat="server" allowsorting="True" autogeneratecheckboxcolumn="False"
                            autogeneratecolumns="False"  
                             DataKeyNames="USER_GUID" OnPageIndexChanging="DGList_PageIndexChanging" OnRowDataBound="DGList_RowDataBound" Width="500px"  AllowPaging="True" OnSorting="DGList_Sorting" DataKeyOnClientWithCheckBox="False"><Columns>
         <asp:TemplateField HeaderText="使用者名稱" meta:resourcekey="TemplateFieldResource1" SortExpression="USER_GUID">
                                        <itemtemplate>
        <asp:Label runat="server" ID="lblUser" meta:resourceKey="lblUserResource1"></asp:Label>


                            
        </itemtemplate>
                            </asp:TemplateField>
        <asp:BoundField DataField="LAST_LOGIN_TIME" HeaderText="最後登入時間" SortExpression="LAST_LOGIN_TIME" meta:resourcekey="BoundFieldResource1"></asp:BoundField>
        <asp:BoundField DataField="IP" HeaderText="最後登入IP" SortExpression="IP" meta:resourcekey="BoundFieldResource2"></asp:BoundField>
        </Columns>
        </fast:grid>
                <asp:TextBox ID="txtMail" runat="server" Visible="False" meta:resourcekey="txtMailResource1"></asp:TextBox> 
                <asp:HiddenField ID="hidQueryTime" runat="server" />
                <asp:HiddenField ID="hidUserType" runat="server" />
            </contenttemplate>
            <triggers>
                <asp:AsyncPostBackTrigger ControlID="RadToolBar1" EventName="ButtonClick" /> 
           </triggers>
        </asp:UpdatePanel>
    </center>
    <asp:HiddenField ID="hfCurrentGUID" runat="server" />
</asp:Content>

