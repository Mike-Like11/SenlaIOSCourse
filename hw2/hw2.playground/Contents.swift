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


public enum CarState {
    case prepared
    case sold
}


public enum EngineState {
    case broken
    case wellDone
}


public struct Engine {
    
    var power:Int
    var state:EngineState
    
    
    init(power:Int) {
        self.power = power
        self.state = .wellDone
    }
    
    mutating func improvePower(newPower:Int){
        power += newPower
    }
    
    mutating func breakPower(){
        state = .broken
    }
    
    mutating func repairPower(){
        state = .wellDone
    }
}


public class Car {
    
    var country: Location
    var manufacture: Manufacture
    var engine:Engine
    var vin: String
    var state: CarState
    var factory: CarFactory
    
    init(country: Location, manufacture: Manufacture, vin: String, enginePower:Int, factory: CarFactory){
        self.country = country
        self.manufacture = manufacture
        self.engine = Engine(power: enginePower)
        self.vin = vin
        self.state = .prepared
        self.factory = factory
    }
    
    func ImproveEngine(){
        
        engine.improvePower(newPower: 1)
    }
    
    func breakEngine(){
        
        engine.breakPower()
    }
    
    func repairEngine(){
        
        engine.repairPower()
    }
    
    func sell(){
        
        state = .sold
    }
}


public class SportCar: Car {
    
    var nitro:Int  = 2
    init(country: Location, manufacture: Manufacture, vin: String, factory: CarFactory){
        super.init(country: country, manufacture: manufacture, vin: vin, enginePower: 100, factory: factory)
    }
    
    func turboMode(){
        print("TurboBoost")
    }
    
    override func ImproveEngine() {
        engine.improvePower(newPower: 100)
    }
}


public class SedanCar: Car {
    
    init(country: Location, manufacture: Manufacture, vin: String, factory: CarFactory){
        super.init(country: country, manufacture: manufacture, vin: vin, enginePower: 50, factory: factory)
    }
    
    func driveSimply(){
        print("🚘")
    }
    
    override func ImproveEngine() {
        engine.improvePower(newPower: 50)
    }
}


public class VanCar: Car {
    var extraSeats = 3
    
    init(country: Location, manufacture: Manufacture, vin: String, factory: CarFactory){
        super.init(country: country, manufacture: manufacture, vin: vin, enginePower: 10, factory: factory)
    }
    
    func partyMode(){
        print("PArty")
    }
    
    override func ImproveEngine() {
        engine.improvePower(newPower: 10)
    }
    
}


public class CrossOverCar: Car {
    
    init(country: Location, manufacture: Manufacture, vin: String, factory: CarFactory){
        super.init(country: country, manufacture: manufacture, vin: vin, enginePower: 70,factory: factory)
    }
    
    func offRoadMode(){
        print("Режим бездорожья активирован")
    }
    
    override func ImproveEngine() {
        engine.improvePower(newPower: 70)
    }

}


public class CarFactory{
    private var name:String
    private var sedanCarParking = [SedanCar]()
    private var sportCarParking = [SportCar]()
    private var vanCarParking = [VanCar]()
    private var crossOverCarParking = [CrossOverCar]()
    init(name: String){
        self.name = name
    }
    func addCar(typeCar: TypeCar, country: Location, manufacture: Manufacture) -> Car {
        switch typeCar {
        case .Sedan:
           return buildSedanCar(country: country, manufacture: manufacture)
        case .Sport:
           return  buildSportCar(country: country, manufacture: manufacture)
        case .Van:
            return buildVanCar(country: country, manufacture: manufacture)
        case .CrossOver:
            return buildCrossOverCar(country: country, manufacture: manufacture)
        }
    }
    func generateVin() -> String{
        var vin = String()
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        for _ in 0...16 {
            vin += String(Array(letters)[Int.random(in: 0..<letters.count)])
        }
        return vin
    }
    private func buildSedanCar(country: Location, manufacture: Manufacture) -> SedanCar {
        
        let car = SedanCar(country: country, manufacture: manufacture, vin: generateVin(), factory: self)
        sedanCarParking.append(car)
        return car
    }
    private func buildSportCar(country: Location, manufacture: Manufacture) -> SportCar {
        let car = SportCar(country: country, manufacture: manufacture, vin: generateVin(), factory: self)
        sportCarParking.append(car)
        return car
    }
    private func buildVanCar(country: Location, manufacture: Manufacture) -> VanCar {
        let car = VanCar(country: country, manufacture: manufacture, vin: generateVin(), factory: self)
        vanCarParking.append(car)
        return car
    }
    private func buildCrossOverCar(country: Location, manufacture: Manufacture) -> CrossOverCar {
        let car = CrossOverCar(country: country, manufacture: manufacture, vin: generateVin(), factory: self)
        crossOverCarParking.append(car)
        return car
    }
    private func findCrossOverCarByVin(vin:String) -> CrossOverCar? {
        if let car = crossOverCarParking.first(where: {$0.vin == vin}) {
            return car
        }
        return nil
    }
    private func findVanCar(vin:String) -> VanCar? {
        if let car = vanCarParking.first(where: {$0.vin == vin}) {
            return car
        }
        return nil
    }
    private func findSportCar(vin:String) -> SportCar? {
        if let car = sportCarParking.first(where: {$0.vin == vin}) {
            return car
        }
        return nil
    }
    private func findSedanCar(vin:String) -> SedanCar? {
        if let car = sedanCarParking.first(where: {$0.vin == vin}) {
            return car
        }
        return nil
    }
    func sellByVin(vin:String){
        
        if let car = findCrossOverCarByVin(vin: vin) {
            car.sell()
        }
        if let car = findVanCar(vin: vin) {
            car.sell()
        }
        if let car = findSportCar(vin: vin) {
            car.sell()
        }
        if let car = findSedanCar(vin: vin) {
            car.sell()
        }
    }
    func breakByName(vin:String){

        if let car = findCrossOverCarByVin(vin: vin) {
            car.breakEngine()
        }
        if let car = findVanCar(vin: vin) {
            car.breakEngine()
        }
        if let car = findSportCar(vin: vin) {
            car.breakEngine()
        }
        if let car = findSedanCar(vin: vin) {
            car.breakEngine()
        }

    }
    func repairByName(vin:String){
      
        if let car = findCrossOverCarByVin(vin: vin) {
            car.repairEngine()
        }
        if let car = findVanCar(vin: vin) {
            car.repairEngine()
        }
        if let car = findSportCar(vin: vin) {
            car.repairEngine()
        }
        if let car = findSedanCar(vin: vin) {
            car.repairEngine()
        }
        
    }
}


var carFactory = CarFactory(name: "Завод Senla")
var car = carFactory.addCar(typeCar: .Sport, country: .Italy, manufacture: .Ferrari)
carFactory.breakByName(vin: car.vin)
carFactory.repairByName(vin: car.vin)
carFactory.sellByVin(vin: car.vin)

