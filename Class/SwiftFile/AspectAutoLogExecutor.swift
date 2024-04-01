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

    public private(set) static var loggers: [AspectAutoLogProtocol.Type] = []

    public static func register(logger: AspectAutoLogProtocol.Type) {
        if loggers.contains(where: { $0 == logger }) {
            #if DEBUG
            assertionFailure("duplicate reigster")
            #endif
        } else {
            #if DEBUG
            debugPrint("[AspectAutuLog] register \(logger) success!")
            #endif
            loggers.append(logger)
        }
    }

}
