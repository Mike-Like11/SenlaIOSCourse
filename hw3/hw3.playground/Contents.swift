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


public enum SteeringWheelSize {
    case S
    case M
    case L
}


protocol WheelSystemable {
    
    var wheelCount:Int { get set }
    mutating func addWheel()
    mutating func deleteWheel()
}


extension WheelSystemable{
    
    mutating func addWheel(){//Static(Direct) Dispatch
        wheelCount+=1
    }
    
    mutating func deleteWheel(){//Static(Direct) Dispatch
        wheelCount-=1
    }
}


protocol Enginable {
    
    var enginePower:Int { get set }
    
    var engineState:EngineState { get set }
    
    mutating func improvePower(newPower:Int)
    
    mutating func breakPower()
    
    mutating func repairPower()
}


extension Enginable{
    
    mutating func improvePower(newPower:Int){//Static(Direct) Dispatch
        enginePower += newPower
    }
    
    mutating func breakPower(){//Static(Direct) Dispatch
        engineState = .broken
    }
    
    mutating func repairPower(){//Static(Direct) Dispatch
        engineState = .wellDone
    }
}


protocol SteeringWheelable {
    var steeringWheelSize: SteeringWheelSize { get set }
    
    var steeringWheelColor:UIColor { get set }
    
    mutating func changeColor()
    
    mutating func changeSize(size:SteeringWheelSize)
}


extension SteeringWheelable{
    
    mutating public func changeColor(){//Static(Direct) Dispatch
        steeringWheelColor = UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
    
    mutating public func changeSize(size:SteeringWheelSize){//Static(Direct) Dispatch
        self.steeringWheelSize = size
    }
}


protocol Car: Enginable, SteeringWheelable, WheelSystemable{
    
    var country: Location { get set }
    
    var manufacture: Manufacture { get set }
    
    var vin: String { get set }
    
    var state: CarState { get set }
    
    var factory: CarFactory { get set }
    
    mutating func sell()
    
}


extension Car{
    
    public mutating func sell() {//Static(Direct) Dispatch
        state = .sold
    }
}


protocol Sportable {
    
    var nitro:Int { get set }
    
    mutating func turboMode()
}


protocol Expandable {
    
    var extraSeats:Int { get set }
    
    func partyMode()
}

struct BabyChair{
    var isScrewed: Bool
    var type:Int
}


protocol Simplable {
    var chair:BabyChair{ get set }
    mutating func driveSimply()
}


protocol Roadlessable {
    var extraTires:Int { get set }
    func offRoadMode()
}


public struct SportCar: Car,Sportable {

    var steeringWheelSize: SteeringWheelSize = .S
    
    var wheelCount: Int = 4
    
    var steeringWheelColor: UIColor
    
    var enginePower: Int = 100
    
    var engineState: EngineState = .wellDone
    
    var country: Location
    
    var manufacture: Manufacture
    
    var vin: String
    
    var state: CarState = .prepared
    
    var factory: CarFactory
    
    public init(country: Location, manufacture: Manufacture, vin: String, factory: CarFactory, color: UIColor) {
        self.country = country
        self.manufacture = manufacture
        self.vin = vin
        self.factory = factory
        steeringWheelColor = color
    }
    
    var nitro:Int  = 2
    
    mutating func turboMode(){//Witness Table Dispatch
        enginePower = nitro * enginePower
    }
    
}


public struct VanCar: Car, Expandable {
    var steeringWheelSize: SteeringWheelSize = .L
    
    var wheelCount: Int = 4
    
    var steeringWheelColor: UIColor
    
    var enginePower: Int = 50
    
    var engineState: EngineState = .wellDone
    
    var country: Location
    
    var manufacture: Manufacture
    
    var vin: String
    
    var state: CarState = .prepared
    
    var factory: CarFactory
    
    public init(country: Location, manufacture: Manufacture, vin: String, factory: CarFactory, color: UIColor) {
        self.country = country
        self.manufacture = manufacture
        self.vin = vin
        self.factory = factory
        steeringWheelColor = color
    }

    var extraSeats = 3
    
    func partyMode(){//Witness Table Dispatch
        print("PArty")
    }
}


public struct SedanCar: Car, Simplable {

   var steeringWheelSize: SteeringWheelSize = .M
    
    var wheelCount: Int = 4
    
    var steeringWheelColor: UIColor
    
    var enginePower: Int = 25
    
    var engineState: EngineState = .wellDone
    
    var country: Location
    
    var manufacture: Manufacture
    
    var vin: String
    
    var state: CarState = .prepared
    
    var factory: CarFactory
    
    public init(country: Location, manufacture: Manufacture, vin: String, factory: CarFactory, color: UIColor) {
        self.country = country
        self.manufacture = manufacture
        self.vin = vin
        self.factory = factory
        steeringWheelColor = color
    }

    var chair: BabyChair = BabyChair(isScrewed: false, type: 1)
    mutating func driveSimply(){//Witness Table Dispatch
        chair.isScrewed = true
    }
}


public struct CrossOverCar: Car, Roadlessable {
    var extraTires: Int = 5
    
    var steeringWheelSize: SteeringWheelSize = .L
    
    var wheelCount: Int = 4
    
    var steeringWheelColor: UIColor
    
    var enginePower: Int = 75
    
    var engineState: EngineState = .wellDone
    
    var country: Location
    
    var manufacture: Manufacture
    
    var vin: String
    
    var state: CarState = .prepared
    
    var factory: CarFactory
    
    init(country: Location, manufacture: Manufacture, vin: String, factory: CarFactory, color: UIColor) {
        self.country = country
        self.manufacture = manufacture
        self.vin = vin
        self.factory = factory
        steeringWheelColor = color
    }
    
    func offRoadMode(){//Witness Table Dispatch
        print("Режим бездорожья активирован")
    }
    var nitro:Int  = 2
}


public protocol Dillerable {
    
    var sedanCarParking:[SedanCar]{get set}
    
    var sportCarParking:[SportCar]{get set}
    
    var vanCarParking:[VanCar] {get set}
    
    var crossOverCarParking:[CrossOverCar]{get set}
    
    mutating func addCar(car:SedanCar)
    
    mutating func addCar(car:SportCar)
    
    mutating func addCar(car:VanCar)
    
    mutating func addCar(car:CrossOverCar)
    
    mutating  func sellByVin(vin:String)
}


public extension Dillerable {
    
    mutating func sellByVin(vin:String){//Static(Direct) Dispatch
        if var car = sportCarParking.first(where: {$0.vin == vin}) {
            car.sell()
            sportCarParking.removeAll(where: {$0.vin == vin})
        }
        if var car = crossOverCarParking.first(where: {$0.vin == vin}) {
            car.sell()
            crossOverCarParking.removeAll(where: {$0.vin == vin})
        }
        if var car = vanCarParking.first(where: {$0.vin == vin}) {
            car.sell()
            vanCarParking.removeAll(where: {$0.vin == vin})
        }
        if var car = sportCarParking.first(where: {$0.vin == vin}) {
            car.sell()
            sportCarParking.removeAll(where: {$0.vin == vin})
        }
    }
    
    mutating func addCar(car:SedanCar){//Static(Direct) Dispatch
        sedanCarParking.append(car)
    }
    
    mutating func addCar(car:SportCar){//Static(Direct) Dispatch
        sportCarParking.append(car)
    }
    
    mutating func addCar(car: VanCar){//Static(Direct) Dispatch
        vanCarParking.append(car)
    }
    
    mutating func addCar(car:CrossOverCar){//Static(Direct) Dispatch
        crossOverCarParking.append(car)
    }
    
}

public class Diller:Dillerable{
    
    public var sedanCarParking: [SedanCar] = []
    
    public var sportCarParking: [SportCar] = []
    
    public var vanCarParking: [VanCar] = []
    
    public var crossOverCarParking: [CrossOverCar] = []
    
    init(){
    }
}

public class CarFactory{
    private var name:String
    var diller: Diller?
    init(name: String, diller:Diller){
        self.name = name
        self.diller = diller
    }
    
    func buildCar(typeCar: TypeCar, country: Location, manufacture: Manufacture) {
        switch typeCar {
        case .Sedan:
            diller?.addCar(car: buildSedanCar(country: country, manufacture: manufacture, color: UIColor.blue))
        case .Sport:
            diller?.addCar(car: buildSportCar(country: country, manufacture: manufacture, color: UIColor.blue))
        case .Van:
            diller?.addCar(car: buildVanCar(country: country, manufacture: manufacture, color: UIColor.blue))
        case .CrossOver:
            diller?.addCar(car: buildCrossOverCar(country: country, manufacture: manufacture, color: UIColor.blue))
        }
    }
    
    func sellByVin(vin:String){
        diller?.sellByVin(vin: vin)
    }
    func generateVin() -> String{
        var vin = String()
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        for _ in 0...16 {
            vin += String(Array(letters)[Int.random(in: 0..<letters.count)])
        }
        return vin
    }
    
    private func buildSedanCar(country: Location, manufacture: Manufacture, color: UIColor) -> SedanCar {

        let car = SedanCar(country: country, manufacture: manufacture, vin: generateVin(), factory: self, color: color)
        return car
    }
    
    private func buildSportCar(country: Location, manufacture: Manufacture, color: UIColor) -> SportCar {
        let car = SportCar(country: country, manufacture: manufacture, vin: generateVin(), factory: self, color: color)
        return car
    }
    
    private func buildVanCar(country: Location, manufacture: Manufacture, color: UIColor) -> VanCar {
        let car = VanCar(country: country, manufacture: manufacture, vin: generateVin(), factory: self, color: color)
        return car
    }
    
    private func buildCrossOverCar(country: Location, manufacture: Manufacture, color: UIColor) -> CrossOverCar {
        let car = CrossOverCar(country: country, manufacture: manufacture, vin: generateVin(), factory: self, color: color)
        return car
    }

}

var d = Diller()
var cf = CarFactory(name: "dsadsa",diller: d)
cf.buildCar(typeCar: .Sedan, country: .JAPAN, manufacture: .Lexus)
