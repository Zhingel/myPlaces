//
//  TableViewController.swift
//  myPlaces
//
//  Created by Стас Жингель on 18.08.2021.
//

import UIKit

class TableViewController: UITableViewController {
    var imageIsChanged = false
    var currentPlace: Place?
     
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen() 
       
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo1")
            let alert = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue( cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel )
            alert.addAction(camera)
            alert.addAction(photo)
            alert.addAction(cancel)
            present(alert, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    func saveNewPlace() {
        var image : UIImage?
        if imageIsChanged {
            image = imageLabel.image
        } else {
            image = #imageLiteral(resourceName: "photo1")
        }
        let imageData = image?.pngData()
        let newPlace = Place(name: nameTextField.text!, location: placeTextField.text!, type: typeTextField.text!, imageData: imageData)
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.location = newPlace.location
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
        
    }
    private func setupEditScreen() {
        if currentPlace != nil {
            imageIsChanged = true
            setupNavigatinBar()
            nameTextField.text = currentPlace?.name
            typeTextField.text = currentPlace?.type
            placeTextField.text = currentPlace?.location
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            imageLabel.image = image
            imageLabel.contentMode = .scaleAspectFill
        }
    }
    private func setupNavigatinBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil )
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
 
}

extension TableViewController : UITextFieldDelegate {
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private  func textFieldChanged() {
        if nameTextField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
}

extension TableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if  UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = source
                present(imagePicker, animated: true)
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageLabel.image = info[.editedImage] as? UIImage
        imageLabel.contentMode = .scaleToFill
        imageLabel.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
}
