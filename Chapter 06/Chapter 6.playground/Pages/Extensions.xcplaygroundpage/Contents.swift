protocol Bird {}
protocol FlyingType {}

protocol Domesticatable {
    var homeAddress: String? { get }
    var hasHomeAddress: Bool { get }
    
    func printHomeAddress()
}

extension Domesticatable {
    var hasHomeAddress: Bool {
        return homeAddress != nil
    }
    
    func printHomeAddress() {
        if let address = homeAddress {
            print(address)
        }
    }
}

protocol HerbivoreType {
    var favoritePlant: String { get }
}

protocol CarnivoreType {
    var favoriteMeat: String { get }
}

protocol OmnivoreType: HerbivoreType, CarnivoreType {}

func printFavoriteMeat(forAnimal animal: CarnivoreType) {
    print(animal.favoriteMeat)
}

func printFavoritePlant(forAnimal animal: HerbivoreType) {
    print(animal.favoritePlant)
}

struct Pigeon: Bird, FlyingType, OmnivoreType, Domesticatable {
    let favoriteMeat: String
    let favoritePlant: String
    let homeAddress: String?
    
    func printHomeAddress() {
        if let address = homeAddress {
            print("address: \(address)")
        }
    }
}

let myPigeon = Pigeon(favoriteMeat: "Insects",
                       favoritePlant: "Seeds",
                       homeAddress: "Leidse plein 12, Amsterdam")

myPigeon.printHomeAddress() // address: Leidse plein 12, Amsterdam

func printAddress(animal: Domesticatable) {
    animal.printHomeAddress()
}
printAddress(animal: myPigeon) // Leidse plein 12, Amsterdam

