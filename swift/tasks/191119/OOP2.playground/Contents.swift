import UIKit

// Q. 상속 적용해보기

class Animal {
    var brain : Bool = true
    var leg : Int = 0
    
}

class Human: Animal {
    var name : String
    
    init(name: String) {
        self.name = name
        super.init()
        super.leg = 2
    }
}

class Pet: Animal {
    var fleas : Int = 0
   override init() {
        super.init()
        super.leg = 4
    }

    
}

class Cat: Pet {
    var kind: String
    init(kind: String) {
        self.kind = kind
        super.init()
        super.fleas = 4
    }
}

class Dog: Pet {
    var kind: String
    
    init(kind: String) {
        self.kind = kind
        super.init()
        super.fleas = 8
    }
}

let human = Human(name: "양중창")
human.name
human.leg
human.brain

let animal = Animal()
animal.brain
animal.leg

let dog = Dog(kind: "푸들")
dog.leg
dog.fleas
dog.kind

let cat = Cat(kind: "샴")
cat.fleas
cat.kind
cat.leg




