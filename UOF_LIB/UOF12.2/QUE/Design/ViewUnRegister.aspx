<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="QUE_Design_ViewUnRegister" culture="auto" uiculture="auto" Codebehind="ViewUnRegister.aspx.cs" %>
   
<%@ Register Assembly="System.Web.Extensions" Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="width: 100%" cellspacing="1" class="PopTable">
                <tr>
                    <td style="text-align:left; white-space:nowrap" class="PopTableRightTD">
                        <asp:CheckBox ID="chkAnsopt" runat="server" Text="顯示全部答案選項" AutoPostBack="True" 
                            OnCheckedChanged="chkAnsopt_CheckedChanged" 
                            meta:resourcekey="chkAnsoptResource1" />
                    </td>                    
                    <td style="width:10%" class="PopTableRightTD">
                        <telerik:RadButton ID="ibtnViewWrite" runat="server" Text="填寫人查詢"  meta:resourcekey="ibtnViewWriteResource1"></telerik:RadButton>
                    </td>
                    <td class="PopTableRightTD" style="text-align:left">
                        <telerik:RadButton ID="ibtnSend" runat="server" Text="再次通知未送出者"  OnClick="ibtnSend_Click" meta:resourcekey="ibtnSendResource1"></telerik:RadButton>
                       
                    </td>
                </tr>
            </table>
            <Fast:Grid ID="gridSubmit" runat="server" AutoGenerateColumns="False" 
                DataKeyOnClientWithCheckBox="False"  
                Width="100%" DataKeyNames="TAGET_USER" AllowPaging="True" 
                EnhancePager="True" PageSize="15" HorizontalAlign="Center" AutoGenerateCheckBoxColumn="False"
                AllowSorting="True" OnRowDataBound="gridSubmit_RowDataBound" 
                >
                <EnhancePagerSettings
                    ShowHeaderPager="True"></EnhancePagerSettings>
                <Columns>
                    <asp:TemplateField HeaderText="問卷" meta:resourcekey="TemplateFieldResource1">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtnQue" runat="server" meta:resourcekey="lbtnQueResource1"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </Fast:Grid>
            <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" EnablePaging="True" MaximumRowsParameterName="intMaxRows"
                SelectCountMethod="GetQueDetail_Count" SelectMethod="GetQueDetail" SortParameterName="strSortExpression"
                StartRowIndexParameterName="intStartIndex" TypeName="Ede.Uof.EIP.QUE.QusUCO">
                <SelectParameters>
                    <asp:Parameter Name="conditon" />
                    <asp:Parameter Name="intStartIndex" />
                    <asp:Parameter Name="intMaxRows" />
                    <asp:Parameter Name="strSortExpression" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:Label ID="lblType" runat="server" Text="瀏覽個人填寫問卷" Visible="False" 
                meta:resourcekey="lblTypeResource1"></asp:Label>
            <asp:Label ID="lblQusName" runat="server" Visible="False" 
                meta:resourcekey="lblQusNameResource1"></asp:Label>
            <asp:Label ID="lblViewWrite" runat="server" Text="查看填寫人" Visible="False" 
                meta:resourcekey="lblViewWriteResource1"></asp:Label>
              <asp:Label ID="lblLinkName" runat="server" Text="請點選此處,填寫問卷。" Visible="False" 
                meta:resourcekey="lblLinkNameResource1"></asp:Label>
              <asp:Label ID="lblName" runat="server" Text="回收問卷" Visible="False" 
                meta:resourcekey="lblNameResource1"></asp:Label>
              <asp:Label ID="lblSendSuccess" runat="server" Visible="False" Text="通知已送出" 
                meta:resourcekey="lblSendSuccessResource1"></asp:Label>
       <asp:Label ID="lblNoMail" runat="server" Visible="False" Text="問卷通知功能未啟用或問卷已經不存在" ></asp:Label>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
