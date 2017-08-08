<%@ Control Language="C#" AutoEventWireup="true" Inherits="EIP_Calendar_Common_UC_ScheduleTypeList" Codebehind="UC_ScheduleTypeList.ascx.cs" %>
<asp:DropDownList ID="ddlTypeList" runat="server" AutoPostBack="True" 
    onselectedindexchanged="ddlTypeList_SelectedIndexChanged" 
    meta:resourcekey="ddlTypeListResource1">
    <asp:ListItem Text="全部顯示" Value="All" meta:resourcekey="ListItemResource1"></asp:ListItem>
    <asp:ListItem Text="工作" Value="Work" meta:resourcekey="ListItemResource2"></asp:ListItem>
    <asp:ListItem Text="會議" Value="Meeting" meta:resourcekey="ListItemResource3"></asp:ListItem>
    <asp:ListItem Text="備忘" Value="Memorandum" meta:resourcekey="ListItemResource4"></asp:ListItem>
    <asp:ListItem Text="交辦事項" Value="Devolve" meta:resourcekey="ListItemResource5"></asp:ListItem>
    <asp:ListItem Text="借用" Value="Borrow" meta:resourcekey="ListItemResource6"></asp:ListItem>
    <asp:ListItem Text="個人休假" Value="MyHoliday" 
        meta:resourcekey="ListItemResource7"></asp:ListItem>
    <asp:ListItem Text="部門休假" Value="CorporationHoliday" 
        meta:resourcekey="ListItemResource8"></asp:ListItem>
    <asp:ListItem Text="部門事件" Value="Event" meta:resourcekey="ListItemResource9"></asp:ListItem>
</asp:DropDownList>