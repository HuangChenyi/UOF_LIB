<%@ Page Language="C#" %>   
<%@ Import namespace="System.DirectoryServices" %>

<body>
    <form id="form1" runat="server">
                      <%  
                          DirectoryEntry entry = new DirectoryEntry("GC://" + "10.1.0.20", "administrator", "NO:3160");
                          DirectorySearcher searcher = new DirectorySearcher(entry);
                          searcher.Filter = "(&(sAMAccountName=chrishuang)(objectClass=user))";
                          
                          try
                          {
                              SearchResult result = searcher.FindOne();
                              if (result != null)
                              {
                                  Response.Write(String.Format("path={0}<BR>", result.Path));
                              }
                              else
                              {
                                  Response.Write("null");
                              }
                          }
                          catch (Exception e)
                          {

                              Response.Write(e);
                          }
                          
                           %>
    </form>
</body>

