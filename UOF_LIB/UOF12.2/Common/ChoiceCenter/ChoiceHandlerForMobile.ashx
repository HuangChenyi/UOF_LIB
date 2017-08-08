<%@ WebHandler Language="C#" Class="ChoiceForMobileHandler" %>

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Dynamic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Xml.Linq;
using Ede.Uof.EIP.Organization;
using Ede.Uof.EIP.Organization.Util;
using Newtonsoft.Json;
using Telerik.Web.UI;
using Ede.Uof.EIP.Customer.PO;
using Ede.Uof.EIP.Customer.UCO;
using Ede.Uof.EIP.Customer.Data;

public class ChoiceForMobileHandler : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        var action = context.Request.Form["action"];
        context.Response.AppendHeader("Access-Control-Allow-Origin", "*");
        if (action == "GetDepartments")
        {
            var parentId = context.Request.Form["parent"];

            dynamic data = new ExpandoObject();
            dynamic parent = new ExpandoObject();
            
            GroupUCO uco = new GroupUCO(GroupType.Department);
            var departments = uco.QueryDepartment(parentId);

            if (!string.IsNullOrEmpty(parentId))
            {
                var parentDepartment = uco.QueryParentDepartment(parentId);
                if (parentDepartment.Rows.Count > 0)
                {
                    parent.GroupId = parentDepartment.Rows[0]["GROUP_ID"];
                    parent.Name = parentDepartment.Rows[0]["GROUP_NAME"];
                }
            }
          

            var departmentsResult = from u in departments.Tables[0].AsEnumerable()
                          select new
                          {

                              GroupId = (string)u["GROUP_ID"],
                              Name = (string)u["GROUP_NAME"],
                              ChildrenCount = ((int)u["RGT"] - (int)u["LFT"] - 1) / 2,
                              Level = u["GROUP_LEVEL"]
                          };
            
            data.parent = parent;
            data.departments = departmentsResult;
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(data));
              
        }
        else if (action == "GetDepartmentWithUser")
        {
            var parentId = context.Request.Form["parent"];
            if (string.IsNullOrEmpty(parentId))
            {
                parentId = "Company";
            }
            dynamic data = new ExpandoObject();

            var groupUCO = new GroupUCO(GroupType.Department);
            var departments = groupUCO.QueryDepartmentWithUserCount(parentId);
            var parentDepartment = groupUCO.QueryParentDepartment(parentId);
            dynamic parent = new ExpandoObject();

            if (parentDepartment.Rows.Count > 0)
            {
                parent.GroupId = parentDepartment.Rows[0]["GROUP_ID"];
                parent.Name = parentDepartment.Rows[0]["GROUP_NAME"];
            }

            var departmentsResult = from u in departments.Tables[0].AsEnumerable()
                                    select new
                                    {
                                        GroupId = (string)u["GROUP_ID"],
                                        Name = (string)u["GROUP_NAME"],
                                        ChildrenCount = ((int)u["RGT"] - (int)u["LFT"] - 1) / 2,
                                        UserCount = (int)u["USER_COUNT"],
                                        Level = u["GROUP_LEVEL"]
                                    };

            var employeeUCO = new EmployeeUCO();
            var users = employeeUCO.SimpleQueryByGroup(parentId, true);

            var userResults = from u in users.AsEnumerable()
                              select new
                              {

                                  UserGuid = (string)u["USER_GUID"],
                                  Name = (string)u["NAME"] + "(" + u["ACCOUNT"] + ")"
                              };

            data.parent = parent;
            data.departments = departmentsResult;
            data.users = userResults;
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(data));
            return;
            context.Response.Write("[]");
        }
        else if (action == "SearchDepartment")
        {
            var keyword = context.Request.Form["keyword"];
            if (!string.IsNullOrEmpty(keyword))
            {
                GroupUCO uco = new GroupUCO(GroupType.Department);
                var departments = uco.SearchDepartment(keyword);

                var results = from u in departments.AsEnumerable()
                              select new
                              {

                                  GroupId = (string)u["GROUP_ID"],
                                  Name = (string)u["GROUP_NAME"]
                              };
                
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
            }
            else
            {
                context.Response.Write("[]");
            }
        }
        else if (action == "SearchUser")
        {
            var keyword = context.Request.Form["keyword"];
            if (!string.IsNullOrEmpty(keyword))
            {
                var users = new DataTable();

                EmployeeUCO uco = new EmployeeUCO();
                users = uco.SimpleQueryByKeyword(keyword, true);

                var results = from u in users.AsEnumerable()
                    select new
                    {
                        UserGuid = (string) u["USER_GUID"],
                        Name = (string) u["NAME"] + "(" + u["ACCOUNT"] + ")"
                    };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");

        }
        else if (action == "SearchGroup")
        {
            var keyword = context.Request.Form["keyword"];
            if (context.Application["RadGroupTree"] != null && !string.IsNullOrEmpty(keyword))
            {
                var doc = XDocument.Parse((string)context.Application["RadGroupTree"]);

                var results = from item in doc.Descendants("Node")
                              where item.Attribute("Text").Value.ToLower().Contains(keyword.ToLower())
                              select new
                                  {
                                      item.Attribute("Value").Value
                                  };
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
            }
            else
            {
                context.Response.Write("[]");
            }
        }
        else if (action == "GetJobTitle")
        {
            TitleUCO titleData = new TitleUCO();
            DataSet rankDs = titleData.Query();
            var results = from r in rankDs.Tables[0].AsEnumerable()
                          select new
                          {
                              Id = (string)r["TITLE_ID"],
                              Name = (string)r["TITLE_NAME"] 
                          };

            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
            return;

        }
        else if (action == "GetJobFunction")
        {
            FunctionUCO functionData = new FunctionUCO();
            DataSet functionDs = functionData.Query();
            var results = from r in functionDs.Tables[0].AsEnumerable()
                          select new
                          {
                              Id = (string)r["FUNC_ID"],
                              Name = (string)r["FUNC_NAME"]
                          };

            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
            return;

        }
        else if (action == "GetFavorite")
        {
            var favoriteGuid = context.Request.Form["favoriteGuid"];
            var expandToUser = bool.Parse(context.Request.Form["expandToUser"]);
            var showEmployee = bool.Parse(context.Request.Form["showEmployee"]);
            var showMember = bool.Parse(context.Request.Form["showMember"]);

            FavoriteUserSetUCO favoUCO = new FavoriteUserSetUCO();
            UserSet userSet = favoUCO.GetFavoriteUserSet(favoriteGuid);

            if (expandToUser)
            {
                DataTable dt = userSet.GetUsers();
                DataRow[] dr = null;
                if (dt.Rows.Count > 0)
                {
                    if (showEmployee && !showMember)
                    {
                        dr = (DataRow[])dt.Select("USER_TYPE='" + "Employee" + "'");
                    }
                    else
                    {
                        dr = (DataRow[])dt.Select("USER_TYPE='" + "Member" + "'");
                    }
                }
                var users = dr.AsEnumerable();

                var results = from u in users.AsEnumerable()
                              select new
                                  {
                                      type = ((string)u["USER_TYPE"]) == "Employee" ? 1 : 8,
                                      name = (string)u["USER_NAME"],
                                      id = (string)u["USER_GUID"],
                                  };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            var list = new List<dynamic>();

            for (int i = 0; i < userSet.Items.Count; i++)
            {

                switch (userSet.Items[i].Type)
                {
                    case UserSetType.Group:

                        var gitem = (UserSetGroup)userSet.Items[i];
                        if ((showEmployee && gitem.GetGroupType() == "Department") ||
                            (showMember && gitem.GetGroupType() == "Group"))
                        {
                            list.Add(new
                                {
                                    type = (gitem.GetGroupType() == "Department") ? 0 : 6,
                                    //name = "",
                                    //id = "",
                                    groupName = gitem.Name,
                                    groupId = gitem.GROUP_ID,
                                    isDepth = gitem.IS_DEPTH
                                });
                        }

                        break;

                    case UserSetType.User:
                        var uitem = (UserSetUser)userSet.Items[i];
                        EBUser ebUser = uitem.EBUsers[0];
                        if (ebUser != null && ebUser.IsActive())
                        {
                            if (showEmployee && ebUser.UserType == UserType.Employee)
                            {
                                list.Add(new
                                    {
                                        type = 1,
                                        name = uitem.Name,
                                        id = uitem.USER_GUID,
                                        //groupName = uitem.Name,
                                        //groupId = gitem.GROUP_ID,
                                        //isDepth = gitem.IS_DEPTH
                                    });
                            }
                            if (showMember && ebUser.UserType == UserType.Member)
                            {
                                list.Add(new
                                    {
                                        type = 8,
                                        name = uitem.Name,
                                        id = uitem.USER_GUID,
                                        //groupName = uitem.Name,
                                        //groupId = gitem.GROUP_ID,
                                        //isDepth = gitem.IS_DEPTH
                                    });
                            }
                        }
                        break;

                    case UserSetType.Title:
                        if (showEmployee)
                        {
                            var item = userSet.Items[i];
                            list.Add(new
                                {
                                    type = 4,
                                    name = item.Name,
                                    id = item.Key,
                                    //groupName = uitem.Name,
                                    //groupId = gitem.GROUP_ID,
                                    //isDepth = gitem.IS_DEPTH
                                });
                        }

                        break;

                    case UserSetType.Function:
                        if (showEmployee)
                        {
                            var item = userSet.Items[i];
                            list.Add(new
                                {
                                    type = 5,
                                    name = item.Name,
                                    id = item.Key,
                                    //groupName = uitem.Name,
                                    //groupId = gitem.GROUP_ID,
                                    //isDepth = gitem.IS_DEPTH
                                });
                        }
                        break;

                    case UserSetType.TitleOfGroup:
                        if (showEmployee)
                        {
                            var item = (UserSetTitleOfGroup)userSet.Items[i];
                            list.Add(new
                                {
                                    type = 2,
                                    name = item.Name,
                                    id = item.TITLE_ID,
                                    groupName = item.Name,
                                    groupId = item.GROUP_ID,
                                    isDepth = item.IS_DEPTH
                                });
                        }
                        break;

                    case UserSetType.FunctionOfGroup:
                        if (showEmployee)
                        {
                            var item = (UserSetFunctionOfGroup)userSet.Items[i];
                            list.Add(new
                                {
                                    type = 3,
                                    name = item.Name,
                                    id = item.FUNC_ID,
                                    groupName = item.Name,
                                    groupId = item.GROUP_ID,
                                    isDepth = item.IS_DEPTH
                                });
                        }
                        break;
                    case UserSetType.MemberClass:
                        if (showMember)
                        {
                            var item = (UserSetMemberClass)userSet.Items[i];
                            list.Add(new
                                {
                                    type = 7,
                                    name = item.Name,
                                    id = item.CLASS_GUID,
                                });
                        }
                        break;
                    case UserSetType.MemberClassOfGroup:
                        if (showMember)
                        {
                            var item = (UserSetMemberClassOfGroup)userSet.Items[i];
                            list.Add(new
                                {
                                    type = 9,
                                    name = item.Name,
                                    id = item.CLASS_GUID,
                                    groupName = item.Name,
                                    groupId = item.GROUP_ID,
                                    isDepth = item.IsDepth
                                });
                        }
                        break;
                }

            }


            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(list));
            return;
        }
        else if (action == "GetExpendToUser")
        {
            var type = context.Request.Form["type"];

            var id = context.Request.Form["id"];
            bool isDepth = bool.Parse(context.Request.Form["isDepth"] ?? "false");
            var groupId = context.Request.Form["groupId"];

            UserSet userSet = new UserSet();

            switch (type)
            {
                case "Department":
                case "Group":
                    UserSetGroup setDept = new UserSetGroup();
                    setDept.IS_DEPTH = isDepth;
                    setDept.GROUP_ID = groupId;
                    userSet.Items.Add(setDept);
                    break;
                case "DepartmentUser":
                case "GroupUser":
                    UserSetUser setUser = new UserSetUser();
                    setUser.USER_GUID = id;
                    userSet.Items.Add(setUser);
                    break;
                case "JobTitle":
                    UserSetTitle setTitle = new UserSetTitle();
                    setTitle.TITLE_ID = id;
                    userSet.Items.Add(setTitle);
                    break;
                case "DepartmentJobTitle":

                    UserSetTitleOfGroup setTitleOfDept = new UserSetTitleOfGroup();
                    setTitleOfDept.IS_DEPTH = isDepth;
                    setTitleOfDept.GROUP_ID = groupId;
                    setTitleOfDept.TITLE_ID = id;
                    userSet.Items.Add(setTitleOfDept);
                    break;
                case "JobFunction":
                    UserSetFunction setFunc = new UserSetFunction();
                    setFunc.FUNC_ID = id;
                    userSet.Items.Add(setFunc);
                    break;
                case "DepartmentJobFunction":
                    UserSetFunctionOfGroup setFuncOfDept = new UserSetFunctionOfGroup();
                    setFuncOfDept.IS_DEPTH = isDepth;
                    setFuncOfDept.GROUP_ID = groupId;
                    setFuncOfDept.FUNC_ID = id;
                    userSet.Items.Add(setFuncOfDept);
                    break;
                case "MemberClass":
                    UserSetMemberClass setMemberClass = new UserSetMemberClass();
                    setMemberClass.CLASS_GUID = id;
                    userSet.Items.Add(setMemberClass);
                    break;
                case "GroupMemberClass":

                    UserSetMemberClassOfGroup setMemberClassOfGroup = new UserSetMemberClassOfGroup();
                    setMemberClassOfGroup.IsDepth = isDepth;
                    setMemberClassOfGroup.GROUP_ID = groupId;
                    setMemberClassOfGroup.CLASS_GUID = id;
                    userSet.Items.Add(setMemberClassOfGroup);
                    break;
            }

            var users = userSet.GetUsers();

            var results = from u in users.AsEnumerable()
                          select new
                          {
                              type = ((string)u["USER_TYPE"]) == "Employee" ? 1 : 8,
                              name = (string)u["USER_NAME"],
                              id = (string)u["USER_GUID"],
                          };

            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));

        }
        else if (action == "CheckFavoriteName")
        {
            var name = context.Request.Form["name"];
            var favoUco = new FavoriteUserSetUCO();

            var result = favoUco.Exists(HttpContext.Current.User.Identity.Name, name);
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(result));
        }
        else if (action == "AddFavorite")
        {
            var name = context.Request.Form["name"];
            var data = context.Request.Form["data"];
            var favoUCO = new FavoriteUserSetUCO();
            var favoDS = new FavoriteUserSetDataSet();
            FavoriteUserSetDataSet.FavoriteUserSetRow favoDR = favoDS.FavoriteUserSet.NewFavoriteUserSetRow();
            string guid = Guid.NewGuid().ToString();
            favoDR.USER_GUID = HttpContext.Current.User.Identity.Name;
            favoDR.FAVORITE_GUID = guid;

            favoDR.USER_SET = JsonToXml(data);
            favoDR.FAVORITE_NAME = name;
            try
            {
                favoDS.FavoriteUserSet.AddFavoriteUserSetRow(favoDR);
                favoUCO.Create(favoDS);
            }
            catch (NoRowEffectedException) { }
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(guid));
            //return guid;
        }
        else if (action == "GetJobTitleUser")//for 限定選人-職級
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                UserSetTitle userTitle = new UserSetTitle();
                userTitle.TITLE_ID = id;

                var results = from u in userTitle.GetUsers().AsEnumerable()
                              select new
                              {

                                  UserGuid = (string)u["USER_GUID"],
                                  Name = (string)u["USER_NAME"] + "(" + u["ACCOUNT"] + ")"
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "GetJobFunctionUser")//for 限定選人-職務
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                UserSetFunction userFun = new UserSetFunction();
                userFun.FUNC_ID = id;

                var results = from u in userFun.GetUsers().AsEnumerable()
                              select new
                              {

                                  UserGuid = (string)u["USER_GUID"],
                                  Name = (string)u["USER_NAME"] + "(" + u["ACCOUNT"] + ")"
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "GetDeptTitleUser")//for 限定選人-部門+職級
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                string[] info = id.Split('|');
                string groupId = string.Empty;
                string titleId = string.Empty;
                string isDepth = string.Empty;
                //xxx|4|0|xxx|xxx

                if (info.Length == 5)
                {
                    groupId = info[3];
                    titleId = info[4];
                    isDepth = info[2];

                    UserSetTitleOfGroup userTitleGroup = new UserSetTitleOfGroup();
                    if (isDepth == "0")
                        userTitleGroup.IS_DEPTH = false;
                    else if (isDepth == "1")
                        userTitleGroup.IS_DEPTH = true;

                    userTitleGroup.GROUP_ID = groupId;
                    userTitleGroup.TITLE_ID = titleId;

                    var results = from u in userTitleGroup.GetUsers().AsEnumerable()
                                  select new
                                  {

                                      UserGuid = (string)u["USER_GUID"],
                                      Name = (string)u["USER_NAME"] + "(" + u["ACCOUNT"] + ")"
                                  };

                    context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                    return;
                }
            }

            context.Response.Write("[]");
        }
        else if (action == "GetDeptFuncUser")//for 限定選人-部門+職務
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                string[] info = id.Split('|');
                string groupId = string.Empty;
                string funId = string.Empty;
                string isDepth = string.Empty;
                //xx|5|0|xxx|xxx

                if (info.Length == 5)
                {
                    groupId = info[3];
                    funId = info[4];
                    isDepth = info[2];

                    UserSetFunctionOfGroup userFunGroup = new UserSetFunctionOfGroup();
                    if (isDepth == "0")
                        userFunGroup.IS_DEPTH = false;
                    else if (isDepth == "1")
                        userFunGroup.IS_DEPTH = true;

                    userFunGroup.GROUP_ID = groupId;
                    userFunGroup.FUNC_ID = funId;

                    var results = from u in userFunGroup.GetUsers().AsEnumerable()
                                  select new
                                  {

                                      UserGuid = (string)u["USER_GUID"],
                                      Name = (string)u["USER_NAME"] + "(" + u["ACCOUNT"] + ")"
                                  };

                    context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                    return;
                }
            }

            context.Response.Write("[]");
        }
        else if (action == "GetCommonUser")//for 客戶聯絡人-常用客戶
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                CUSContactUCO contactUco = new CUSContactUCO();
                CUSCustomerUCO customerData = new CUSCustomerUCO();
                CUSCustomerDataSet cusCustomerDs = customerData.GetCommonUseData(0, 30, string.Empty, id, Ede.Uof.EIP.SystemInfo.Current.UserGUID);

                DataTable dt = new DataTable();
                dt.Columns.Add("CUSTOMER_ID");
                dt.Columns.Add("CUSTOMER_NAME");
                dt.Columns.Add("CONTACT_ID");
                dt.Columns.Add("CONTACT_NAME");
                dt.Columns.Add("HAVE_CHILD");
                dt.Columns.Add("TYPE");

                foreach (CUSCustomerDataSet.TB_EB_CUS_CUSTOMERRow row in cusCustomerDs.TB_EB_CUS_CUSTOMER.Rows)
                {
                    DataRow pRow = dt.NewRow();
                    pRow["CUSTOMER_ID"] = row.CUSTOMER_ID;
                    pRow["CUSTOMER_NAME"] = row.CUSTOMER_NAME;
                    pRow["TYPE"] = "ClassContact";
                    dt.Rows.Add(pRow);

                    List<string> listc = new List<string>();
                    listc.Add(row.CUSTOMER_ID);
                    CUSContactDataSet contactDataSet = contactUco.GetContactDataSetByCustID(listc);
                    foreach (CUSContactDataSet.TB_EB_CUS_CONTACTRow contactRow in contactDataSet.TB_EB_CUS_CONTACT.Rows)
                    {
                        DataRow cRow = dt.NewRow();
                        cRow["CUSTOMER_ID"] = row.CUSTOMER_ID;
                        cRow["CUSTOMER_NAME"] = row.CUSTOMER_NAME;
                        cRow["CONTACT_ID"] = contactRow.CONTACT_ID;
                        cRow["CONTACT_NAME"] = contactRow.CONTACT_NAME;
                        cRow["TYPE"] = "ClassContact";
                        cRow["HAVE_CHILD"] = "Y";

                        dt.Rows.Add(cRow);
                    }
                }
                var results = from u in dt.AsEnumerable()
                              select new
                              {
                                  CoustomerID = Convert.ToString(u["CUSTOMER_ID"]),
                                  CoustomerName = Convert.ToString(u["CUSTOMER_NAME"]),
                                  ContactID = Convert.ToString(u["CONTACT_ID"]),
                                  ContactName = Convert.ToString(u["CONTACT_NAME"]),
                                  HaveChild = Convert.ToString(u["HAVE_CHILD"]),
                                  Type = Convert.ToString(u["TYPE"])
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "GetClass")//for 客戶聯絡人-類別
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                QuoToConCondition QueryCon = new QuoToConCondition();
                CUSContactUCO contactUco = new CUSContactUCO();
                CUSCustomerUCO customerData = new CUSCustomerUCO();
                QueryCon.listClassID = new List<string>();
                QueryCon.listClassID.Add(id);

                CUSCustomerDataSet cusCustomerDs = customerData.GetCustDataSet(QueryCon, 0, 30, string.Empty, Ede.Uof.EIP.SystemInfo.Current.UserGUID, "ALL");
                DataTable dt = new DataTable();
                dt.Columns.Add("CUSTOMER_ID");
                dt.Columns.Add("CUSTOMER_NAME");
                dt.Columns.Add("CONTACT_ID");
                dt.Columns.Add("CONTACT_NAME");
                dt.Columns.Add("HAVE_CHILD");
                dt.Columns.Add("TYPE");
                foreach (CUSCustomerDataSet.TB_EB_CUS_CUSTOMERRow row in cusCustomerDs.TB_EB_CUS_CUSTOMER.Rows)
                {
                    DataRow pRow = dt.NewRow();
                    pRow["CUSTOMER_ID"] = row.CUSTOMER_ID;
                    pRow["CUSTOMER_NAME"] = row.CUSTOMER_NAME;
                    pRow["TYPE"] = "ClassContact";
                    dt.Rows.Add(pRow);
                    List<string> listc = new List<string>();
                    listc.Add(row.CUSTOMER_ID);
                    CUSContactDataSet contactDataSet = contactUco.GetContactDataSetByCustID(listc);
                    foreach (CUSContactDataSet.TB_EB_CUS_CONTACTRow contactRow in contactDataSet.TB_EB_CUS_CONTACT.Rows)
                    {
                        DataRow cRow = dt.NewRow();
                        cRow["CUSTOMER_ID"] = row.CUSTOMER_ID;
                        cRow["CUSTOMER_NAME"] = row.CUSTOMER_NAME;
                        cRow["CONTACT_ID"] = contactRow.CONTACT_ID;
                        cRow["CONTACT_NAME"] = contactRow.CONTACT_NAME;
                        cRow["TYPE"] = "ClassContact";
                        cRow["HAVE_CHILD"] = "Y";

                        dt.Rows.Add(cRow);
                    }
                }

                var results = from u in dt.AsEnumerable()
                              select new
                              {
                                  CoustomerID = Convert.ToString(u["CUSTOMER_ID"]),
                                  CoustomerName = Convert.ToString(u["CUSTOMER_NAME"]),
                                  ContactID = Convert.ToString(u["CONTACT_ID"]),
                                  ContactName = Convert.ToString(u["CONTACT_NAME"]),
                                  HaveChild = Convert.ToString(u["HAVE_CHILD"]),
                                  Type = Convert.ToString(u["TYPE"])
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "GetIndustry")//for 客戶聯絡人-行業別
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                QuoToConCondition QueryCon = new QuoToConCondition();
                CUSContactUCO contactUco = new CUSContactUCO();
                CUSCustomerUCO customerData = new CUSCustomerUCO();
                QueryCon.listIndustryID = new List<string>();

                QueryCon.listIndustryID.Add(id);
                CUSCustomerDataSet cusCustomerDs = customerData.GetCustDataSetByIndustryID(QueryCon, 0, 30, string.Empty, Ede.Uof.EIP.SystemInfo.Current.UserGUID, "ALL");
                DataTable dt = new DataTable();
                dt.Columns.Add("CUSTOMER_ID");
                dt.Columns.Add("CUSTOMER_NAME");
                dt.Columns.Add("CONTACT_ID");
                dt.Columns.Add("CONTACT_NAME");
                dt.Columns.Add("HAVE_CHILD");
                dt.Columns.Add("TYPE");
                foreach (CUSCustomerDataSet.TB_EB_CUS_CUSTOMERRow row in cusCustomerDs.TB_EB_CUS_CUSTOMER.Rows)
                {
                    DataRow pRow = dt.NewRow();
                    pRow["CUSTOMER_ID"] = row.CUSTOMER_ID;
                    pRow["CUSTOMER_NAME"] = row.CUSTOMER_NAME;
                    pRow["TYPE"] = "ClassContact";
                    dt.Rows.Add(pRow);
                    List<string> listc = new List<string>();
                    listc.Add(row.CUSTOMER_ID);
                    CUSContactDataSet contactDataSet = contactUco.GetContactDataSetByCustID(listc);
                    foreach (CUSContactDataSet.TB_EB_CUS_CONTACTRow contactRow in contactDataSet.TB_EB_CUS_CONTACT.Rows)
                    {
                        DataRow cRow = dt.NewRow();
                        cRow["CUSTOMER_ID"] = row.CUSTOMER_ID;
                        cRow["CUSTOMER_NAME"] = row.CUSTOMER_NAME;
                        cRow["CONTACT_ID"] = contactRow.CONTACT_ID;
                        cRow["CONTACT_NAME"] = contactRow.CONTACT_NAME;
                        cRow["TYPE"] = "ClassContact";
                        cRow["HAVE_CHILD"] = "Y";

                        dt.Rows.Add(cRow);
                    }
                }
                var results = from u in dt.AsEnumerable()
                              select new
                              {
                                  CoustomerID = Convert.ToString(u["CUSTOMER_ID"]),
                                  CoustomerName = Convert.ToString(u["CUSTOMER_NAME"]),
                                  ContactID = Convert.ToString(u["CONTACT_ID"]),
                                  ContactName = Convert.ToString(u["CONTACT_NAME"]),
                                  HaveChild = Convert.ToString(u["HAVE_CHILD"]),
                                  Type = Convert.ToString(u["TYPE"])
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "GetArea")
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                QuoToConCondition QueryCon = new QuoToConCondition();
                CUSContactUCO contactUco = new CUSContactUCO();
                CUSCustomerUCO customerData = new CUSCustomerUCO();
                QueryCon.listAreaID = new List<string>();

                DataTable areaDT = new DataTable();
                CUSAreaStructureUCO areaStructureUCO = new CUSAreaStructureUCO();
                areaDT = areaStructureUCO.GetStructureDataTable(id);
                QueryCon.listAreaID.Add(id);

                for (int i = 0; i < areaDT.Rows.Count; i++)
                {
                    QueryCon.listAreaID.Add(areaDT.Rows[i]["AREA_CHILD"].ToString());
                }

                CUSCustomerDataSet cusCustomerDs = customerData.GetCustDataSetByListAreaID(QueryCon, 0, 30, string.Empty, Ede.Uof.EIP.SystemInfo.Current.UserGUID, "ALL");
                DataTable dt = new DataTable();
                dt.Columns.Add("CUSTOMER_ID");
                dt.Columns.Add("CUSTOMER_NAME");
                dt.Columns.Add("CONTACT_ID");
                dt.Columns.Add("CONTACT_NAME");
                dt.Columns.Add("HAVE_CHILD");
                dt.Columns.Add("TYPE");
                foreach (CUSCustomerDataSet.TB_EB_CUS_CUSTOMERRow row in cusCustomerDs.TB_EB_CUS_CUSTOMER.Rows)
                {
                    DataRow pRow = dt.NewRow();
                    pRow["CUSTOMER_ID"] = row.CUSTOMER_ID;
                    pRow["CUSTOMER_NAME"] = row.CUSTOMER_NAME;
                    pRow["TYPE"] = "ClassContact";
                    dt.Rows.Add(pRow);
                    List<string> listc = new List<string>();
                    listc.Add(row.CUSTOMER_ID);
                    CUSContactDataSet contactDataSet = contactUco.GetContactDataSetByCustID(listc);
                    foreach (CUSContactDataSet.TB_EB_CUS_CONTACTRow contactRow in contactDataSet.TB_EB_CUS_CONTACT.Rows)
                    {
                        DataRow cRow = dt.NewRow();
                        cRow["CUSTOMER_ID"] = row.CUSTOMER_ID;
                        cRow["CUSTOMER_NAME"] = row.CUSTOMER_NAME;
                        cRow["CONTACT_ID"] = contactRow.CONTACT_ID;
                        cRow["CONTACT_NAME"] = contactRow.CONTACT_NAME;
                        cRow["TYPE"] = "ClassContact";
                        cRow["HAVE_CHILD"] = "Y";

                        dt.Rows.Add(cRow);
                    }

                }
                var results = from u in dt.AsEnumerable()
                              select new
                              {
                                  CoustomerID = Convert.ToString(u["CUSTOMER_ID"]),
                                  CoustomerName = Convert.ToString(u["CUSTOMER_NAME"]),
                                  ContactID = Convert.ToString(u["CONTACT_ID"]),
                                  ContactName = Convert.ToString(u["CONTACT_NAME"]),
                                  HaveChild = Convert.ToString(u["HAVE_CHILD"]),
                                  Type = Convert.ToString(u["TYPE"])
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "GetExpandToContact")
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                List<string> listc = new List<string>();
                listc.Add(id);

                CUSContactUCO contactUco = new CUSContactUCO();
                CUSContactDataSet contactDataSet = contactUco.GetContactDataSetByCustID(listc);
                DataTable dt = new DataTable();
                dt.Columns.Add("CUSTOMER_ID");
                dt.Columns.Add("CUSTOMER_NAME");
                dt.Columns.Add("CONTACT_ID");
                dt.Columns.Add("CONTACT_NAME");
                dt.Columns.Add("HAVE_CHILD");
                dt.Columns.Add("TYPE");
                foreach (CUSContactDataSet.TB_EB_CUS_CONTACTRow row in contactDataSet.TB_EB_CUS_CONTACT.Rows)
                {
                    DataRow cRow = dt.NewRow();
                    cRow["CUSTOMER_ID"] = row.CUSTOMER_ID;
                    cRow["CUSTOMER_NAME"] = row.CUSTOMER_NAME;
                    cRow["CONTACT_ID"] = row.CONTACT_ID;
                    cRow["CONTACT_NAME"] = row.CONTACT_NAME;
                    cRow["TYPE"] = "Contact";
                    cRow["HAVE_CHILD"] = "N";

                    dt.Rows.Add(cRow);
                }
                var results = from u in dt.AsEnumerable()
                              select new
                              {
                                  CoustomerID = Convert.ToString(u["CUSTOMER_ID"]),
                                  CoustomerName = Convert.ToString(u["CUSTOMER_NAME"]),
                                  ContactID = Convert.ToString(u["CONTACT_ID"]),
                                  ContactName = Convert.ToString(u["CONTACT_NAME"]),
                                  HaveChild = Convert.ToString(u["HAVE_CHILD"]),
                                  Type = Convert.ToString(u["TYPE"])
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }
            context.Response.Write("[]");
        }
    }

    private string JsonToXml(string json)
    {
        var doc = JsonConvert.DeserializeXNode(json);
        foreach (var detail in doc.Descendants("Element"))
        {
            var ele = detail.Element("image");
            if (ele != null)
            {
                ele.Remove();
            }
            ele = detail.Element("text");
            if (ele != null)
            {
                ele.Remove();
            }
        }

        return doc.ToString();
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

    private void BuildDepartmentTreeByGroup(RadTreeNodeCollection nodes, string ParentNodeId)
    {
        GroupUCO deptData = new GroupUCO(GroupType.Department);
        DepartmentDataSet departmentDs = deptData.QueryDepartmentByGroupID(ParentNodeId);

        for (int i = 0; i < departmentDs.Department.Rows.Count; i++)
        {
            var newNode = new RadTreeNode();
            newNode.ImageUrl = "~/Common/Images/Icon/icon_m01.png";
            newNode.Text = departmentDs.Department.Rows[i]["GROUP_NAME"].ToString();
            newNode.Value = departmentDs.Department.Rows[i]["GROUP_ID"].ToString();
            newNode.Attributes.Add("DataKey", GroupType.Department.ToString());
            nodes.Add(newNode);
            BuildDepartmentTreeByGroup(nodes[nodes.Count - 1].Nodes, departmentDs.Department.Rows[i]["GROUP_ID"].ToString());
        }
    }
}