<%@ Control Language="C#" AutoEventWireup="true" Inherits="System_Organization_Employee_UC_BirthdayList" CodeBehind="UC_BirthdayList.ascx.cs" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <Fast:Grid ID="Grid1" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="False"
            AutoGenerateColumns="False"
            ShowHeader="False" Width="100%" AllowPaging="True" BorderStyle="None" BorderWidth="0px" OnPageIndexChanging="Grid1_PageIndexChanging" OnRowDataBound="Grid1_RowDataBound" SkinID="HomepageBlockStyle">
            <Columns>
                <asp:TemplateField meta:resourcekey="TemplateFieldResource1">
                    <ItemTemplate>
                        <table width="100%" border="0">
                            <tbody>
                                <tr>
                                    <td width="16" style="min-width: 16px">
                                        <img height="16" src="<%=ResolveUrl("~/common/images/icon/icon02.png")%>" width="16" />
                                    </td>
                                    <td width="20%">
                                        <asp:Label runat="server" Text='<%# Bind("BIRTHDAY", "{0:m}") %>' ID="lblBirthday" meta:resourcekey="lblBirthdayResource1"></asp:Label>
                                    </td>
                                    <td width="50%">
                                        <asp:LinkButton runat="server" ID="LinkButton1" meta:resourcekey="LinkButton1Resource1"></asp:LinkButton>
                                    </td>
                                    <td width="30%">
                                        <asp:Label runat="server" Text='<%# Eval("ACCOUNT") %>' ID="lblAccount" meta:resourcekey="lblAccountResource1"></asp:Label>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </Fast:Grid>
    </ContentTemplate>
</asp:UpdatePanel>
