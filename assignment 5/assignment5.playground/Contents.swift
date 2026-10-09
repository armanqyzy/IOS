// =============================================================
//  Station ALMA-7, Part III: The Repair Fleet
//  iOS Mobile Development · Module 5 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part3_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section. LegacyBeacon in
//     particular must be reached with an extension, not edited.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • The Health Rule must exist in exactly ONE place in this file.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
/// One `kind` does not correspond to any drone type you will build.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this
/// declaration — no methods, no protocols, no properties.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================

// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · The Power Cell

// Why a class and not a struct here?

// A power cell is one physical battery that drone and 
// else holding it need to share, so we need reference semantics (one
// object, many references) instead of value semantics (every copy gets his own charge)

final class PowerCell {
    private var charge: Int

    init(charge: Int) {
        if charge < 0 {
            self.charge = 0
        } else if charge > 100 {
            self.charge = 100
        } else {
            self.charge = charge
        }
    }


    func level() -> Int {
        return charge
    }

    func spend(_ amount: Int) -> Bool {
        if amount <= 0 || amount > charge {
            return false
        }
        charge -= amount
        return true
    }

    func recharge(by amount: Int) {
        if amount <= 0 {
            return
        }
        charge += amount
        if charge > 100 {
            charge = 100
        }
    }
}

let cell = PowerCell(charge: 50)
print("Test cell level: \(cell.level())")

// Then prove the encapsulation works: write cell.charge = 100 outside the class, run it,
// leave the line commented out with the exact compiler error:

// cell.charge = 100
// error: 'charge' is inaccessible due to 'private' protection level


// MARK: Level 2 · The Fleet

// 2.1  What does `final` on runOnce() buy you?

// No subclass can override runOnce(), so the shift ritual
// (spend powerCost -> if it fails return 0 -> otherwise performTask())
// is guaranteed to be the same for every drone, subclasses can only change cost and work



class Drone {
    let id: String
    let cell: PowerCell

    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }

    var powerCost: Int { 10 }

    var statusLine: String {
        return "\(id): \(cell.level())% \(cell.level().powerBar)"
    }

    func performTask() -> Int { 0 }

    final func runOnce() -> Int {
        if cell.spend(powerCost) == false {
            return 0
        }
        return performTask()
    }

    var canWorkAgain: Bool {
        return cell.level() >= powerCost
    }
}

// 2.2
final class WelderDrone: Drone {
    override var powerCost: Int { 25 }
    override func performTask() -> Int { 40 }

    func weldSeam() -> String {
        return "\(id) welded a hull seam"
    }
}

class ScannerDrone: Drone {
    override var powerCost: Int { 10 }
    override func performTask() -> Int { 15 }

    override var statusLine: String {
        return super.statusLine + " [scanner]"
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int { 20 }
    override func performTask() -> Int { 25 }
}

// 2.3
func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)
    switch kind {
    case "welder":
        return WelderDrone(id: id, cell: cell)
    case "scanner":
        return ScannerDrone(id: id, cell: cell)
    case "cargo":
        return CargoDrone(id: id, cell: cell)
    default:
        return nil
    }
}

var builtFleet: [Drone] = []
for record in fleetData {
    if let drone = makeDrone(kind: record.kind, id: record.id, charge: record.charge) {
        builtFleet.append(drone)
    } else {
        print("WARNING: unknown drone kind '\(record.kind)' for record \(record.id), skipped.")
    }
}
let fleet: [Drone] = builtFleet
print("Fleet built: \(fleet.count) drones.")


// MARK: Level 3 · The Shift

func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    var totalWork = 0
    if rounds <= 0 {
        return 0
    }
    for _ in 1...rounds {
        for drone in fleet {
            totalWork += drone.runOnce()   
        }
    }
    return totalWork
}

print("\nSHIFT (3 rounds):")
let A = runShift(fleet, rounds: 3)

var chargeSum = 0
var readyCount = 0
for drone in fleet {
    print(drone.statusLine)
    chargeSum += drone.cell.level()
    if drone.canWorkAgain {
        readyCount += 1
    }
}
print("\nDrones that can run one more task: \(readyCount)")

let B = chargeSum
let C = readyCount
print("A (work units) = \(A), B (charge left) = \(B), C (ready drones) = \(C)")


// MARK: Level 4 · Diagnostics

// 4.1
protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

// 4.2
protocol Rechargeable {
    mutating func recharge(by amount: Int)
}

// Why does Drone implement recharge(by:) without `mutating`?

// Drone is a class (a reference type), a method changes
// the object the reference points to, never the reference
// itself, so 'mutating' has no meaning for classes.
// Here it doesn't even change the drone, only the powercell object it holds


extension Drone: Diagnosable, Rechargeable {
    var componentID: String { id }
    
    var statusCode: Int { healthCode(for: cell.level()) }

    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct SensorModule: Diagnosable, Rechargeable {
    let componentID: String
    var chargeLevel: Int

    var statusCode: Int { healthCode(for: chargeLevel) }

    mutating func recharge(by amount: Int) {
        if amount <= 0 {
            return
        }
        chargeLevel += amount
        if chargeLevel > 100 {
            chargeLevel = 100
        }
    }
}

var sensors: [SensorModule] = []
for record in sensorData {
    sensors.append(SensorModule(componentID: record.id, chargeLevel: record.charge))
}

var testSensor = SensorModule(componentID: "test", chargeLevel: 95)
testSensor.recharge(by: 20)
print("\nTest sensor after recharge(by: 20): \(testSensor.chargeLevel)")


// 4.3
// Why could [Drone] never have held the sensors?

// [Drone] only holds drone objects and its subclasses, and
// SensorModule is a struct that cannot inherit from a class,
// so only common type of drones and sensors is protocol Diagnosable



func diagnosticsReport(_ components: [Diagnosable]) -> String {
    var report = "DIAGNOSTICS: \(components.count) components"
    for component in components {
        report += "\n" + component.diagnose()
    }
    return report
}

var components: [Diagnosable] = []
for drone in fleet {
    components.append(drone)
}
for sensor in sensors {
    components.append(sensor)
}

print("")
print(diagnosticsReport(components))


// MARK: Level 5 · Shared Behaviour

// 5.1 · default diagnose() + the single home of the Health Rule

extension Diagnosable {
    func diagnose() -> String {
        return "\(componentID): code \(statusCode)"
    }
    
    
    
//health rule
    func healthCode(for level: Int) -> Int {
        if level < 20 {
            return 2 // critical
        }
        if level < 50 {
            return 1 // warning
        }
        return 0 // nominal
    }
}



// 5.2 · the beacon you cannot edit

extension LegacyBeacon: Diagnosable {
    var componentID: String { name }

    var statusCode: Int { healthCode(for: signalStrength) }

    func diagnose() -> String {
        return "[LEGACY] \(componentID): signal \(signalStrength), code \(statusCode)"
    }
}

components.append(beacon)
print("")
print(diagnosticsReport(components))

func totalStatusCode(_ components: [Diagnosable]) -> Int {
    var sum = 0
    for component in components {
        sum += component.statusCode
    }
    return sum
}

let D = totalStatusCode(components)
print("D (sum of status codes) = \(D)")

// 5.3
extension Int {
    var powerBar: String {
        var filled = self / 10
        if filled < 0 {
            filled = 0
        }
        if filled > 10 {
            filled = 10
        }

        var bar = ""
        for i in 0..<10 {
            if i < filled {
                bar += "#"
            } else {
                bar += "."
            }
        }
        return bar
    }
}

print("\npowerBar check: 42 -> \(42.powerBar), -5 -> \((-5).powerBar), 250 -> \(250.powerBar)")


// MARK: Level 6 · Incident Reports
// Two of these do not compile. Two compile and lie.
// For each: expectation, actual behaviour, the language rule, the fix

/*
// Report 1
class PatchDrone: Drone {
    func performTask() -> Int {
        return 30
    }
}

// Report 2
final class HeavyWelder: WelderDrone {
    override func runOnce() -> Int {
        return 999
    }
}

// Report 3
let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]
print(first.weldSeam())

// Report 4
protocol Labelled {
    var componentID: String { get }
}

extension Labelled {
    func label() -> String { "generic component" }
}

struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}

let parts: [Labelled] = [Thruster(componentID: "T-1")]
print(parts[0].label())
*/

/*
 REPORT 1 (PatchDrone)
   Expected: PatchDrone produces 30 work units for one task.
   Actual:   does not compile: "overriding declaration requires an 'override' keyword".
   Rule:     to replace a parent's method you must write 'override'
   Fix:      override func performTask() -> Int { return 30 }

 REPORT 2 (HeavyWelder)
   Expected: HeavyWelder returns 999 every time
   Actual:   does not compile. "inheritance from a final class 'WelderDrone'", and even if
             WelderDrone were not final: "instance method overrides a 'final' instance method"
             (runOnce() is final in Drone).
   Rule:     'final' forbids subclassing / overriding
   Fix:      do not touch the ritual. Change the work instead, and inherit from Drone:
             final class HeavyWelder: Drone {
                 override var powerCost: Int { 25 }
                 override func performTask() -> Int { 60 }
             }

 REPORT 3 (weldSeam() on a [Drone])
   Expected: prints the weld message, because the object really is a WelderDrone.
   Actual:   does not compile: "value of type 'Drone' has no member 'weldSeam'"
   Rule:     the array type is [Drone], so the compiler only allows Drones methods
   Fix:      ask at runtime with a conditional cast (code below, it runs).
             'as?' returns an optional because the cast can fail, the element might be a
             scanner or cargo drone, result is nil

 REPORT 4 (Thruster label)
   Expected: "thruster T-1".
   Actual:   compiles but prints "generic component"
   Rule:     label() is not in protocol, it only exists in the extension.
             the compiler looks at the variables type (Labelled, not Thruster) and calls the
             extensions version. Only protocol requirements are dispatched dynamically
             to the real types implementation.
   Fix:      add the method to the protocol as a requirement:
             protocol Labelled {
                 var componentID: String { get }
                 func label() -> String          // <- this line
             }
             Now it prints "thruster T-1". (This is exactly why diagnose() is declared in
             Diagnosable, because otherwise the beacons custom diagnose() would be ignored too.)

*/

// Report 3, fixed version:
let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]
if let welder = first as? WelderDrone {
    print("\nReport 3 fixed: \(welder.weldSeam())")
}


// MARK: Finale · Mission Code

let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("\nMISSION CODE: \(missionCode)")


// MARK: Bonus

/*
1) Two ways to forbid using Drone directly;

(a) Runtime way (program crashes when it runs):
 I can put fatalError inside performTask() of Drone:
 
    func performTask() -> Int {
        fatalError("Don't use Drone, use WelderDrone, ScannerDrone or CargoDrone")
    }
        
 Drone(id:cell:) still can be created, the compiler says nothing.
 But when plain Drone works in the shift, the program stops with this message.
 Subclasses override performTask(), so for them it is fine.

 
 (b) Compile time way (Xcode shows error before running):
     
 I can make Drone a protocol instead of a class.
 You cannot create a protocol, so if somebody writes DroneUnit(...),
 Xcode shows an error right away. Also every drone must write its own
 powerCost and performTask(), otherwise it also does not compile.

*/

// 2) Same idea but with protocol + struct
protocol DroneUnit {
    var id: String { get }
    var charge: Int { get set }
    var powerCost: Int { get }
    func performTask() -> Int
}

extension DroneUnit {
    // runOnce is written one time here, and all drones use it
    mutating func runOnce() -> Int {
        if charge < powerCost {
            return 0
        }
        charge -= powerCost
        return performTask()
    }
}

struct WelderUnit: DroneUnit {
    let id: String
    var charge: Int
    var powerCost: Int { 25 }
   
    func performTask() -> Int { 40 }
}

var bonusWelder = WelderUnit(id: "W-1", charge: 80)
var bonusWork = 0
for _ in 1...3 {
    bonusWork += bonusWelder.runOnce()
}
print("Bonus (struct welder): work \(bonusWork), charge left \(bonusWelder.charge)")

/*
 3) Comparison
class version: all drones get id and cell from Drone, and runOnce() is final,
so nobody can change the rule. But anybody can still write Drone(...)
    
protocol version: you cant create a plain DroneUnit, and it works with structs.
But runOnce() in extension cant be final, so a struct can write its own runOnce()
(same problem like in report 4).

i would choose classes for this station. Drones have a battery that changes all
the time. With class everybody works with the same battery. With struct every
copy has its own charge, so if i change a copy, the original drone doesnt change.

 
*/


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why does a class satisfy a 'mutating' protocol requirement without the
    keyword, while a struct must write it?

Struct is a value type. If a method changes a property of a struct,
it changes the whole struct, so Swift wants the word mutating.
Class is a reference type. Variable keeps only a link to the object,
and methods can change properties of the object any time.
Thats why classes dont need mutating at all.

 2. One thing inheritance does that protocols cannot, and one thing
    protocols do that inheritance cannot:

Inheritance: subclass gets ready properties and init from parent.
WelderDrone has id and cell from Drone and I didnt write them again.
Also I can call super, like in ScannerDrone statusLine.
Protocols: they work for classes, structs and even for types I cant change.
Drone (class), SensorModule (struct) and LegacyBeacon all are Diagnosable.
With inheritance its impossible, struct cant inherit from class.

 3. What does 'final' prevent, and what did it protect in runOnce()?

final on a class: nobody can make a subclass from it.
final on a method: subclasses cant override it.
In runOnce() it protects the rule "first pay powerCost, then work".
So no drone can work without charge, like HeavyWelder in Report 2
wanted to return 999 always.

 4. In Report 4, why did the protocol extension's method win?

Because label() is not written inside the protocol, it is only in extension.
parts is [Labelled], so Swift looks only at type Labelled and takes
label() from the extension. It doesn't check that inside is Thruster.
If I add func label() -> String in the protocol, Swift will check the real
type and print "thruster T-1".

 
 
 */
