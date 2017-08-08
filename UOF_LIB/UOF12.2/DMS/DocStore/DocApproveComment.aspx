<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_DocStore_DocApproveComment" Title="" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="DocApproveComment.aspx.cs" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="height: 100%;border:0px;width:100%;" class="PopTable">
        <tr runat="server" id="trgrid">
            <td colspan="2" class="PopTableRightTD">
                <Fast:Grid runat="server" ID="gridApproved" AutoGenerateCheckBoxColumn="False" AllowSorting="True" AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False" EnhancePager="True" OnRowDataBound="gridApproved_RowDataBound" PageSize="15" Width="100%">
                    <EnhancePagerSettings
                        ShowHeaderPager="True" FirstAltImageUrl="" FirstImageUrl="" LastAltImage="" LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass="" PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass="" PreviousAltImageUrl="" PreviousImageUrl="" />
                    <Columns>
                        <asp:BoundField DataField="DOC_NAME" HeaderText="已被審核文件" SortExpression="DOC_NAME" meta:resourcekey="BoundFieldResource1" />
                        <asp:TemplateField HeaderText="調閱人" SortExpression="LEND_USER" meta:resourcekey="TemplateFieldResource1">
                            <EditItemTemplate>
                                <asp:TextBox runat="server" Text='<%# Bind("LEND_USER") %>' ID="TextBox1"></asp:TextBox>

                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label runat="server" Text='<%# Bind("LEND_USER") %>' ID="lblAuthor" __designer:wfdid="w49"></asp:Label>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="APPROVE_USER" HeaderText="審核者" SortExpression="APPROVE_USER" meta:resourcekey="BoundFieldResource2" />
                    </Columns>
                </Fast:Grid>
            </td>
        </tr>
        <tr>
            <td style="white-space:nowrap" >
                <asp:Label ID="lblComment" runat="server"></asp:Label></td>
            <td >
                <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Height="100%" Width="100%" Rows="10"></asp:TextBox></td>
        </tr>
    </table>
    <asp:CustomValidator ID="cvError" runat="server" ErrorMessage="CustomValidator" Visible="False" meta:resourcekey="cvErrorResource1">請填寫拒絕原因!</asp:CustomValidator>

    <asp:Label ID="lblAccept" runat="server" Text="允許備註" Visible="False" meta:resourcekey="lblAcceptResource1"></asp:Label>
    <asp:Label ID="lblReject" runat="server" Text="拒絕理由" Visible="False" meta:resourcekey="lblRejectResource1"></asp:Label>
    <asp:Label ID="lblAlreadyApprove" runat="server" Text="您選擇的文件已被其他審核者審核，請關閉視窗重新選擇" Visible="False" meta:resourcekey="lblAlreadyApproveResource1"></asp:Label>
    <asp:HiddenField ID="hfType" runat="server" />
    <asp:HiddenField ID="hfStatus" runat="server" />
</asp:Content>

