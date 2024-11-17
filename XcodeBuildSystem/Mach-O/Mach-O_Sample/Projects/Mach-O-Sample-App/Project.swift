@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Define.appName,
    targets: [
        .target(
            name: Define.appName,
            destinations: .iOS,
            product: .app,
            bundleId: "\(Define.bundleIdentifier).\(Define.appName)",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: Targets.secondLayerTargets.map { $0.targetDependency }
        ),
    ]
)
