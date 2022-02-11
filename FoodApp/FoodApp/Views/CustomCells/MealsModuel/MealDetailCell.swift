//
//  MealDetailCell.swift
//  FoodApp
//
//  Created by OPSolutions on 2/11/22.
//

import UIKit

class MealDetailCell: UICollectionViewCell {
    
    static let identifier = "MealDetailCell"
    @IBOutlet weak var mealDetailImage: UIImageView!
    @IBOutlet weak var mealDetailName: UILabel!
    
    var mealID: String = ""
    var ingredients: [Any] = []
    var quantity: [Any] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.getMealDetails()
        }
    }
    
    public func configure(Image: UIImage, Name: String, ID: String){
        mealDetailImage.image = Image
        mealDetailName.text = Name
        mealID = ID
    }
    
    static func nib() -> UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }

}

extension MealDetailCell{
    func getMealDetails(){
        
        let mealDetailsURL = theMealDBURL().searchByID + mealID
        print(mealDetailsURL)
        let task = URLSession.shared.dataTask(with: URL(string: mealDetailsURL)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("\(error!.localizedDescription)")
                return
            }
            self.decodeMealDetail(data: data)
        })
        task.resume()
    }
    
    fileprivate func decodeMealDetail(data: Data){
        var details: MealsID?
        do{
            details = try JSONDecoder().decode(MealsID.self, from: data)
        }
        catch{
            NSLog("failed to convert \(error)")
        }
        guard let pulledDetails = details else {
            return
        }
        let contents = pulledDetails.meals[0]
        print("instructions: \(contents.strInstructions)")
        // to do: assign ingredients/quantity to table view
        // assign youtube link
        // assign instructions to label
    }
}
