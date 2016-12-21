protocol PlantType {
    var latinName: String { get }
}

protocol HerbivoreType {
    associatedtype Plant: PlantType
    
    var plantsEaten: [Plant] { get set }
    
    mutating func eat(plant: Plant)
}

extension HerbivoreType {
    mutating func eat(plant: Plant) {
        print("eating a \(plant.latinName)")
        plantsEaten.append(plant)
    }
}

struct Grass: PlantType {
    var latinName = "Poaceae"
}

struct Pine: PlantType {
    var latinName = "Pinus"
}

struct Cow: HerbivoreType {
    var plantsEaten = [Grass]()
}

var cow = Cow()
let pine = Pine()
let grass = Grass()
cow.eat(plant: grass)

struct Carrot: PlantType {
    let latinName = "Daucus carota"
}

struct Rabbit: HerbivoreType {
    var plantsEaten = [Carrot]()
}