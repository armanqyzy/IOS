import Cocoa

var array: [Int] = [1, 2, 3]
let set: Set<String> = ["John", "Sam", "Sam"]
var dict: [String: Int] = ["Mom": 1111, "Dad": 2222, "Boss": 1234]

dict["Mom"] = 1212
dict["Son"] = 3131

array.append(4)
array.remove(at: 0)
array.append(contentsOf: [5, 6])

//array.forEach { number in print("Item: \(number)") }

//print(array.count)
//print(array)

//print(array[5])
//print(dict["Dada"])


/// If - Examples

//let number = 6
//
///// Variant 1
//if number.isMultiple(of: 2) {
//    print("Even")
//} else if number.isMultiple(of: 3) {
//    print("Fizz")
//} else {
//    print("Buzz")
//}
//
///// Varian 2
//if number.isMultiple(of: 2) {
//    print("Even")
//}
//if number.isMultiple(of: 3) {
//    print("Fizz")
//} else {
//    print("Buzz")
//}
//
//if true && false { // AND
//    print("Success")
//}
//
//if true || false { // OR
//    print("Success")
//}

/// For Loops - Example
let colors = ["Red", "Blue", "Orange", "Cyan"]

//for color in colors {
//    print(color)
//}

//for (index, color) in colors.enumerated() {
//    print("Index: \(index) - Color: \(color)")
//}

//for i in stride(from: 0, to: colors.count, by: 1) {
//    print(colors[i])
//}

//for j in stride(from: colors.count - 1, through: 0, by: -1) {
//    print(colors[j], terminator: ", ")
//}

//for i in 0...colors.count - 1 {
//    print(colors[i])
//}

//for i in stride(from: 0, to: 10, by: 1) {
//    print("i: \(i)")
//}
//
//for j in stride(from: 0, through: 10, by: 1) {
//    print("j: \(j)")
//}

var moviesByRatings = ["Spider-Man": 7, "Odyssey": 9, "Astral": 10]
let smile = "😀"
let emoji = ["⚡️", "🔋", "🚀"]

//for (title, rating) in moviesByRatings {
//    let starIcon: String = "⭐️"
//    var finalRating = ""
//    for _ in 1...rating {
//        finalRating.append(starIcon)
//    }
//
//    print("Movie: \(title) - IMDB: \(finalRating)")
//}
//var number = 11


/// While Loops
//while number < 10 {
//    number += 1 // number = number + 1
//    print("Doing...")
//}
//
//repeat {
//    number += 1
//    print("DO Doing")
//} while number < 10

/// Switch - Example

let temperature: Double = 1

switch temperature {
case 30...:
    print("😎")
case 20..<30:
    print("⛅️")
case 15..<20:
    print("☁️")
case 10..<15:
    print("🌧️")
default:
    print("❄️")
}

enum Season {
    case winter
    case spring
    case autumn
    case summer
}

let season: Season = .autumn

switch season {
case .autumn:
    break
case .spring:
    break
case .summer:
    break
case .winter:
    break
}

let char = "a"

switch char {
case "a", "e", "o", "u", "i":
    print("Vowels")
default:
    print("Consonant")
}
