using Ede.Uof.EIP.Organization.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.Organization
{
    public class Organization
    {
        /// <summary>
        /// 取得員工直屬主管
        /// </summary>
        /// <param name="userGuid"></param>
        /// <returns></returns>
        public UserSet GetUserSuperior(string userGuid)
        {
            UserSet userSet = new UserSet();

            UserUCO userUCO = new UserUCO();
            EBUser ebUser = userUCO.GetEBUser(userGuid);
            BaseGroup baseGp = ebUser.GetEmployeeDepartment(DepartmentOfUser.Major).Department;

            //如果目前簽核人員不是部門主管，那就要找尋該人員目前部門的主管
            if (CheckIsDeptSuperior(ebUser.UserGUID, baseGp.GroupId) == false)
            {
                AddSuperiorToUserSet(baseGp.GroupId, userSet);
            }
            else
            {
                //如果目前的簽核人員是部門主管，則要找尋上一個部門的主管
                if (baseGp.ParnetGroup != null)
                {
                    AddSuperiorToUserSet(baseGp.ParnetGroup.GroupId, userSet);
                }
            }

            return userSet;

        }


        /// <summary>
        /// 檢查是否是否是部門主管
        /// </summary>
        /// <returns></returns>
        private bool CheckIsDeptSuperior(string userGUID, string groupId)
        {
            UserUCO userUco = new UserUCO();
            bool IsSuperior = false;
            EBUser ebUser = userUco.GetEBUser(userGUID);
            EmployeeJobFunctionCollection employeeJobFunctionCollection = ebUser.GetJobFunctionsOfDepartment(groupId);

            //判斷是否是主管
            for (int i = 0; i < employeeJobFunctionCollection.Count; i++)
            {
                if (employeeJobFunctionCollection[i].FunctionId == "Superior")
                {
                    IsSuperior = true;
                    break;
                }
            }
            return IsSuperior;
        }


        /// <summary>
        /// 把主管加到 UserSet 裡 , 2006/11/27 尋找部門主管，如果找不到就往上找，直到找到為止
        /// </summary>
        /// <param name="groupId"></param>
        /// <param name="userSet"></param>
        private void AddSuperiorToUserSet(string groupId, UserSet userSet)
        {
            EmployeeFindUCO employeeFindUCO = new EmployeeFindUCO();
            //取得查詢群組的主管
            UserSetEBUsersCollection userSetEBUsersCollection = employeeFindUCO.FindEmployeeByFunction(groupId, "Superior");

            if (userSetEBUsersCollection.Count > 0)
            {
                for (int i = 0; i < userSetEBUsersCollection.Count; i++)
                {
                    //把查到的主管 UserGuid 加到 userSet 裡
                    UserSetUser userSetUser = new UserSetUser();
                    userSetUser.USER_GUID = userSetEBUsersCollection[i].UserGUID;
                    userSet.Items.Add(userSetUser);
                }
            }
            else
            {
                //如果找不到直屬主管就往上一層層找上去，直到有為止
                BaseGroup baseGroup = new BaseGroup(groupId);
                if (baseGroup.ParnetGroup != null)
                {
                    AddSuperiorToUserSet(baseGroup.ParnetGroup.GroupId, userSet);
                }
            }
        }


    }

}
