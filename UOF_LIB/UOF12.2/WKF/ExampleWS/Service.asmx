<%@ WebService Language="C#" Class="Service" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class Service  : System.Web.Services.WebService 
{
    /// <summary>
    /// 單行文字Web Service回傳範例
    /// </summary>
    /// <param name="formInfo"></param>
    /// <returns></returns>
    [WebMethod]
    public string SingleLine(string formInfo) 
    {
        return "<Form returnStatus='regular'><item fieldText='單行文字回傳範例' fieldValue='單行文字回傳範例' /></Form>";
    }

    /// <summary>
    /// 多行文字Web Service回傳範例
    /// </summary>
    /// <param name="formInfo"></param>
    /// <returns></returns>
    [WebMethod]
    public string MultiLine(string formInfo)
    {
        return "<Form returnStatus='regular'><item fieldText='多行文字回傳範例' fieldValue='多行文字回傳範例' /></Form>";
    }

    /// <summary>
    /// 數值欄位Web Service回傳範例
    /// </summary>
    /// <param name="formInfo"></param>
    /// <returns></returns>
    [WebMethod]
    public string NumberText(string formInfo)
    {
        return "<Form returnStatus='regular'><item fieldText='100' fieldValue='100' /></Form>";
    }

    /// <summary>
    /// 日期欄位Web Service回傳範例
    /// </summary>
    /// <param name="formInfo"></param>
    /// <returns></returns>
    [WebMethod]
    public string DateSelect(string formInfo)
    {
        return "<Form returnStatus='regular'><item fieldText='" + DateTime.Now.ToShortDateString() + "' fieldValue='" + DateTime.Now.ToShortDateString() + "' /></Form>";
    }

    /// <summary>
    /// 時間欄位Web Service回傳範例
    /// </summary>
    /// <param name="formInfo"></param>
    /// <returns></returns>
    [WebMethod]
    public string TimeSelect(string formInfo)
    {
        return "<Form returnStatus='regular'><item fieldText='" + DateTime.Now.ToString("HH:mm") + "' fieldValue='" + DateTime.Now.ToString("HH:mm") + "' /></Form>";
    }

    /// <summary>
    /// 下拉選單Web Service回傳範例
    /// </summary>
    /// <param name="formInfo"></param>
    /// <returns></returns>
    [WebMethod]
    public string DropDownList(string formInfo)
    {
        string returnValue = "<Form returnStatus='regular'>";
        returnValue += "<item fieldText='選項一' fieldValue='選項一' />";
        returnValue += "<item fieldText='選項二' fieldValue='選項二' />";
        returnValue += "<item fieldText='選項三' fieldValue='選項三' />";
        returnValue += "<item fieldText='選項四' fieldValue='選項四' />";
        returnValue += "<item fieldText='選項五' fieldValue='選項五' />";
        returnValue += "</Form>";

        return returnValue;
    }

    /// <summary>
    /// 結案前呼叫Web Service範例(成功)
    /// </summary>
    /// <param name="formInfo"></param>
    /// <returns></returns>
    [WebMethod]
    public string EndFormValidateSuccess(string formInfo)
    {
        return "<ReturnValue><Status>1</Status></ReturnValue>";
    }

    /// <summary>
    /// 結案前呼叫Web Service範例(失敗)
    /// </summary>
    /// <param name="formInfo"></param>
    /// <returns></returns>
    [WebMethod]
    public string EndFormValidateFail(string formInfo)
    {
        return "<ReturnValue><Status>0</Status><Exception><Message>回傳的訊息</Message></Exception></ReturnValue>";
    }
}

