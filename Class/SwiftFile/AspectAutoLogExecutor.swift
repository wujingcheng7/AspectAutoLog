//
//  AspectAutoLogExecutor.swift
//  AspectAutoLog
//
//  Created by 吴京城 on 2024/4/1.
//

import UIKit

@objc(AALAspectAutoLogExecutor)
@objcMembers
public class AspectAutoLogExecutor: NSObject {

    private static var loggers: [AspectAutoLogProtocol.Type] = []

    public static func register(logger: AspectAutoLogProtocol.Type) {
        if loggers.contains(where: { $0 == logger }) {
            #if DEBUG
            debugPrint("[AspectAutuLog] 😂duplicate register [\(logger)]")
            #endif
        } else {
            #if DEBUG
            debugPrint("[AspectAutuLog] ✅success register [\(logger)]")
            #endif
            loggers.append(logger)
        }
    }

    internal static func loggersDo(block: (_ logger: AspectAutoLogProtocol.Type) -> Void) {
        loggers.forEach({ block($0) })
    }

}
