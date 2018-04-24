using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.EIP.Organization;

namespace Lib.Organization
{
    public class OrganizationPlus
    {
        /// <summary>
        /// 取得人員GUID
        /// </summary>
        /// <param name="account">帳號</param>
        /// <returns></returns>
        public string GetUserGuid(string account)
        {
            UserUCO userUCO = new UserUCO();
            string userGuid = userUCO.GetGUID(account);

            if (string.IsNullOrEmpty(userGuid))
            {
                //再丟例外
            }

            return userGuid;
        }

        /// <summary>
        /// 取得職務GUID
        /// </summary>
        /// <param name="funcName">職務名稱</param>
        /// <returns></returns>
        public string GetFuncGuid(string funcName)
        {
            Ede.Uof.EIP.Organization.FunctionUCO uco = new Ede.Uof.EIP.Organization.FunctionUCO();

            string funcId = uco.GetFunctionID(funcName);

            if (string.IsNullOrEmpty(funcId))
            {
                //丟例外
            }

            return funcId;

        }

        /// <summary>
        /// 取得職級GUID
        /// </summary>
        /// <param name="titleName">職級名稱</param>
        /// <returns></returns>
        public string GetTitleGuid(string titleName)
        {
            Ede.Uof.EIP.Organization.TitleUCO uco = new Ede.Uof.EIP.Organization.TitleUCO();

            string titleId = uco.GetTitleID(titleName);

            if (string.IsNullOrEmpty(titleId))
            {
                //丟例外
            }

            return titleId;

        }

        /// <summary>
        /// 取得部門Guid
        /// </summary>
        /// <param name="deptPath">部門結構(EX:總公司/第一事業部)</param>
        /// <returns></returns>
        public string getDeptGuid(string deptPath)
        {
            //如果是空的部門的話就給個GUID
            if (string.IsNullOrEmpty(deptPath))
            {
                //丟例外
            }

            string[] deptNames = deptPath.Split('/');
            GroupUCO groupData = new GroupUCO(GroupType.Department);
            string groupId = null;
            string parentGroupID = "Company";

            string tmp = groupData.GetRootGroupID(deptNames[0].Trim());
          
            if (tmp != parentGroupID) //取得第0階的GroupID,如果不等於 "Company" 則抛出例外
            {
                //丟例外
                return "";
            }

            groupId = parentGroupID;

            for (int i = 1; i < deptNames.Length; i++)
            {
                if (string.IsNullOrEmpty(deptNames[i]))
                    continue;

                string name = deptNames[i];
                groupId = groupData.GetGroupID(name.Trim(), parentGroupID);

                parentGroupID = groupId;
            }
            return groupId;
        }

    }

}
