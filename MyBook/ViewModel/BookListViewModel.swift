//
//  BookListViewModel.swift
//  MyBook
//
//  Created by Subendran on 29/11/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import Foundation
import Alamofire


class BookListViewModel {
    var booksModel: BooksModel?
    var defaultData: BooksModel?
    var isSearchEnabled: Bool = false
    var searchText = String()
    //MARK:- Api Call
    func getArticleResponse(withBaseURl finalURL: String, withParameters parameters: String, completionHandler: @escaping (Bool, String?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   parameters, withHttpMethod: "GET", withContentType: "application/hal+json", completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completionHandler(false, error , errorCode)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    let values = try! decoder.decode(BooksModel.self, from: result!)
                    
                    if self.booksModel?.items?.count ?? 0 > 0 && !self.isSearchEnabled {
                        if let items = values.items {
                            for item in items {
                                self.booksModel?.items?.append(item)
                            }
                        }
                    } else {
                        self.booksModel = values
                    }
                    self.defaultData = values
                    completionHandler(true, error, errorCode)
                    
                } catch let error as NSError {
                    //do something with error
                    completionHandler(false, error.localizedDescription, errorCode)
                }
            }
        }
        )}
    
    //fun to get  number of rows
    func numberOfRows() -> Int {
        return self.booksModel?.items?.count ?? 0
    }
    
    //Method to get parameter
    func getParameter(imageUrl: String) ->[String: String?] {
        let url = URLComponents(string: imageUrl)?.queryItems
        let id = url?.filter({$0.name == "id" }).first
        let printsec = url?.filter({$0.name == "printsec" }).first
        let img = url?.filter({$0.name == "img" }).first
        let zoom = url?.filter({$0.name == "zoom" }).first
        let edge = url?.filter({$0.name == "edge" }).first
        let source = url?.filter({$0.name == "source" }).first
        return  ["id": id?.value,"printsec": printsec?.value,"img":img?.value,"zoom":zoom?.value,"edge": edge?.value,"source":source?.value]
    }
}
