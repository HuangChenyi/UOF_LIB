<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="CDS_Grid_Default" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   
    
    <script>
    function AA()
    {
 
    var checkboxs = $('#'+ '<%=grid.ClientID%>' +' input[type=checkbox][purpose=autocheck]')
        .each(function(){
            if($(this).prop("checked")){ checkedString+=","+$(this).attr("DataKey");}

            console(checkedString);
            });

      
    }


     
Sys.Application.add_load(function(){

            $('#<%=grid.ClientID%> input[type=checkbox][purpose=autocheck] ').on('click', GetDetail);
            $('#<%=grid.ClientID%> > tbody > .GridHeader th:first-child input[type=checkbox]').on('click',  GetDetail);
          }
        ); 

        function GetDetail(){
            var dataKeys = [];
            $('#<%=grid.ClientID%> input[type=checkbox][purpose=autocheck] ').each(function(){
                if($(this).prop("checked"))
                {
                    dataKeys.push($(this).attr("DataKey"));
                }
            });
            alert(dataKeys.join(","));
        } 


</script>


    

     <Fast:Grid ID="grid"  DataKeyOnClientWithCheckBox ="true" AutoGenerateCheckBoxColumn="true" OnRowDataBound="grid_RowDataBound"   OnBeforeExport ="grid_BeforeExport" PageSize="3" AllowSorting="true" runat="server" OnSorting="grid_Sorting" OnPageIndexChanging="grid_PageIndexChanging" DataKeyNames="USER_GUID" AutoGenerateColumns="false" AllowPaging="true">
<EnhancePagerSettings FirstImageUrl="" FirstAltImageUrl="" PreviousImageUrl="" NextImageUrl="" LastImageUrl="" LastAltImage="" PageNumberCssClass="" PageNumberCurrentCssClass="" PageInfoCssClass="" PageRedirectCssClass="" NextIAltImageUrl="" PreviousAltImageUrl="" ShowHeaderPager="True"></EnhancePagerSettings>

        <ExportExcelSettings  AllowExportToExcel="true" ExportType="DataSource" />          
          <Columns>
                        <asp:BoundField HeaderText="帳號" DataField="ACCOUNT" ItemStyle-Width="200px" SortExpression="ACCOUNT" >
<ItemStyle Width="200px"></ItemStyle>
                        </asp:BoundField>
                         <asp:BoundField HeaderText="姓名" DataField="NAME" ItemStyle-Width="200px" SortExpression="NAME"  >
<ItemStyle Width="200px"></ItemStyle>
                        </asp:BoundField>
              <asp:TemplateField>
                  <ItemTemplate>

                  </ItemTemplate>
              </asp:TemplateField>
                    </Columns>

    </Fast:Grid>


    <telerik:RadGrid ID="gg" runat="server"  CssClass="Grid" EnableTheming="true"  Width="100px" >
        <HeaderStyle Wrap="false" />
        <ItemStyle Wrap="false" />
    </telerik:RadGrid>

   

    <asp:Button ID="btnGetSelect" runat="server" Text="取得選取內容(Key)" OnClientClick="AA();" OnClick="btnGetSelect_Click" />  
     <asp:Button ID="btnGetSelectKey" runat="server" Text="取得選取內容(Index)" OnClick="btnGetSelectKey_Click" />    
    <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Width="300px" Height="300px"></asp:TextBox>
   

</asp:Content>

