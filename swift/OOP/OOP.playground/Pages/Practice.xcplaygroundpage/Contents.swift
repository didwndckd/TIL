//: [Previous](@previous)

/*
 1. width, height 속성을 가진 Rectangle 클래스 정의
 2. 생성자에서 width, height 프로퍼티 값을 설정할 수 있도록 구현
 3. 사각형의 가로 세로 길이를 설정할 수 있는 메서드 구현
 4. 사각형 가로와 세로의 길이를 반환하는 메서드 구현
 5. 사각형의 넓이를 반환하는 메서드 구현
 6. 다음과 같은 속성을 지닌 인스턴스 생성
 - 직사각형 1개 속성: width = 10, height = 5
 - 정사각형 1개 속성: width = 7, height = 7
 */

class Rectangle {
    
    var width : Int
    var height : Int
    var area : Int {
        return self.width * self.height
    }
    init(width : Int , height : Int ) {
        self.width = width
        self.height = height
    }
    
    func widthAndHeight () -> (Int , Int ){
        return (width, height)
    }
    
    
  
}

let rect : Rectangle = Rectangle(width: 7, height: 7)
rect.height
rect.width
rect.area
rect.width = 10
rect.area


/*
 1. 채널 정보, Volume 값, 전원 설정여부를 속성으로 가지는 클래스 정의
 2. TV 의 현재 채널 및 볼륨을 변경 가능한 메서드 구현
 3. TV 의 현재 채널 및 볼륨을 확인할 수 있는 메서드 구현
 4. TV 전원이 꺼져있을 때는 채널과 볼륨 변경을 할 수 없도록 구현
    (직접 프로퍼티에 값을 설정할 수 없다고 가정)
 5. TV 전원이 꺼져있을 때는 채널과 볼륨 정보를 확인했을 때 -1 이 반환되도록 구현
 */

class TV {
   private var channel : Int = -1
   private var volum : Int = -1
   private var onOff : Bool = false
    
    func turnOn () {
        onOff = true
        print("전원 on")
    }
    func turnOff () {
        onOff = false
        print("전원 off")
    }
    func changeChannel (request : Int) {
        guard onOff else {
            print("채널 변경 불가")
            return
        }// 만약 전원이 꺼져 있으면 불가
        channel = request
        print("현재 채널 : \(channel)")
        
        
    }
    func volumChange (request : Int ) {
        guard onOff else {
            print("볼륨 조절 불가")
            return
        }
        volum = request
        print("현재 볼륨 : \(volum)")
        
    }
    func getData () {
        if onOff {
            print("채널 : \(channel) 볼륨 : \(volum)")
        }else{
            print("채널 : -1 볼륨 -1 ")
        }
    }
    
}

let mytv : TV = TV()

mytv.changeChannel(request: 3)
mytv.volumChange(request: 5)
mytv.turnOn()
mytv.changeChannel(request: 5)
mytv.volumChange(request: 3)
mytv.getData()
mytv.turnOff()
mytv.getData()

/*
 1. 사각형의 길이를 설정하는 초기화 메서드, 둘레와 넓이값을 구하는 메서드 구현
 2. 원의 반지름을 설정하는 초기화 메서드, 둘레와 넓이값을 구하는 메서드 구현
 */

class Square {
    var width : Int
    var height : Int
    init(width : Int , height : Int ) {
        self.height = height
        self.width = width
    }
    func getValue () {
        print("""
            사각형
            둘레 : \((height * 2) + ( width*2))
            넓이 : \(height * width)
            """)
    }
}

var squ : Square = Square(width: 11, height: 2)
squ.getValue()


class Circle {
    var r : Double
    let pie : Double = 3.14
    init(r : Double) {
        self.r = r
    }
    func getValue () {
        print("""
            원
            둘레 : \((r*2)*pie)
            넓이 : \((r*r)*pie)
            """)
    }
}
let cir = Circle(r: 10)
cir.getValue()

//: [Next](@next)
