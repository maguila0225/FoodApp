//
//  MealsModel.swift
//  FoodApp
//
//  Created by OPSolutions on 2/10/22.
//

import Foundation

struct theMealDBURL{
    let categoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    let mealsPerCategoryURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    let searchUsingFirstLetterURL = "https://www.themealdb.com/api/json/v1/1/search.php?f="
    let searchByNameURL = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    let searchByID = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
}

struct Categories: Codable{
    let categories: [CategoryDetail]
}

struct CategoryDetail: Codable{
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

struct Meals: Codable{
    let meals: [MealDetail]
}

struct MealDetail: Codable{
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

struct MealsID: Codable{
    var meals: [MealsIDDetail]
}

struct MealsIDDetail: Codable{
    var idMeal: String
    var strMeal: String
    var strDrinkAlternate: String?
    var strCategory: String
    var strArea: String
    var strInstructions: String
    var strTags:String
    var strYoutube:String?
    var strIngredient1:String?
    var strIngredient2:String?
    var strIngredient3:String?
    var strIngredient4:String?
    var strIngredient5:String?
    var strIngredient6:String?
    var strIngredient7:String?
    var strIngredient8:String?
    var strIngredient9:String?
    var strIngredient10:String?
    var strIngredient11:String?
    var strIngredient12:String?
    var strIngredient13:String?
    var strIngredient14:String?
    var strIngredient15:String?
    var strIngredient16:String?
    var strIngredient17:String?
    var strIngredient18:String?
    var strIngredient19:String?
    var strIngredient20:String?
    var strMeasure1:String?
    var strMeasure2:String?
    var strMeasure3:String?
    var strMeasure4:String?
    var strMeasure5:String?
    var strMeasure6:String?
    var strMeasure7:String?
    var strMeasure8:String?
    var strMeasure9:String?
    var strMeasure10:String?
    var strMeasure11:String?
    var strMeasure12:String?
    var strMeasure13:String?
    var strMeasure14:String?
    var strMeasure15:String?
    var strMeasure16:String?
    var strMeasure17:String?
    var strMeasure18:String?
    var strMeasure19:String?
    var strMeasure20:String?
    var strSource:String?
    var strImageSource:String?
    var strCreativeCommonsConfirmed:String?
    var dateModified:String?
}
