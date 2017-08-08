﻿<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="WKF_FlowManagement_MaintainMailTemplate"
    Title="站點郵件樣板維護" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="MaintainMailTemplate.aspx.cs" %>

<%@ Register Src="~/WKF/Common/UC_VariableList.ascx" TagName="UC_VariableList"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script>
        function CopyFiled(Text) {
            //Add code to handle your event here.

            clipboardData.setData("Text", Text);

        }

        function CopyText(ClientID) {
            //Add code to handle your event here.


            var data = $('#' + ClientID).text();
            clipboardData.setData("Text", data);

        }
    </script>
    <table width="50%" class="PopTable" cellspacing="1" cellpadding="0">

        <tr>
            <td class="PopTableHeader" colspan="2" align="center">
                <asp:Label ID="Label1" runat="server" Text="郵件樣板維護" meta:resourcekey="Label1Resource1"></asp:Label>
            </td>
        </tr>
        <tr>
            <td nowrap="nowrap">
                <asp:Label ID="Label3" runat="server" Text="型態" meta:resourcekey="Label3Resource1"></asp:Label>
            </td>
            <td>
                <asp:Label ID="lblAlertType" runat="server" meta:resourcekey="lblAlertTypeResource1"></asp:Label>
                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="該類型郵件已存在"
                    meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
            </td>
        </tr>
        <tr>
            <td nowrap="nowrap">
                <asp:Label ID="Label2" runat="server" Text="語系" meta:resourcekey="Label2Resource1"></asp:Label>
            </td>
            <td>
                <asp:Label ID="lblCulture" runat="server" meta:resourcekey="lblCultureResource1"></asp:Label>
                <asp:CheckBox ID="cbDefault" runat="server" Text="當系統找不到其他語系時,以此語系發送" meta:resourcekey="cbDefaultResource1" />
                <asp:CustomValidator ID="cvDefault" runat="server" Display="Dynamic" ErrorMessage="該郵件內容未有預設語系,請先設定預設語系"
                    meta:resourcekey="cvDefaultResource1"></asp:CustomValidator>
            </td>
        </tr>
        <tr>
            <td nowrap="nowrap">
                <asp:Label ID="Label4" runat="server" Text="郵件主旨" meta:resourcekey="Label4Resource1"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtSubjuct" runat="server" Width="1100px" meta:resourcekey="txtSubjuctResource1"
                    Text="表單簽核通知：{#formName}-{#applicant}"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="郵件主旨不可空白"
                    ControlToValidate="txtSubjuct" Display="Dynamic" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td nowrap="nowrap">
                <asp:Label ID="Label5" runat="server" Text="郵件內容" meta:resourcekey="Label5Resource1"></asp:Label>
            </td>
            <td>
                <telerik:RadEditor ID="wheMailContent" runat="server"  Height="450px" Width="1100px"></telerik:RadEditor>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="郵件內容不可空白"
                    ControlToValidate="wheMailContent" Display="Dynamic" meta:resourcekey="RequiredFieldValidator2Resource1"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td  colspan="2" style="border-color: White">
                <div style="text-align:left"> 
                            <asp:Label ID="Label21" runat="server" Text="將「變數名稱」與「欄位代號」複製到郵件內容中，代表郵件內容會依表單當時的資訊顯示所屬內容" CssClass="SizeMemo" meta:resourcekey="Label21Resource1"></asp:Label>
                </div>
                <table width="100%">
                    <tr>
                        <td valign="top" style="width:50%">
                            <table width="100%" class="PopTable" cellspacing="1">
                                <colgroup class="PopTableLeftTD">
                                </colgroup>
                                <colgroup class="PopTableRightTD">
                                </colgroup>
                                <tr>
                                    <td class="PopTableHeader" colspan="2" align="center">
                                        <center>
                                            <asp:Label ID="Label6" runat="server" Text="可用變數列表" meta:resourcekey="Label6Resource1"></asp:Label></center>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="PopTableHeader" align="center">
                                        <center>
                                            <asp:Label ID="Label11" runat="server" Text="變數名稱" meta:resourcekey="Label11Resource1"></asp:Label></center>
                                    </td>
                                    <td class="PopTableHeader" align="center">
                                        <center>
                                            <asp:Label ID="Label12" runat="server" Text="變數說明" meta:resourcekey="Label12Resource1"></asp:Label></center>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblFormName" runat="server" Text="{#formName}" meta:resourcekey="lblFormNameResource1"></asp:Label>
                                    </td>
                                    <td  style="text-align:left">
                                        <asp:Label ID="Label13" runat="server" Text="表單名稱" meta:resourcekey="Label13Resource1"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblFormVersion" runat="server" Text="{#formVersion}" meta:resourcekey="lblFormVersionResource1"></asp:Label>
                                    </td>
                                    <td style="text-align:left">
                                        <asp:Label ID="Label14" runat="server" Text="表單版本" meta:resourcekey="Label14Resource1"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblFormNo" runat="server" Text="{#formNo}" meta:resourcekey="lblFormNoResource1"></asp:Label>
                                    </td>
                                    <td style="text-align:left">
                                        <asp:Label ID="Label15" runat="server" Text="表單單號" meta:resourcekey="Label15Resource1"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblApplicant" runat="server" Text="{#applicant}" meta:resourcekey="lblApplicantResource1"></asp:Label>
                                    </td>
                                    <td style="text-align:left">
                                        <asp:Label ID="Label16" runat="server" Text="申請者" meta:resourcekey="Label16Resource1"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblApplyTime" runat="server" Text="{#applyTime}" meta:resourcekey="lblApplyTimeResource1"></asp:Label>
                                    </td>
                                    <td style="text-align:left">
                                        <asp:Label ID="Label17" runat="server" Text="申請時間" meta:resourcekey="Label17Resource1"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblFormStatus" runat="server" Text="{#formStatus}" meta:resourcekey="lblFormStatusResource1"></asp:Label>
                                    </td>
                                    <td style="text-align:left">
                                        <asp:Label ID="Label18" runat="server" Text="表單狀態" meta:resourcekey="Label18Resource1"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblFormResult" runat="server" Text="{#formResult}" meta:resourcekey="lblFormResultResource1"></asp:Label>
                                    </td>
                                    <td style="text-align:left">
                                        <asp:Label ID="Label20" runat="server" Text="申請結果" meta:resourcekey="Label20Resource1"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                            <asp:Label ID="Label19" runat="server" Text="*點擊變數名稱可複製變數名稱" ForeColor="Red" meta:resourcekey="Label19Resource1" Visible="false"></asp:Label>
                        </td>
                        <td valign="top">
                            
                            <asp:Table ID="tbFormFiled" runat="server" Width="100%" CellSpacing="1" CssClass="PopTable"
                                meta:resourcekey="tbFormFiledResource1">
                                <asp:TableHeaderRow meta:resourcekey="TableHeaderRowResource1">
                                    <asp:TableCell ColumnSpan="2" CssClass="PopTableHeader" HorizontalAlign="Center">
                                        <center>
                                            <asp:Label ID="Label7" runat="server" Text="可用欄位列表" meta:resourcekey="Label7Resource1"></asp:Label></center>
                                    </asp:TableCell>
                                </asp:TableHeaderRow>
                                <asp:TableHeaderRow meta:resourcekey="TableHeaderRowResource2">
                                    <asp:TableCell CssClass="PopTableHeader" HorizontalAlign="Center">
                                        <center>
                                            <asp:Label ID="Label8" runat="server" Text="欄位代號" meta:resourcekey="Label8Resource1"></asp:Label>
                                        </center>
                                    </asp:TableCell>
                                    <asp:TableCell CssClass="PopTableHeader" HorizontalAlign="Center ">
                                        <center>
                                            <asp:Label ID="Label9" runat="server" Text="欄位名稱" meta:resourcekey="Label9Resource1"></asp:Label></center>
                                    </asp:TableCell>
                                </asp:TableHeaderRow>
                            </asp:Table>
                            <asp:Label ID="Label10" runat="server" Text="*點擊欄位代號可複製欄位變數\r\n({@fieldId},@號後面接的是欄位代號,表示要列出欄位資料)" Visible="false"
                                ForeColor="Red" meta:resourcekey="Label10Resource1"></asp:Label>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:Label ID="lblType" runat="server" Visible="False" meta:resourcekey="lblTypeResource1"></asp:Label>
    <asp:Label ID="lblSign" runat="server" Text="簽核通知" Visible="False" meta:resourcekey="lblSignResource1"></asp:Label>
    <asp:Label ID="lblAlert" runat="server" Text="表單知會" Visible="False" meta:resourcekey="lblAlertResource1"></asp:Label>
    <asp:Label ID="lblFinish" runat="server" Text="表單結案" Visible="False" meta:resourcekey="lblFinishResource1"></asp:Label>
    <asp:Label ID="lblCancel" runat="server" Text="表單作廢" Visible="False" meta:resourcekey="lblCancelResource1"></asp:Label>
    <asp:Label ID="lblBackSign" runat="server" Text="表單退簽" Visible="False" meta:resourcekey="lblBackSignResource1"></asp:Label>
</asp:Content>
