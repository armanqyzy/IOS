
import Foundation

// pers info
let firstName: String = "Anara"
let lastName: String = "Armankyzy"
let nickname: String = "anarittto"

let birthYear: Int = 2005
let currentYear: Int = 2026
var age: Int = currentYear - birthYear

let isStudent: Bool = true
let height: Double = 1.61
let country: String = "Kazakhstan"
let favEmoji: String = "💓"
var countriesVisited: Int = 5



// hobbies
let hobby: String = "travelling"
let secondHobby: String = "watching tv shows"
let thirdHobby: String = "chatting with people"

let numOfHobbies: Int = 3
let favNumber: Int = 8
let meaningNum: String = "luck"
let isHobbyCreative: Bool = true


// goals
let futureGoals: String = "an AI producer and travel around the world"
let countries: String = "Kazakhstan, Kyrgistsan, UAE, Turkey, USA"


// long long story about me

let lifeStory: String = """
My name is \(firstName) \(lastName). Or you can just call me \(nickname) 🤭

I am \(age) years old and i was born in \(birthYear). I live in \(country) and my height is \(height)metres. Good thing to know that my fav emoji is \(favEmoji), cute is not it? :)

I have visited in my life \(countriesVisited) countris. My visited countries are \(countries).

My favorite hobby is \(hobby), which is \(isHobbyCreative ? "a creative hobby" : "not very creative").

So everybody now knows that i really enjoy \(hobby) , so you might ask if I am student? \(isStudent ? "yes" : "no"). 

I also enjoy \(secondHobby) and \(thirdHobby). So if you can calculate hahaha in total, I have \(numOfHobbies) hobbies😅.
My favorite number is \(favNumber), they say that this number is for \(meaningNum) :).


In the future i want to become \(futureGoals).
I hope now you know better about me thank you so much for reading this blog! see you
"""

print(lifeStory)
