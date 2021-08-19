//
//  ViewController.swift
//  myPlaces
//
//  Created by Стас Жингель on 17.08.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource  {
    
    var places: Results<Place>!
    var ascendingSorting = true

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reverseSortingButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        places = realm.objects(Place.self)
       
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return
            places.isEmpty ? 0 : places.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let place = places[indexPath.row]

        cell.nameLabel.text = place.name
        cell.location.text = place.location
        cell.typeLabel.text = place.type
        cell.imageCell.image = UIImage(data: place.imageData!)
        cell.imageCell.layer.cornerRadius = cell.imageCell.frame.height/2
        cell.imageCell.clipsToBounds = true
        return cell

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]
        let deleteAction = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete"){_,_,_ in
            StorageManager.deleteObject(place)
                      tableView.deleteRows(at: [indexPath ], with: .automatic)
        }])
    return deleteAction
    }
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? TableViewController else {return}
        newPlaceVC.saveNewPlace()
        tableView.reloadData()
      
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let place = places[indexPath.row]
            let newPlaceVC = segue.destination as! TableViewController
            newPlaceVC.currentPlace = place
            
        }
    }
  
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
       sorting()
    }
    
    @IBAction func reverseSorting(_ sender: UIBarButtonItem) {
        ascendingSorting.toggle()
        if ascendingSorting {
            reverseSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reverseSortingButton.image = #imageLiteral(resourceName: "ZA")        }
        sorting()
        
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}

