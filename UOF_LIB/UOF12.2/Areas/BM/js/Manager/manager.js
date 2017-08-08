


function gridColumn_reportDate(input) {

    var date = kendo.parseDate(input, "yyyy/MM/dd");
    return kendo.toString(new Date(date), "d")

}

//全選按鈕
function ToggleChkBox(flag) {
    $('.chkbxq').each(function () {
        $(this).attr('checked', flag);
    });
}

//事件啟動立即註冊gridCaseChange的事件 點擊Grid內的某一個按鍵後，可以直接讓該Row的chkbox打勾
$(document).ready(function () {
    //$('#gridCaseChange').on("click", "td", function (e) {
    //    var selectedTd = $(e.target).closest("td");
    //    var grdChkBox = selectedTd.parents('tr').find("td:first").find('input:checkbox');
    //    grdChkBox.prop('checked', !grdChkBox.prop('checked'));

    //});
})




