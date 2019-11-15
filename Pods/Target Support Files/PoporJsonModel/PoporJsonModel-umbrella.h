#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JSONModel+pSafe.h"
#import "PoporJsonModel.h"
#import "PoporJsonModelTool.h"

FOUNDATION_EXPORT double PoporJsonModelVersionNumber;
FOUNDATION_EXPORT const unsigned char PoporJsonModelVersionString[];

