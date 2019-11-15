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
        js = [NSString stringWithFormat: @"\n\
              function jsonStatic(formKey) {\n\
              var form = document.getElementById(formKey);\n form.action='/%@';\n form.submit();\n\
              }\n\
              ", PnrPathJsonXml];
    }
    return js;
}

// MARK: 动态的查看json js代码, 生成新的form,并且submit.
+ (NSString *)jsJsonDynamic {
    // http://www.cnblogs.com/haoqipeng/p/create-form-with-js.html
    static NSString * js;
    if (!js) {
        js = [NSString stringWithFormat: @"\n\
              function jsonDynamic(formKey, contentkey) {\n\
              var valueFrom = document.forms[formKey].elements[contentkey].value;\n\
              \n\
              var dlform = document.createElement('form');\n\
              dlform.style = 'display:none;';\n\
              dlform.method = 'POST';\n\
              dlform.action = '/%@';\n\
              dlform.target = '_blank';\n\
              \n\
              var hdnFilePath = document.createElement('input');\n\
              hdnFilePath.type = 'hidden';\n\
              hdnFilePath.name = '%@';\n\
              hdnFilePath.value = valueFrom;\n\
              dlform.appendChild(hdnFilePath);\n\
              \n\
              document.body.appendChild(dlform);\n\
              dlform.submit();\n\
              document.body.removeChild(dlform);\n\
              }\n\
              ", PnrPathJsonXml, PnrKeyConent];
    }
    return js;
}

// MARK: 高度自适应的textarea
+ (NSString *)textareaAutoHeightFuntion {
    // http://caibaojian.com/textarea-autoheight.html
    return @"\n function makeExpandingArea(el) { var setStyle = function (el) { el.style.height = 'auto'; el.style.height = el.scrollHeight + 'px'; }; var delayedResize = function (el) { window.setTimeout(function () { setStyle(el); }, 0); }; if (el.addEventListener) { el.addEventListener('input', function () { setStyle(el) }, false); setStyle(el); } else if (el.attachEvent) { el.attachEvent('onpropertychange', function () { setStyle(el); }); setStyle(el); } if (window.VBArray && window.addEventListener) { el.attachEvent('onkeydown', function () { var key = window.event.keyCode; if (key == 8 || key == 46) {delayedResize(el);} }); el.attachEvent('oncut', function () { delayedResize(el); }); } } ";
}

+ (NSString *)textareaAuhoHeigtEventClass:(NSString *)className {
    return [NSString stringWithFormat:@"\n var taArray = document.getElementsByClassName('%@'); for (var i = 0; i < taArray.length; i++) { makeExpandingArea(taArray[i]); } \n", className];
}

// MARK: ajax 刷新增加
+ (NSString *)ajaxResubmit {
    static NSString * js;
    if (!js) {
        js = [NSString stringWithFormat:@"\n\
              function ajaxResubmit(form) {\n\
              var ta = document.forms['%@'].elements['%@'];\n\
              ta.value = \"请等待\"\n\
              \n\
              var xmlhttp = new XMLHttpRequest();\n\
              xmlhttp.open('POST','/%@',true);\n\
              xmlhttp.onreadystatechange=function() {\n\
              if (xmlhttp.readyState==4 && xmlhttp.status==200){\n\
              ta.value = xmlhttp.responseText; \n\
              makeExpandingArea(ta);\n\
              parent.freshList();\
              }\n\
              }\n\
              \n\
              var text = '';\n\
              for (var i = 0; i < form.elements.length; i++) {\n\
              var filed = form.elements[i];\n\
              var type = filed.type;\n\
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
              }\n\
              \n\
              xmlhttp.send(text.substr(1)); \n\
              }\n", PnrFormFeedback, PnrKeyConent, PnrPathResubmit];
    }
    return js;
    // https://developer.mozilla.org/zh-CN/docs/Web/API/FormData/Using_FormData_Objects
};

// https://blog.csdn.net/wild46cat/article/details/52718545
+ (NSString *)updateShareUrl {
    static NSString * js;
    if (!js) {
        js = [NSString stringWithFormat:@"\n window.onload=function (){\n\
              document.getElementById('%@').innerText = getRoot(); \n\
              } \n", PnrIdShare];
    }
    return js;
}

+ (NSString *)getRootUrl {
    return @"\n function getRoot() {\n\
    var hostname = location.hostname;\n\
    var pathname = location.pathname;\n\
    var contextPath = pathname.split('/')[1];\n\
    var port = location.port;\n\
    var protocol = location.protocol;\n\
    return protocol + '//' + hostname + ':' + port + '/' + contextPath;\n\
    }";
}

+ (NSString *)copyInnerText {
    return @"\n function copyInnerText(idName) {\n\
    var text = document.getElementById(idName).innerText;\n\
    var oInput = document.createElement('input');\n\
    oInput.value = text;\n\
    document.body.appendChild(oInput);\n\
    oInput.select();\n\
    document.execCommand(\"Copy\");\n\
    oInput.className = 'oInput';\n\
    oInput.style.display = 'none';\n\
    }";
}

+ (NSString *)clearText {
    static NSString * js;
    if (!js) {
        js = [NSString stringWithFormat:@"\n\
              function clearAction() {\n\
              var xmlhttp = new XMLHttpRequest();\n\
              xmlhttp.open('POST','/%@',true);\n\
              \n\
              \n\
              xmlhttp.onreadystatechange=function() {\n\
              location.reload();\n\
              }\n\
              \n\
              \n\
              xmlhttp.send('clear'); \n\
              }\n", PnrPathClear];
    }
    return js;
}

@end
