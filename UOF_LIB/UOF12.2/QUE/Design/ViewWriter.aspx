<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="QUE_Design_ViewWriter" culture="auto" uiculture="auto" Codebehind="ViewWriter.aspx.cs" %>
<%@ Register Assembly="System.Web.Extensions" Namespace="System.Web.UI" TagPrefix="asp" %>
  
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
          <table style="width: 100%" cellspacing="1" class="PopTable">
                <tr>                   
                    <td style="width: 80px">
                        <asp:Label ID="Label2" runat="server" Text="人員姓名" meta:resourcekey="Label2Resource1" ></asp:Label>
                    </td>
                    <td style="width: 80px">
                        <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
                    </td>
                    <td>
                        <telerik:RadButton ID="ibtnQuery" runat="server" Text="查詢" OnClick="ibtnQuery_Click" meta:resourcekey="ibtnQueryResource1"></telerik:RadButton>
                    </td>
                   
                </tr>
            </table>
         <div style="padding-left:3px;padding-top :3px;width:99%">
            <Fast:Grid ID="gridSubmit" runat="server" AutoGenerateColumns="False" 
                DataKeyOnClientWithCheckBox="False"  
                Width="100%" DataKeyNames="TAGET_USER" AllowPaging="True" 
                EnhancePager="True" PageSize="15" HorizontalAlign="Center" AutoGenerateCheckBoxColumn="False"
                AllowSorting="True" OnRowDataBound="gridSubmit_RowDataBound" 
                >
                <EnhancePagerSettings
                    ShowHeaderPager="True"></EnhancePagerSettings>
                <Columns>
                    <asp:BoundField HeaderText="人員姓名" DataField="NAME" SortExpression="TAGET_USER" 
                        meta:resourcekey="BoundFieldResource1" />
<%--                    <asp:BoundField HeaderText="儲存數" SortExpression="SA"  DataField="SA" />
--%>                    <asp:BoundField HeaderText="完成數" SortExpression="SM"  DataField="SM" />

                </Columns>
            </Fast:Grid>
            </div>
            <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" EnablePaging="True" MaximumRowsParameterName="intMaxRows"
                SelectCountMethod="GetQueWriter_Count" SelectMethod="GetQueWriter" SortParameterName="strSortExpression"
                StartRowIndexParameterName="intStartIndex" TypeName="Ede.Uof.EIP.QUE.QusUCO" 
                OldValuesParameterFormatString="original_{0}">
                <SelectParameters>
                    <asp:Parameter Name="conditon"  />
                    <asp:Parameter Name="intStartIndex" Type="Int32" />
                    <asp:Parameter Name="intMaxRows" Type="Int32" />
                    <asp:Parameter Name="strSortExpression" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:Label ID="lblMasterID" runat="server" Visible="False" 
                meta:resourcekey="lblMasterIDResource1"></asp:Label>
            <asp:Label ID="lblDesignID" runat="server" Visible="False" 
                meta:resourcekey="lblDesignIDResource1"></asp:Label>
            <asp:Label ID="lblUN" runat="server" Text="未填寫" Visible="False" 
                meta:resourcekey="lblUNResource1"></asp:Label>
            <asp:Label ID="lblSM" runat="server" Text="已填寫" Visible="False" 
                meta:resourcekey="lblSMResource1"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
