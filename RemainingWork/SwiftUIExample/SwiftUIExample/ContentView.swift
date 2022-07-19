//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by 양중창 on 2020/03/16.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // some -> associatedtype 사용시에 사용
        // 추후 확인해야함
        
//        VStack(spacing: 20){
//            Text("Hello, World!") // return 생략 가능
//            .font(.largeTitle)
//            .foregroundColor(.red)
//            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//            .padding()
//            .colorInvert() // -> some View
//
//            Text("SwiftUI")
//                .foregroundColor(.white)
//                .padding()
//                .background(Color.blue)
//
//            Text("커스텀 폰트, 볼드체, 이텔릭체, 밑줄, 취소선")
//                .font(.custom("Menlo", size: 16))
//                .bold()
//                .italic()
//                .underline()
//                .strikethrough()
//
//            Text("라인수 제한과\n 텍스트 정령 기능입니다.\n이건 안보이죠?")
//            .lineLimit(2)
//            .multilineTextAlignment(.trailing)
//
//            ( Text("자간과 기준선").kerning(8) +
//             Text(" 조정도 쉽게 가능합니다.").baselineOffset(-20)
//                .font(.system(20)) )
//
//        }
        
        
        
        
        
        
        
//        VStack (spacing: 20) {
//
            // 기본 -> scaleToFIll
//            Image("SwiftUI")
//                .resizable(capInsets: .init(top: 0, leading: 200, bottom: 0, trailing: 0))// 이미지의 원하는 영역을 특정해서 늘려줄 수 있다.
//                .resizable(resizingMode: .tile) // 스타일?
//            .resizable()// 이미지의 크기를 조정 하려면 호출해 줘야 함
//            .frame(width: 150, height: 150)
//            .scaledToFit() // 자기 비율 유지 UIKit -> Aspect Fit
//            .scaledToFill() // UIkit -> Aspect Fill
//            .clipped() // UIkit -> clipToBounds/
            
//            Image("SwiftUI")
//                .clipShape(Rectangle().inset(by: 10))
//
//            Image("SwiftUI")
//            .clipShape(Circle())
//
//            Image("SwiftUI")
//                .clipShape(Ellipse().path(in: CGRect(x: 0, y: 0, width: 80, height: 110)))
//
//
//
//            Image("SwiftUI")
//                .renderingMode(.original)
//                .accentColor(.red)
//
//            Image("SwiftUI")
//                .renderingMode(.template) // 이미지의 불투명한 영역
//                .foregroundColor(.red)
//
//            Image("SwiftUI")
//
//            Image(systemName: "person")
//                .renderingMode(.original)
//                .foregroundColor(.red)
//                .font(.largeTitle)
//
//
//            Image(systemName: "person")
//                .renderingMode(.template)
//                .foregroundColor(.red)
//                .font(.largeTitle)
//
//            Image(systemName: "book.fill")
//                .imageScale(.small)
//                .foregroundColor(.red)
//                .font(.largeTitle)
//
//            Image(systemName: "book.fill")
//                .imageScale(.medium)
//                .foregroundColor(.red)
//                .font(.largeTitle)
//
//            Image(systemName: "book.fill")
//                .imageScale(.large)
//                .foregroundColor(.red)
//                .font(.largeTitle)
//
//
//            Rectangle()
//                .fill(Color.green)
//        }
//
        
        
        
        
        
        
//        ZStack {
//            Rectangle()
//                .fill(Color.green)
//            .frame(width: 150, height: 150)
//
//            Rectangle()
//                .fill(Color.yellow)
//            .frame(width: 150, height: 150)
//                .offset(x: 40, y: 40)
//            .zIndex(-1) // 계층구조 바꿀수 있음
//
//            Rectangle()
//                .fill(Color.red)
//            .frame(width: 150, height: 150)
//                .offset(x: -40, y: -40)
//            .zIndex(-1)
//
//        }
        
//        HStack(alignment: .top) {
//            Rectangle()
//                .fill(Color.green)
//            .frame(width: 150, height: 150)
//
//            Rectangle()
//                .fill(Color.yellow)
//            .frame(width: 150, height: 550)
//
//
//        }
        
//        HStack(alignment: .top) {
//            Text("HStack")
//                .font(.title)
//                .foregroundColor(.blue)
//
//            Text("은 뷰를 가로로 배열 합니다.")
//            Text("!")
//        }
//        .padding()
//        .border(Color.black)
//        .font(.largeTitle)
//
//
        
        
        
        
        
        
//        VStack {
//
//            HStack{
//                Text("제목")
//                    .font(.largeTitle)
//
//                Text("부제목")
//                    .foregroundColor(.gray)
//            }
//            .fixedSize()
//
//
//            Spacer()
//
//            Text("본문 내용")
//
//            Spacer()
//            Spacer()
//
//            Text("각주")
//                .font(.body)
//        }
//        .font(.title)
//    .frame(width: 200, height: 200)
//    .padding()
        
//        return List {
//            ForEach(0..<100) { i in
//                Section(header: Text("Header"), footer: Text("Footer"), content: {
//                    MyRow(someNumber: i)
//                })
//            }
//
//        }
        
        print("CountUp")
        return NavigationView{
            VStack (spacing: 20) {
                
                NavigationLink(destination: Text("ASDASF"), label: {
                    Image("SwiftUI")
                })
                
                 Text("\(count)")
                 
                 Button("Count Up") {
                     self.count += 1
                 }
             }
             .font(.largeTitle)
             .navigationBarTitle("navigation")

        }
    
        
        
    }
    
    @State var count = 0
        
        
        
        
}

struct MyRow: View {
    
    var someNumber: Int
    
    var body: some View {
        HStack {
            Image("SwiftUI")
            Text("\(someNumber)")
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            ContentView()
            .background(Color.red)
                .previewLayout(.device)
//                .previewLayout(.fixed(width: 200, height: 200))
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("SwiftUI")
                
            
//            ContentView()
//                .background(Color.orange)
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
//            .previewDisplayName("SwiftUIPreview")
        }
        
    }
}

struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        ForEach (["iPhone 8", "iPhon 11", "iPhon 11 Pro Max"], id: \.self) {
                device in
            
            VStack(spacing: 20) {
                ContentView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                
                ContentView()
                .flipsForRightToLeftLayoutDirection(true)
                    .environment(\.layoutDirection, .rightToLeft)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
            }
            
            }
        
    }
}
