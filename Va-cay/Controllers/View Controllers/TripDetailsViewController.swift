//
//  ItineraryDetailsViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/27/21.
//

import UIKit

class TripDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mediaContainerView: UIView!
    
    //MARK: - Properties
//    var selectedImage = UIImage?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMediaSelectorVC" {
            guard let destinationVC = segue.destination as? MediaSelectorViewController else { return }
            destinationVC.delegate = self
        }
    }
    
}//End of class

//MARK: - Extensions
extension TripDetailsViewController: MediaSelectorDelegate {
    func mediaPickerSelected(image: UIImage) {
//        self.selectedImage = image
    }
}//End of extension
