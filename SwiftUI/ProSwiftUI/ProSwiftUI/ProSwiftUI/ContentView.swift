//
//  ContentView.swift
//  ProSwiftUI
//
//  Created by yjc on 1/6/26.
//

import SwiftUI
internal import Combine

struct FormElementIsRequiredKey: EnvironmentKey {
    static var defaultValue = false
}

extension EnvironmentValues {
    var required: Bool {
        get { self[FormElementIsRequiredKey.self] }
        set { self[FormElementIsRequiredKey.self] = newValue }
    }
}

extension View {
    func required(_ makeRequired: Bool = true) -> some View {
        environment(\.required, makeRequired)
    }
}


struct RequirableTextField: View {
    @Environment(\.required) var required

    let title: String
    @Binding var text: String

    var body: some View {
        HStack {
            TextField(title, text: $text)

            if required {
                Image(systemName: "asterisk")
                    .imageScale(.small)
                    .foregroundColor(.red)
            }
        }
    }
}

struct StrokeWidthKey: EnvironmentKey {
    static var defaultValue = 1.0
}

extension EnvironmentValues {
    var strokeWidth: Double {
        get { self[StrokeWidthKey.self] }
        set { self[StrokeWidthKey.self] = newValue }
    }
}

extension View {
    func strokeWidth(_ width: Double) -> some View {
        environment(\.strokeWidth, width)
    }
}

struct TitleFontKey: EnvironmentKey {
    static var defaultValue = Font.custom("Georgia", size: 34)
}

extension EnvironmentValues {
    var titleFont: Font {
        get { self[TitleFontKey.self] }
        set { self[TitleFontKey.self] = newValue }
    }
}

extension View {
    func titleFont(_ font: Font) -> some View {
        environment(\.titleFont, font)
    }
}

class ThemeManager: ObservableObject {
    @Published var strokeWidth = 1.0
    @Published var titleFont = TitleFontKey.defaultValue
}

struct CirclesView: View {
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        print("In CirclesView.body")

        return ForEach(0..<3) { _ in
            Circle()
                .stroke(.red, lineWidth: theme.strokeWidth)
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "sun.max")
                .fontWeight(.black)
//                .transformEnvironment(\.font) { font in
//                        font = font?.weight(.black)
//                    }
            Text("Welcome!")
        }
    }
}

public struct KmongDesignSystemFontConvertible: Sendable {
    public let name: String
    public let family: String
    public let path: String
}

public enum KmongDesignSystemFontFamily: Sendable {
  public enum MetroSans: Sendable {
    public static let bold = KmongDesignSystemFontConvertible(name: "MetroSans-Bold", family: "MetroSans", path: "MetroSans-Bold.otf")
    public static let light = KmongDesignSystemFontConvertible(name: "MetroSans-Light", family: "MetroSans", path: "MetroSans-Light.otf")
    public static let medium = KmongDesignSystemFontConvertible(name: "MetroSans-Medium", family: "MetroSans", path: "MetroSans-Medium.otf")
    public static let regular = KmongDesignSystemFontConvertible(name: "MetroSans-Regular", family: "MetroSans", path: "MetroSans-Regular.otf")
    public static let all: [KmongDesignSystemFontConvertible] = [bold, light, medium, regular]
  }
  public enum Pretendard: Sendable {
    public static let bold = KmongDesignSystemFontConvertible(name: "Pretendard-Bold", family: "Pretendard", path: "Pretendard-Bold.otf")
    public static let medium = KmongDesignSystemFontConvertible(name: "Pretendard-Medium", family: "Pretendard", path: "Pretendard-Medium.otf")
    public static let regular = KmongDesignSystemFontConvertible(name: "Pretendard-Regular", family: "Pretendard", path: "Pretendard-Regular.otf")
    public static let all: [KmongDesignSystemFontConvertible] = [bold, medium, regular]
  }
  public static let allCustomFonts: [KmongDesignSystemFontConvertible] = [MetroSans.all, Pretendard.all].flatMap { $0 }
}


public struct KDFont {
    let size: CGFloat
    let weight: Weight
    let lineHeight: CGFloat
    
    var font: Font {
        return .custom(weight.fontName, size: size)
    }
    
    enum Weight {
        case regular
        case medium
        case bold
        
        var fontName: String {
            switch self {
            case .regular: return KmongDesignSystemFontFamily.Pretendard.regular.name
            case .medium: return KmongDesignSystemFontFamily.Pretendard.medium.name
            case .bold: return KmongDesignSystemFontFamily.Pretendard.bold.name
            }
        }
    }
    
    public enum Size12 {
        static let regular = KDFont(size: 12, weight: .regular, lineHeight: 15)
        static let medium = KDFont(size: 12, weight: .medium, lineHeight: 15)
        static let bold = KDFont(size: 12, weight: .bold, lineHeight: 15)
    }
}

struct KDFontEnvironmentKey: EnvironmentKey {
    static var defaultValue: KDFont { KDFont.Size12.regular }
}

extension EnvironmentValues {
    var kdFont: KDFont {
        get { self[KDFontEnvironmentKey.self] }
        set { self[KDFontEnvironmentKey.self] = newValue }
    }
}

struct KDText: View {
    @Environment(\.kdFont) var kdFont
    let text: LocalizedStringKey
    
    var body: some View {
        Text(text)
            .font(kdFont.font)
            .lineSpacing(kdFont.lineHeight / 2)
            .padding(.vertical, kdFont.lineHeight / 4)
    }
}

extension View {
    func font(_ font: KDFont) -> some View {
        environment(\.kdFont, font)
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static let defaultValue = 0.0

    static func reduce(value: inout Double, nextValue: () -> Double) {

    }
}

struct SizingView: View {
    @State private var width = 50.0

    var body: some View {
        Color.red
            .frame(width: width, height: 100)
            .onTapGesture {
                width = Double.random(in: 50...160)
            }
            .preference(key: WidthPreferenceKey.self, value: width)
    }
}

struct Category: Identifiable, Equatable {
    let id: String
    let symbol: String
}

struct CategoryPreference: Equatable {
    let category: Category
    let anchor: Anchor<CGRect>
}

struct CategoryPreferenceKey: PreferenceKey {
    static let defaultValue = [CategoryPreference]()

    static func reduce(value: inout [CategoryPreference], nextValue: () -> [CategoryPreference]) {
        value.append(contentsOf: nextValue())
    }
}

struct CategoryButton: View {
    var category: Category
    @Binding var selection: Category?

    var body: some View {
        Button {
            withAnimation {
                selection = category
            }
        } label: {
            VStack {
                Image(systemName: category.symbol)
                Text(category.id)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement()
        .accessibilityLabel(category.id)
        .anchorPreference(key: CategoryPreferenceKey.self, value: .bounds, transform: { [CategoryPreference(category: category, anchor: $0)] })
    }
}

struct ContentView: View {
    @State private var selectedCategory: Category?

    let categories = [
        Category(id: "Arctic", symbol: "snowflake"),
        Category(id: "Beach", symbol: "beach.umbrella"),
        Category(id: "Shared Homes", symbol: "house")
    ]

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(categories) { category in
                    CategoryButton(category: category, selection: $selectedCategory)
                }
            }
            .overlayPreferenceValue(CategoryPreferenceKey.self) { preferences in
                GeometryReader { proxy in
                    if let selected = preferences.first(where: { $0.category == selectedCategory }) {
                        let frame = proxy[selected.anchor]

                        Rectangle()
                            .fill(.primary)
                            .frame(width: frame.width, height: 2)
                            .position(x: frame.midX, y: frame.maxY)
                    }
                }
            }
            
            List(categories, id: \.id) { category in
                HStack {
                    Button(category.id) {
                        withAnimation {
                            selectedCategory = category
                        }
                    }

                    if selectedCategory == category {
                        Spacer()

                        Image(systemName: "checkmark")
                    }
                }
            }
            
        }
    }
}


#Preview {
    ContentView()
}
