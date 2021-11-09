//
//  SearchViewCoordinator.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

class CategoriesViewCoordinator {
    
    public var categories: [Category] = []
    
    private var allCategories: [Category] = []
    
    private var delegate: CategoriesViewDelegate!

    init(_ delegate: CategoriesViewDelegate) {
        self.delegate = delegate
    }
    
    func loadData(){
        APIService.shared.fetchCategories { result in
            switch result {
            case .success(let categories):
                self.categories = categories.categories
                self.allCategories = categories.categories
                self.delegate.reloadView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func filterCategories(filter: String){
        if filter == "" {
            self.categories = allCategories
            DispatchQueue.main.async {
                self.delegate.reloadView()
            }
        }
        else{
            let filtered = allCategories.filter( { $0.category?.capitalizingFirstLetter().replacingOccurrences(of: "-", with: " ").lowercased().contains(filter.lowercased()) ?? false } )
            self.categories = filtered
            DispatchQueue.main.async {
                self.delegate.reloadView()
            }
        }
    }
}

