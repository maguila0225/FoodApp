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
