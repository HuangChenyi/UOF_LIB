<script language="C#" runat="server">
    public void Page_Load(object sender, EventArgs e)
    {
        Response.Redirect("Downloadfile.ashx?id=" + Request["id"]+"&type=image");
    }

</script>
