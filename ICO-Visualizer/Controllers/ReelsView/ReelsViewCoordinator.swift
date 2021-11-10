//
//  ReelsViewCoordinator.swift
//  ICO-visualizer
//
//  Created by Anonymous on 10/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

class ReelsViewCoordinator {
    private var delegate: ReelsViewControllerDelegate!
    
    public var videos: [HorizontalGIF] = []
    
    init(_ delegate: ReelsViewControllerDelegate) {
        self.delegate = delegate
    }
    
    func load(){
        self.videos = []
        APIService.shared.fetchFeeds { response in
            switch response {
            case .success(let response):
                for item in response.verticalGifs {
                    if URL(string: item.urls.hd) != nil{
                        self.videos.append(item)
                    }
                }
                for item in response.hotGifs {
                    if URL(string: item.urls.hd) != nil{
                        self.videos.append(item)
                    }
                }
                for item in response.verifiedGifs {
                    if URL(string: item.urls.hd) != nil{
                        self.videos.append(item)
                    }
                }
                for item in response.soundGifs {
                    if URL(string: item.urls.hd) != nil{
                        self.videos.append(item)
                    }
                }
                for item in response.horizontalGifs {
                    if URL(string: item.urls.hd) != nil{
                        self.videos.append(item)
                    }
                }
                for item in response.longGifs {
                    if URL(string: item.urls.hd) != nil{
                        self.videos.append(item)
                    }
                }
                self.delegate.reloadView()
            case .failure(let error):
                print(error)
            }
        }
    }
}
