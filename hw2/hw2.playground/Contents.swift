import UIKit


public enum Location {
    case RUSSIA
    case JAPAN
    case Italy
}
public enum Manufacture {
    case Lada
    case Lexus
    case Ferrari
}
public enum TypeCar {
    case Sedan
    case Sport
    case Van
    case CrossOver
}
public enum State {
    case readyToSold
    case sold
    case broken
}
public class Car {
    var country: Location
    var manufacture: Manufacture
    var enginePower: Int
    var name: String
    var state: State
    var factory: String
    init(country: Location, manufacture: Manufacture, name: String, enginePower:Int, factory: String){
        self.country = country
        self.manufacture = manufacture
        self.enginePower = 0
        self.name = name
        self.enginePower = enginePower
        self.state = .readyToSold
        self.factory = factory
    }
    func getInfo(){
        print("Имя: \(name)")
        print("Производитель: \(manufacture)")
        print("Страна: \(country)")
        print("Завод: \(factory)")
        print("Мощность двигателя: \(enginePower)")
        print("Состояние: \(state)")
    }
    func ImproveEngine(){
        enginePower += 1
    }
    func breakEngine(){
        state = .broken
    }
    func repairEngine(){
        state = .readyToSold
    }
    func sell(){
        state = .sold
    }
}
public class SportCar: Car {
    init(country: Location, manufacture: Manufacture, name: String, factory: String){
        super.init(country: country, manufacture: manufacture, name: name, enginePower: 100, factory: factory)
    }
    override func getInfo() {
        print("Тип: Спортивный автомобиль")
        super.getInfo()
    }
    override func ImproveEngine() {
        enginePower += 100
    }
}
public class SedanCar: Car {
    init(country: Location, manufacture: Manufacture, name: String, factory: String){
        super.init(country: country, manufacture: manufacture, name: name, enginePower: 50, factory: factory)
    }
    override func getInfo() {
        print("Тип: Седан")
        super.getInfo()
    }
}
public class VanCar: Car {
    init(country: Location, manufacture: Manufacture, name: String, factory: String){
        super.init(country: country, manufacture: manufacture, name: name, enginePower: 10, factory: factory)
    }
    override func getInfo() {
        print("Тип: Фургон ")
        super.getInfo()
    }
}
public class CrossOverCar: Car {
    init(country: Location, manufacture: Manufacture, name: String, factory: String){
        super.init(country: country, manufacture: manufacture, name: name, enginePower: 70,factory: factory)
    }
    override func getInfo() {
        print("Тип: Внедорожник")
        super.getInfo()
    }
}
public class CarFactory{
    private var cars:[Car]
    private var name:String
    init(name: String){
        cars = []
        self.name = name
    }
    func addCar(typeCar: TypeCar, country: Location, manufacture: Manufacture, name: String){
        switch typeCar {
        case .Sedan:
            cars.append(SedanCar(country: country, manufacture: manufacture, name: name,factory: self.name))
        case .Sport:
            cars.append(SportCar(country: country, manufacture: manufacture, name: name,factory: self.name))
        case .Van:
            cars.append(VanCar(country: country, manufacture: manufacture, name: name,factory: self.name))
        case .CrossOver:
            cars.append(CrossOverCar(country: country, manufacture: manufacture, name: name,factory: self.name))
        }
    }
    func printAllCars(){
        for car in cars {
            car.getInfo()
            print()
        }
    }
    func sellByName(name:String){
        if let car = cars.first(where: {$0.name == name}) {
            car.sell()
        }
    }
    func breakByName(name:String){
        if let car = cars.first(where: {$0.name == name}) {
            car.breakEngine()
        }
    }
    func repairByName(name:String){
        if let car = cars.first(where: {$0.name == name}) {
            car.repairEngine()
        }
    }
}
var carFactory = CarFactory(name: "Завод Senla")
carFactory.addCar(typeCar: .Sport, country: .Italy, manufacture: .Ferrari, name: "The best")
carFactory.addCar(typeCar: .Sedan, country: .JAPAN, manufacture: .Lexus, name: "Nice One")
carFactory.printAllCars()
carFactory.sellByName(name: "The best")
carFactory.printAllCars()
carFactory.breakByName(name: "Nice One")
carFactory.printAllCars()
carFactory.repairByName(name: "Nice One")
carFactory.printAllCars()
