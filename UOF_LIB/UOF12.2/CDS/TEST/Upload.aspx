<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Upload.aspx.cs" Inherits="CDS_TEST_Upload" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
                
       
    <div>
       <asp:Table ID="Table1" runat="server" Width="800px"  >
            <asp:TableRow>
                <asp:TableCell BorderStyle="Solid" BorderWidth="1px" Width="100px" >
                    <asp:Label ID="Label2" runat="server" Text="主題"></asp:Label>
                </asp:TableCell>
                <asp:TableCell BorderStyle="Solid" BorderWidth="1px" ColumnSpan="7" >
                    <asp:Label ID="lblA02" runat="server" Text=""></asp:Label>
                </asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell BorderStyle="Solid" BorderWidth="1px" Width="100px" >
                    <asp:Label ID="Label3" runat="server" Text="廠別"></asp:Label>
                </asp:TableCell>
                <asp:TableCell BorderStyle="Solid" BorderWidth="1px"  Width="100px" >
                    <asp:Label ID="lblA03" runat="server" Text=""></asp:Label>
                </asp:TableCell>
                              <asp:TableCell BorderStyle="Solid" BorderWidth="1px" Width="100px" >
                    <asp:Label ID="Label4" runat="server" Text="改善類別"></asp:Label>
                </asp:TableCell>
                <asp:TableCell BorderStyle="Solid" BorderWidth="1px"  Width="100px" >
                    <asp:Label ID="lblA04" runat="server" Text=""></asp:Label>
                </asp:TableCell>
                <asp:TableCell BorderStyle="Solid" BorderWidth="1px" Width="100px" >
                    <asp:Label ID="Label5" runat="server" Text="負責人"></asp:Label>
                </asp:TableCell>
                <asp:TableCell BorderStyle="Solid" BorderWidth="1px"  Width="100px" >
                    <asp:Label ID="lblA05" runat="server" Text=""></asp:Label>
                </asp:TableCell>
                <asp:TableCell BorderStyle="Solid" BorderWidth="1px" Width="100px" >
                    <asp:Label ID="Label6" runat="server" Text="配合單位"></asp:Label>
                </asp:TableCell>
                <asp:TableCell BorderStyle="Solid" BorderWidth="1px"  Width="100px" >
                    <asp:Label ID="lblA06" runat="server" Text=""></asp:Label>
                </asp:TableCell>
            </asp:TableRow>
        </asp:Table>  

          <asp:Table ID="Table2" runat="server" Width="800px"  >
            <asp:TableRow>
                  <asp:TableCell BorderStyle="Solid" BorderWidth="1px" >
                      <asp:Label ID="Label1" runat="server" Text="改善前"></asp:Label>
                  </asp:TableCell>
                       <asp:TableCell BorderStyle="Solid" BorderWidth="1px" >
                          <asp:Label ID="Label7" runat="server" Text="改善後"></asp:Label>
                  </asp:TableCell>
                  </asp:TableRow>
              <asp:TableRow>
                  <asp:TableCell BorderStyle="Solid" BorderWidth="1px" Width="400px" Height="400px">
                      <asp:Image ID="imgA01" runat="server"  Width="400px" Height="400px"/>
                  </asp:TableCell>
                       <asp:TableCell BorderStyle="Solid" BorderWidth="1px" Width="400px" Height="400px">
                            <asp:Image ID="imgA07" runat="server" Width="400px" Height="400px" />
                  </asp:TableCell>
                  </asp:TableRow>
                   <asp:TableRow>
                    <asp:TableCell BorderStyle="Solid" BorderWidth="1px" Width="400px" Height="200px" VerticalAlign="Top">
                        <asp:Label ID="lblA01Content" runat="server" Text="Label"></asp:Label>
                  </asp:TableCell>
                    <asp:TableCell BorderStyle="Solid" BorderWidth="1px" Width="400px" Height="200px" VerticalAlign="Top">
                         <asp:Label ID="lblA07Content" runat="server" Text="Label"></asp:Label>
                  </asp:TableCell>
              </asp:TableRow>
          </asp:Table>

        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" Width="800px">
            <Columns>
                <asp:BoundField HeaderText="KPI項目" DataField="A081"  />
                 <asp:BoundField HeaderText="改善前" DataField="A082"  />
                 <asp:BoundField HeaderText="改善後" DataField="A083"  />
                 <asp:BoundField HeaderText="差異" DataField="A084"  />
                 <asp:BoundField HeaderText="改善百分比" DataField="A085"  />
            </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>
