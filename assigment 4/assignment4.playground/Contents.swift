// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part2_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · The Deck Register

// 1.1
enum Deck: String, CaseIterable {
    case bridge, lab, cargo, medbay, engine

    var evacuationPriority: Int {
        switch self {
        case .bridge: return 1
        case .medbay: return 2
        case .lab:    return 3
        case .engine: return 4
        case .cargo:  return 5
        }
    }
}

print("\n LEVEL 1 · The Deck Register")
for deck in Deck.allCases {
    print("Deck \(deck.rawValue) -> evacuation priority \(deck.evacuationPriority)")
}

// 1.2
enum AlarmLevel: Int {
    case green = 0, yellow, orange, red
    static func level(forTotalMass mass: Int) -> AlarmLevel {
        let step = min(max(mass / 500, 0), 3)
        return AlarmLevel(rawValue: step) ?? .red
    }
}

print("AlarmLevel for 0 kg:    \(AlarmLevel.level(forTotalMass: 0))")
print("AlarmLevel for 940 kg:  \(AlarmLevel.level(forTotalMass: 940))")
print("AlarmLevel for 4000 kg: \(AlarmLevel.level(forTotalMass: 4000))")


// MARK: Level 2 · The Manifest

// 2.1
enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

// 2.2
func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)

    switch parts[0] {
    case "crate":
        if parts.count == 3, let id = Int(parts[1]), let massKg = Int(parts[2]) {
            return .crate(id: id, massKg: massKg)
        }
    case "container":
        if parts.count == 3, let massKg = Int(parts[2]) {
            return .container(code: parts[1], massKg: massKg)
        }
    case "livestock":
        if parts.count == 4, let count = Int(parts[2]), let perUnit = Int(parts[3]) {
            return .livestock(species: parts[1], count: count, massPerUnitKg: perUnit)
        }
    default:
        break
    }
    return .unknown(raw: line)
}

// 2.3
func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg):
        return massKg
    case .container(_, let massKg):
        return massKg
    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg
    case .unknown:
        return 0
    }
}

print("\n LEVEL 2 · Manifest")
var totalManifestMass = 0
var unknownLines = 0
for line in rawManifest {
    let entry = parseEntry(line)
    let entryMass = mass(of: entry)
    print("\"\(line)\" -> \(entry) -> \(entryMass) kg")
    totalManifestMass += entryMass
    if case .unknown = entry {
        unknownLines += 1
    }
}
print("Total manifest mass: \(totalManifestMass) kg")
print("Corrupted (.unknown) lines: \(unknownLines)")

let A = totalManifestMass


// MARK: Level 3 · Crew Snapshots
// record about crew shapshot, and data on the moment of time. copy of the snapshot must be independent - struct
// 3.1
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(_ amount: Int) {
        oxygen -= amount
        if oxygen < 0 {
            oxygen = 0
        }
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: name, deck: .medbay, oxygen: 100)
    }

    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

// 3.2
// we need to make from crewdata to massive (crewsnapshot) , deck take from deck(rawvalue), crew from not existing deck with alarm
func buildRoster(from records: [(name: String, deck: String, oxygen: Int)]) -> [CrewSnapshot] {
    var result: [CrewSnapshot] = []
    for record in records {
        if let deck = Deck(rawValue: record.deck) {
            result.append(CrewSnapshot(name: record.name, deck: deck, oxygen: record.oxygen))
        } else {
            print("WARNING: \(record.name) is assigned to unknown deck '\(record.deck)', skipped")
        }
    }
    return result
}

func findCrew(named name: String, in roster: [CrewSnapshot]) -> CrewSnapshot? {
    for member in roster {
        if member.name == name {
            return member
        }
    }
    return nil
}

print("\n LEVEL 3 · Crew Snapshots ")
let crewRoster: [CrewSnapshot] = buildRoster(from: crewData)
for member in crewRoster {
    print("Crew: \(member.name), deck \(member.deck.rawValue), oxygen \(member.oxygen)")
}

var testMember = CrewSnapshot.rookie(named: "Aliya")
print("Rookie: \(testMember.name) on \(testMember.deck.rawValue), oxygen \(testMember.oxygen)")
testMember.breathe(130)
print("After breathe(130): oxygen \(testMember.oxygen) (never below 0)")
testMember.move(to: .cargo)
print("After move(to: .cargo): deck \(testMember.deck.rawValue)")
testMember.reviveInMedbay()
print("After reviveInMedbay(): deck \(testMember.deck.rawValue), oxygen \(testMember.oxygen)")

// 3.3 · Value-semantics demonstration (copy / plain parameter / inout)
// 3 experiments and each has before and after
print("\n3.3 Value semantics ")

// 1) copy
//must copy all the data(change 100 to 60 and original stays 100)
var original = CrewSnapshot.rookie(named: "Dana")
print("[copy] BEFORE: original.oxygen = \(original.oxygen)")
var copyOfOriginal = original
copyOfOriginal.breathe(40)
print("[copy] AFTER:  copy.oxygen = \(copyOfOriginal.oxygen), original.oxygen = \(original.oxygen)  <- original unchanged")


// 2) plain parameter
//parameter fuction is constant (as if let) so inside we do var local=member (another copy)

func drainPlain(_ member: CrewSnapshot) {
    var local = member
    local.breathe(50)
    print("[plain] inside function: oxygen = \(local.oxygen)")
}
print("[plain] BEFORE: original.oxygen = \(original.oxygen)")
drainPlain(original)
print("[plain] AFTER:  original.oxygen = \(original.oxygen)  <- original unchanged")


// 3) inout
//fuction can change variable outside
func drainInPlace(_ member: inout CrewSnapshot) {
    member.breathe(50)
    print("[inout] inside function: oxygen = \(member.oxygen)")
}
print("[inout] BEFORE: original.oxygen = \(original.oxygen)")
drainInPlace(&original)
print("[inout] AFTER:  original.oxygen = \(original.oxygen)  <- original changed")


// MARK: Level 4 · The Teleport Pod

// 4.1
// Why a class: a pod is one physical machine. and everybody who holds the pod must
// see the same charge and the same occupant, so we need a reference type
//
// Why i write the init myself, because classes never get a memberwise initializer
// Structs do (level 3) because a struct cannot be inherited, so swift can safely
// generate init from the stored properties. for a class, the author must write
// an init that gives every stored property a value


final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    // Bonus 1
    deinit {
        print("  [deinit] TeleportPod \(id) is destroyed")
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        if let _ = occupant {
            return false
        }
        if chargeLevel < 20 {
            return false
        }
        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        guard let passenger = occupant else {
            return nil
        }
        chargeLevel -= 20
        occupant = nil
        return passenger
    }
}

// 4.2 · Charge ledger: load+fire three times, then fire an empty pod
print("\n LEVEL 4 · Teleport Pod ")
let ledgerPod = TeleportPod(id: "P-1", chargeLevel: 100)
print("Pod \(ledgerPod.id) start charge: \(ledgerPod.chargeLevel)")

var ledgerStep = 1
for name in ["Timur", "Dana", "Nurlan"] {
    if let member = findCrew(named: name, in: crewRoster) {
        let loaded = ledgerPod.load(member)
        if let arrived = ledgerPod.fire() {
            print("Step \(ledgerStep): load \(name) = \(loaded), fired \(arrived.name) -> charge \(ledgerPod.chargeLevel)")
        } else {
            print("Step \(ledgerStep): load \(name) = \(loaded), nothing fired -> charge \(ledgerPod.chargeLevel)")
        }
    } else {
        print("Step \(ledgerStep): \(name) not found in roster -> charge \(ledgerPod.chargeLevel)")
    }
    ledgerStep += 1
}

if let ghost = ledgerPod.fire() {
    print("Step 4: empty pod fired \(ghost.name)?? -> charge \(ledgerPod.chargeLevel)")
} else {
    print("Step 4: fire() on empty pod returned nil -> charge \(ledgerPod.chargeLevel)")
}

let C = ledgerPod.chargeLevel

// 4.3 · Reference-semantics demonstration
print("\n 4.3 Reference vs value")
let demoPod = TeleportPod(id: "P-2", chargeLevel: 100)
let samePod = demoPod
print("[class]  BEFORE: demoPod = \(demoPod.chargeLevel), samePod = \(samePod.chargeLevel)")
samePod.chargeLevel = 35
print("[class]  AFTER changing samePod: demoPod = \(demoPod.chargeLevel), samePod = \(samePod.chargeLevel)")

var snapOne = CrewSnapshot.rookie(named: "Timur")
var snapTwo = snapOne
print("[struct] BEFORE: snapOne = \(snapOne.oxygen), snapTwo = \(snapTwo.oxygen)")
snapTwo.oxygen = 35
print("[struct] AFTER changing snapTwo: snapOne = \(snapOne.oxygen), snapTwo = \(snapTwo.oxygen)")
// "rule: assigning a class copies the REFERENCE (both names point to one object), assigning a struct copies the VALUE (two independent snapshots)"


// MARK: Level 5 · Station Systems

// 5.1
// Why a class, because there is exactly one station and all systems must share its live state.
// station - class, because station is one and all the systems must see the same состояние
final class Station {
    // stored let
    let callSign: String

    // stored var (plain)
    var oxygenByDeck: [Deck: Int]

    // stored var with observers
    var hullIntegrity: Int {
        willSet {
            print("  [hull] willSet: \(hullIntegrity) -> \(newValue)")
        }
        didSet {
            if hullIntegrity > 100 {
                hullIntegrity = 100
            } else if hullIntegrity < 0 {
                hullIntegrity = 0
            }
        }
    }

    // built only on first access
    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        var report = "Diagnostics \(self.callSign):"
        for deck in Deck.allCases {
            if let oxygen = self.oxygenByDeck[deck] {
                report += " \(deck.rawValue)=\(oxygen)"
            }
        }
        report += " | hull=\(self.hullIntegrity)"
        return report
    }()

    // readonly
    var totalOxygen: Int {
        var sum = 0
        for (_, oxygen) in oxygenByDeck {
            sum += oxygen
        }
        return sum
    }

    // get + set
    var averageOxygen: Int {
        get {
            if oxygenByDeck.count == 0 {
                return 0
            }
            return totalOxygen / oxygenByDeck.count
        }
        set {
            for deck in Deck.allCases {
                if let _ = oxygenByDeck[deck] {
                    oxygenByDeck[deck] = newValue
                }
            }
        }
    }

    init(callSign: String, readings: [(deck: String, oxygen: Int)], hullIntegrity: Int) {
        self.callSign = callSign
        var map: [Deck: Int] = [:]
        for reading in readings {
            if let deck = Deck(rawValue: reading.deck) {
                map[deck] = reading.oxygen
            } else {
                print("  [station] skipped reading for unknown deck '\(reading.deck)'")
            }
        }
        self.oxygenByDeck = map
        self.hullIntegrity = hullIntegrity
    }
}

print("\n LEVEL 5 · Station Systems ")
let alma7 = Station(callSign: "ALMA-7", readings: deckReadings, hullIntegrity: 100)
print("Station \(alma7.callSign): \(alma7.oxygenByDeck.count) valid decks")
print("Total oxygen: \(alma7.totalOxygen)")
print("Average oxygen at start-up: \(alma7.averageOxygen)")

let B = alma7.averageOxygen

let spareStation = Station(callSign: "ALMA-8", readings: deckReadings, hullIntegrity: 90)
print("Spare station \(spareStation.callSign) created, fullDiagnostics never touched (no scan line for it)")

print("Before first access to fullDiagnostics")
print("1st access: \(alma7.fullDiagnostics)")

print("2nd access: \(alma7.fullDiagnostics)")

alma7.averageOxygen = 70
print("After averageOxygen = 70: total = \(alma7.totalOxygen), average = \(alma7.averageOxygen)")
print("Diagnostics still old (lazy is stored once): \(alma7.fullDiagnostics)")

// 5.2 · The clamp trap: 130, then -40, then 55
print("\n 5.2 Clamp trap ")
alma7.hullIntegrity = 130
print("hullIntegrity after 130: \(alma7.hullIntegrity)")
alma7.hullIntegrity = -40
print("hullIntegrity after -40: \(alma7.hullIntegrity)")
alma7.hullIntegrity = 55
print("hullIntegrity after 55:  \(alma7.hullIntegrity)")

// Why no infinite loop: assigning to a property inside its OWN didSet does not
// call willSet/didSet again. The new value simply replaces the one just stored.
// (That is also why "willSet" is printed only once per assignment above.)




// MARK: Level 6 · Incident Reports
// Three of these compile and are wrong. One does not compile.
// For each: expectation, actual behaviour, the language rule, the fix.

/*
// Report 1
var roster = crewRoster
for var member in roster {
    member.oxygen -= 10
}
print(roster[0].oxygen)   // author expected the crew to have lost oxygen

// Report 2
let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = podA
podB.chargeLevel = 0
print(podA.chargeLevel)   // author expected 100

// Report 3
struct Logbook {
    var entries: [String] = []
    func add(_ entry: String) {
        entries.append(entry)
    }
}

// Report 4
let snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40

let pod = TeleportPod(id: "B", chargeLevel: 50)
pod.chargeLevel = 10
*/

print("\n LEVEL 6 · Incident Reports")

// Report 1
// Expected: every crew member loses 10 oxygen, roster[0].oxygen becomes 52.
// Actual:   Timur was 62 and compiles, prints 62. Nothing changed
// Rule:     CrewSnapshot is a struct (value type).
//                for var member in roster
//           gives a COPY of each element. changing the copy does not touch the array

// Fix:      we need to go by indexes start with 0 until count-1 (0..<count)

// also crewRoaster itself does not change because report1Roster its his copy (arrays also value type)

var report1Roster = crewRoster
for var member in report1Roster {           // bug
    member.oxygen -= 10
}
print("Report 1 buggy: roster[0].oxygen = \(report1Roster[0].oxygen)")
// here we can see that roster[0] is 62 nothing changed


for index in 0..<report1Roster.count {      // fixed
    report1Roster[index].breathe(10)
}
print("Report 1 fixed: roster[0].oxygen = \(report1Roster[0].oxygen)")
// roster is 52 now

// Report 2
// Expected: podA keeps 100, only podB goes to 0.
// Actual:   podA compiles, and it prints 0.

// Rule:    so TeleportPod is a class. let podB=podA copies the link, and both variables are the same object pod

// Fix:      if needs independent pod then create new object thgrough teleportPod(..)

let report2PodA = TeleportPod(id: "A", chargeLevel: 100)
let report2PodB = report2PodA               // bug
report2PodB.chargeLevel = 0
print("Report 2 buggy: podA.chargeLevel = \(report2PodA.chargeLevel)")
// here shows that level is 0


report2PodA.chargeLevel = 100
let report2PodC = TeleportPod(id: "A-copy", chargeLevel: report2PodA.chargeLevel)   // fixed
report2PodC.chargeLevel = 0
print("Report 2 fixed: podA.chargeLevel = \(report2PodA.chargeLevel), new pod = \(report2PodC.chargeLevel)")
//now shows that podA=100, new is 0



// Report 3
// Expected: add(_:) adds to the logbook
// Actual:   DOES NOT COMPILE:
//           error: cannot use mutating member on immutable value: 'self' is immutable

// Rule:    in a usual method of struct "self" is a constant, a method that
//           changes a stored property must be marked "mutating"
// Fix: we need to add mutating before func. and logbook itself should be var, otherwise cannot call mutating method

struct Logbook {
    var entries: [String] = []
    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}
var fixedLogbook = Logbook()
print("Report 3 fixed: logbook starts with \(fixedLogbook.entries.count) entries")
fixedLogbook.add("Teleporter recalibrated")
fixedLogbook.add("Crew count verified")
print("Report 3 fixed: logbook now has \(fixedLogbook.entries.count) entries: \(fixedLogbook.entries)")

// Report 4

// Expected: both assignments work
// Actual:   "snapshot.oxygen = 40" does not compile:
//           error: cannot assign to property: 'snapshot' is a 'let' constant
//           `pod.chargeLevel = 10` compiles and works.


// Rule:    struct is the data, let freezes all the value even though var inside it. class variable stores only reference. let freezes only address: cannot write pod=anotherpod, but you can change var properties

// Fix:      declare the snapshot with var


var report4Snapshot = CrewSnapshot.rookie(named: "Dana") //var instead of let

report4Snapshot.oxygen = 40
print("Report 4 fixed: snapshot.oxygen = \(report4Snapshot.oxygen)")
let report4Pod = TeleportPod(id: "B", chargeLevel: 50)
report4Pod.chargeLevel = 10                 // let freezes the reference, not the object (so it worked before and it will work now)

print("Report 4: pod declared with let, chargeLevel changed to \(report4Pod.chargeLevel)")


// MARK: Level 7 · Sealing the Black Box

// The leaky original:
//
// class FlightRecorder {
//     var entries: [String] = []
//     var isSealed = false
// }
//
// Why a class: the black box is one physical recorder shared by every system.

final class FlightRecorder {
    // private: blocks all code outside this class from reading, replacing or clearing the list
    private var entries: [String] = []

    // private(set): blocks outside code from writing isSealed (it can only read it)
    private(set) var isSealed = false

    // internal: blocks only other modules; inside this app anyone may read the count
    internal var entryCount: Int {
        return entries.count
    }

    // internal: blocks only other modules; anyone in the app may read the transcript
    internal var transcript: String {
        var text = " FLIGHT RECORDER (\(isSealed ? "SEALED" : "open")) "
        var number = 1
        for entry in entries {
            text += "\n\(number). \(entry)"
            number += 1
        }
        return text
    }

    // internal: blocks only other modules; this is the one allowed way to add, refuses after sealing
    internal func add(_ entry: String) -> Bool {
        if isSealed {
            return false
        }
        entries.append(entry)
        return true
    }

    // internal: blocks only other modules, sealing works one way, there is no "unseal"
    internal func seal() {
        isSealed = true
    }

    // fileprivate: blocks code in other files, lets auditTranscript (same file) read a copy of the raw entries
    fileprivate func rawEntries() -> [String] {
        return entries
        // returns a copy (Array is a value type), the original stays safe
    }
}

// A free function elsewhere in the file that uses the fileprivate helper
func auditTranscript(of recorder: FlightRecorder) -> String {
    let raw = recorder.rawEntries()
    var longest = ""
    for entry in raw {
        if entry.count > longest.count {
            longest = entry
        }
    }
    return "AUDIT: \(raw.count) raw entries, sealed = \(recorder.isSealed), longest entry = \"\(longest)\""
}

print("\n LEVEL 7 · Black Box")
let blackBox = FlightRecorder()
print("Added 'Day 10: teleporter fired': \(blackBox.add("Day 10: teleporter fired"))")
print("Added 'Crew duplicated on two decks': \(blackBox.add("Crew duplicated on two decks"))")
print("Entries: \(blackBox.entryCount), sealed: \(blackBox.isSealed)")
blackBox.seal()
print("After seal, add 'Nothing happened' -> \(blackBox.add("Nothing happened"))")
print("Entries: \(blackBox.entryCount), sealed: \(blackBox.isSealed)")
print(blackBox.transcript)
print(auditTranscript(of: blackBox))

// Attempts to break the recorder from outside (they do not compile):
//
// blackBox.entries = []
//   error: 'entries' is inaccessible due to 'private' protection level
//
// blackBox.entries.removeAll()
//   error: 'entries' is inaccessible due to 'private' protection level
//
// blackBox.isSealed = false
//   error: cannot assign to property: 'isSealed' setter is inaccessible


// MARK: Finale · Integrity Code

print("\n FINALE")

let D = AlarmLevel.level(forTotalMass: A).rawValue
print("A = \(A) (total manifest mass)")
print("B = \(B) (starting average oxygen)")
print("C = \(C) (pod charge after the ledger)")
print("D = \(D) (alarm level \(AlarmLevel.level(forTotalMass: A)))")
let integrityCode = "\(A)-\(B)-\(C)-\(D)"
print("INTEGRITY CODE: \(integrityCode)")


// MARK: Bonus

print("\n BONUS ")

// Bonus 2 · deinit and the do-block
var survivor: TeleportPod? = nil
print("Before the do block")
do {
    let tempPod = TeleportPod(id: "TMP-1", chargeLevel: 30)
    survivor = tempPod
    
    let lonelyPod = TeleportPod(id: "TMP-2", chargeLevel: 30)
    
    print("Inside the do block: \(tempPod.id) and \(lonelyPod.id) exist")
}   // deinit of TMP-2 fires here: its only reference (lonelyPod) goes out of scope
print("After the do block: TMP-1 is still alive because `survivor` holds it")
survivor = nil                                      // <- deinit of TMP-1 fires here: last reference removed


print("After survivor = nil")

// Why deinit fires on?
//   TMP-2: on the closing brace of the do block (its only reference ends there).
//   TMP-1: on the line survivor = nil (the last strong reference is removed

// ARC (automatic reference counting): in every class object it counts strong references. when variable indicates on object then counter +1. when variable dissapears or becomes nil then counter is -1. whenever it becomes 0, the object deletes or calls deinit.


// Bonus 3 · identity (===) vs equal contents
func sameOccupant(_ first: CrewSnapshot?, _ second: CrewSnapshot?) -> Bool {
    if let a = first, let b = second {
        return a.name == b.name && a.deck == b.deck && a.oxygen == b.oxygen
    }
    return first == nil && second == nil
}

func comparePods(_ first: TeleportPod, _ second: TeleportPod) -> String {
    if first===second {
        return "SAME pod (two references to one object)"
    }
    if first.id == second.id && first.chargeLevel == second.chargeLevel
        && sameOccupant(first.occupant, second.occupant) {
        return "TWO different pods with equal contents"
    }
    return "TWO different pods with different contents"
}

let recordOne = TeleportPod(id: "P-9", chargeLevel: 80)
let recordTwo = recordOne
let recordThree = TeleportPod(id: "P-9", chargeLevel: 80)
print("recordOne vs recordTwo:   \(comparePods(recordOne, recordTwo))")
print("recordOne vs recordThree: \(comparePods(recordOne, recordThree))")
print("recordOne vs ledgerPod:   \(comparePods(recordOne, ledgerPod))")


// Why  === cannot be used on CrewSnapshot at all?

// let me explain first === what means
// === asks is this the same object in memory, and == asks is the inside is the same?

// struct does not has identity, every assigment creates independent copy and no shared object to compare. Compiler will not let to write snapOne===snapTwo because === works only with class objects




// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why did CrewSnapshot get an initializer for free and TeleportPod did not?
 
 Structs automatically get a free memberwise init on all sotred properties: CrewSnapshot(name:deck:oxygen:)
    
Classes never get a memberwise init (only an empty init() when every property has a default value)
 
 
TeleportPod has id and chargeLevel without defaults, so I must write init(id:chargeLevel:) myself
 
 if I wrote my own init inside the struct, the free one would disappear
 
 
 

 2. What does mutating do to self, and why do classes never need it?
 
 
In a usual struct method, self is a constant copy.
mutating makes self an inout parameter:
the method may change properties or even replace self completely (self = CrewSnapshot(...) in reviveInMedbay), and the result is written back to the variable.
 
 That is why a mutating method cannot be called on a let struct.
 
 In a class, self is a reference, the method changes the object on the heap, not the reference, so mutating is not needed.

 
 
 
 3. In Report 4 both values are let. What exactly does let freeze?
 
Struct freezes the whole value. The value IS the data, so no property
(even a var one) can change:  snapshot.oxygen = 40  leads to error
 
Class freezes only the reference (the "address").
pod must always point to the same pod and you cannot address to different pod
but that pod's var properties can change:

pod.chargeLevel = 10 leads to OK
pod = TeleportPod(id: "C", chargeLevel: 1) is error.
 

 
 4. Why must a lazy property be var? When does lazy change behaviour?
    
A lazy property has no value when init finishes it gets its value later
 
let must have its value by the end of init and can never be set afterwards, so lazy must be var
    
Behaviour change (not just speed):
fullDiagnostics takes a snapshot at the moment of first access.
In my output I read it, then set averageOxygen = 70, and fullDiagnostics still shows the old numbers.

 If I had set 70 BEFORE the first access, the report would show 70.
 
 Also "Running full scan..." is printed only if someone touches it (never for spareStation): side effects move or disappear.
 
 

 5. private vs fileprivate: where would private be too strict?
    
 
auditTranscript(of:) is a free function outside the FlightRecorder type but in
the same fileб and it needs the raw entry list.
 
If rawEntries() were private, only code inside FlightRecorder could call it and auditTranscript would not compile.
    
fileprivate opens it to this file only, while entries itself stays private,
    so nobody can replace or clear the list


*/
