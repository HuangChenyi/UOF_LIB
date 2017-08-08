<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OptionFieldUC_Order.ascx.cs" Inherits="WKF_OptionalFields_OptionFieldUC_Order" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Ede" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>

<table class="PopTable"  style="width:500px" >
    <tr>
        <td>
            <asp:Label ID="Label1" runat="server" Text="訂單編號"></asp:Label>
        </td>
        
        
        <td>
            <asp:DropDownList ID="ddlOrderId" runat="server" DataTextField="OrderID" DataValueField="OrderID" AutoPostBack="true"
                 OnSelectedIndexChanged="ddlOrderId_SelectedIndexChanged" ></asp:DropDownList>

            <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                ControlToValidate="ddlOrderId" Display="Dynamic"
                 runat="server" ErrorMessage="請選擇訂單編號"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td>
             <asp:Label ID="Label2" runat="server" Text="客戶ID"></asp:Label>
        </td>
        <td>
            <asp:Label ID="lblCustomerID" runat="server" Text=""></asp:Label>
        </td>
    </tr>
    
        <tr>
        <td>
             <asp:Label ID="Label3" runat="server" Text="訂單日期"></asp:Label>
        </td>
        <td>
             <asp:Label ID="lblOrderDate" runat="server" Text=""></asp:Label>
        </td>
    </tr>
</table>

<Ede:Grid ID="Grid1" runat="server" AutoGenerateCheckBoxColumn="false" AutoGenerateColumns="false" >
    <Columns>
        <asp:BoundField HeaderText="產品名稱"  DataField="ProductName" />
         <asp:BoundField HeaderText="單價"  DataField="UnitPrice" />
         <asp:BoundField HeaderText="數量"  DataField="Quantity" />
    </Columns>
</Ede:Grid>

<asp:Label ID="lblSelected" runat="server" Text="---請選擇---" Visible="false"></asp:Label>
<asp:Label ID="lblHasNoAuthority" runat="server" Text="無填寫權限" ForeColor="Red" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
<asp:Label ID="lblToolTipMsg" runat="server" Text="不允許修改(唯讀)" Visible="False" meta:resourcekey="lblToolTipMsgResource1"></asp:Label>
<asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
<asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
<asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>