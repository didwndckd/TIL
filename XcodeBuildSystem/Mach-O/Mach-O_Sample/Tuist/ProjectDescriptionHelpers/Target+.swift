//
//  Target+.swift
//  Mach-O_SampleManifests
//
//  Created by yjc on 11/18/24.
//

@preconcurrency import ProjectDescription

public enum Targets: CaseIterable {
    case moduleA
    case moduleB
    case moduleC
    case moduleCommon
    
    public static var secondLayerTargets: [Targets] {
        return [.moduleA, .moduleB, .moduleC]
    }
    
    var moduleName: String {
        switch self {
        case .moduleA: return "ModuleA"
        case .moduleB: return "ModuleB"
        case .moduleC: return "ModuleC"
        case .moduleCommon: return "ModuleCommon"
        }
    }
    
    var product: Product {
        switch self {
        case .moduleA: return .framework
        case .moduleB: return .framework
        case .moduleC: return .framework
        case .moduleCommon: return .staticLibrary
        }
    }
    
    var dependencies: [TargetDependency] {
        switch self {
//        case .moduleA:
//            return [Targets.moduleCommon, .moduleB, .moduleC].map { $0.targetDependency }
        case .moduleA, .moduleB, .moduleC:
            return [Targets.moduleCommon.targetDependency]
        case .moduleCommon:
            return []
        }
    }
    
    public var moduleTarget: Target {
        return .createModule(targetName: moduleName, product: product, dependencies: dependencies)
    }
    
    public var appTarget: Target {
        return .createApp(moduleName: moduleName, dependencies: [targetDependency])
    }
    
    public var targetDependency: TargetDependency {
        return .project(target: moduleName, path: .relativeToRoot(Define.modulePath))
    }
}

public extension Target {
    static func createModule(targetName: String, product: Product, dependencies: [TargetDependency] = []) -> Target {
        var resources: ResourceFileElements?
        
        switch product {
        case .framework, .staticFramework:
            resources = ["\(targetName)/Resources/**"]
        default:
            resources = nil
        }
        
        return Target.target(
            name: targetName,
            destinations: .iOS,
            product: product,
            bundleId: Define.bundleIdentifier + ".\(targetName)",
            sources: ["\(targetName)/Sources/**"],
            resources: resources,
            dependencies: dependencies,
            settings: .settings(base: Define.defaultSettings)
        )
    }
    
    static func createApp(moduleName: String, dependencies: [TargetDependency]) -> Target {
        let appName = "\(moduleName)-App"
        
        return Target.target(
            name: appName,
            destinations: .iOS,
            product: .app,
            bundleId: Define.bundleIdentifier + ".\(moduleName)",
            sources: ["\(moduleName)/Sources/**"],
            resources: ["\(moduleName)/Resources/**"],
            dependencies: dependencies,
            settings: .settings(base: Define.defaultSettings)
        )
    }
}
