//
//  MediaSelectorViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/27/21.
//

import UIKit

//MARK: - Protocol
protocol MediaSelectorDelegate: AnyObject {
    func mediaPickerSelected(image: UIImage)
}

class MediaSelectorViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var uploadMediaButton: UIButton!
    @IBOutlet weak var uploadedMediaImageView: UIImageView!
    
    //MARK: - Properties
    let imagePicker = UIImagePickerController()
    var tripImage: UIImage? {
        didSet {
            
        }
    }
    static weak var delegate: MediaSelectorDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        TripQuestionnairePartOneViewController.delegate = self
    }
    
    //MARK: - Actions
    @IBAction func uploadMediaButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a photo", message: nil, preferredStyle: .alert)
       
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
//        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
//            self.openCamera()
//        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openPhotoLibrary()
        }
        
        alert.addAction(cancelAction)
//        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        present(alert, animated: true, completion: nil)
    }

    func setupViews() {
        if let tripImage = tripImage {
            uploadedMediaImageView.image = tripImage
            print(tripImage)
        }
        uploadedMediaImageView.contentMode = .scaleAspectFill
        uploadedMediaImageView.clipsToBounds = true
        uploadedMediaImageView.backgroundColor = Colors.customLightGray
        imagePicker.delegate = self
    }
    
    func updateImageView(image: UIImage){
        guard let imageView = uploadedMediaImageView else {return}
        imageView.image = image
    }
    
}//End of class

//MARK: - Extensions
extension MediaSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func openCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//            present(imagePicker, animated: true, completion: nil)
//        } else {
//            presentErrorAlert(title: "No Access to Camera", message: "Please allow access to the camera to use this feature")
//        }
//    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            presentErrorAlert(title: "No Access to Photo Library", message: "Please allow access to Photo Library to use this feature")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            guard let delegate = MediaSelectorViewController.delegate else { return }
            delegate.mediaPickerSelected(image: pickedImage)
            uploadedMediaImageView.image = pickedImage
            uploadMediaButton.isHidden = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
}//End of extension

extension MediaSelectorViewController: updateImageDelegate {
    func updateImage(image: UIImage){
        updateImageView(image: image)
    }
}//End of extension
