using Ede.Uof.EIP.Organization.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.Organization
{
    public class UserSetPlus
    {

        public UserSetPlus()
        {
            UserSetItems = new List<UserSetItem>();
        }

        public List<UserSetItem> UserSetItems { get; set; }


        /// <summary>
        /// 轉換回UOF的UserSet格式
        /// </summary>
        /// <returns></returns>
        public UserSet ConverToUserSet()
        {
            UserSet userUset = new UserSet();
            OrganizationPlus orgP = new OrganizationPlus();
            foreach (UserSetItem item in UserSetItems)
            {
                switch (item.Type)
                {
                    case "user":
                        UserSetUser user = new UserSetUser();
                        user.USER_GUID = orgP.GetUserGuid(item.Value);
                        userUset.Items.Add(user);
                        break;
                    case "group":
                        UserSetGroup userSetGroup = new UserSetGroup();
                        userSetGroup.GROUP_ID = orgP.getDeptGuid(item.Value);
                        userSetGroup.IS_DEPTH = item.isDepth;
                        userUset.Items.Add(userSetGroup);
                        break;
                    case "jobTitle":
                        UserSetTitle userSetTitle = new UserSetTitle();
                        userSetTitle.TITLE_ID = orgP.GetTitleGuid(item.Value);
                        userUset.Items.Add(userSetTitle);
                        break;

                    case "jobFunction":
                        UserSetFunction userSetFunc = new UserSetFunction();
                        userSetFunc.FUNC_ID = orgP.GetFuncGuid(item.Value);
                        userUset.Items.Add(userSetFunc);
                        break;
                    case "jobTitleOfGroup":
                        UserSetTitleOfGroup userSetTitleOfGroup = new UserSetTitleOfGroup();
                        userSetTitleOfGroup.TITLE_ID = orgP.GetTitleGuid(item.Value);
                        userSetTitleOfGroup.GROUP_ID = orgP.getDeptGuid(item.Value2);
                        userSetTitleOfGroup.IS_DEPTH = item.isDepth;
                        userUset.Items.Add(userSetTitleOfGroup);
                        break;

                    case "jobFunctionOfGroup":
                        UserSetFunctionOfGroup userSetFuncOfGroup = new UserSetFunctionOfGroup();
                        userSetFuncOfGroup.FUNC_ID = orgP.GetFuncGuid(item.Value);
                        userSetFuncOfGroup.GROUP_ID = orgP.getDeptGuid(item.Value2);
                        userSetFuncOfGroup.IS_DEPTH = item.isDepth;
                        userUset.Items.Add(userSetFuncOfGroup);
                        break;



                }
            }



            return userUset;
        }


        public string GetFieldValue()
        {
            string returnValue = String.Empty;
            List<String> userList = new List<string>();

            UserSet userSet = ConverToUserSet();
            #region ================= 群組 =================
            foreach (UserSetGroup userSetGroup in userSet.Items.GetGroupArray())
            {
                userList.Add(userSetGroup.GetGroupName());
            }
            #endregion

            #region ================= 人員 =================
            foreach (UserSetUser userSetUser in userSet.Items.GetUserAaary())
            {
                userList.Add(userSetUser.GetName());
            }
            #endregion

            #region ================= 職稱 =================
            foreach (UserSetTitle userSetTitle in userSet.Items.GetTitleArray())
            {
                userList.Add(userSetTitle.GetTitleName());
            }
            #endregion

            #region ================= 職務 =================
            foreach (UserSetFunction userSetFunction in userSet.Items.GetFunctionArray())
            {
                userList.Add(userSetFunction.GetFunctionName());
            }
            #endregion

            #region ================= 部門+職級 =================
            foreach (UserSetTitleOfGroup userSetTitleOfGroup in userSet.Items.GetTitleOfGroupArray())
            {
                userList.Add(userSetTitleOfGroup.GetGroupName() + "-" + userSetTitleOfGroup.GetTitleName());
            }
            #endregion

            #region ================= 部門+職務 =================
            foreach (UserSetFunctionOfGroup userSetFunctionOfGroup in userSet.Items.GetFunctionOfGroupArray())
            {
                userList.Add(userSetFunctionOfGroup.GetGroupName() + "-" + userSetFunctionOfGroup.GetFunctionName());
            }
            #endregion


            foreach (string str in userList)
            {
                returnValue += str + "、";
            }

            if (returnValue != String.Empty)
            {
                returnValue = returnValue.Substring(0, returnValue.LastIndexOf("、"));
            }

            return returnValue;
        }
    }

    public class UserSetItem
    {
        public string Type { get; set; }
        public bool isDepth { get; set; }
        public string Value { get; set; }
        public string Value2 { get; set; }
    }
}
