//
//  TableViewController.swift
//  myPlaces
//
//  Created by Стас Жингель on 18.08.2021.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var imageLabel: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
       
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

}

extension TableViewController : UITextFieldDelegate {
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        dismiss(animated: true)
    }
}
