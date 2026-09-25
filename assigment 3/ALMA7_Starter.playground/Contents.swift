// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · Decoding Telemetry

// 1.1 here we need function that controlles one line and returns a Reading or nil

func parseReading(_ raw: String) -> Reading? {
    guard let parts = splitOnce(raw, by: ":"),
          parts.0.isEmpty == false,
          let value = Int(parts.1),
          value >= 0 || parts.0 == "TEMP"
    else { return nil }
    return (sensor: parts.0, value: value)
}
print("\n Lvl 1‼️")
print("\n 1.1 parseReading ")
print(parseReading("O2:87") as Any)
print(parseReading("TEMP:-12") as Any)
print(parseReading("RAD:-1") as Any)
print(parseReading(":55") as Any)
print(parseReading("O2:9x") as Any)

// 1.2 here we need to check all lines with function from 1.1 and return 2 things: good lines in list and bad lines in nums

func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0
    for line in lines {
        if let reading = parseReading(line) {
            valid.append(reading)
        } else {
            invalidCount += 1
        }
    }
    return (valid: valid, invalidCount: invalidCount)
}

print("\n 1.2 parseLog")
let parsed = parseLog(rawLog)
print("Valid: \(parsed.valid.count), invalid: \(parsed.invalidCount)")

let smallLog = parseLog(["O2:1", "bad", "TEMP:-5"])
print("Small log result: \(smallLog.valid.count) valid, \(smallLog.invalidCount) invalid.")
let validReadings = parsed.valid
let A = parsed.invalidCount
print("A = \(A)")


// MARK: Level 2 · Analysis
print("\n")
print("\nLvl 2‼️")

// 2.1 here we  keep only readings for which the closure returns true bool version and second is to ectract only values

func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var result: [Reading] = []
    for reading in readings {
        if isIncluded(reading) {
            result.append(reading)
        }
    }
    return result
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []
    for reading in readings {
        result.append(reading.value)
    }
    return result
}
print("\n 2.1 select / values")

let o2Readings = select(validReadings) { $0.sensor == "O2" }
print("O2 readings: \(o2Readings)")
print("O2 values:   \(values(of: o2Readings))")

let bigReadings = select(validReadings) { $0.value > 90 }
print("Values > 90: \(values(of: bigReadings))")


// 2.2 here we need to do 2 verisons functions to find min max avg

func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard let first = values.first else { return nil }
    var minValue = first
    var maxValue = first
    var sum = 0
    for value in values {
        if value < minValue { minValue = value }
        if value > maxValue { maxValue = value }
        sum += value
    }
    return (min: minValue, max: maxValue, average: Double(sum) / Double(values.count))
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

print("\n 2.2 stats ")
print(stats(3, 8, 1) as Any)
print(stats() as Any)
print(stats(of: [10, 20]) as Any)
print(stats(of: []) as Any)

let o2Stats = stats(of: values(of: o2Readings))
let B = Int(o2Stats?.average ?? 0)
print("B = \(B)")


// 2.3 · create a Closure Ladder (5 sorts every time gets shorter, and then compare results(same should be))
print("\n 2.3 Closure Ladder")

// 1. Full closure syntax with types and return
let sorted1 = validReadings.sorted(by: { (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})

// 2. Types inferred from context
let sorted2 = validReadings.sorted(by: { a, b in return a.value > b.value })

// 3. Implicit return
let sorted3 = validReadings.sorted(by: { a, b in a.value > b.value })

// 4. Shorthand argument names $0,$1
let sorted4 = validReadings.sorted(by: { $0.value > $1.value })

// 5. Trailing closure
let sorted5 = validReadings.sorted { $0.value > $1.value }


func sameReadings(_ a: [Reading], _ b: [Reading]) -> Bool {
    guard a.count == b.count else { return false }
    for i in 0..<a.count {
        guard a[i].sensor == b[i].sensor, a[i].value == b[i].value else {
            return false
        }
    }
    return true
}

let allSortsMatch = sameReadings(sorted1, sorted2) && sameReadings(sorted1, sorted3) && sameReadings(sorted1, sorted4) && sameReadings(sorted1, sorted5)

print("sorted: \(values(of: sorted5))")
print("all 5 sorts match: \(allSortsMatch)")


// MARK: Level 3 · Temperature Stabilization
print("\n Lvl 3‼️")

// 3.1 heat up, cool down, and hold and we have to write function that returns funciton
func heatUp(_ t: Int) -> Int { t + 5 }
func coolDown(_ t: Int) -> Int { t - 3 }
func hold(_ t: Int) -> Int { t }

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 {
        return heatUp
    } else if temp > 24 {
        return coolDown
    } else {
        return hold
    }
}
print("\n 3.1 protocols ")
print(heatUp(10), coolDown(10), hold(10))
print(chooseProtocol(for: 5)(5))
print(chooseProtocol(for: 30)(30))
print(chooseProtocol(for: 20)(20))

// 3.2 we need to take first temp and reapeat: choose protocol and use. stop when temp will be in in the safe range (18-24), but not forever, max steps =10. RETURN: final temp, how many stepps made, and if its stable

func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var temp = start
    var steps = 0
    while (temp < 18 || temp > 24) && steps < maxSteps {
            let applyProtocol = chooseProtocol(for: temp)
            temp = applyProtocol(temp)
            steps += 1
    }
    let isStable = temp >= 18 && temp <= 24
        return (finalTemp: temp, steps: steps, isStable: isStable)
}

print("\n 3.2 runUntilStable ")
print(runUntilStable(from: 31))
print(runUntilStable(from: -100, maxSteps: 5))
print(runUntilStable(from: 20))

let tempReadings = select(validReadings) { $0.sensor == "TEMP" }
let tempStats = stats(of: values(of: tempReadings))

let lowestTemp = tempStats?.min ?? 0
//? — может быть а может не быть
//?? — если нет то возьми запасной вариант

print("Lowest TEMP in log: \(lowestTemp)")
let C = runUntilStable(from: lowestTemp).steps
print("C = \(C)")


// MARK: Level 4 · The Crew
print("\n Lvl 4‼️")

// 4.1 return oxygen lvl from a crew, if module or tank is nil, the whole chain is nil

func oxygenLevel(of member: CrewMember) -> Int? {
    member.module?.oxygenTank?.level
}

print("\n 4.1 oxygenLevel ")

for member in crew {
    print(member.name, oxygenLevel(of: member) as Any)
}

// 4.2 return the status

func status(of member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        let location = member.module?.name ?? "open space"
        return "\(member.name): no data (\(location))"
    }

    if level < 20 {
        return "\(member.name): \(level)% CRITICAL"
    } else {
        return "\(member.name): \(level)% OK"
    }
}
print("\n 4.2 status ")
for member in crew {
    print(status(of: member))
}

// 4.3
let tankCapacity = 100

@discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    guard amount > 0 else { return 0 }

    var actual = amount

    if actual > source {
        actual = source
    }

    let freeSpace = tankCapacity - target
    if actual > freeSpace {
        actual = freeSpace
    }

    source -= actual
    target += actual
    return actual
}

print("\n 4.3 transferOxygen tests ")
var t1 = 50, t2 = 90
print(transferOxygen(from: &t1, to: &t2, amount: 30), t1, t2)

var t3 = 5, t4 = 0
print(transferOxygen(from: &t3, to: &t4, amount: 30), t3, t4)

var t5 = 50, t6 = 50
print(transferOxygen(from: &t5, to: &t6, amount: -10), t5, t6)

if let labTank = lab.oxygenTank, let habTank = hab.oxygenTank {
    let moved = transferOxygen(from: &labTank.level, to: &habTank.level, amount: 30)
    print("transferred \(moved) units Lab -> Hab")
} else {
    print("transfer failed: a tank is missing")
}

for member in crew {
    print(status(of: member))
}

let D = hab.oxygenTank?.level ?? 0
print("D = \(D)")



// 4.4
func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var found: [CrewMember] = []
    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }
        found.append(member)
    }
    found.sort { $0.priority < $1.priority }
    var result: [String] = []
    for member in found {
        result.append(member.name)
    }
    return result
}

print("\n 4.4 evacuationOrder ")
print(evacuationOrder("Dana", "Ghost", "Aigerim", "Timur", roster: roster))
print(evacuationOrder("Nurlan", "Timur", "Alien", roster: roster))


// MARK: Level 5 · The Saboteur's Logbook
print("\n Lvl 5‼️")

/*
 ORIGINAL (saboteur's) CODE — kept for reference:

func reportOxygen(for member: CrewMember) -> String {
    let tank = member.module!.oxygenTank!
    return "\(member.name): \(tank.level)%"
}

func firstCritical(in crew: [CrewMember]) -> String {
    var result: String?
    for member in crew {
        if oxygenLevel(of: member)! < 20 {
            result = member.name
        }
    }
    return result!
}

 PROBLEMS FOUND:

 reportOxygen:

1. member.module!
    This is dangerous because not every crew member has a module
    For example, Nurlan has module == nil because he is in open space.
    So trying to use ! here causes a crash: "Unexpectedly found nil"

  2. member.module!.oxygenTank!
    Even if the member has a module, it may not have an oxygen tank
    Dana is in the dock, and dock has no oxygen tank
    So this ! can also crash the program

  3. The function returns String, so there is no good way to say
  "this person has no oxygen data"
  instead of handling nil safely, the original code just crashes


  firstCritical:

  4. oxygenLevel(of: member)!
  This can crash when a crew member has no oxygen data
  Dana has no tank and Nurlan has no module, so their oxygen level is nil
  With the starter crew, the code crashes when it reaches Dana

  5. return result!
  If nobody is critical, result stays nil
  Then ! crashes the program.
  For example, this could happen if the crew is empty or everyone has enough oxygen.

  6. There is also logic problem
  The function is called firstCritical, so we want the FIRST critical crew member.
  But there is no break or return inside the loop.
  If several people are critical, result keeps getting replaced.
  So the function actually returns the LAST critical member

  7. The return type should be String?, not String.
  Why? Because sometimes nobody is critical
  In that case returning nil is completely normal
  String cannot represent "nobody found", but String? can

 */

// FIXED VERSIONS
func reportOxygen(for member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data"
    }
    return "\(member.name): \(level)%"
}

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        if let level = oxygenLevel(of: member), level < 20 {
            return member.name
        }
    }
    return nil
}


for member in crew {
    print(reportOxygen(for: member))     // here Dana and Nurlan not falls down the program
}
print(firstCritical(in: crew) ?? "none")
print(firstCritical(in: []) ?? "none")   // empty then no crush


let testModuleA = Module(name: "TestA", oxygenTank: Tank(level: 5))
let testModuleB = Module(name: "TestB", oxygenTank: Tank(level: 10))
let testCrew = [
    CrewMember(name: "NoData", role: "Test", priority: 1, module: nil),
    CrewMember(name: "Alpha",  role: "Test", priority: 2, module: testModuleA),
    CrewMember(name: "Beta",   role: "Test", priority: 3, module: testModuleB)
]
let firstFound = firstCritical(in: testCrew)
print(firstFound ?? "none")
print("Logic bug fixed: \(firstFound == "Alpha")")

// MARK: Finale · Launch Code
print("\n FINAL‼️‼️")

let launchCode = "\(A)-\(B)-\(C)-\(D)"
print("\nLAUNCH CODE: \(launchCode)")


// MARK: Bonus

func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var firedCount = 0

    return { level in
        guard level < threshold else {
            return false
        }
        firedCount += 1
        print("Alarm #\(firedCount)")
        return true
    }
}

print("\n Bonus‼️ ")
let alarm = makeAlarm(threshold: 20)
print(alarm(12))   // Alarm #1 -> true
print(alarm(40))   // false
print(alarm(5))    // Alarm #2 -> true
let otherAlarm = makeAlarm(threshold: 50)
print(otherAlarm(30))  // Alarm #1 -> true (its own, separate counter)


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. How does guard let differ from if let beyond syntax?
    Give an example where if let would make the code noticeably worse.

 if let unwrapped value is available only inside {}
 guard let it available after guard, in the rest of function
 
 in guard using else we need to must to leave (return, continue, break) because otherwise compiler will concern. so "early exit" is bad cases are handled in top, main code goes equally without unintended
 
    
 Example: parseReading with if let becomes a "pyramid of doom":
 
        if let parts = splitOnce(raw, by: ":") {
            if parts.0.isEmpty == false {
                if let value = Int(parts.1) {
                    if value >= 0 || parts.0 == "TEMP" {
                        return (parts.0, value)
                    }
                }
            }
        }
        return nil
    
 Four levels of nesting, and the happy path is buried deepest.

 2. Why can't you call stats(someArray) Where
    someArray: [Int], even though inside the function values is already [Int] ?
 
 Int... means give the numbers seperately with using coma:stats(1, 2, 3)
 swift takes and packs them in the [Int] (массив) and its inside the function.
 [Int] is a one value of a different type, and "spread" array unpacking into argument Swift cannot do that.
 So thats why we have two versions:stats(of: [Int]) for the array, and  variadic version just forwarfs to it.


 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5)
    compile? What bug does this prevent?

 
 Swift has a strict rule to not to give the same variable in to two inout in the same time, because both
 functions(source and target) would get right to change the same memory
 this called exclusivity rule.
 
 that protects from nonesence: function assumes 2 different tanks with the same variable
 source -= actual;
 target += actual
 that changes one tank twicely, function would add and minuse them from the same place,
 and the result would depend  from order, and transfer makes no sense
 (oxygen appears/disappears, the return value lies).

 

 4. Why doesn't oxygenLevel (of: dana) ?? "no data" compile?
     
 ?? in the left and in the right must to have the same type as the wrapped value
 oxygenLevel returns Int?, so means in the right Int has to be, and "no data" is the String
 Fix: convert first, e.g.
     if let level = oxygenLevel(of: dana) { "\(level)%" } else { "no data" }
 or use a String? on the left side.


 5. What is the full type of the function chooseProtocol itself?
    Write it out and explain how to read it.
    
    (Int) -> (Int) -> Int
    
 "function that takes Int (temp) and returns function that takes Int and returns Int"
 arrows groups from the right (Int) -> ((Int) -> Int)
 thats why whenever you call the function use to pairs of ()
 example:
 chooseProtocol(for: 30)(30)
 
 the first () choses the protocol, and secind applies it
 
 
6. THE BONUS: Explain: where does the counter physically live if makeAlarm has already returned?
  
 Usual local variable stored in the temporary memory of funciton (stack) and disapears after its done
 but, firedCount is captured returned closure that leaves longer that the funciton
 
 thats why swift transfers in longterm memory (heap) and returned closure holds reference to it
 
 counter lives while alarm lives, every new makeAlarm has own seperate independent counter

*/
