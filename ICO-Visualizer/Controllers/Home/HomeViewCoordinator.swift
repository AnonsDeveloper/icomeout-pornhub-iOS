//
//  HomeViewCoordinator.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

class HomeViewCoordinator {
    
    private var currentPage: Int = 1
    
    public var videos: [Video] = []
    
    public var searchText: String? = nil
    public var category: String? = nil
    
    private var delegate: HomeViewDelegate!
    
    init(_ delegate: HomeViewDelegate) {
        self.delegate = delegate
    }
    
    func loadData(){
        APIService.shared.sendSearchRequest(searchText: self.searchText, category: self.category ?? "teen-18-1", page: currentPage) { result in
            switch result {
            case .success(let videos):
                self.videos.append(contentsOf: videos.videos)
                self.delegate.reloadView()
            case .failure(let error):
                if let errorRes = error as? APIServiceError {
                    switch errorRes {
                    case .unknown:
                        self.delegate.showError(message: "Unknown error")
                    case .decodeError(let error):
                        self.delegate.showError(message: error.localizedDescription)
                    case .noDataFound:
                        self.delegate.showError(message: "No data found")
                    case .error(let errorResponse):
                        if errorResponse.code == "2001" && self.videos.count <= 0 {
                            self.delegate.showError(message: errorResponse.message)
                        }
                    }

                }
                else if self.videos.count <= 0 {
                    self.delegate.showError(message: error.localizedDescription)
                }
                print(error)
            }
        }
    }
    
    func search(searchText: String?){
        self.searchText = searchText
        self.category = nil
        self.currentPage = 1
        self.loadData()
    }
    
    func searchForCategory(category : String){
        self.currentPage = 1
        self.searchText = nil
        self.category = category
        self.loadData()
    }
    
    func fetchNext(){
        currentPage += 1
        self.loadData()
    }
}
