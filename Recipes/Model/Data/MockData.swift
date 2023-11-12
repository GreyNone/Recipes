//
//  MockData.swift
//  Recipes
//
//  Created by Александр Василевич on 19.10.23.
//

import Foundation

struct MockData {
    
    static let mockRecipe = Recipe(vegetarian: true,
                                   vegan: false,
                                   cheap: true,
                                   veryHealthy: false,
                                   veryPopular: true,
                                   pricePerServing: 100.5,
                                   cookingMinutes: 30,
                                   aggregateLikes: 115,
                                   healthScore: 30,
                                   extendedIngredients: ingridients,
                                   id: 637016,
                                   title: "Caramel Peanut Fudge Cake",
                                   readyInMinutes: 45,
                                   image: "",
                                   summary: "Caramel Peanut Fudge Cake might be just the dessert you are searching for. One portion of this dish contains approximately <b>16g of protein</b>, <b>35g of fat</b>, and a total of <b>459 calories</b>. This recipe serves 10. For <b>$1.24 per serving</b>, this recipe <b>covers 23%</b> of your daily requirements of vitamins and minerals. From preparation to the plate, this recipe takes about <b>45 minutes</b>. 84 people were glad they tried this recipe. If you have almonds, sugar, cream, and a few other ingredients on hand, you can make it. It is brought to you by Foodista. It is a good option if you're following a <b>gluten free and lacto ovo vegetarian</b> diet. Taking all factors into account, this recipe <b>earns a spoonacular score of 74%</b>, which is solid. If you like this recipe, you might also like recipes such as <a href=\"https://spoonacular.com/recipes/slow-cooker-caramel-peanut-butter-hot-fudge-cake-1331813\">Slow Cooker Caramel Peanut Butter Hot Fudge Cake</a>, <a href=\"https://spoonacular.com/recipes/slow-cooker-caramel-peanut-butter-hot-fudge-cake-951248\">Slow Cooker Caramel Peanut Butter Hot Fudge Cake</a>, and <a href=\"https://spoonacular.com/recipes/caramel-peanut-butter-fudge-573829\">Caramel Peanut Butter Fudge</a>.",
                                   instructions: "<ol><li>For the sponge, beat egg yolks with sugar for 3-4 minutes until the mixture doubles in volume and becomes pale yellow.</li><li>Whisk the egg whites until soft peaks form.</li><li>Fold the egg whites gently into the egg yolks cream.</li><li>Gently stir in almonds and cocoa.</li><li>Lightly butter and flour a 20 round cake pan, line with parchment paper. Pour in the sponge mixture Bake in preheated oven at 180C for about 20 minutes or until done (the trick with a toothpick).</li><li>Leave the cake to cool completely in the cake pan, then carefully remove it and split into two layers.</li><li>For the caramel cream heat sugar and water over medium heat and cook, stirring occasionally, until the sugar dissolves and comes to a boil. Continue cooking, but without stirring, until mixture becomes golden amber in color. Remove from flame and set aside.</li><li>Whip the cream, gradually stir in the caramel syrup.</li><li>Add peanuts, stir and combine. Mixture must be smooth (at first it will foam up a little). Transfer the cream to a bowl to cool down to room temperature and thicken.</li><li>For the ganache bring the cream just to a boil over medium-high heat; pour over chocolate. Let stand 10 minutes. Stir very gently for 3-4 minutes until smooth and glossy, incorporating the cream steadily, without overworking.</li><li>Cool ganache for an hour or until completely chilled, then beat for 2-3 minutes or until it becomes fluffy and lighter in color. Do not overbeat because it will become too thick and not spreadable.</li><li>To assemble the cake, first sprinkle each cake layer with half of the rum and water syrup.</li><li>Spread the caramel cream over the bottom layer, cover with the top layer (wet side down).</li><li>Immediately spread ganache over top and sides of cake.</li></ol>",
                                   analyzedInstructions: [AnalyzedInstruction(steps: steps)]
    )    
    
    static let firstMockIngridient = Ingredient(id: 12061,
                                                name: "almonds",
                                                image: "",
                                                consistency: "SOLID",
                                                amount: 100.0,
                                                unit: "g")
    
    static let secondMockIngridient = Ingredient(id: 19365,
                                                 name: "cocoa",
                                                 image: "",
                                                 consistency: "SOLID",
                                                 amount: 25.0,
                                                 unit: "g")
    
    static let ingridients = [firstMockIngridient, secondMockIngridient]
    
    static let firstStep = Step(number: 1,
                                step: "For the sponge, beat egg yolks with sugar for 3-4 minutes until the mixture doubles in volume and becomes pale yellow.",
                                length: firstLength)
    static let firstLength = Length(number: 4,
                                    unit: "minutes")
    
    static let secondStep = Step(number: 2,
                                 step: "Whisk the egg whites until soft peaks form.Fold the egg whites gently into the egg yolks cream.Gently stir in almonds and cocoa.Lightly butter and flour a 20 round cake pan, line with parchment paper.",
                                 length: nil)
    
    static let thirdStep =  Step(number: 3,
                                 step: "Cut into one single \"steak\" piece working around the bone. Save smaller pieces for cooking as well. Set aside in a large mixing bowl.Pulse the marinade ingredients in a food processor until smooth.Coat the chicken pieces with the marinade. Marinate overnight in the refrigerator or a minimum of 6-12 hours. With a skewer or toothpick, piercing the thighs for extra marinade absorption is optional.Preheat a skillet or non stick pan over medium heat.",
                                 length: nil)
    static let steps = [firstStep, secondStep, thirdStep]
}
