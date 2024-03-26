//
//  AALAspectAutoFrogExecutor.h
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/3/26.
//

#import <Foundation/Foundation.h>
#import "AALAspectAutoLogProtocol.h"

/// 需要外界对这个类进行初始化，建议在 NSObject 的 "+load" 方法内执行初始化
/// External initialization of this class is required. It is recommended to do this within the NSObject's "+load" method.
///
/// Example:
///
/// step1:
///
/// First, you need to write a class that inherits from NSObject and implements the AALAspectAutoLogProtocol protocol.
/// Let's name this class YourCustomLogClass for now.
///
/// 首先，你需要自己写一个类，这个类继承自 NSObject 并且实现了 AALAspectAutoLogProtocol 协议.
/// 我们暂且讲这个类命名为 YourCustomLogClass
///
/// step2:
/// 然后，你需要自己写一个 NSObject 分类，在 +load 方法中指定 AALAspectAutoFrogExecutor = [YourCustomLogClass class];
///
/// Then, you need to write an NSObject category yourself
/// and specify `AALAspectAutoFrogExecutor = [YourCustomLogClass class];` in the "+load" method.
///
/// ----- YourCustomLog.h file -----
/// #import <Foundation/Foundation.h>
///
/// @interface NSObject (YourCustomLog)
///
/// @end
///
///
/// ----- YourCustomLog.m file -----
/// #import "NSObject+YourCustomLog.h"
/// #import <AspectAutoLog/AALAspectAutoLogProtocol.h>
///
/// @implementation NSObject (YourCustomLog)
///
/// + (void)load {
///     // YourCustomLogClass must implement AALAspectAutoLogProtocol
///     AALAspectAutoFrogExecutor = [YourCustomLogClass class];
/// }
///
/// @end
///
/// step3:
/// ✅ done [大功告成]
///
extern _Nullable Class<AALAspectAutoLogProtocol> AALAspectAutoFrogExecutor;
