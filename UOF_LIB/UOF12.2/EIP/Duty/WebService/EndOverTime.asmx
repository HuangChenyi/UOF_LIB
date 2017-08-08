<%@ WebService Language="C#" Class="EndOverTime" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Ede.Uof.WKF.DutyForm.OverTime;
using System.Xml;

[WebService(Namespace = "http://www.1st-excellenc.ecom/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class EndOverTime  : System.Web.Services.WebService 
{

    [WebMethod]
    public string Check(string formInfo) 
    {
        formInfo = HttpUtility.UrlDecode(formInfo);
        OverTimeUCO overTimeUCO = new OverTimeUCO();
        string returnValue = "<ReturnValue><Status>{0}</Status><Exception><Message>{1}</Message></Exception></ReturnValue>";

        //目前只先檢查實際加班資訊要輸入,打卡資訊先不檢查
        try
        {
            if (overTimeUCO.EndFormCheckActualTime(formInfo))
            {
                returnValue = string.Format(returnValue, "1", "");
            }
        }
        catch (Exceptions.FormInfoNotFound ex)
        {
            returnValue = string.Format(returnValue, "0", "請填寫實際加班時間資訊");
        }
        catch (Exception ex)
        {
            returnValue = string.Format(returnValue, "0", ex.Message);
        }
        
        return returnValue;        
        //下列不執行,因暫不檢查打卡資訊
        //如要檢查打卡資訊把上面的程式mark起來就可以了,因為檢查打卡資訊裡面就有檢查是否有實際加班資訊

        try
        {
            if (overTimeUCO.EndFormCheckPunch(formInfo))
            {
                returnValue = string.Format(returnValue, "1", "");
            }
        }
        catch (Exceptions.ApplicantInfoNotFound ex)
        {
            returnValue = string.Format(returnValue, "0", "無申請者資訊");
        }
        catch (Exceptions.SignInfoNotFound ex)
        {
            returnValue = string.Format(returnValue, "0", "無簽核者資訊");
        }
        catch (Exceptions.FormInfoNotFound ex)
        {
            returnValue = string.Format(returnValue, "0", "請填寫實際加班時間資訊");
        }
        catch (Exceptions.ActualOverTimeDatePunchRecordNotFound ex)
        {
            returnValue = string.Format(returnValue, "0", "實際加班日期無打卡記錄,無法結案!!");
        }
        catch (Exception ex)
        {
            returnValue = string.Format(returnValue, "0", ex.Message);
        }

        return returnValue;
    }
}