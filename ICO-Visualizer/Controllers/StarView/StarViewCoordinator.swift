//
//  StarViewCoordinator.swift
//  ICO-visualizer
//
//  Created by Anonymous on 04/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

class StarViewCoordinator {
    
    private var delegate: StarViewControllerDelegate!
    
    public var star: Star!
    public var images: [String] = []
    
    private var page: Int = 1
    
    init(_ delegate: StarViewControllerDelegate) {
        self.delegate = delegate
        self.star = delegate.getStar()
    }
    
    func load(){
        APIService.shared.getStarImages(starName: self.star.starName!) { response in
            switch response {
            case .success(let res):
                self.images = res
                self.delegate.reloadImages(res.count == 0 ? "No images found for \(self.star.starName!) pornstar :(" : nil)
            case .failure(let error):
                print(error)
                self.delegate.reloadImages(error.localizedDescription)
            }
        }
        APIService.shared.getStarVideos(starName: self.star.starName!, page: self.page, completionHandler: { result in
            switch result {
            case .success(let videos):
                if self.star.starVideos == nil {
                    self.star.starVideos = []
                }
                self.star.starVideos?.append(contentsOf: videos)
                DispatchQueue.main.async {
                    if self.star.starVideos?.count == 0 {
                        self.delegate.reloadView("No videos found for pornstar " + (self.star.starName ?? "") + " :(")
                    }
                    else{
                        self.delegate.reloadView(nil)
                    }
                }
            case .failure(let error):
                self.delegate.videosCompleted = true
                DispatchQueue.main.async {
                    self.delegate.reloadView(nil)
                }
                print(error)
            }
        })
    }
    
    func fetchNext(){
        self.page += 1
        self.load()
    }
}
