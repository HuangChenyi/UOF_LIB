<%@ Control Language="C#" AutoEventWireup="true" Inherits="Ede.Uof.EIP.Schedule.UI.UC_DayList" Codebehind="UC_DayList.ascx.cs" %>
<%@ Register Assembly="System.Web.Extensions" Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Src="UC_CalendarMenu.ascx" TagName="UC_CalendarMenu" TagPrefix="uc2" %>
<%@ Register Src="UC_Calendar.ascx" TagName="UC_Calendar" TagPrefix="uc1" %>

<%@ Register Src="UC_ScheduleTypeList.ascx" TagName="UC_ScheduleTypeList" TagPrefix="uc3" %>
<script type="text/javascript">
    function MyImage(Img) {
        var image = new Image();
        image.src = Img.src;
        var width = 16; //預先設置的所期望的寬的值
        var height = 16; //預先設置的所期望的高的值
        if (image.width > width || image.height > height) {//現有圖片只有寬或高超了預設值就進行js控制
            var w = image.width / width;
            var h = image.height / height;
            if (w > h) {//比值比較大==>寬比高大
                Img.width = width; //定下寬度為width的寬度
                Img.height = image.height / w; //以下為計算高度
                Img.style.margin = Math.floor((16 - (image.height / w)) / 2) + 'px '
                               + Math.floor((16 - width) / 2) + 'px';

            } else {//高比寬大
                Img.height = height; //定下寬度為height高度
                Img.width = image.width / h; //以下為計算高度
                Img.style.margin = Math.floor((16 - height) / 2) + 'px '
                               + Math.floor((16 - (image.width / h)) / 2) + 'px';
            }
        }
    }
</script>
<div onclick="Window_OnClick()">
    <asp:UpdatePanel ID="UpdatePanelTable1" runat="server">
        <contenttemplate>
    <table width="100%" style="background-color:white">
        <tr>
            <td style="width: 180px;text-align: left;vertical-align: top" >
                <uc1:UC_Calendar ID="UC_Calendar1" runat="server" />
                <uc2:UC_CalendarMenu ID="UC_CalendarMenu1" runat="server" />
            </td>
            <td style="text-align: left;vertical-align: top">
                <table width="100%" >
                    <tr>
                        <td>
                            <table style="width: 100%; height: 100%">
                                <tr>
                                    <td style="width: 33%">
                                        <table>
                                            <tr>
                                                <td>
                                                    <uc3:UC_ScheduleTypeList ID="UC_ScheduleTypeList1" runat="server" />
                                                </td>
                                                <td>
                                                    <asp:LinkButton ID="lbtnImgDesc" runat="server" Text="圖示說明" meta:resourcekey="lbtnImgDescResource2"></asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 34%;text-align: center">
                                        <table width="100%" style="height: 100%" >
                                            <tr>
                                                <td style="width: 15%;text-align:right" >
                                                    <asp:ImageButton ID="leftImgButton" runat="server" ImageUrl="~/EIP/Calendar/images/pre.jpg"
                                                        OnClick="leftImgButton_Click" meta:resourcekey="leftImgButtonResource1"></asp:ImageButton>
                                                </td>
                                                <td align="center">
                                                    <asp:Label ID="lbShowDate" runat="server" Font-Bold="True" meta:resourcekey="lbShowDateResource1"></asp:Label>
                                                </td>
                                                <td style="width: 15%" align="left">
                                                    <asp:ImageButton ID="rightImgButton" runat="server" ImageUrl="~/EIP/Calendar/images/next.jpg"
                                                        OnClick="rightImgButton_Click" meta:resourcekey="rightImgButtonResource1"></asp:ImageButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 33%" align="right">
                                        <asp:Label ID="lbOwner" runat="server" Font-Bold="True" ForeColor="Maroon" meta:resourcekey="lbOwnerResource1"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top">
                            <asp:Table ID="Table1" runat="server" meta:resourcekey="Table1Resource1">
                            </asp:Table>
                        </td>
                    </tr>
                </table>
    </td>
        </tr>
    </table>
<asp:Label ID="lblNotDisplay" runat="server" Visible="False" 
        Text="當別人查閱我的行事曆時不顯示事件" meta:resourcekey="lblNotDisplayResource1"></asp:Label>
<asp:Label ID="lbReaderGuid" runat="server" Visible="False" meta:resourcekey="lbReaderGuidResource1"></asp:Label>
<asp:Label ID="lbOwnerGuid" runat="server" Visible="False" meta:resourcekey="lbOwnerGuidResource1"></asp:Label>
<asp:Label ID="lbAllDay" runat="server" Visible="False" Text="全天" meta:resourcekey="lbAllDayResource1"></asp:Label>
<input id="hideIsInferior" type="hidden" value="false" runat="server" />
   
    <input id="HiddenXML" runat="server" type="hidden" />
        <asp:Label ID="lblXML" runat="server" meta:resourcekey="lblXMLResource1" 
            Visible="False"></asp:Label>
        <asp:Label ID="lblOwnMsg" runat="server" meta:resourceKey="lblOwnMsgResource1" 
            Text="共{0}人的行事曆" Visible="False"></asp:Label>
        <input id="hideDatePeriod" runat="server" type="hidden" />
            <input id="hideAllowCreats" runat="server" type="hidden" />

    </contenttemplate>
    </asp:UpdatePanel>
</div>
