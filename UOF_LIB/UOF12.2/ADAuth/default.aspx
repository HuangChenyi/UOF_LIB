<%@ Page Language="C#" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string type = Request["t"];
        if (string.IsNullOrEmpty(type))
        {
            type = "ad";
        }

        if(type=="ad")
        {
            if (!Request.IsAuthenticated)
            {
                Response.StatusCode = 401;
                Response.StatusDescription = "Unauthorized";
            }
            else
            {
                FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(Request.LogonUserIdentity.Name, true, 1);
                string encTicket = FormsAuthentication.Encrypt(ticket);
                Response.Cookies.Add(new HttpCookie("EBAdAuthAccount", encTicket));
                Response.Redirect(@"../Login/CheckSSoAccount.aspx");
            }
        }
        else if(type=="ca")
        {
            HttpClientCertificate hcc = Request.ClientCertificate;
            string clientSubject = hcc.Subject;
            bool pass = false;
            string scheme = Request["scheme"];
            if (string.IsNullOrEmpty(scheme))
            {
                scheme = "http";
            }

            if (!string.IsNullOrEmpty(clientSubject))
            {
                Regex regex = new Regex(@"CN=(?<account>[^,]*)", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
                MatchCollection matches = regex.Matches(clientSubject);

                if (matches.Count > 0)
                {
                    string account = matches[0].Groups["account"].Value;
                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(account, true, 1);
                    string encTicket = FormsAuthentication.Encrypt(ticket);
                    Response.Cookies.Add(new HttpCookie("EBAdAuthAccount", encTicket));
                    Response.Redirect(string.Format("{0}://{1}{2}/../Login/CheckSSoAccount.aspx",
                                                    scheme, Request.Url.Host, Request.ApplicationPath));
                    pass = true;
                }
            }

            if (!pass)
            {
                Response.Redirect(string.Format("{0}://{1}{2}/login.aspx?state=SSOFail",
                                                scheme, Request.Url.Host, Request.ApplicationPath));
            }

        }
		else if(type=="onlyca")
		{
		    HttpClientCertificate hcc = Request.ClientCertificate;
            string clientSubject = hcc.Subject;
            string clientSerialNum = hcc.SerialNumber;
            bool pass = false;
            string scheme = Request["scheme"];
            if (string.IsNullOrEmpty(scheme))
            {
                scheme = "http";
            }
            if (!string.IsNullOrEmpty(clientSubject))
            {
                Regex regex = new Regex(@"CN=(?<account>[^,]*)", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
                MatchCollection matches = regex.Matches(clientSubject);

                if (matches.Count > 0)
                {
                    string account = matches[0].Groups["account"].Value;
                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(account, true, 1);
                    string encTicket = FormsAuthentication.Encrypt(ticket);
                    Response.Cookies.Add(new HttpCookie("EBCaAuthAccount", encTicket));
                    
                    FormsAuthenticationTicket ticketNum = new FormsAuthenticationTicket(clientSerialNum, true, 1);
                    string encTicketNum = FormsAuthentication.Encrypt(ticketNum);
                    Response.Cookies.Add(new HttpCookie("EBCaSerialNum", encTicketNum));
                    

                    Response.Redirect(string.Format("{0}://{1}{2}/../Login/CheckCaAccount.aspx",
                                                    scheme, Request.Url.Host, Request.ApplicationPath));
                    pass = true;
                }
            }

            if (!pass)
            {
                Response.Redirect(string.Format("{0}://{1}{2}/login.aspx?state=CAFail",
                                                scheme, Request.Url.Host, Request.ApplicationPath));
            }
		}
		else if(type=="adonlyca")
		{
		    if (!Request.IsAuthenticated)
            {                
                Response.StatusCode = 401;
                Response.StatusDescription = "Unauthorized";
            }
            else
            {
				HttpClientCertificate hcc = Request.ClientCertificate;
				string clientSubject = hcc.Subject;
				string clientSerialNum = hcc.SerialNumber;
				bool pass = false;
				string scheme = Request["scheme"];
				if (string.IsNullOrEmpty(scheme))
				{
					scheme = "http";
				}
				if (!string.IsNullOrEmpty(clientSubject))
				{
					Regex regex = new Regex(@"CN=(?<account>[^,]*)", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
					MatchCollection matches = regex.Matches(clientSubject);

					if (matches.Count > 0)
					{

						FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(Request.LogonUserIdentity.Name, true, 1);
						string encTicket = FormsAuthentication.Encrypt(ticket);
						Response.Cookies.Add(new HttpCookie("EBAdAuthAccount", encTicket));

						string account = matches[0].Groups["account"].Value;
						FormsAuthenticationTicket ticketCa = new FormsAuthenticationTicket(account, true, 1);
						string encTicketCa = FormsAuthentication.Encrypt(ticketCa);
						Response.Cookies.Add(new HttpCookie("EBCaAuthAccount", encTicketCa));
                    
						FormsAuthenticationTicket ticketNum = new FormsAuthenticationTicket(clientSerialNum, true, 1);
						string encTicketNum = FormsAuthentication.Encrypt(ticketNum);
						Response.Cookies.Add(new HttpCookie("EBCaSerialNum", encTicketNum));

						Response.Redirect(string.Format("{0}://{1}{2}/../Login/CheckSSoAccount.aspx",
                                                    scheme, Request.Url.Host, Request.ApplicationPath));

						pass = true;
					}
				}

				if (!pass)
				{
					Response.Redirect(string.Format("{0}://{1}{2}/login.aspx?state=CAFail",
													scheme, Request.Url.Host, Request.ApplicationPath));
				}
            }
		}
    }
</script>
<html>
<head>
    <script type="text/javascript">    
        window.location.href='../login.aspx?state=SSOFail';
    </script>
</head>
</html>
