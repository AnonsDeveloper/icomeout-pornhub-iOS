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
    
    public var videos: [ReelElement] = []
    
    private var cursor: Int = 1
    
    init(_ delegate: ReelsViewControllerDelegate) {
        self.delegate = delegate
    }
    
    func load(){
        APIService.shared.fetchTikFeeds(cursor: cursor) { response in
            switch response {
            case .success(let result):
                if let posts = result.data?.posts {
                    for post in posts {
                        var url: String? = nil
                        if post.redGifsVideoURL != nil {
                            url = post.redGifsVideoURL
                        }
                        else if post.vimeoURI != nil {
                            url = post.vimeoURI
                        }
                        let reel = ReelElement(videoUrl: url, username: post.author?.name, avatarUrl: nil, likes: post.count?.reactions, views: post.reactionInitial, tags: post.tags?.map({ $0.name ?? "" }), verified: post.author?.emailVerified, externalUrl: post.source, duration: nil, width: post.width, height: post.height)
                        if url != nil {
                            self.videos.append(reel)
                        }
                    }
                }
                self.delegate.reloadView()
            case .failure(let error):
                print(error)
            }
        }
//        APIService.shared.fetchFeeds { response in
//            switch response {
//            case .success(let response):
//                for item in response.verticalGifs {
//                    if URL(string: item.urls?.hd ?? "") != nil{
//                        self.videos.append(ReelElement(videoUrl: item.urls?.hd, username: item.user?.username, avatarUrl: item.user?.profileImageURL, likes: item.likes, views: item.views, tags: item.tags, verified: item.verified, externalUrl: item.user?.profileURL, duration: item.duration, width: item.width, height: item.height))
//                    }
//                }
//                for item in response.hotGifs {
//                    if URL(string: item.urls?.hd ?? "") != nil{
//                        self.videos.append(ReelElement(videoUrl: item.urls?.hd, username: item.user?.username, avatarUrl: item.user?.profileImageURL, likes: item.likes, views: item.views, tags: item.tags, verified: item.verified, externalUrl: item.user?.profileURL, duration: item.duration, width: item.width, height: item.height))
//                    }
//                }
//                for item in response.verifiedGifs {
//                    if URL(string: item.urls?.hd ?? "") != nil{
//                        self.videos.append(ReelElement(videoUrl: item.urls?.hd, username: item.user?.username, avatarUrl: item.user?.profileImageURL, likes: item.likes, views: item.views, tags: item.tags, verified: item.verified, externalUrl: item.user?.profileURL, duration: item.duration, width: item.width, height: item.height))
//                    }
//                }
//                for item in response.soundGifs {
//                    if URL(string: item.urls?.hd ?? "") != nil{
//                        self.videos.append(ReelElement(videoUrl: item.urls?.hd, username: item.user?.username, avatarUrl: item.user?.profileImageURL, likes: item.likes, views: item.views, tags: item.tags, verified: item.verified, externalUrl: item.user?.profileURL, duration: item.duration, width: item.width, height: item.height))
//                    }
//                }
//                for item in response.horizontalGifs {
//                    if URL(string: item.urls?.hd ?? "") != nil{
//                        self.videos.append(ReelElement(videoUrl: item.urls?.hd, username: item.user?.username, avatarUrl: item.user?.profileImageURL, likes: item.likes, views: item.views, tags: item.tags, verified: item.verified, externalUrl: item.user?.profileURL, duration: item.duration, width: item.width, height: item.height))
//                    }
//                }
//                for item in response.longGifs {
//                    if URL(string: item.urls?.hd ?? "") != nil{
//                        self.videos.append(ReelElement(videoUrl: item.urls?.hd, username: item.user?.username, avatarUrl: item.user?.profileImageURL, likes: item.likes, views: item.views, tags: item.tags, verified: item.verified, externalUrl: item.user?.profileURL, duration: item.duration, width: item.width, height: item.height))
//                    }
//                }
//                self.delegate.reloadView()
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    func reloadAll(){
        self.videos = []
        self.cursor = 1
        self.load()
    }
    
    func loadMore(){
        self.cursor += 1
        self.load()
    }
}
