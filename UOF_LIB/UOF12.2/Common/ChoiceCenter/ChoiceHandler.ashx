<%@ WebHandler Language="C#" Class="ChoiceHandler" %>

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Xml.Linq;
using Ede.Uof.EIP.Organization;
using Ede.Uof.EIP.Organization.Util;
using Newtonsoft.Json;
using Telerik.Web.UI;
using Ede.Uof.EIP.Customer.PO;
using Ede.Uof.EIP.Customer.UCO;
using Ede.Uof.EIP.Duty.Report;
using Ede.Uof.Utility.Configuration;
using System.Text;

public class ChoiceHandler : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        var action = context.Request.Form["action"];

        if (action == "GetDepartmentUser")
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                EmployeeUCO uco = new EmployeeUCO();
                var users = uco.SimpleQueryByGroup(id, true);

                var results = from u in users.AsEnumerable()
                              select new
                              {

                                  UserGuid = (string)u["USER_GUID"],
                                  Name = (string)u["NAME"] + "(" + u["ACCOUNT"] + ")"
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "GetDepartments")
        {
            var parentId = context.Request.Form["parent"];

            GroupUCO uco = new GroupUCO(GroupType.Department);
            var departments = uco.QueryDepartment(parentId);

            var results = from u in departments.Tables[0].AsEnumerable()
                          select new
                          {

                              GroupId = (string)u["GROUP_ID"],
                              Name = (string)u["GROUP_NAME"],
                              ChildrenCount = ((int)u["RGT"] - (int)u["LFT"] - 1) / 2,
                              Level = u["GROUP_LEVEL"]
                          };
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));

        }
        else if (action == "GetGroupUser")
        {
            var id = context.Request.Form["id"];
            if (!string.IsNullOrEmpty(id))
            {
                MemberUCO uco = new MemberUCO();
                var users = uco.SimpleQueryByGroup(id, true);

                var results = from u in users.AsEnumerable()
                              select new
                              {

                                  UserGuid = (string)u["USER_GUID"],
                                  Name = (string)u["NAME"] + "(" + u["ACCOUNT"] + ")"
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "SearchUser")
        {
            var keyword = context.Request.Form["keyword"];
            var type = context.Request.Form["userType"];
            var userGuid = context.Request.Form["userGuid"];
            if (!string.IsNullOrEmpty(keyword))
            {
                var users = new DataTable();
                if (type == "Employee")
                {
                    EmployeeUCO uco = new EmployeeUCO();
                    users = uco.SimpleQueryByKeyword(keyword, true);
                }
                if (type == "Member")
                {
                    MemberUCO uco = new MemberUCO();
                    Setting setting = new Setting();
                    bool enableMembClassAuth = false;
                    if (!bool.TryParse(setting["EnableMembGroupAuth"], out enableMembClassAuth))
                    {
                        enableMembClassAuth = false;
                    }
                    EBUser ebUser = new UserUCO().GetEBUser(userGuid);
                    if (!enableMembClassAuth || ebUser.IsInRole("SystemAdmin"))
                    {
                        users = uco.SimpleQueryByKeyword(keyword, true);
                    }
                    else
                    {
                        List<string> groupIDlist = new List<string>();
                        GroupUCO groupUCO = new GroupUCO(userGuid);
                        MemberGroupAuthorityUCO membGroupAuthUCO = new MemberGroupAuthorityUCO();
                        groupIDlist = membGroupAuthUCO.GetMembGroupViewAuthority(userGuid);

                        if (groupIDlist.Count > 0)
                            users = uco.SimpleQueryByKeywordByGroup(keyword, groupIDlist, true);
                    }
                }

                var results = from u in users.AsEnumerable()
                              select new
                              {
                                  UserGuid = (string)u["USER_GUID"],
                                  Name = (string)u["NAME"] + "(" + u["ACCOUNT"] + ")"
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");

        }
        else if (action == "SearchUserByID")
        {
            var keyword = context.Request.Form["keyword"];
            var type = context.Request.Form["userType"];
            var id = context.Request.Form["id"];
            var userGuid = context.Request.Form["userGuid"];
            if (!string.IsNullOrEmpty(keyword))
            {
                var users = new DataTable();
                if (type == "Employee")
                {
                    EmployeeUCO uco = new EmployeeUCO();
                    users = uco.SimpleQueryByKeywordByGroup(keyword, id, true);
                }
                if (type == "Member")
                {
                    MemberUCO uco = new MemberUCO();
                    List<string> groupIDlist = new List<string>();
                    Setting setting = new Setting();

                    bool enableMembClassAuth = false;
                    if (!bool.TryParse(setting["EnableMembGroupAuth"], out enableMembClassAuth))
                    {
                        enableMembClassAuth = false;
                    }
                    EBUser ebUser = new UserUCO().GetEBUser(userGuid);
                    if (!enableMembClassAuth || ebUser.IsInRole("SystemAdmin"))
                    {
                        groupIDlist.Add(id);

                        if (groupIDlist.Count > 0)
                            users = uco.SimpleQueryByKeywordByGroup(keyword, groupIDlist, true);
                    }
                    else
                    {
                        GroupUCO groupUCO = new GroupUCO(userGuid);
                        MemberGroupAuthorityUCO membGroupAuthUCO = new MemberGroupAuthorityUCO();
                        groupIDlist = membGroupAuthUCO.GetMembGroupViewAuthority(userGuid);

                        if (groupIDlist.Count > 0)
                            users = uco.SimpleQueryByKeywordByGroup(keyword, groupIDlist, true);
                    }
                }

                var results = from u in users.AsEnumerable()
                              select new
                              {
                                  UserGuid = (string)u["USER_GUID"],
                                  Name = (string)u["NAME"] + "(" + u["ACCOUNT"] + ")"
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "SearchLimitUser")
        {
            var keyword = context.Request.Form["keyword"];
            var choiceType = context.Request.Form["choiceType"];
            var userGuid = context.Request.Form["userGuid"];
            var limitData = context.Request.Form["limitData"];

            if (!string.IsNullOrEmpty(keyword))
            {
                UserSet us = new UserSet();
                us.SetXML(JsonToXml(limitData));
                UserSetDataSet users = new UserSetDataSet();
                //將UserSet裡的類別拆開，為了要分別查詢。
                StringBuilder apartXML = new StringBuilder("<UserSet>");

                if (choiceType == "1")//部門
                {
                    UserSetGroup[] groups = us.Items.GetGroupArray();
                    foreach (UserSetGroup group in groups)
                    {
                        apartXML.AppendFormat(
                            "<Element type='group' isDepth='{0}'><groupId>{1}</groupId></Element>",
                            group.IS_DEPTH.ToString(), group.GROUP_ID);
                    }
                    apartXML.AppendLine("</UserSet>");
                    UserSet groupUS = new UserSet();
                    groupUS.SetXML(apartXML.ToString());
                    users = groupUS.GetUsersDataSet();
                }
                else if (choiceType == "4")//職級
                {
                    UserSetTitle[] titles = us.Items.GetTitleArray();

                    foreach (UserSetTitle title in titles)
                    {
                        apartXML.AppendFormat(
                            "<Element type='jobTitle'> <jobTitleId>{0}</jobTitleId></Element>", title.TITLE_ID);
                    }
                    apartXML.AppendLine("</UserSet>");
                    UserSet titleUS = new UserSet();
                    titleUS.SetXML(apartXML.ToString());
                    users = titleUS.GetUsersDataSet();
                }
                else if (choiceType == "5")//職務
                {
                    UserSetFunction[] functions = us.Items.GetFunctionArray();
                    foreach (UserSetFunction function in functions)
                    {
                        apartXML.AppendFormat(
                            "<Element type='jobFunction'><jobFunctionId>{0}</jobFunctionId></Element>", function.FUNC_ID);
                    }
                    apartXML.AppendLine("</UserSet>");
                    UserSet funcUS = new UserSet();
                    funcUS.SetXML(apartXML.ToString());
                    users = funcUS.GetUsersDataSet();
                }
                else if (choiceType == "2")//部門+職級
                {
                    UserSetTitleOfGroup[] titlesOfGroups = us.Items.GetTitleOfGroupArray();

                    foreach (UserSetTitleOfGroup titleOfGroup in titlesOfGroups)
                    {
                        apartXML.AppendFormat(
                            @"<Element type='jobTitleOfGroup' isDepth='{0}'>
                            <jobTitleId>{1}</jobTitleId><groupId>{2}</groupId></Element>",
                                titleOfGroup.IS_DEPTH.ToString(), titleOfGroup.TITLE_ID, titleOfGroup.GROUP_ID);
                    }
                    apartXML.AppendLine("</UserSet>");
                    UserSet jobDeptUS = new UserSet();
                    jobDeptUS.SetXML(apartXML.ToString());
                    users = jobDeptUS.GetUsersDataSet();
                }
                else if (choiceType == "3")//部門+職務
                {
                    UserSetFunctionOfGroup[] functionsOfGroups = us.Items.GetFunctionOfGroupArray();
                    foreach (UserSetFunctionOfGroup functionOfGroup in functionsOfGroups)
                    {
                        apartXML.AppendFormat(
                            @"<Element type='jobFunctionOfGroup' isDepth='{0}'>
                            <jobFunctionId>{1}</jobFunctionId><groupId>{2}</groupId></Element>",
                                functionOfGroup.IS_DEPTH.ToString(), functionOfGroup.FUNC_ID, functionOfGroup.GROUP_ID);
                    }
                    apartXML.AppendLine("</UserSet>");
                    UserSet funcDeptUS = new UserSet();
                    funcDeptUS.SetXML(apartXML.ToString());
                    users = funcDeptUS.GetUsersDataSet();
                }
                else if (choiceType == "12")
                {
                    EBUser ebUser = new UserUCO().GetEBUser(userGuid);
                    if (ebUser != null)
                    {
                        apartXML.AppendFormat(
                            "<Element type='group' isDepth='{0}'><groupId>{1}</groupId></Element>",
                            true.ToString(), ebUser.GroupID);
                    }
                    apartXML.AppendLine("</UserSet>");
                    UserSet userDeptUS = new UserSet();
                    userDeptUS.SetXML(apartXML.ToString());
                    users = userDeptUS.GetUsersDataSet();
                }

                var results = from u in users.USER.AsEnumerable()
                              where u.NAME.ToLower().Contains(keyword) || u.ACCOUNT.ToLower().Contains(keyword)
                              select new
                              {
                                  UserGuid = u.USER_GUID,
                                  Name = u.NAME + "(" + u.ACCOUNT + ")"
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "SearchDepartment")
        {
            var keyword = context.Request.Form["keyword"];
            if (context.Application["RadDepartmentTree"] != null && !string.IsNullOrEmpty(keyword))
            {
                var doc = XDocument.Parse((string)context.Application["RadDepartmentTree"]);

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
        else if (action == "SearchDepartmentByGroupID")
        {
            var id = context.Request.Form["id"];
            var keyword = context.Request.Form["keyword"];
            RadTreeView tempTree = new RadTreeView();
            RadTreeView tree = new RadTreeView();
            tree.Nodes.Clear();
            GroupUCO deptData = new GroupUCO(GroupType.Department);
            DepartmentDataSet deptDs = deptData.QueryDepartment();
            if (string.IsNullOrEmpty(id))
            {
                for (int i = 0; i < deptDs.Tables[0].Rows.Count; i++)
                {
                    var NODE = new RadTreeNode();
                    NODE.ImageUrl = "~/Common/Images/Icon/icon_m01.png";
                    NODE.Text = deptDs.Tables[0].Rows[i]["GROUP_NAME"].ToString();
                    NODE.Value = deptDs.Tables[0].Rows[i]["GROUP_ID"].ToString();
                    NODE.Attributes.Add("DataKey", GroupType.Department.ToString());

                    var tempNODE = new RadTreeNode();
                    tempNODE.ImageUrl = "~/Common/Images/Icon/icon_m01.png";
                    tempNODE.Text = deptDs.Tables[0].Rows[i]["GROUP_NAME"].ToString();
                    tempNODE.Value = deptDs.Tables[0].Rows[i]["GROUP_ID"].ToString();
                    tempNODE.Attributes.Add("DataKey", GroupType.Department.ToString());

                    if (i == 0)
                    {
                        tree.Nodes.Add(NODE);
                        tempTree.Nodes.Add(tempNODE);
                    }
                    else
                    {
                        RadTreeNode parentNode = tree.FindNodeByValue(Convert.ToString(deptDs.Tables[0].Rows[i]["PARENT_GROUP_ID"]));
                        RadTreeNode tempParentNode = tempTree.FindNodeByValue(Convert.ToString(deptDs.Tables[0].Rows[i]["PARENT_GROUP_ID"]));
                        if (parentNode != null)
                            parentNode.Nodes.Add(NODE);

                        if (tempParentNode != null)
                            tempParentNode.Nodes.Add(tempNODE);
                    }
                }
            }
            else
            {
                DepartmentDataSet departmentDs = new DepartmentDataSet();
                string groupName = deptData.QueryDepartmentName(id);
                var NODE = new RadTreeNode();
                NODE.ImageUrl = "~/Common/Images/Icon/icon_m01.png";
                NODE.Text = groupName;
                NODE.Value = id;
                NODE.Attributes.Add("DataKey", GroupType.Department.ToString());

                var tempNODE = new RadTreeNode();
                tempNODE.ImageUrl = "~/Common/Images/Icon/icon_m01.png";
                tempNODE.Text = groupName;
                tempNODE.Value = id;
                tempNODE.Attributes.Add("DataKey", GroupType.Department.ToString());

                tree.Nodes.Add(NODE);
                tempTree.Nodes.Add(tempNODE);

                BuildDepartmentTreeByGroup(tree.Nodes[0].Nodes, id);
                BuildDepartmentTreeByGroup(tempTree.Nodes[0].Nodes, id);
            }
            if (tree.GetXml() != null && !string.IsNullOrEmpty(keyword))
            {
                var doc = XDocument.Parse(tree.GetXml());

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
                    if (showEmployee && showMember)
                    {
                        dr = (DataRow[])dt.Select("USER_TYPE='Employee' OR USER_TYPE='Member'");
                    }
                    else if (showEmployee && !showMember)
                    {
                        dr = (DataRow[])dt.Select("USER_TYPE='" + "Employee" + "'");
                    }
                    else if (!showEmployee && showMember)
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
        else if (action == "SearchUserByDeptLimit")//for 限定選人-部門管理員組織樹
        {
            var keyword = context.Request.Form["keyword"];
            var userGuid = context.Request.Form["userGuid"];
            if (!string.IsNullOrEmpty(keyword))
            {
                ReportUCO m_reportUCO = new ReportUCO();
                List<string> groupList = new List<string>();
                if (m_reportUCO.CheckUserRoleAuth("DutyManager", userGuid))
                {
                    DepartmentDataSet departmentDS = new DepartmentDataSet();
                    departmentDS = m_reportUCO.GetSubDepartment("Company");
                    groupList = departmentDS.Department.AsEnumerable().Select(dr => dr.Field<string>("GROUP_ID")).ToList();
                }
                else if (m_reportUCO.CheckUserRoleAuth("HierarchicalManager", userGuid))//判斷是否為部門管理員
                {
                    List<string> tempList = new List<string>();
                    tempList = m_reportUCO.GetDeptManagerGroup(userGuid);
                    tempList.ForEach(
                        groupID =>
                        {
                            DepartmentDataSet departmentDS = new DepartmentDataSet();
                            departmentDS = m_reportUCO.GetSubDepartment(groupID);
                            groupList.AddRange(departmentDS.Department.AsEnumerable().Select(dr => dr.Field<string>("GROUP_ID")));
                        }
                        );
                }

                EmployeeUCO uco = new EmployeeUCO();
                var users = new DataTable();
                if (groupList.Count > 0)
                    users = uco.SimpleQueryByDeptLimitKeyword(groupList, keyword, true);

                var results = from u in users.AsEnumerable()
                              select new
                              {
                                  UserGuid = (string)u["USER_GUID"],
                                  Name = (string)u["NAME"] + "(" + u["ACCOUNT"] + ")"
                              };

                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                return;
            }

            context.Response.Write("[]");
        }
        else if (action == "SearchDepartmentByLimit")
        {
            var keyword = context.Request.Form["keyword"];
            var userGuid = context.Request.Form["userGuid"];
            if (!string.IsNullOrEmpty(keyword))
            {
                RadTreeView treeDepartment = new RadTreeView();
                treeDepartment.Nodes.Clear();
                ReportUCO m_reportUCO = new ReportUCO();

                if (m_reportUCO.CheckUserRoleAuth("DutyManager", userGuid))
                {
                    CreateGroupTree("Company", treeDepartment);
                }
                else if (m_reportUCO.CheckUserRoleAuth("HierarchicalManager", userGuid))//判斷是否為部門管理員
                {
                    List<string> groupList = m_reportUCO.GetDeptManagerGroup(userGuid);
                    if (groupList.Count > 0)
                    {
                        for (int i = 0; i < groupList.Count; i++)
                        {
                            CreateGroupTree(groupList[i].ToString(), treeDepartment);
                        }
                    }
                }

                if (treeDepartment.GetXml() != null && !string.IsNullOrEmpty(keyword))
                {
                    var doc = XDocument.Parse(treeDepartment.GetXml());

                    var results = from item in doc.Descendants("Node")
                                  where item.Attribute("Text").Value.ToLower().Contains(keyword.ToLower())
                                  select new
                                  {
                                      item.Attribute("Value").Value
                                  };
                    context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(results));
                    return;
                }
                else
                {
                    context.Response.Write("[]");
                }
            }
            context.Response.Write("[]");
        }
    }

    private void CreateGroupTree(string groupID, RadTreeView treeDepartment)
    {
        ReportUCO m_reportUCO = new ReportUCO();
        DepartmentDataSet departmentDS = new DepartmentDataSet();
        departmentDS = m_reportUCO.GetSubDepartment(groupID);
        RadTreeView groupTempTree = new RadTreeView();//用來暫時此部門底下之所有子部門
        foreach (DepartmentDataSet.DepartmentRow departmentDR in departmentDS.Department.Rows)
        {
            RadTreeNode node = new RadTreeNode();
            node.Text = departmentDR.GROUP_NAME;
            node.Value = departmentDR.GROUP_ID;
            node.ImageUrl = "~/Common/Images/Icon/icon_m01.png";
            if (departmentDR.GROUP_ID != groupID)
            {
                RadTreeNode parNode = groupTempTree.FindNodeByValue(departmentDR.PARENT_GROUP_ID);//尋找父節點
                if (parNode != null)
                {
                    parNode.Nodes.Add(node);
                }
            }
            else
            {
                groupTempTree.Nodes.Add(node);
            }
        }
        if (groupTempTree.Nodes.Count > 0)
        {
            treeDepartment.Nodes.Add(groupTempTree.Nodes[0]);//回傳根節點
        }

        groupTempTree.Nodes.Clear();
        groupTempTree.Dispose();
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