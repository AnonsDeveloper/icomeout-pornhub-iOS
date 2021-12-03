//
//  StarsViewCoordinator.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//
import Foundation

class StarsViewCoordinator {
    
    public var stars: [StarElement] = []
    
    private var allStars: [StarElement] = []
    
    private var delegate: StarsViewControllerDelegate!

    init(_ delegate: StarsViewControllerDelegate) {
        self.delegate = delegate
    }
    
    func filterStars(filter: String){
        if filter == "" {
            self.stars = allStars
            DispatchQueue.main.async {
                self.delegate.reloadView()
            }
        }
        else{
            let filtered = allStars.filter( { $0.star?.starName?.lowercased().contains(filter.lowercased()) ?? false } )
            self.stars = filtered
            DispatchQueue.main.async {
                self.delegate.reloadView()
            }
        }
    }
    
    func loadData(){
        self.allStars = []
        self.stars = []
        DispatchQueue.global(qos: .default).async {
            APIService.shared.fetchStars { result in
                switch result {
                case .success(let stars):
                    if let stars = stars.stars {
                        for item in stars {
                            self.stars.append(item)
                        }
                    }
                    let orderedStars = self.stars.sorted(by: { Int($0.star?.videosCountAll ?? "0") ?? 0 > Int($1.star?.videosCountAll ?? "0") ?? 0 })
                    self.stars = orderedStars
                    self.allStars = self.stars
                    DispatchQueue.main.async {
                        self.delegate.reloadView()
                    }
                case .failure(let error):
                    print(error)
                    self.delegate.onError(error: error)
                }
            }

        }

    }
}
