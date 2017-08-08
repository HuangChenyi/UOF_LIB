<%@ Control Language="C#" AutoEventWireup="true" Inherits="Ede.Uof.Common.ChoiceCenter.UC_ChoiceList" Codebehind="UC_ChoiceList.ascx.cs" %>

<div style="margin: 5px">
    <telerik:RadButton ID="btnEdit" runat="server" SkinID="YellowButton" Text="選取人員" OnClientClicking="button1Click" OnClick="btnEdit_Click" CausesValidation="False" meta:resourcekey="btnEditResource2" style="position: relative;">
    </telerik:RadButton>
    <telerik:RadButton ID="btnEdit2" runat="server" SkinID="BlueButton" Text="選取人員" OnClientClicking="button1Click" OnClick="btnEdit2_Click" CausesValidation="False" meta:resourcekey="btnEdit2Resource2" style="position: relative;">
    </telerik:RadButton>
    <div class="UserSetBorder" id="listViewBorder" runat="server">
        <telerik:RadListView ID="RadListView1" runat="server" ItemPlaceholderID="ItemPlaceholderContainer" meta:resourcekey="RadListView1Resource1">
            <LayoutTemplate>
                <div id="itemContainer" runat="server">
                    <asp:PlaceHolder ID="ItemPlaceholderContainer" runat="server"></asp:PlaceHolder>
                </div>
            </LayoutTemplate>
            <ItemTemplate>
                <div class="UserSetItem">
                    <div>
                        <img src='<%# Eval("image") %>' />
                    </div>
                    <div><%#Eval("text")%></div>
                </div>
            </ItemTemplate>
            <ClientSettings>
                <DataBinding ItemPlaceHolderID="itemContainer">
                    <ItemTemplate>
                    

                    <div class="UserSetItem">
                        <div><img src="#= image #" /></div>
                        <div>#= text #</div>
                    </div>
                    </ItemTemplate>
                </DataBinding>
                <ClientEvents></ClientEvents>
            </ClientSettings>
        </telerik:RadListView>
    </div>
    <span style="display: none">
        <asp:Label ID="lbSelect" runat="server" Text="選取人員" Visible="False" meta:resourcekey="lbSelectResource1"></asp:Label>
        <input id="hiddenJSON" runat="server" type="hidden" value="" />
        <input id="hideShowMember" runat="server" type="hidden" />
        <input id="hideShowSubDep" runat="server" type="hidden" value="true" />
        <input id="hideShowEmployee" runat="server" type="hidden" />
        <input id="hideExpandToUser" runat="server" type="hidden" />
        <input id="hideShowChioceType" runat="server" type="hidden" />
        <input id="hideFavorite" runat="server" type="hidden" />
        <input id="hidLimitChoice" runat="server" type="hidden" />
        <input id="hidLimitXML" runat="server" type="hidden" />
    </span>
</div>
