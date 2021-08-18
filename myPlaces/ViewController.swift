//
//  ViewController.swift
//  myPlaces
//
//  Created by Стас Жингель on 17.08.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
//
//    let restaurantNames = [
//        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
//        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
//        "Speak Easy", "Morris Pub", "Вкусные истории",
//        "Классик", "Love&Life", "Шок", "Бочка"
//    ]
    let places = Place.getPlaces()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.nameLabel.text = places[indexPath.row].name
        cell.imageCell.layer.cornerRadius = cell.imageCell.frame.height/2
        cell.imageCell.image = UIImage(named: places[indexPath.row].name)
        cell.imageCell.clipsToBounds = true
        cell.location.text = places[indexPath.row].location
        cell.typeLabel.text = places[indexPath.row].type
        return cell
    }
    
    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}
}

