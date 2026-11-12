//
//  FavoritesData.swift
//  FavoritesNavigator
//
//  Created by Anara Arman on 12.11.2026.
//

import Foundation

struct FavoritesData {

    static let items: [FavoriteItem] = [
        FavoriteItem(
            title: "Golden Gate Bridge",
            subtitle: "San Francisco, CA",
            imageName: "golden_gate",
            rating: 5,
            description: "Fun fact: the famous orange color was supposed to be temporary. It was just a primer, and the Navy actually wanted to paint the bridge black and yellow! San Francisco fog is so famous that locals even gave it a name, Karl. I saw it at sunset, and the red towers against the pink sky looked unreal."
        ),
        FavoriteItem(
            title: "Alcatraz Island",
            subtitle: "San Francisco, CA",
            imageName: "alcatraz",
            rating: 4,
            description: "In 1962 three prisoners escaped from here and were never found. They made fake heads out of soap, paper and real hair and left them in their beds so the guards would think they were sleeping. Even Al Capone was locked up here, and he played the banjo in the prison band"
        ),
        FavoriteItem(
            title: "Times Square",
            subtitle: "New York, NY",
            imageName: "times_square",
            rating: 4,
            description: "More than 300k people walk through it every single day. At night the screens are so bright that you forget it is dark outside. Dream: take a photo with a flag your country"
        ),
        FavoriteItem(
            title: "Statue of Liberty",
            subtitle: "New York, NY",
            imageName: "statue_of_liberty",
            rating: 5,
            description: "The statue was not always green! It was made of shiny brown copper, and it slowly turned green over about 30 years because of the air and the sea water. At her feet there is a broken chain that is hard to see from the ground. Seeing her from the ferry with the city behind was one of my favorite moments of the whole trip."
        ),
        FavoriteItem(
            title: "Lincoln Memorial",
            subtitle: "Washington, D.C.",
            imageName: "lincoln_memorial",
            rating: 4,
            description: "People say his hands show the letters A and L in sign language, but nobody knows if the sculptor really planned that. You can also find this building on the back of the five dollar bill. Inside it is so quiet that everyone starts whispering."
        ),
        FavoriteItem(
            title: "U.S. Capitol",
            subtitle: "Washington, D.C.",
            imageName: "capitol",
            rating: 4,
            description: "The whole city of Washington is divided into four parts, and the Capitol is right in the center of them. That is why street addresses in D.C. end with NW, NE, SW or SE. I was sick that day, and could not watch it in details.."
        ),
        FavoriteItem(
            title: "Las Vegas Strip",
            subtitle: "Las Vegas, NV",
            imageName: "vegas_strip",
            rating: 5,
            description: "most of the Las Vegas Strip is not actually in the city of Las Vegas, it is in a town called Paradise! The famous Welcome sign was designed in 1959 and was never copyrighted, so anyone can use it. Be ready to stand in the line."
        ),
        FavoriteItem(
            title: "Bellagio Fountains",
            subtitle: "Las Vegas, NV",
            imageName: "bellagio",
            rating: 5,
            description: "The fountains can shoot water almost 140 meters into the air, higher than a 40 floor building. The show is free and the water dances to music, from Sinatra to pop songs. Right across the street there is a half size copy of the Eiffel Tower, so you get Paris and Vegas in one photo."
        ),
        FavoriteItem(
            title: "Hollywood Sign",
            subtitle: "Los Angeles, CA",
            imageName: "hollywood_sign",
            rating: 3,
            description: "The sign first said HOLLYWOODLAND and was just an advertisement for new houses. The last four letters were removed in 1949. Each letter is about 14 meters tall, and it is actually illegal to walk right up to them. I liked seeing it from far away at sunset, it looked like a movie scene."
        ),
        FavoriteItem(
            title: "Santa Monica Pier",
            subtitle: "Los Angeles, CA",
            imageName: "santa_monica",
            rating: 4,
            description: "If you ever played GTA V, you already know this place. it looks almost exactly the same, with the Ferris wheel and the roller coaster. Honestly, you will not need 2GIS here, your GTA memory will show you the way."
        ),
        FavoriteItem(
            title: "South Rim",
            subtitle: "Grand Canyon, AZ",
            imageName: "grand_canyon_south_rim",
            rating: 5,
            description: "The rocks at the bottom of the canyon are almost 2 billion years old. The canyon is so deep that it has its own weather, and at the bottom it can be much hotter than at the top. Pictures really do not show how huge it is, I just stood there and could not say anything."
        ),
        FavoriteItem(
            title: "Mather Point",
            subtitle: "Grand Canyon, AZ",
            imageName: "mather_point",
            rating: 5,
            description: "Mather Point is where most people see the Grand Canyon for the first time, and many of them get emotional. In some places the canyon is up to 29 kilometers wide, so the other side looks like a painting. The colors change every hour as the sun moves, from pink to orange to deep red."
        ),
        FavoriteItem(
            title: "Horseshoe Falls",
            subtitle: "Niagara Falls",
            imageName: "horseshoe_falls",
            rating: 5,
            description: "In 1901 a 63 year old teacher named Annie Taylor went over these falls in a wooden barrel and survived. She was the first person ever to do it, and she did it on her birthday! The falls are so powerful that you feel the mist on your face from far away, and at night they are lit up in rainbow colors."
        ),
        FavoriteItem(
            title: "Maid of the Mist",
            subtitle: "Niagara Falls",
            imageName: "maid_of_the_mist",
            rating: 5,
            description: "These boats have been taking people to the falls since 1846. Everyone gets a blue raincoat, but trust me, you still get completely wet. The boat goes so close that the noise is crazy loud and you can barely see anything because of the water."
        ),
        FavoriteItem(
            title: "Ocean City Boardwalk",
            subtitle: "Ocean City, MD",
            imageName: "oc_boardwalk",
            rating: 4,
            description: "The famous Thrasher's French fries have been sold here since 1929, and they only come with salt and vinegar. The boardwalk is about 4.5 kilometers long, so we walked a lot."
        ),
        FavoriteItem(
            title: "Ocean City Beach",
            subtitle: "Ocean City, MD",
            imageName: "oc_beach",
            rating: 3,
            description: "Only about 7k people live in Ocean City all year, but in summer they are 300k visitors. The seagulls here are very brave and will steal your food right out of your hands. Watching the sunset from the boardwalk with seagulls flying around was so peaceful."
        ),
        FavoriteItem(
            title: "Rehoboth Boardwalk",
            subtitle: "Rehoboth Beach, DE",
            imageName: "rehoboth_boardwalk",
            rating: 3,
            description: "The little shops and lights here make it feel like a cozy small town from a movie. Work in Bethany, shop in Rehoboth, party in Maryland. Plenty of cafe there."
        ),
        FavoriteItem(
            title: "Rehoboth Beach",
            subtitle: "Rehoboth Beach, DE",
            imageName: "rehoboth_beach",
            rating: 3,
            description: "Rehoboth is called The Nation's Summer Capital because so many people from Washington spend their summers here. Even President Biden has a beach house in this town. Delaware has no sales tax, so shopping here is cheaper than in other states, which I definitely used!"
        ),
        FavoriteItem(
            title: "Wild Ponies",
            subtitle: "Assateague Island",
            imageName: "assateague_ponies",
            rating: 3,
            description: "The ponies here are completely wild and nobody feeds them. They look a bit round because they eat salty grass and drink a lot of water. But it was not unusual for me, in my country they are a lot"
        ),
        FavoriteItem(
            title: "Assateague Beach",
            subtitle: "Assateague Island",
            imageName: "assateague_beach",
            rating: 3,
            description: "Assateague Island is split between Maryland and Virginia, and there is a fence at the state line that keeps the two pony herds apart. There are no hotels on the island, only wild beaches and nature. You can even camp here, and sometimes ponies walk right past the tents."
        )
    ]
}
