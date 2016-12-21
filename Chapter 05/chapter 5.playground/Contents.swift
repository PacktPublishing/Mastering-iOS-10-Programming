//: Playground - noun: a place where people can play

class Food {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

struct Pet {
    let name: String
    let food: Food = Food(name: "Chicke")
}

let cat = Pet(name: "Bubbles")
cat.food.name = "Turkey"
print(cat.food.name)

enum MessageStatus {
    case sent, delivered, read, unsent
}

struct Message {
    let contents: String
    let status: MessageStatus
}

let message = Message(contents: "Hello, world", status: .unsent)

enum FoodType: String {
    case meat = "Meat"
    case vegetables = "Vegetables"
    case fruit = "Fruit"
    case mixed = "Mixed food"
    
    var description: String {
        switch self {
        case .meat:
            return "A meaty food type"
        case .vegetables:
            return "Vegetables are good!"
        case .fruit:
            return "Fruity goodness"
        case .mixed:
            return "Just about anything edible"
        }
    }
}

let food: FoodType = .meat
print(food.description) //A meaty food type

enum Optional {
    case some(Int)
    case none
}

let optionalInt: Optional = .some(10)
if case let .some(value) = optionalInt {
    print(value)
}