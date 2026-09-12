//easy lvl

//1
let fruits = ["strawberry", "banana", "blueberry", "grape", "raspberry"]
print(fruits[2])


//2
var favNums: Set<Int> = [8, 18, 28, 48]
favNums.insert(38)
print(favNums)

//3
let progLang = ["Swift": 2014, "Python": 1991, "SQL": 1978]

print(progLang["Swift"]!)

//4
var colors = ["red", "pink", "gray", "black"]
colors[1]="white"
print(colors)




// med lvl

//1
let firstSet: Set<Int> = [1, 2, 3, 4]
let secondSet: Set<Int> = [3, 4, 5, 6]

let intrs = firstSet.intersection(secondSet)

print(intrs)

//2
var stScore = ["Anara":98, "Nazerke":76, "Aruzhan":81]

stScore["Aruzhan"]=95
print(stScore)

//3
//You have two arrays: one contains [“apple”, “banana”] and the other contains [“cherry”, “date”]. Merge the two arrays into one and print the result.

var first = ["apple", "banana"]
var second = ["cherry", "date"]

let mrg=first+second
print(mrg)



//hard lvl

//1
var dict=["Kazakhstan":20000000, "India":1500000000, "USA":349000000 ]

dict["Russia"]=143000000

print(dict)


//2
let fst: Set<String>=["cat", "dog"]
let scnd: Set<String>=["dog", "mouse"]

let unionanimal=fst.union(scnd)
let subs=unionanimal.subtracting(scnd)
print(subs)


//3
var grades=["Anara":[97, 98, 100], "Zhanara":[66, 71, 69], "Aruzhan":[89, 85, 80]]

let aruzhan = grades["Aruzhan"]!
print(aruzhan[1])

