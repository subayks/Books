//
//  ViewController.swift
//  MyBook


import UIKit
import NVActivityIndicatorView
import SDWebImage
import AlamofireImage
import Alamofire

class ViewController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet weak var buttonLoadMore: UIButton!
    @IBOutlet weak var collectionViewList: UICollectionView!
    @IBOutlet weak var searchBar: UITextField!
    
    var booksViewModel = BookListViewModel()
    var startIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any dadditional setup after loading the view.
        makeApiCall()
        searchBar.delegate = self
        searchBar.placeholder = "Please enter book name"
    }
    
    //MARK:- API Call
    func makeApiCall() {
        let finalURL = "https://www.googleapis.com/books/v1/volumes?"
        
        var parameter = ""
        if self.booksViewModel.searchText == "" || self.booksViewModel.searchText.count == 0 {
            startIndex = 0
            parameter = "q=" + "how" + "&" + "startIndex=" + String(startIndex)
        } else {
            parameter = "q=" + self.booksViewModel.searchText + "&" + "startIndex=" + String(startIndex)
        }
        
        if Reachability.isConnectedToNetwork() {
            let size = CGSize(width: 50, height: 50)
            self.startAnimating(size, message: "Loading", messageFont: .none, type: .ballScaleRippleMultiple, color: .white, fadeInAnimation: .none)
            booksViewModel.getArticleResponse(withBaseURl: finalURL, withParameters: parameter, completionHandler: { (status: Bool?, errorMessage: String?, errorCode: String?)  -> Void in
                DispatchQueue.main.async {
                    if status == true {
                        print("Success")
                        self.stopAnimating()
                        self.collectionViewList.reloadData()
                        
                    }
                }
            })
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func actionLoadMore(_ sender: Any) {
        self.startIndex = startIndex + 10
        makeApiCall()
    }
    
    @IBAction func actionPrice(_ sender: Any) {
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "DisplayImageViewController") as? DisplayImageViewController else {
            return
        }
        for item in self.booksViewModel.booksModel?.items ?? [] {
            let imageLink = item.volumeinfo?.imageLinks?.thumbnail ?? ""
            vc.imageLinks.append(imageLink)
        }
        vc.selectedIndex = indexPath.row
        self.present(vc, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.booksViewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewList.dequeueReusableCell(withReuseIdentifier: "BookDetailsCell", for: indexPath) as! BookDetailsCell
        
        cell.backgroundColor = .gray
        
        if let model = self.booksViewModel.booksModel {
            cell.labelTitle.text = model.items?[indexPath.row].volumeinfo?.title
            cell.labelSubTitle.text = model.items?[indexPath.row].volumeinfo?.subtitle
            
            if let retailPrice = model.items?[indexPath.row].saleInfo?.retailPrice {
                let buttonTitle = (retailPrice.currencyCode ?? "") + " " +
                "\(retailPrice.amount ?? 0)"
                cell.buttonPrice.setTitle(buttonTitle, for: .normal)
            } else {
                cell.buttonPrice.setTitle("Not For Sale", for: .normal)
            }
            
            let baseUrl = "https://books.google.com/books/content?"
            let imageUrl = (model.items?[indexPath.row].volumeinfo?.imageLinks?.thumbnail ?? "")
            let parameters = self.booksViewModel.getParameter(imageUrl: imageUrl)
            AF.request(baseUrl,method: .get, parameters: parameters).validate(contentType: ["image/jpeg"]).response { response in
                cell.imageViewBook.image = UIImage(data: response.data ?? Data())
            }
        }
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: self.collectionViewList.bounds.width/4, height: self.collectionViewList.bounds.height/5)
        } else {
            return CGSize(width: self.collectionViewList.bounds.width/3, height: self.collectionViewList.bounds.height/3)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


extension ViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        self.booksViewModel.isSearchEnabled = true
        self.startIndex = 0
        if let text = self.searchBar.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,with: string)
            self.booksViewModel.searchText = updatedText
            makeApiCall()
        }
        return true
    }
    
    private func textFieldShouldEndEditing(textField: UITextField!) -> Bool {  //delegate method
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        self.booksViewModel.isSearchEnabled = false
        
        return true
    }
}
