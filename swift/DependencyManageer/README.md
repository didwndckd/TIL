# Dependency Manager

- cocoapods
- carthage

## CocoaPods


- **CocoaPods Install**

```zsh
$ sudo gem install cocoapods
```

- **Edit Podfile**

```Bash
$ pod init
$ vi Podfile
```

```vim
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CocoaPodsSnapKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CocoaPodsSnapKit
	pod '[Library name]'
end
```

- **Install Library**

```Bash
$ pod repo update
$ pod install $ open [ProjectName].xcworkspace
```


## Carthage

- **Install Carthage**

```Bash
// 미설치시 설치
$ brew update && brew install carthage
// brew 가 없을 경우 https://brew.sh 에서 설치

// 이미 설치되어 있을 때 업그레이드
$ brew upgrade carthage 
```

- **Edit Cartfile**

사용할 프로젝트의 [ProjectName].xcodeproj가 있는 폴더에 Cartfile을 만든다.

```Bash
$ vi Cartfile
```

내부에 작성할 내용
아래 형식으로 적어주면 된다.

```
github “[GITHUB ACCOUNT]/[REPO NAME]”
```

예시

```vim
# 사용할 라이브러리 작성
ggithub "Alamofire/Alamofire"
github "onevcat/Kingfisher"
```

- **Install Library**

```Bash
$ carthage update  
// 전체 업데이트
 
$ carthage update --platform iOS 
// iOS Platform 한정

$ carthage update [LibraryName]
// 여러 가지 라이브러리 중 일부만 지정하여 업데이트 할 때
```

- **Link Binary With Libraries**

<img src = "https://github.com/JoongChangYang/TIL/blob/master/Assets/swift/LinkBinaryWithLibraries.png">

- **New Run Script Phase**

<img src = "https://github.com/JoongChangYang/TIL/blob/master/Assets/swift/NewRunScroptPhase.png">

- **Run Script**

<img src = "https://github.com/JoongChangYang/TIL/blob/master/Assets/swift/RunScript.png">

- **Setting**

```
Build Phases - Run Script - Shell
> /usr/local/bin/carthage copy-frameworks

Build Phases - Run Script - Input Files
> $(SRCROOT)/Carthage/Build/iOS/[Library Name].framework
```











