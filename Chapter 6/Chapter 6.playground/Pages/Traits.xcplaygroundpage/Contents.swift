protocol Bird {}
protocol FlyingType {}

protocol Domesticatable {
    var homeAddress: String? { get }
}

protocol HerbivoreType {
    var favoritePlant: String { get }
}

protocol CarnivoreType {
    var favoriteMeat: String { get }
}

protocol OmnivoreType: HerbivoreType, CarnivoreType {}

struct Pigeon: Bird, FlyingType, OmnivoreType, Domesticatable {
    let favoriteMeat: String
    let favoritePlant: String
    let homeAddress: String?
}

func printHomeAddress(animal: Domesticatable) {
    if let address = animal.homeAddress {
        print(address)
    }
}

func printFavoriteMeat(forAnimal animal: CarnivoreType) {
    print(animal.favoriteMeat)
}

func printFavoritePlant(forAnimal animal: HerbivoreType) {
    print(animal.favoritePlant)
}

let pidgey = Pigeon(favoriteMeat: "Insects", favoritePlant: "Seeds", homeAddress: nil)
printFavoritePlant(forAnimal: pidgey)
