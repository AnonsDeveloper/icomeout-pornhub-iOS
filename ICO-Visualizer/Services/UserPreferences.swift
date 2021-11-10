//
//  UserPreferences.swift
//  ICO-visualizer
//
//  Created by Anonymous on 05/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

class UserPreferences{
    static let shared = UserPreferences()
    
    var isAudioOn: Bool {
        get{
            if UserDefaults.standard.object(forKey: "isAudioOn") == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: "isAudioOn")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isAudioOn")
        }
    }
    
    var userPin: String? {
        get{
            return UserDefaults.standard.string(forKey: "userPin")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userPin")
        }
    }
    
    var userFakePin: String? {
        get{
            return UserDefaults.standard.string(forKey: "userFakePin")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userFakePin")
        }
    }
    
    var faceIdEnabled: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "faceId")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "faceId")
        }
    }
    
    var starToFind: String? {
        get {
            return UserDefaults.standard.string(forKey: "starToFind")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "starToFind")
        }
    }
}


class UserBookmakrs {
    static let shared = UserBookmakrs()
    
    func saveVideoToBookmark(video: Video){
        if self.checkVideoBookmarksCointain(video){
            return
        }
        var bookmarks = self.getVideosBookmarks()
        bookmarks.append(video)
        self.serializeVideosToUserDefaults(bookmarks)
    }
    
    func removeVideoBookmark(video: Video){
        var bookmarks = self.getVideosBookmarks()
        bookmarks.removeAll(where: { $0.videoID == video.videoID })
        self.serializeVideosToUserDefaults(bookmarks)
    }
    
    func getVideosBookmarks() -> [Video]{
        do {
            if let jsonString = UserDefaults.standard.string(forKey: "videobookmarks")?.data(using: .utf8) {
                let result = try JSONDecoder().decode([Video].self, from: jsonString)
                return result
            }
        }
        catch{
            print(error)
        }
        
        return []
    }
    
    
    func checkVideoBookmarksCointain(_ video: Video) -> Bool {
        return self.getVideosBookmarks().first(where: { $0.videoID == video.videoID }) != nil
    }
    
    private func serializeVideosToUserDefaults(_ videos: [Video]){
        do {
            let result = try JSONEncoder().encode(videos)
            let resultString = String(data: result, encoding: .utf8)
            UserDefaults.standard.set(resultString, forKey: "videobookmarks")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .didUpdateBookmarks, object: nil)
        }
        catch {
            print(error)
        }
    }
    
    func saveStarToBookmark(star: Star){
        if self.checkStarBookmarksCointain(star){
            return
        }
        var bookmarks = self.getStarsBookmarks()
        bookmarks.append(star)
        self.serializeStarsToUserDefaults(bookmarks)
    }
    
    func removeStarBookmark(star: Star){
        var bookmarks = self.getStarsBookmarks()
        bookmarks.removeAll(where: { $0.starName == star.starName })
        self.serializeStarsToUserDefaults(bookmarks)
    }
    
    func getStarsBookmarks() -> [Star]{
        do {
            if let jsonString = UserDefaults.standard.string(forKey: "starsbookmarks")?.data(using: .utf8) {
                let result = try JSONDecoder().decode([Star].self, from: jsonString)
                return result
            }
        }
        catch{
            print(error)
        }
        
        return []
    }
    
    func checkStarBookmarksCointain(_ star: Star) -> Bool {
        return self.getStarsBookmarks().first(where: { $0.starName == star.starName }) != nil
    }
    
    private func serializeStarsToUserDefaults(_ stars: [Star]){
        do {
            let result = try JSONEncoder().encode(stars)
            let resultString = String(data: result, encoding: .utf8)
            UserDefaults.standard.set(resultString, forKey: "starsbookmarks")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .didUpdateBookmarks, object: nil)
        }
        catch {
            print(error)
        }
    }
}
