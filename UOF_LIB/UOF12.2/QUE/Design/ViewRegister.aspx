<%@ Page Language="C#" Title="回收結果" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="QUE_Design_ViewRegister" culture="auto" uiculture="auto" meta:resourcekey="PageResource1" Codebehind="ViewRegister.aspx.cs" %>
   
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="width: 100%" cellspacing="1" class="NormalPopTable">
                <tr>
                    <td style="width: 150px; white-space:nowrap;">
                        <asp:CheckBox ID="chkAnsopt" runat="server" Text="顯示全部答案選項" AutoPostBack="True" 
                            OnCheckedChanged="chkAnsopt_CheckedChanged" 
                            meta:resourcekey="chkAnsoptResource1" />
                    </td>
                    <td>
                    <div style ="width :60px;padding-left:5px;">
                        <asp:Label ID="Label2" runat="server" Text="人員姓名"  Width="60px"
                            meta:resourcekey="Label2Resource1"></asp:Label></div>
                    </td>
                    <td style="width: 60px; padding-left:5px; padding-right:5px">
                        <asp:TextBox ID="txtName" runat="server" meta:resourcekey="txtNameResource1"></asp:TextBox>
                    </td>
                    <td  class="PopTableRightTD">
                        <telerik:RadButton ID="ibtnQuery" runat="server" Text="查詢" OnClick="ibtnQuery_Click" meta:resourcekey="ibtnQueryResource1"></telerik:RadButton>
                    </td>
                    <td  class="PopTableRightTD">
                        <telerik:RadButton ID="ibtnSend" runat="server" Text="再次通知未送出者" OnClick="ibtnSend_Click" meta:resourcekey="ibtnSendResource1"></telerik:RadButton>
                    </td>
                </tr>
            </table>
            <Fast:Grid ID="gridSubmit" runat="server" AutoGenerateColumns="False" 
                DataKeyOnClientWithCheckBox="False"  
                Width="100%" DataKeyNames="TAGET_USER" AllowPaging="True" 
                EnhancePager="True" PageSize="15" HorizontalAlign="Center" AutoGenerateCheckBoxColumn="False"
                AllowSorting="True" OnRowDataBound="gridSubmit_RowDataBound"  DefaultSortDirection="Ascending" EmptyDataText="沒有資料" KeepSelectedRows="False" meta:resourcekey="gridSubmitResource2"   
                >
                <EnhancePagerSettings
                    ShowHeaderPager="True" firstaltimageurl="" firstimageurl="" lastaltimage="" lastimageurl="" nextialtimageurl="" nextimageurl="" pageinfocssclass="" pagenumbercssclass="" pagenumbercurrentcssclass="" pageredirectcssclass="" previousaltimageurl="" previousimageurl=""></EnhancePagerSettings>
                <exportexcelsettings allowexporttoexcel="False" />
                <Columns>
                    <asp:BoundField HeaderText="人員姓名" DataField="NAME" SortExpression="NAME"  meta:resourcekey="BoundFieldResource1" />
               <asp:BoundField HeaderText="完成數" DataField="SM"  SortExpression="SM" meta:resourcekey="BoundFieldResource2" />                        
                    <asp:TemplateField HeaderText="最近回收時間" SortExpression="SUBMIT_DATE" meta:resourcekey="BoundFieldResource3">                     
                        <ItemTemplate>
                            <asp:Label ID="lblLatestRecycleTime" runat="server" Text='<%# Bind("SUBMIT_DATE") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                   <asp:TemplateField HeaderText="操作" meta:resourcekey="TemplateFieldResource1">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtnViewAns" runat="server" Text="查看內容" meta:resourcekey="lbtnViewAnsResource1"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </Fast:Grid>        

       <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" EnablePaging="True" MaximumRowsParameterName="intMaxRows"
                SelectCountMethod="GetQueWriter_Count" SelectMethod="GetQueWriter" SortParameterName="strSortExpression"
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
            <asp:Label ID="lblUN" runat="server" Text="未填寫" Visible="False" 
                meta:resourcekey="lblUNResource1"></asp:Label>
            <asp:Label ID="lblSM" runat="server" Text="已送出" Visible="False" meta:resourcekey="lblSMResource2"></asp:Label>
           <asp:Label ID="lblSA" runat="server" Text="已保存" Visible="False" meta:resourcekey="lblSAResource1" ></asp:Label>
                
            <asp:Label ID="lblLinkName" runat="server" Text="請點選此處,填寫問卷。" Visible="False" 
                meta:resourcekey="lblLinkNameResource1"></asp:Label>
            <asp:Label ID="lblSendSuccess" runat="server" Visible="False" Text="通知已送出" 
                meta:resourcekey="lblSendSuccessResource1"></asp:Label>
                        <asp:Label ID="lblPersonalQusList" Text ="選擇填寫/觀看問卷" Visible="False" runat="server" meta:resourcekey="lblPersonalQusListResource1"></asp:Label>
                        <asp:Label ID="lblViewDetailList" Text ="觀看問卷" Visible="False" runat="server" meta:resourcekey="lblViewDetailListResource1"></asp:Label>
            <asp:HiddenField ID="hidRcdSort" runat="server" />
                 <asp:Label ID="lblNoMail" runat="server" Visible="False" Text="問卷通知功能未啟用或問卷已經不存在" meta:resourcekey="lblNoMailResource1" ></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
