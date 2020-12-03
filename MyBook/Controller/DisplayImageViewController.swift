//
//  DisplayImageViewController.swift
//  MyBook
//
//  Created by Subendran on 02/12/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import UIKit
import SDWebImage
import AlamofireImage
import Alamofire


class DisplayImageViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var displayImage: UIImageView!
    
    var imageLinks = [String]()
    var selectedIndex = Int()
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        let imageUrl = self.imageLinks[selectedIndex]
        self.downloadImage(imageUrl: imageUrl)
    }
    
    //Action for dismiss
    @IBAction func actionClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Action for previous image
    @IBAction func actionPreviousButton(_ sender: Any) {
        if selectedIndex > 0 {
            self.previousButton.isHidden = false
            self.nextButton.isHidden = false
            let imageUrl =
                self.imageLinks[selectedIndex - 1]
            self.downloadImage(imageUrl: imageUrl)
            self.selectedIndex = selectedIndex - 1
            
        } else {
            self.previousButton.isHidden = true
        }
    }
    
    //Func to download image
    func downloadImage(imageUrl: String)  {
        let baseUrl = "https://books.google.com/books/content?"
        let url = URLComponents(string: imageUrl)?.queryItems
        let id = url?.filter({$0.name == "id" }).first
        let printsec = url?.filter({$0.name == "printsec" }).first
        let img = url?.filter({$0.name == "img" }).first
        let zoom = url?.filter({$0.name == "zoom" }).first
        let edge = url?.filter({$0.name == "edge" }).first
        let source = url?.filter({$0.name == "source" }).first
        let parameters = ["id": id?.value,"printsec": printsec?.value,"img":img?.value,"zoom":zoom?.value,"edge": edge?.value,"source":source?.value]
        AF.request(baseUrl,method: .get, parameters: parameters).validate(contentType: ["image/jpeg"]).response { response in
            self.displayImage.image = UIImage(data: response.data ?? Data())
        }
    }
    
    //Action for next Image
    @IBAction func actionNextButton(_ sender: Any) {
        if selectedIndex < self.imageLinks.count - 1  {
            self.nextButton.isHidden = false
            self.previousButton.isHidden = false
            let imageUrl = self.imageLinks[selectedIndex + 1]
            self.downloadImage(imageUrl: imageUrl)
            self.selectedIndex = selectedIndex + 1
        } else {
            self.nextButton.isHidden = true
        }
    }
}
