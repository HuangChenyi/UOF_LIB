<%@ Page Language="C#" Culture="auto"
    Inherits="_Login" meta:resourcekey="PageResource1" UICulture="auto" EnableEventValidation="false"
    CodeBehind="Login.aspx.cs" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <link rel="icon" href="" type="image/x-icon" runat="server" id="Icon" />
    <title>Welcome to the Best U-Office Force system</title>
    <link rel="home" id="ApplicationRoot" href="" runat="server" enableviewstate="False" clientidmode="Static" />
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <style>
        body, .ui.button, .ui.form input[type="text"], .ui.form input[type="password"] , .ui.message .header {
            font-family: "Segoe UI", Arial, Helvetica,"文泉驛正黑", "WenQuanYi Zen Hei", "微軟正黑體", "Microsoft JhengHei", "黑體-繁","Heiti TC","微软雅黑","Microsoft YaHei", sans-serif !important;
        }

        .ui.grid {
            height: 100%;
        }

        .ui.error.login div{
            display:block;
            text-indent : -1em ;
        }
        
        .ui.error.login span:before{
            content: "．";
        }
        
        #lblLicenseExpireDate span {          
            color:#FF9F1C;
        }

      #cboKeepaccount:checked ~ label:before,
      #cboKeepaccount:focus:checked~label:before{
          background-color :#4d4d4d  !important;
      }
    </style>
    <link href="MForm/Content/SemanticUI/semantic.css" rel="stylesheet" />
    <link href="Common/Style/uof-fixed.css" rel="stylesheet" />
    <link href="Common/Style/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
</head>
<body>
    <style>
        .mainbox {
            background-image: url("<%=BackgroundUrl%>");
            background-repeat: no-repeat;
            background-size: cover;            
        }

            .mainbox > .column > .grid > div {
                background-color: rgba(255,255,255,0.8);
                 width:360px !important;
            }                   

        @media only screen and (max-width: 768px) {
            .mainbox {
                background-image: none;
            }

             .mainbox > .column > .grid > div {            
                 width:100% !important;
            }
        }
        
    </style>
    <form id="form1" runat="server" class="ui large form">

        <script src="MForm/Content/SemanticUI/semantic.js"></script>
       
        <telerik:RadScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="True" AsyncPostBackTimeout="36000">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
                <asp:ScriptReference Path="~/mForm/Scripts/less/less.min.js" ScriptMode="Release" />
            </Scripts>
        </telerik:RadScriptManager>
       
        <div class="ui padded grid mainbox">
            <div class="stretched column">              
                <div class="ui grid">     
                    <%--sixteen wide mobile six wide tablet four wide computer three wide widescreen --%>              
                    <div class="right floated stretched column">
                        <div class="ui grid">
                            <div class="top aligned stretched row">
                                <div class="column">
                                    <h2 class="ui teal image center aligned header">
                                        <asp:Image ID="imgLogo" runat="server" meta:resourcekey="imgLogoResource1" CssClass="ui small image" />
                                    </h2>
                                    <div class="ui hidden divider"></div>
                                    <div id="expiredMessage" class="ui yellow icon message" style="display:none">
                                        <i class="warning sign icon"></i>
                                        <div class="content">
                                            <div class="header">
                                                <asp:UpdatePanel ID="UpdatePanel4" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                            <ContentTemplate>
                                                <asp:Label ID="lblLicenseExpireDate" runat="server" Text="您的授權即將在{0}天後到期,屆時將無法登入系統"
                                                    meta:resourcekey="lblLicenseExpireDateResource1"></asp:Label>
                                                  </ContentTemplate>
                                                    <Triggers>
                                                        <asp:AsyncPostBackTrigger ControlID="ddlCulture" EventName="SelectedIndexChanged" />
                                                    </Triggers>
                                        </asp:UpdatePanel>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div id="loginSegment">
                                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <div class="field" id="fieldDomain" runat="server" style="height: 2.5em;">
                                                    <asp:DropDownList CssClass="ui dropdown left icon" ID="ddlDomain" runat="server" meta:resourcekey="ddlDomainResource1" AutoPostBack="True" OnSelectedIndexChanged="ddlDomain_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="field" style="height: 2.5em;">
                                                    <asp:DropDownList
                                                        CssClass="ui dropdown" ID="ddlCulture" runat="server" meta:resourcekey="DropDownList1Resource1"
                                                        AutoPostBack="True"
                                                        OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>

                                                <div class="required field">
                                                    <div class="ui left icon input">
                                                        <i class="user icon"></i>
                                                        <asp:TextBox ID="txtAccount" ValidationGroup="login" runat="server" meta:resourcekey="accTXTResource1" TabIndex="1" placeHolder="帳號"></asp:TextBox>
                                                    </div>
                                                </div>

                                                <div class="field">
                                                    <div class="ui left icon input">
                                                        <i class="lock icon"></i>
                                                        <asp:TextBox ID="txtPwd" ValidationGroup="login" runat="server" meta:resourcekey="pwdTXTResource1"
                                                            TextMode="Password" TabIndex="2" placeHolder="密碼"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="field">
                                                    <div class="ui toggle  checkbox">
                                                        <asp:CheckBox ID="cboKeepaccount" runat="server" Text="記住我的帳號" TabIndex="4" meta:resourcekey="cboKeepaccountResource1" />
                                                 
                                                            </div>
                                                </div>
                                                
                                      
                                                <div class="field">
                                                    <asp:Button ID="btnSubmit" CssClass="ui fluid large submit button" runat="server"
                                                        OnClick="btnSubmit_Click" OnClientClick="return btnSubmit_Click();" ValidationGroup="login"
                                                        Text="登入" TabIndex="3" EnableTheming="false" CausesValidation="true"
                                                        meta:resourcekey="WebImageButtonSubmitResource1"></asp:Button>

                                                </div>
                                                <div class="field">

                                                    <asp:HyperLink ID="hlForgetpw" CssClass="ui icon fluid large button" runat="server"
                                                        NavigateUrl="javascript:openDialog();" meta:resourcekey="hlForgetpwResource1"><i class="question icon"></i>忘記密碼</asp:HyperLink>
                                                </div>
                                                <div class="field">
                                                    <asp:HyperLink ID="hlAutoLogon" CssClass="ui icon fluid large button" runat="server" NavigateUrl="~" Target="_self" Visible="false"
                                                        Text="自動登入" meta:resourcekey="hlAutoLogonResource1"></asp:HyperLink>
                                                </div>
                                                <div class="field">
                                                    <asp:HyperLink ID="hlApplyCA" CssClass="ui icon fluid large teal button" runat="server"
                                                        Target="_self"
                                                        Visible="False" Text="申請憑證" meta:resourcekey="hlApplyCAResource1"></asp:HyperLink>
                                                </div>


                                                <div class="ui error message login">
                                                    <div>
                                                        <asp:RequiredFieldValidator ID="rvalidAccount" runat="server" Display="Dynamic" ControlToValidate="txtAccount" SetFocusOnError="true"
                                                            ValidationGroup="login" ErrorMessage="請輸入帳號" EnableTheming="false" meta:resourcekey="rvalidAccountResource1"></asp:RequiredFieldValidator>
                                                    </div>
                                                    <div>
                                                        <asp:CustomValidator ID="cvLogout" runat="server" Display="Dynamic" ErrorMessage="您已經登出" EnableTheming="false"
                                                            ValidationGroup="login" meta:resourcekey="cvLogoutResource1" Visible="False"></asp:CustomValidator>
                                                    </div>
                                                    <div>
                                                        <asp:CustomValidator ID="cvLicenseFile" runat="server" Display="Dynamic" EnableTheming="false" ErrorMessage="授權資訊不正確無法啟用應用程式"
                                                            ValidationGroup="login" OnServerValidate="cvLicenseFile_ServerValidate" meta:resourcekey="cvLicenseFileResource1"></asp:CustomValidator>
                                                    </div>
                                                    <div>
                                                        <asp:CustomValidator ID="cvalidLogin" runat="server" Display="Dynamic" EnableTheming="false" ErrorMessage="帳號或密碼錯誤。<br/>若使用AD驗證，帳號輸入格式為：AD Domain\Account，例：ABC\admin"
                                                            ValidationGroup="login" OnServerValidate="cvalidLogin_ServerValidate" meta:resourcekey="cvalidLoginResource1"></asp:CustomValidator>
                                                    </div>
                                                    <div>
                                                        <asp:CustomValidator ID="cvLicenseFull" runat="server" Display="Dynamic" EnableTheming="false" ErrorMessage="授權人數已滿無法登入"
                                                            ValidationGroup="login" OnServerValidate="cvLicenseFull_ServerValidate" meta:resourcekey="cvLicenseFullResource1"></asp:CustomValidator>
                                                    </div>
                                                    <div>
                                                        <asp:CustomValidator ID="cvLicenseExpired" runat="server" Display="Dynamic" EnableTheming="false" ErrorMessage="授權已到期無法登入"
                                                            ValidationGroup="login" OnServerValidate="cvLicenseExpired_ServerValidate" meta:resourcekey="cvLicenseExpiredResource1"></asp:CustomValidator>
                                                    </div>                                                   
                                                </div>

                                            </ContentTemplate>
                                        </asp:UpdatePanel>

                                    </div>
                                   <div  id="LogingWait" style="margin: 0 auto 0 auto; text-align: center;display:none">                                        
                                            <h3 class="ui icon  header">
                                                <%--<i class="settings icon"></i>--%>
                                                <i class="fa fa-5x fa-cog fa-spin"></i>
                                                <div class="content">
                                                    <asp:Label ID="lbLoginWait" runat="server" Text="登入中,請稍候" meta:resourcekey="lbLoginWaitResource1"></asp:Label>
                                                </div>
                                            </h3>

                                            <div id="loadingAnimation" style="margin: 2px auto 2px auto;">
                                                <div></div>
                                                <div></div>
                                                <div></div>
                                                <div></div>
                                                <div></div>
                                                <div></div>
                                                <div></div>
                                                <div></div>
                                            </div>
                                        </div>
                                </div>
                            </div>
                            <div class="bottom aligned row">
                                <div class="sixteen wide center aligned column">
                                    <asp:Label ID="lbCopyRight" runat="server" Font-Size="Small"
                                        meta:resourcekey="lbCopyRightResource2"></asp:Label>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>              
            </div>
        </div>

        <div class="ui small modal forget">
            <div class="header">
                <asp:UpdatePanel ID="UpdatePanel3" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Literal ID="Literal1" runat="server" Text="忘記密碼"></asp:Literal>
                        
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlCulture" EventName="SelectedIndexChanged" />

                    </Triggers>

                </asp:UpdatePanel>
            </div>
            <div class="description">
                <asp:UpdatePanel ID="UpdatePanel5" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table style="widh:100%"><tr><td style="width:20px"></td><td style="color:blue" ><asp:Literal ID="literalDesc"   runat="server" Text="系統會寄送給您一個臨時的UOF密碼，如果您是使用AD驗證登入，忘記密碼請另洽AD管理員"></asp:Literal></td></tr></table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ddlCulture" EventName="SelectedIndexChanged" />

                    </Triggers>

                </asp:UpdatePanel>
            </div>
            <i class="close big red icon"></i>
            <div class="image content">
                <div class="image">
                    <i class="right question icon"></i>

                </div>
                <div class="description" style="width: 100%">
                    <div class="ui form">
                        <asp:UpdatePanel ID="UpdatePanel2" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                            <ContentTemplate>

                                <div class="field">
                                    <div class="ui left icon input">
                                        <i class="user icon"></i>
                                        <asp:TextBox ID="txtAccount2" ValidationGroup="forget" runat="server" placeHolder="帳號"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="field">
                                    <div class="ui left icon input">
                                        <i class="mail icon"></i>
                                        <asp:TextBox ID="txtEmail" ValidationGroup="forget" runat="server" placeHolder="e-Mail"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="ui error message forget">
                                    <asp:RequiredFieldValidator ID="rvalidAccount2" runat="server" ControlToValidate="txtAccount2"
                                        ValidationGroup="forget" ErrorMessage="請輸入帳號" EnableTheming="false" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RequiredFieldValidator ID="rvalidEmail" runat="server" ControlToValidate="txtEmail"
                                        ValidationGroup="forget" ErrorMessage="請輸入e-mail" EnableTheming="false" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:CustomValidator ID="cvalidInfo" runat="server" Display="Dynamic" ValidationGroup="forget" EnableTheming="false" ErrorMessage="找不到此帳號及Mail資訊,請重新輸入"></asp:CustomValidator>
                                    <asp:CustomValidator ID="cvSuccess" runat="server" Display="Dynamic" ValidationGroup="forget" EnableTheming="false" ErrorMessage="寄出密碼通知成功"></asp:CustomValidator>
                                </div>
                                </div>
                               
                            </ContentTemplate>

                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnForget" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="ddlCulture" EventName="SelectedIndexChanged" />

                            </Triggers>

                        </asp:UpdatePanel>
                    </div>
                </div>
                <div class="actions">
                    <asp:Button ID="btnForget" CssClass="ui submit button" runat="server"
                        OnClick="btnForget_Click" OnClientClick="return btnForget_Click();"
                        ValidationGroup="forget"
                        Text="送出" EnableTheming="false"></asp:Button>

                  
                </div>
            </div>

        </div>
        <script>
            var trigger = "";
            Sys.Application.add_load(function () {
                if (trigger == "" || trigger == "login") {
                    $('#<%=txtPwd.ClientID%>').keypress(function (event) {
                        if (event.keyCode == 10 || event.keyCode == 13) {
                            $("#<%=btnSubmit.ClientID%>").click();
                        }
                    });

                    $('#<%=ddlDomain.ClientID%>').dropdown();
                    $('#<%=ddlCulture.ClientID%>').dropdown();

                    $('.ui.dropdown').has("#<%=ddlCulture.ClientID%>").prepend("<i class=\"world icon\" style='margin:0 12px 0 -4px'></i>");
                    $('.ui.dropdown').has("#<%=ddlDomain.ClientID%>").prepend("<i class=\"desktop icon\"  style='margin:0 12px 0 -4px'></i>");


                    var color = "<%=ColorClass%>";
                    

                    $("#loginSegment i.icon").addClass(color);
                    $("#LogingWait .header").addClass(color);
                    $("i.copyright.icon").addClass(color);

                    $(".ui.button").addClass(color);
                    $("i.icon.close").removeClass(color);

                    $('#loginSegment').show();
                    $('#LogingWait').hide();

                    if ($('#<%=txtAccount.ClientID %>').val() == "") {
                        $('#<%=txtAccount.ClientID %>').focus();
                    }
                    else {
                        $('#<%=txtPwd.ClientID %>').focus();
                    }
                }

                $('.ui.modal.forget').find(".ui.form").removeClass("loading");

                $(".ui.error.message").hide();
                if (!Page_IsValid) {
                    $.each(Page_Validators, function (index) {
                        var v = Page_Validators[index];
                        if (!v.isvalid) {
                            $(".ui.error.message." + v.validationGroup).show();
                            $(".field").has("#" + v.controltovalidate).addClass("error");
                            if (v.id == "cvalidLogin") {
                                $(".field").has('#<%=txtAccount.ClientID %>').addClass("error");
                                $(".field").has('#<%=txtPwd.ClientID %>').addClass("error");
                            }
                        }
                    });
                }
                if ($("#lblLicenseExpireDate").html()) {
                    $("#expiredMessage").show();
                }                
            });



            function btnSubmit_Click(source, args) {
                $(".ui.error.message.login").hide();
                $(".field").removeClass("error");

                var isValid = Page_ClientValidate("login");
                if (isValid) {
                    $('#loginSegment').hide();
                    $('#LogingWait').show();
                }
                else {
                    $(".ui.error.message.login").show();
                    $.each(Page_Validators, function (index) {
                        var v = Page_Validators[index];
                        if (!v.isvalid) {
                            $(".field").has("#" + v.controltovalidate).addClass("error");
                        }
                    });
                }
                trigger = "login";
                return isValid;
            }

            function btnForget_Click(source, args) {
                var isValid = Page_ClientValidate("forget");
                if (!isValid) {
                    $(".ui.error.message.forget").show();
                    $.each(Page_Validators, function (index) {
                        var v = Page_Validators[index];
                        if (!v.isvalid) {
                            $(".field").has("#" + v.controltovalidate).addClass("error");
                        }
                    });
                }
                else {
                    $('.ui.modal.forget').find(".ui.form").addClass("loading");
                }
                trigger = "forget";
                return isValid;
            }

            function openDialog() {
                $('.ui.modal.forget').modal({
                    detachable: false
                });

                $('.ui.modal.forget').modal('show');
            };


        </script>
        <script>
            less = {
                async: true
            };
        </script>
        <asp:Label ID="Label1" runat="server" meta:resourcekey="Label1Resource1" Text="帳號" Visible="false"></asp:Label>
        <asp:Label ID="Label2" runat="server" meta:resourcekey="Label2Resource1" Text="密碼" Visible="false"></asp:Label>
        <asp:Label ID="Label3" runat="server" Text="系統操作逾時或權限不足,請重新登入系統!!" Visible="False"
            meta:resourcekey="Label3Resource1"></asp:Label>
        <asp:Label ID="Label4" runat="server" Text="下載檔案" Visible="False" meta:resourcekey="Label4Resource1"></asp:Label>
        <asp:Label ID="Label5" runat="server" Text="下載完畢後點此關閉視窗" Visible="False" meta:resourcekey="Label5Resource1"></asp:Label>
        <asp:Label ID="lockedUserMsg" runat="server" Text="您的帳號已被鎖定" Visible="False"
            meta:resourcekey="lockedUserMsgResource1"></asp:Label>
        <asp:Label ID="overdueUserMsg" runat="server" Text="您的帳號已過期" Visible="False"
            meta:resourcekey="overdueUserMsgResource1"></asp:Label>
        <asp:Label ID="suspendedUserMsg" runat="server" Text="您的帳號已被停用" Visible="False"
            meta:resourcekey="suspendedUserMsgResource1"></asp:Label>
        <asp:Label ID="lbAdOnly" runat="server" Text="系統已設定為'只允許使用AD帳號登入',請使用AD帳號登入系統" Visible="False"></asp:Label>
        <asp:Label ID="lbSSOOnly" runat="server" Text="系統已設定為'只允許使用自動登入',請點選[自動登入]來登入系統" Visible="False"></asp:Label>
        <asp:Label ID="cvalidLoginMsg" runat="server" Text="帳號或密碼錯誤。<br/>若使用AD驗證，帳號輸入格式為：AD Domain\Account，例：ABC\admin"
            Visible="False" meta:resourcekey="cvalidLoginMsgResource1"></asp:Label>
        <asp:Label ID="cvalidLoginForDomainMsg" runat="server" Text="帳號或密碼錯誤。"
            Visible="False" meta:resourcekey="cvalidLoginForDomainMsgResource1"></asp:Label>
        <asp:HiddenField ID="hdflag" Value="false" runat="server" />
        <asp:Label ID="caMsg" runat="server" Text="用戶端憑證驗證錯誤<br/>發生原因有(未申請憑證、登入帳號與憑證不符)" Visible="false" meta:resourcekey="caMsgResource1"></asp:Label>
        <asp:Label ID="applyCaMsg" runat="server" Text="申請用戶端憑證錯誤，帳號不存在於AD" Visible="false" meta:resourcekey="applyCaMsgResource1"></asp:Label>
        <asp:Label ID="applyCaMsgByError" runat="server" Text="申請用戶端憑證發生錯誤<br/>請聯絡系統管理員" Visible="false" meta:resourcekey="applyCaMsgByErrorResource1"></asp:Label>
        <asp:Label ID="caIPRangeMsg" runat="server" Text="不可登入，IP不在憑證限制範圍內" Visible="false" meta:resourcekey="caIPRangeMsgResource1"></asp:Label>
        <asp:Label ID="msgDays" runat="server" Text="天" Visible="false" ForeColor="Red" meta:resourcekey="msgDaysMsgResource1"></asp:Label>
        <asp:Label ID="msgHours" runat="server" Text="小時" Visible="false" ForeColor="Red" meta:resourcekey="msgHoursResource1"></asp:Label>
        <asp:Label ID="lblExceedUserAccount" runat="server" Text="授權人數已滿無法登入(以帳號人數計算)" Visible="False" meta:resourcekey="lblExceedUserAccountResource1" ></asp:Label>
        <asp:Label ID="lblForgetADdesc" runat="server" meta:resourcekey="lblForgetADdescResource1" Text="系統會寄送給您一個臨時的UOF密碼，如果您是使用AD驗證登入，忘記密碼時請另洽AD管理員" Visible="false"></asp:Label>
        <asp:HiddenField ID="hfUserGuid" runat="server" />
    </form>
</body>
</html>
