<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MeetingReport.aspx.cs" MasterPageFile="~/Master/DefaultMasterPage.master" Inherits="CDS_Jcic_MeetingReport" %>

<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagPrefix="uc1" TagName="UC_ChoiceList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        table.mainTable {
            border-width: 0px;
        }

            table.mainTable > tbody > tr > td {
                vertical-align: middle;
                padding: 10px 10px 10px 10px;
                white-space: nowrap;
            }

        table.gridTable {
            border-width: 1px;
        }

            table.gridTable > tbody > tr > th {
                border: 1px solid #E6E6E6;
                vertical-align: middle;
                padding: 10px 10px 10px 10px;
                white-space: nowrap;
                background-color: #336699;
                color: white;
            }

            table.gridTable > tbody > tr > td {
                border: 1px solid #E6E6E6;
                vertical-align: middle;
                padding: 10px 10px 10px 10px;
                white-space: nowrap;
            }

        table.calendarTable {
            border-width: 1px;
        }

            table.calendarTable > tbody > tr > th {
                border: 1px solid #E6E6E6;
                vertical-align: middle;
                padding: 10px 10px 10px 10px;
                white-space: nowrap;
                background-color: #336699;
                color: white;
            }

            table.calendarTable > tbody > tr > td {
                border: 1px solid #ABABAB;
                vertical-align: middle;
                padding: 10px 10px 10px 10px;
            }

        .blueButton {
            border: 1px solid #0a3c59;
            background: #3e779d;
            background: -webkit-gradient(linear, left top, left bottom, from(#65a9d7), to(#3e779d));
            background: -webkit-linear-gradient(top, #65a9d7, #3e779d);
            background: -moz-linear-gradient(top, #65a9d7, #3e779d);
            background: -ms-linear-gradient(top, #65a9d7, #3e779d);
            background: -o-linear-gradient(top, #65a9d7, #3e779d);
            background-image: -ms-linear-gradient(top, #65a9d7 0%, #3e779d 100%);
            padding: 5px 10px;
            -webkit-border-radius: 6px;
            -moz-border-radius: 6px;
            border-radius: 6px;
            -webkit-box-shadow: rgba(255,255,255,0.4) 0 1px 0, inset rgba(255,255,255,0.4) 0 1px 0;
            -moz-box-shadow: rgba(255,255,255,0.4) 0 1px 0, inset rgba(255,255,255,0.4) 0 1px 0;
            box-shadow: rgba(255,255,255,0.4) 0 1px 0, inset rgba(255,255,255,0.4) 0 1px 0;
            text-shadow: #7ea4bd 0 1px 0;
            color: #06426c;
            font-size: 14px;
            font-family: helvetica, serif;
            text-decoration: none;
            vertical-align: middle;
        }

            .blueButton:hover {
                border: 1px solid #0a3c59;
                text-shadow: #1e4158 0 1px 0;
                background: #3e779d;
                background: -webkit-gradient(linear, left top, left bottom, from(#65a9d7), to(#3e779d));
                background: -webkit-linear-gradient(top, #65a9d7, #3e779d);
                background: -moz-linear-gradient(top, #65a9d7, #3e779d);
                background: -ms-linear-gradient(top, #65a9d7, #3e779d);
                background: -o-linear-gradient(top, #65a9d7, #3e779d);
                background-image: -ms-linear-gradient(top, #65a9d7 0%, #3e779d 100%);
                color: #fff;
            }

            .blueButton:active {
                text-shadow: #1e4158 0 1px 0;
                border: 1px solid #0a3c59;
                background: #65a9d7;
                background: -webkit-gradient(linear, left top, left bottom, from(#3e779d), to(#3e779d));
                background: -webkit-linear-gradient(top, #3e779d, #65a9d7);
                background: -moz-linear-gradient(top, #3e779d, #65a9d7);
                background: -ms-linear-gradient(top, #3e779d, #65a9d7);
                background: -o-linear-gradient(top, #3e779d, #65a9d7);
                background-image: -ms-linear-gradient(top, #3e779d 0%, #65a9d7 100%);
                color: #fff;
            }
    </style>

    <script>
        function OnClientAppointmentEditing(sender, args) {
            args.set_cancel(true);
        }
    </script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <telerik:RadTabStrip runat="server" ID="rtsMain" RenderMode="Lightweight" Skin="MetroTouch" SelectedIndex="0" AutoPostBack="true" OnTabClick="rtsMain_TabClick">
                <Tabs>
                    <telerik:RadTab Text="月曆格式"></telerik:RadTab>
                    <telerik:RadTab Text="表格格式"></telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage runat="server" ID="rmpMain" SelectedIndex="0">
                <telerik:RadPageView runat="server" ID="rpvGrid">
                    <table width="100%" border="0" class="mainTable">
                        <tr>
                            <td colspan="5" style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">
                                <table border="0">
                                    <tr>
                                        <td width="1%" nowrap style="vertical-align: middle;">
                                            <h1>會議室清單</h1>
                                        </td>
                                        <td style="vertical-align: middle;">&nbsp;<asp:LinkButton ID="lbMA2" runat="server" CssClass="blueButton" OnClick="lbRaiseMeetingApply_Click">會議申請</asp:LinkButton></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td width="1%" style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">日期：
                            </td>
                            <td width="1%" style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">
                                <telerik:RadDatePicker runat="server" ID="rdpBeginDate" AutoPostBack="true" OnSelectedDateChanged="rdpBeginDate_SelectedDateChanged"></telerik:RadDatePicker>
                            </td>
                            <td width="1%" style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">~
                            </td>
                            <td width="1%" style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">
                                <telerik:RadDatePicker runat="server" ID="rdpEndDate" AutoPostBack="true" OnSelectedDateChanged="rdpEndDate_SelectedDateChanged"></telerik:RadDatePicker>
                            </td>
                            <td style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;"></td>
                        </tr>
                        <tr>
                            <td width="1%" style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">會議室過濾：</td>
                            <td colspan="4" style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">
                                <asp:DropDownList ID="ddlRooms" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlRooms_SelectedIndexChanged"></asp:DropDownList></td>
                        </tr>
                    </table>
                    <asp:GridView ID="gvMain" Width="100%" runat="server" AutoGenerateColumns="false" ShowHeaderWhenEmpty="true" CssClass="gridTable" OnRowDataBound="gvMain_RowDataBound">
                        <EmptyDataTemplate>
                            <asp:Label ID="lblEmptyData" runat="server" ForeColor="Red" Text="選擇的條件下沒有會議"></asp:Label>
                        </EmptyDataTemplate>
                        <Columns>
                            <asp:BoundField HeaderText="時間" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" DataField="START_TIME" />
                            <asp:BoundField HeaderText="會議室名稱" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" DataField="NAME" />
                            <asp:BoundField HeaderText="會議類別" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" DataField="MEETING_TYPE" />
                            <asp:BoundField HeaderText="主席" HeaderStyle-Wrap="false" ItemStyle-Wrap="false" DataField="CHAIRMAN" />
                            <asp:TemplateField HeaderText="操作" HeaderStyle-Width="1%" ItemStyle-Width="1%" HeaderStyle-Wrap="false" ItemStyle-Wrap="false">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDetail" runat="server">明細</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </telerik:RadPageView>
                <telerik:RadPageView runat="server" ID="rpvCalendar">
                    <table width="100%" border="0" class="mainTable">
                        <tr>
                            <td colspan="2" style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">
                                <table border="0">
                                    <tr>
                                        <td width="1%" nowrap style="vertical-align: middle;">
                                            <h1>會議室清單</h1>
                                        </td>
                                        <td style="vertical-align: middle;">&nbsp;<asp:LinkButton ID="lbRaiseMeetingApply" runat="server" CssClass="blueButton" OnClick="lbRaiseMeetingApply_Click">會議申請</asp:LinkButton></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td width="1%" style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">月份：
                            </td>
                            <td style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">
                                <telerik:RadMonthYearPicker runat="server" ID="rypMain" AutoPostBack="true" OnSelectedDateChanged="rypMain_SelectedDateChanged"></telerik:RadMonthYearPicker>
                            </td>
                        </tr>
                        <tr>
                            <td width="1%" style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">會議室過濾：</td>
                            <td style="background-color: #FAFAFA; border-bottom: 1px solid #E6E6E6;">
                                <asp:DropDownList ID="ddlRooms2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlRooms2_SelectedIndexChanged"></asp:DropDownList></td>
                        </tr>
                    </table>
                    <telerik:RadScheduler ID="rscMain"  runat="server" RenderMode="Lightweight" SelectedView="MonthView" AllowDelete="false" AllowEdit="false" AllowInsert="false" ShowDateHeaders="true" OnClientAppointmentDoubleClick="OnClientAppointmentEditing">
                        <WeekView UserSelectable="false" />
                        <DayView UserSelectable="false" />
                        <MultiDayView UserSelectable="false" />
                        <TimelineView UserSelectable="false" />
                        <AdvancedForm Modal="false" />
                        <Reminders Enabled="false" />
                        <TimeSlotContextMenuSettings EnableDefault="false" />
                        <AppointmentContextMenuSettings EnableDefault="false" />
                        <AppointmentTemplate>
                            <div>
                                <asp:Label ID="lblDisplay" runat="server" Text='<%# Eval("Description") %>' ToolTip='<%# Eval("Description") %>'></asp:Label>
                            </div>
                        </AppointmentTemplate>
                    </telerik:RadScheduler>
                </telerik:RadPageView>
            </telerik:RadMultiPage>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
