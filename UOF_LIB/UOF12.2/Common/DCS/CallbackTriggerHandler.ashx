<%@ WebHandler Language="C#" Class="CallbackTriggerHandler" %>

using System;
using System.Collections.Generic;
using System.Reflection;
using System.Web;
using Ede.Uof.Utility.Task;


public class CallbackTriggerHandler : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        var assembly = HttpUtility.UrlDecode(context.Request.QueryString.Get("Assembly"));
        var type = HttpUtility.UrlDecode(context.Request.QueryString.Get("Type"));
        var json = HttpUtility.UrlDecode(context.Request.QueryString.Get("Args"));
        var args = Newtonsoft.Json.JsonConvert.DeserializeObject <List<string>>(json);

        var error = context.Request.QueryString.Get("Error");
        if (!string.IsNullOrEmpty(error))
        {
            error = HttpUtility.UrlDecode(error);
        }

        var asmb = Assembly.Load(assembly);
        var trigger = asmb.CreateInstance(type) as BaseCallbackTrigger;
        trigger.Execute(args.ToArray(), error);
        
        context.Response.End();
    }
    

    public bool IsReusable {
        get {
            return false;
        }
    }

}