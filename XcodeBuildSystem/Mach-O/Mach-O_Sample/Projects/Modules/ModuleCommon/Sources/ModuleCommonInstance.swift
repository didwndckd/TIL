//
//  ModuleCommon.swift
//  ModuleCommon
//
//  Created by yjc on 11/17/24.
//

public class ModuleCommonInstance {
    public static let shared = ModuleCommonInstance()
    
    public init() {}
    
    public func callMyName(caller: String) {
        print("I am ModuleCommon in \(caller)")
    }
}
