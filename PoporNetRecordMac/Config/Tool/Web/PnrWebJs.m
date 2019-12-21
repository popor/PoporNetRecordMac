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
         ;            if (text == 'success') {\n\
         ;                formSaveBt.innerText = '保存 成功';\n\
         ;            } else {\n\
         ;                formSaveBt.innerText = '保存 失败';\n\
         ;            }\n\
         ;        }\n\
         ;    }\n\
         ;\n\
         ;    var text = '%@='+ formContent + '&%@='+ index +'&%@='+ type; \n\
         ;    xmlhttp.send(text);\n\
         ;}\n\n"
         , PnrKey_Conent
         , PnrKey_TestSave
         , PnrPost_TestEdit
         , PnrKey_Conent, PnrKey_TestIndex, PnrKey_TestType
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
         ;function jsTestDeleteStatic(formKey, index, type) {\n\
         ;    var formContent = document.forms[formKey].elements['%@'].value;\n\
         ;    var formSaveBt  = document.forms[formKey].elements['%@'];\n\
         ;    formSaveBt.innerText = '保存中';\n\
         ;    var xmlhttp = new XMLHttpRequest();\n\
         ;    xmlhttp.open('POST','/%@',true);\n\
         ;\n\
         ;    xmlhttp.onreadystatechange = function() {\n\
         ;        if (xmlhttp.readyState == 4) {\n\
         ;            var text = xmlhttp.responseText;\n\
         ;            if (text == 'success') {\n\
         ;                formSaveBt.innerText = '保存 成功';\n\
         ;            } else {\n\
         ;                formSaveBt.innerText = '保存 失败';\n\
         ;            }\n\
         ;        }\n\
         ;    }\n\
         ;\n\
         ;    var text = '%@='+ formContent + '&%@='+ index +'&%@='+ type; \n\
         ;    xmlhttp.send(text);\n\
         ;}\n\n"
         , PnrKey_Conent
         , PnrKey_TestSave
         , PnrPost_TestEdit
         , PnrKey_Conent, PnrKey_TestIndex, PnrKey_TestType
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

@end
