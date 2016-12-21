//: Playground - noun: a place where people can play

protocol PetType {
    var name: String { get }
    var age: Int { get set }
    
    func sleep()
    
    static var latinName: String { get }
}

struct Cat: PetType {
    let name: String
    var age: Int
    
    static let latinName: String = "Felis catus"
    
    func sleep() {
        print("Cat: ZzzZZ")
    }
}

struct Dog: PetType {
    let name: String
    var age: Int
    
    static let latinName: String = "Canis familiaris"
    
    func sleep() {
        print("Dog: ZzzZZ")
    }
}

func nap(pet: PetType) {
    pet.sleep()
}