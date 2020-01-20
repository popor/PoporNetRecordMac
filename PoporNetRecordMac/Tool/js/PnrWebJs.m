//
//  PnrWebJs.m
//  PoporNetRecord
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import "PnrWebJs.h"

#import "PnrEntity.h"
#import "PnrPortEntity.h"
#import "PnrConfig.h"

@implementation PnrWebJs

// MARK: 固定的查看json js代码
+ (NSString *)jsJsonStatic {
    static NSString * js;
    if (!js) {
        js =
        [NSString stringWithFormat: @"\n\
         ;function jsonStatic(formKey) {\n\
         ;    var form = document.getElementById(formKey);\n\
         ;    form.action='/%@';\n\
         ;    form.submit();\n\
         ;}\n\
         ", PnrPost_commonJsonXml];
    }
    return js;
}

+ (NSString *)jsTestEditStatic {
    static NSString * js;
    if (!js) {
        // https://blog.csdn.net/harryhare/article/details/80778066
        // function send(type) {
        //     url = "http://127.0.0.1:8080/";
        //     xhr = new XMLHttpRequest();
        //     xhr.open("post", url, true);
        //     var data;
        //     if (type === "formdata") {
        //         data = new FormData();
        //         data.append("key", "value");
        //     } else if (type === "json") {
        //         xhr.setRequestHeader("Content-Type", "application/json");
        //         data = JSON.stringify({"key": "value"});
        //     } else if (type === "text") {
        //         data = "key=value";
        //     } else if (type === "www") {
        //         // 这个header 其实是 传统post 表单的格式
        //         xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        //         data = "key=value";
        //     }
        //     xhr.send(data);
        // }
    
        js =
        [NSString stringWithFormat:
         @"\n\n\
         ;function jsTestEditStatic(formKey, index, type) {\n\
         ;    var formContent = document.forms[formKey].elements['%@'].value;\n\
         ;    var formSaveBt  = document.forms[formKey].elements['%@'];\n\
         ;    formSaveBt.innerText = '保存中';\n\
         ;    var xmlhttp = new XMLHttpRequest();\n\
         ;    xmlhttp.open('POST','/%@',true);\n\
         ;\n\
         ;    xmlhttp.onreadystatechange = function() {\n\
         ;        if (xmlhttp.readyState == 4) {\n\
         ;            var text = xmlhttp.responseText;\n\
         ;            if (text == '%@') {\n\
         ;                formSaveBt.innerText = '保存 成功';\n\
         ;            } else {\n\
         ;                formSaveBt.innerText = '保存 失败';\n\
         ;            }\n\
         ;        }\n\
         ;    }\n\
         ;\n\
         ;    xmlhttp.setRequestHeader('Content-Type', 'application/json');\n\
         ;    var data = JSON.stringify({\"%@\": type, \"%@\": index, \"%@\": formContent }); \n\
         ;    xmlhttp.send(data);\n\
         ;}\n\n"
         , PnrKey_Conent
         , PnrKey_TestSave
         , PnrPost_TestEdit
         , PnrKey_success
         , PnrKey_TestType, PnrKey_TestIndex, PnrKey_Conent
         ];
    }
    return js;
}

+ (NSString *)jsTestSearchStatic {
    static NSString * js;
    if (!js) {
        js =
        [NSString stringWithFormat:
         @"\n\n\
         ;function jsTestSearchStatic(formKey) {\n\
         ;    var formSearch = document.forms[formKey].elements['%@'].value;\n\
         ;    var src = '/%@' + '?' + '%@=' + formSearch ;\n\
         ;    window.location.href = src;\n\
         }\n\n"
         , PnrKey_Conent
         , PnrGet_TestRoot, PnrKey_TestSearch
         ];
    }
    return js;
}

+ (NSString *)jsTestDeleteStatic {
    static NSString * js;
    if (!js) {
        js =
        [NSString stringWithFormat:
         @"\n\n\
         ;function jsTestDeleteStatic(formKey, index) {\n\
         ;    var form         = document.forms[formKey];\n\
         ;    var formDeleteBt = document.forms[formKey].elements['%@'];\n\
         ;    formDeleteBt.innerText = '删除中';\n\
         ;    var xmlhttp = new XMLHttpRequest();\n\
         ;    xmlhttp.open('POST','/%@',true);\n\
         ;\n\
         ;    xmlhttp.onreadystatechange = function() {\n\
         ;        if (xmlhttp.readyState == 4) {\n\
         ;            var text = xmlhttp.responseText;\n\
         ;            if (text == '%@') {\n\
         ;                formDeleteBt.innerText = '删除 成功';\n\
         ;            } else {\n\
         ;                formDeleteBt.innerText = '删除 失败';\n\
         ;            }\n\
         ;        }\n\
         ;    }\n\
         ;\n\
         ;    xmlhttp.setRequestHeader('Content-Type', 'application/json');\n\
         ;    var data = JSON.stringify({\"%@\": index}); \n\
         ;    xmlhttp.send(data);\n\
         ;}\n\n"
         , PnrKey_TestDelete
         , PnrPost_TestDelete
         , PnrKey_success
         , PnrKey_TestIndex
         ];
    }
    return js;
}

// MARK: 动态的查看json js代码, 生成新的form,并且submit.
+ (NSString *)jsJsonDynamic {
    // http://www.cnblogs.com/haoqipeng/p/create-form-with-js.html
    static NSString * js;
    if (!js) {
        js =
        [NSString stringWithFormat: @"\n\
         ;function jsonDynamic(formKey, contentkey) {\n\
         ;    var valueFrom = document.forms[formKey].elements[contentkey].value;\n\
         ;    \n\
         ;    var dlform = document.createElement('form');\n\
         ;    dlform.style = 'display:none;';\n\
         ;    dlform.method = 'POST';\n\
         ;    dlform.action = '/%@';\n\
         ;    dlform.target = '_blank';\n\
         ;    \n\
         ;    var hdnFilePath = document.createElement('input');\n\
         ;    hdnFilePath.type = 'hidden';\n\
         ;    hdnFilePath.name = '%@';\n\
         ;    hdnFilePath.value = valueFrom;\n\
         ;    dlform.appendChild(hdnFilePath);\n\
         ;    \n\
         ;    document.body.appendChild(dlform);\n\
         ;    dlform.submit();\n\
         ;    document.body.removeChild(dlform);\n\
         ;}\n\
         ", PnrPost_commonJsonXml, PnrKey_Conent];
    }
    return js;
}

// MARK: YcUrl
// 修改AES密码
+ (NSString *)jsYcUrlPsdEditStatic {
    static NSString * js;
    if (!js) {
        // https://blog.csdn.net/harryhare/article/details/80778066
        // function send(type) {
        //     url = "http://127.0.0.1:8080/";
        //     xhr = new XMLHttpRequest();
        //     xhr.open("post", url, true);
        //     var data;
        //     if (type === "formdata") {
        //         data = new FormData();
        //         data.append("key", "value");
        //     } else if (type === "json") {
        //         xhr.setRequestHeader("Content-Type", "application/json");
        //         data = JSON.stringify({"key": "value"});
        //     } else if (type === "text") {
        //         data = "key=value";
        //     } else if (type === "www") {
        //         // 这个header 其实是 传统post 表单的格式
        //         xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        //         data = "key=value";
        //     }
        //     xhr.send(data);
        // }
    
        js =
        [NSString stringWithFormat:
         @"\n\n\
         ;function jsYcUrlPsdEditStatic(formKey) {\n\
         ;    var formContent = document.forms[formKey].elements['%@'].value;\n\
         ;    var formSaveBt  = document.forms[formKey].elements['%@'];\n\
         ;    formSaveBt.innerText = '保存中';\n\
         ;    var xmlhttp = new XMLHttpRequest();\n\
         ;    xmlhttp.open('POST','/%@',true);\n\
         ;\n\
         ;    xmlhttp.onreadystatechange = function() {\n\
         ;        if (xmlhttp.readyState == 4) {\n\
         ;            var text = xmlhttp.responseText;\n\
         ;            if (text == '%@') {\n\
         ;                formSaveBt.innerText = '保存 成功';\n\
         ;            } else {\n\
         ;                formSaveBt.innerText = '保存 失败';\n\
         ;            }\n\
         ;        }\n\
         ;    }\n\
         ;\n\
         ;    xmlhttp.setRequestHeader('Content-Type', 'application/json');\n\
         ;    var data = JSON.stringify({\"%@\": formContent}); \n\
         ;    xmlhttp.send(data);\n\
         ;}\n\n"
         , PnrKey_Conent
         , PnrKey_ycUrlBTPsd
         , PnrPost_YcUrlPsdEdit
         , PnrKey_success
         , PnrKey_ycUrlPsd
         ];
    }
    return js;
    
}

+ (NSString *)jsYcUrlAnalysisStatic {
    static NSString * js;
    if (!js) {
        js =
        [NSString stringWithFormat:
         @"\n\n\
         ;function jsYcUrlAnalysisStatic(formKey, formShowKey) {\n\
         ;    var formContent = document.forms[formKey].elements['%@'].value;\n\
         ;    var formSaveBt  = document.forms[formKey].elements['%@'];\n\
         ;    var formShowTa  = document.forms[formShowKey].elements['%@'];\n\
         ;    formSaveBt.innerText = '分析中';\n\
         ;    var xmlhttp = new XMLHttpRequest();\n\
         ;    xmlhttp.open('POST','/%@',true);\n\
         ;\n\
         ;    xmlhttp.onreadystatechange = function() {\n\
         ;        if (xmlhttp.readyState == 4) {\n\
         ;            //var jsonObj = xmlhttp.responseText.parseJSON();\n\
         ;            var jsonObj = JSON.parse(xmlhttp.responseText); //由JSON字符串转换为JSON对象\n\
         ;            var status = jsonObj.%@;\n\
         ;            if (status == '%@') {\n\
         ;                \n\
         ;                var type = jsonObj.%@; \n\
         ;                if(type.length > 0) { formSaveBt.innerText = type +' 成功'; } else { formSaveBt.innerText = '分析 成功'; }\n\
         ;                formShowTa.textContent = jsonObj.%@;\n\
         ;            } else {\n\
         ;                formSaveBt.innerText = '分析 失败';\n\
         ;                formShowTa.innerText = ''; \n\
         ;            }\n\
         ;            //刷新 textarea 高度\n\
         ;            %@  \n\
         ;        }\n\
         ;    }\n\
         ;\n\
         ;    xmlhttp.setRequestHeader('Content-Type', 'application/json');\n\
         ;    var data = JSON.stringify({\"%@\": formContent}); \n\
         ;    xmlhttp.send(data);\n\
         ;}\n\n"
         , PnrKey_Conent
         , PnrKey_ycUrlBTUrl
         , PnrKey_Conent
         , PnrPost_YcUrlDecrypt
         , PnrKey_ycUrlStatus
         , PnrKey_success
         , PnrKey_ycUrlType
         , PnrKey_ycUrlValue
         , [PnrWebJs textareaAuhoHeigtEventClass:PnrJsClassTaAutoH]
         , PnrKey_ycUrlUrl
         ];
    }
    return js;
    
}

// MARK: 高度自适应的textarea

/**
 获取所有的ta
 */
+ (NSString *)textareaAuhoHeigtEventClass:(NSString *)className {
    // http://caibaojian.com/textarea-autoheight.html
    return
    [NSString stringWithFormat:@"\n\
     ;var taArray = document.getElementsByClassName('%@');\n\
     ;for (var i = 0; i < taArray.length; i++) {\n\
     ;    makeExpandingArea(taArray[i]);\n\
     ;} \n"
     , className
     ];
}

/**
 给ta增加监听事件,刷新ta高度.
 */
+ (NSString *)textareaAutoHeightFuntion {
    // http://caibaojian.com/textarea-autoheight.html
    return @"\n\n\
    ;function makeExpandingArea(el) {\n\
    ;    var setStyle = function (el) {\n\
    ;        el.style.height = 'auto';\n\
    ;        el.style.height = el.scrollHeight + 'px';\n\
    ;    };\n\
    ;    var delayedResize = function (el) { window.setTimeout(function () { setStyle(el);}, 0);};\n\
    ;    if (el.addEventListener) {\n\
    ;        el.addEventListener('input', function () { setStyle(el) }, false);\n\
    ;        setStyle(el);\n\
    ;    } else if (el.attachEvent) {\n\
    ;        el.attachEvent('onpropertychange', function () { setStyle(el); });\n\
    ;        setStyle(el);\n\
    ;    }\n\
    ;    if (window.VBArray && window.addEventListener) {\n\
    ;        el.attachEvent('onkeydown', function () { var key = window.event.keyCode; if (key == 8 || key == 46) {delayedResize(el);} });\n\
    ;        el.attachEvent('oncut', function () { delayedResize(el); });\n\
    ;    }\n\
    } \n";
}

// MARK: ajax 刷新增加
+ (NSString *)ajaxResubmit {
    static NSString * js;
    if (!js) {
        js =
        [NSString stringWithFormat:@"\n\
         ;function ajaxResubmit(form) {\n\
         ;    var ta = document.forms['%@'].elements['%@'];\n\
         ;    ta.value = \"请等待\"\n\
         ;    \n\
         ;    var xmlhttp = new XMLHttpRequest();\n\
         ;    xmlhttp.open('POST','/%@',true);\n\
         ;    xmlhttp.onreadystatechange=function() {\n\
         ;        if (xmlhttp.readyState==4 && xmlhttp.status==200){\n\
         ;            ta.value = xmlhttp.responseText; \n\
         ;            makeExpandingArea(ta);\n\
         ;            parent.freshList();\
         ;        }\n\
         ;    }\n\
         ;\n\
         ;    var text = '';\n\
         ;    for (var i = 0; i < form.elements.length; i++) {\n\
         ;        var filed = form.elements[i];\n\
         ;        var type = filed.type;\n\
         switch (filed.type) {\n\
         case 'textarea': {\n\
         text = text + '&' + filed.name + '=' + filed.value;\n\
         break;\n\
         }\n\
         case 'radio': {\n\
         if (filed.checked) {\n\
         text = text + '&' + filed.name + '=' + filed.value;\n\
         }\n\
         break;\n\
         }\n\
         }\n\
         ;    }\n\
         ;    \n\
         ;    xmlhttp.send(text.substr(1)); \n\
         ;}\n", PnrFormFeedback, PnrKey_Conent, PnrPost_recordResubmit];
    }
    return js;
    // https://developer.mozilla.org/zh-CN/docs/Web/API/FormData/Using_FormData_Objects
};

// https://blog.csdn.net/wild46cat/article/details/52718545
+ (NSString *)updateShareUrl {
    static NSString * js;
    if (!js) {
        js =
        [NSString stringWithFormat:
         @"\n\n\
         ;window.onload=function (){\n\
         ;    document.getElementById('%@').innerText = getRoot(); \n\
         ;} \n", PnrKey_IdShare];
    }
    return js;
}

+ (NSString *)getRootUrl {
    return
    [NSString stringWithFormat:
     @"\n\n\
     ;function getRoot() {\n\
     ;    var hostname = location.hostname;\n\
     ;    var pathname = location.pathname;\n\
     ;    var contextPath = pathname.split('/')[1];\n\
     ;    var port = location.port;\n\
     ;    var protocol = location.protocol;\n\
     ;    var deviceName = getQueryVariable('%@')\n\
     ;    deviceName = decodeURIComponent(deviceName); \n\
     ;    var row = getQueryVariable('%@')\n\
     ;    if(deviceName.length > 0){\n\
     ;        return protocol + '//' + hostname + ':' + port + '/' + '%@' + '?' +'%@=' + deviceName + '&%@=' + row;\n\
     ;    } else {\n\
     ;        return protocol + '//' + hostname + ':' + port + '/' + '%@' + '?' +'%@=' + row ;\n\
     ;    }\n\
     ;    //return protocol + '//' + hostname + ':' + port + '/' + contextPath;\n\
     ;}" ,
     PnrKey_DeviceName,
     PnrKey_index,
     PnrGet_recordRoot, PnrKey_DeviceName, PnrKey_index,
     PnrGet_recordRoot, PnrKey_index
     ];;
}

+ (NSString *)copyInnerText {
    return @"\n\n\
    ;function copyInnerText(idName) {\n\
    ;    var text = document.getElementById(idName).innerText;\n\
    ;    var oInput = document.createElement('input');\n\
    ;    oInput.value = text;\n\
    ;    document.body.appendChild(oInput);\n\
    ;    oInput.select();\n\
    ;    document.execCommand(\"Copy\");\n\
    ;    oInput.className = 'oInput';\n\
    ;    oInput.style.display = 'none';\n\
    ;}";
}

+ (NSString *)clearText {
    static NSString * js;
    if (!js) {
        js =
        [NSString stringWithFormat:
         @"\n\n\
         ;function clearAction() {\n\
         ;    var xmlhttp = new XMLHttpRequest();\n\
         ;    xmlhttp.open('POST','/%@',true);\n\
         ;    xmlhttp.onreadystatechange=function() {\n\
         ;        location.reload();\n\
         ;    }\n\
         ;    xmlhttp.send('clear'); \n\
         ;}\n\n", PnrPost_recordClear];
    }
    return js;
}

+ (NSString *)getQuery {
    static NSString * js;
    if (!js) {
        js = @"\n\n\
        ;function getQueryVariable(variable){\n\
        ;    var query = window.location.search.substring(1);\n\
        ;    var vars = query.split(\"&\");\n\
        ;    for (var i=0;i<vars.length;i++) {\n\
        ;        var pair = vars[i].split(\"=\");\n\
        ;        if(pair[0] == variable){\n\
        ;             return pair[1];\n\
        ;        }\n\
        ;    }\n\
        ;    return('');\n\
        ;}\n";
    }
    return js;
}

// 感觉不太需要
+ (NSString *)ajaxObject {
    return
    @"\n\
    ;function ajaxObject() {\n\
    ;    var xmlHttp;\n\
    ;    try {\n\
    ;        // Firefox, Opera 8.0+, Safari\n\
    ;        xmlHttp = new XMLHttpRequest();\n\
    ;        }\n\
    ;    catch (e) {\n\
    ;        // Internet Explorer\n\
    ;        try {\n\
    ;                xmlHttp = new ActiveXObject(\"Msxml2.XMLHTTP\");\n\
    ;            } catch (e) {\n\
    ;            try {\n\
    ;                xmlHttp = new ActiveXObject(\"Microsoft.XMLHTTP\");\n\
    ;            } catch (e) {\n\
    ;                alert(\"您的浏览器不支持AJAX！\");\n\
    ;                return false;\n\
    ;            }\n\
    ;        }\n\
    ;    }\n\
    ;    return xmlHttp;\n\
    ;}\n\
    ";
}

@end
