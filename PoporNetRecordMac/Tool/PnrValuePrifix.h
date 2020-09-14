//
//  PnrValuePrifix.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/20.
//  Copyright © 2019 popor. All rights reserved.
//

#ifndef PnrValuePrifix_h
#define PnrValuePrifix_h

//#define NSLogSuccess(FORMAT, ...) NSLog(@"%s: %s", [@"✅" UTF8String], [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

static NSString * PnrCN_title     = @"名称:";
static NSString * PnrCN_path      = @"接口:";
static NSString * PnrCN_url       = @"链接:";
static NSString * PnrCN_time      = @"时间:";
static NSString * PnrCN_method    = @"方法:";
static NSString * PnrCN_head      = @"head参数:";
static NSString * PnrCN_parameter = @"请求参数:";
static NSString * PnrCN_response  = @"返回数据:";
static NSString * PnrCN_extra     = @"额外参数:";
static NSString * PnrCN_share     = @"分享:";
static NSString * PnrCN_log       = @"日志:";
static NSString * PnrCN_Simulator = @"模拟";

static NSString * PnrCN_crashTitle = @"崩溃信息";
static NSString * PnrCN_testDefaultResponse = @"{\"status\":200}";

static int PnrListHeight            = 50;

// 新窗口
static NSString * PnrIframeList     = @"IframeList";
static NSString * PnrIframeDetail   = @"IframeDetail";

// 表单
static NSString * PnrFormResubmit   = @"formResubmit";
static NSString * PnrFormFeedback   = @"formFeedback";

// MARK: 网页请求URL
// 记录部分
static NSString * PnrGet_admin           = @"admin";

// 记录部分
static NSString * PnrGet_recordRoot      = @"record";
static NSString * PnrGet_recordList      = @"recordList";
static NSString * PnrGet_recordDetail    = @"recordDetail";
static NSString * PnrGet_recordResubmit  = @"recordResubmit";

static NSString * PnrPost_recordResubmit = @"recordResubmit";
static NSString * PnrPost_recordClear    = @"recordClear";
//static NSString * PnrPost_recordAdd      = @"recordAdd";

// 模拟测试部分
static NSString * PnrGet_TestHeadAdd     = @"test";// 模拟假数据, 假如没有则会增加一个默认数据, post get 都支持

static NSString * PnrGet_TestRoot        = @"request";// 模拟假数据 主页面
static NSString * PnrPost_TestAdd        = @"requestAdd";// 模拟假数据 新增事件
static NSString * PnrPost_TestEdit       = @"requestEdit";// 模拟假数据 编辑事件
static NSString * PnrPost_TestDeleteOne  = @"requestDeleteOne";// 模拟假数据 删除事件
static NSString * PnrPost_TestDeleteAll  = @"requestDeleteAll";// 模拟假数据 删除事件

// 图片URL解析
static NSString * PnrGet_YcUrl           = @"ycUrl";
static NSString * Pnrget_YcUrlPsd        = @"ycUrlPsd";
static NSString * PnrPost_YcUrlPsdEdit   = @"ycUrlPsdEdit";
static NSString * PnrPost_YcUrlDecrypt   = @"ycUrlDecrypt";

// 二维码
static NSString * PnrGet_QrUrlSelf       = @"QrUrlSelf.png";

// 公共
static NSString * PnrPost_commonJsonXml  = @"jsonXml";

// 文件
static NSString * PnrGet_file            = @"file";
static NSString * PnrGet_fileName        = @"name";
static NSString * PnrGet_fileFolder      = @"file";

// MARK: web key
static NSString * PnrKey_Conent     = @"content";

static NSString * PnrKey_Title      = @"title";
static NSString * PnrKey_Url        = @"url";
static NSString * PnrKey_Method     = @"method";
static NSString * PnrKey_Path       = @"path";

static NSString * PnrKey_Head       = @"headValue";
static NSString * PnrKey_Parameter  = @"parameterValue";
static NSString * PnrKey_Response   = @"responseValue";

static NSString * PnrKey_Time       = @"time";

static NSString * PnrKey_DeviceName = @"deviceName";
static NSString * PnrKey_index      = @"index";

static NSString * PnrKey_TestUrl        = @"url";
static NSString * PnrKey_TestResponse   = @"response";
static NSString * PnrKey_TestIndex      = @"index";
static NSString * PnrKey_TestType       = @"type";
static NSString * PnrKey_TestSave       = @"save";
static NSString * PnrKey_TestDeleteOne  = @"deleteOne";
static NSString * PnrKey_TestDeleteAll  = @"deleteAll";
static NSString * PnrKey_TestSearch     = @"search";
static NSString * PnrKey_TestSearchWord = @"word";
static NSString * PnrKey_TestSearchForm = @"searchForm";

static NSString * PnrKey_success        = @"success";
static NSString * PnrKey_fail           = @"fail";

static NSString * PnrKey_ycUrlBTPsd       = @"btPsd";
static NSString * PnrKey_ycUrlBTUrl       = @"btUrl";
static NSString * PnrKey_ycUrlTaResult    = @"result";

static NSString * PnrKey_ycUrlPsd       = @"psd";
static NSString * PnrKey_ycUrlUrl       = @"url"; // 需要解密的url
static NSString * PnrKey_ycUrlResult    = @"result";

static NSString * PnrKey_ycUrlStatus    = @"status";
static NSString * PnrKey_ycUrlType      = @"type";
static NSString * PnrKey_ycUrlValue     = @"value";

// 分享url
static NSString * PnrKey_IdShare    = @"idShare";

static NSString * PnrJsClassTaAutoH = @"TaAutoH";


// MARK: 页面
static NSString * PnrH5_list        = @"list";
static NSString * PnrH5_listText1   = @"listText1_";
static NSString * PnrH5_listText2   = @"listText2_";


#endif /* PnrValuePrifix_h */
