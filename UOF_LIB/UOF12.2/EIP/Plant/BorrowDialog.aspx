<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="Test_Borrow_BorrowDialog" Title="預約時間" meta:resourcekey="PageResource1" Culture="auto" UICulture="auto" Codebehind="BorrowDialog.aspx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" ForeColor="Red" ErrorMessage="設備已被預訂,無法新增借用" meta:resourcekey="CustomValidator2Resource1"></asp:CustomValidator>
    <asp:CustomValidator ID="CustomValidator5" runat="server" Display="Dynamic" ForeColor="Red" ErrorMessage="結束時間需大於開始時間"></asp:CustomValidator>
    <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ForeColor="Red" ErrorMessage=""></asp:CustomValidator>
    <table cellspacing="0" class="PopTable">
        <tr>
            <td style="white-space:nowrap;">
                <span style="color: #ff0000">*</span><asp:Label ID="lbLeftBegin" runat="server" Text="開始時間" meta:resourcekey="lbLeftBeginResource1"></asp:Label></td>
            <td>
                <table>
                    <tr>
                        <td>
                            <telerik:RadDateTimePicker ID="RadDateTimePicker1" runat="server">
                            </telerik:RadDateTimePicker>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:CustomValidator ID="CustomValidator4" runat="server" Display="Dynamic" ErrorMessage="請填寫開始時間" ForeColor="Red" meta:resourcekey="CustomValidator4Resource1"></asp:CustomValidator></td>

                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color: #ff0000">*</span><asp:Label ID="lbLeftEnd" runat="server" Text="結束時間" meta:resourcekey="lbLeftEndResource1"></asp:Label></td>
            <td>
                <table>
                    <tr>
                        <td>
                            <telerik:RadDateTimePicker ID="RadDateTimePicker2" runat="server">
                            </telerik:RadDateTimePicker>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:CustomValidator ID="CustomValidator3" runat="server" Display="Dynamic" ErrorMessage="請填寫結束時間" ForeColor="Red" meta:resourcekey="CustomValidator3Resource1"></asp:CustomValidator></td>

                    </tr>

                </table>
            </td>
        </tr>
    </table>
    <asp:Label ID="lblSampleShowLimitMsg" runat="server" Text="設備{0}只開放今天後{1}天內借用(可借用到{2})。" Visible="false" meta:resourcekey="lblSampleShowLimitMsgResource1"></asp:Label>
</asp:Content>

