//
//  APIService.swift
//  ICO-visualizer
//
//  Created by Anonymous on 24/09/2020.
//  Copyright © 2020 Anonymous. All rights reserved.
//

import Foundation
import Alamofire

class APIService {

    public static let shared = APIService()
    
    private let baseUrl = "https://www.pornhub.com/webmasters"
    private let feedsUrl = "https://api.redgifs.com/v2/home/feeds"
    
    private var retryCount: Int = 0
    private let maxRetry: Int = 3
    
    func sendSearchRequest(searchText: String? = nil, page: Int = 1, completionHandler: ((Result<VideosResponseModel, Error>) -> Void)?){
        self.sendSearchRequest(searchText: searchText, category: "teen-18-1", page: page, completionHandler: completionHandler)
    }
    
    func sendSearchRequest(searchText: String? = nil, category: String? = nil, page: Int = 1, completionHandler: ((Result<VideosResponseModel, Error>) -> Void)?){
        let url = "\(self.baseUrl)/search"
        var parameters: Parameters = [ "page" : page, "rating" : 80 ]
        if let searchText = searchText {
            parameters["search"] = searchText
        }
        if let category = category {
            parameters["category"] = category
        }
        AF.request(url, method: .get, parameters: parameters).responseJSON { result in
            if let error = result.error{
                completionHandler?(.failure(error))
                return
            }
            if let data = result.data{
                if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data){
                    completionHandler?(.failure(APIServiceError.error(error)))
                    return
                }
                do {
                    let response = try JSONDecoder().decode(VideosResponseModel.self, from: data)
                    completionHandler?(.success(response))
                }
                catch{
                    completionHandler?(.failure(APIServiceError.decodeError(error)))
                    print(data)
                }
            }
            else{
                completionHandler?(.failure(APIServiceError.noDataFound))
            }
        }
    }
    
    func fetchPokemons(completionHandler: ((Result<PokemonList, Error>) -> Void)?){
        let url = "https://pokeapi.co/api/v2/pokemon"
        let parameters: Parameters = ["offset": 1, "limit": 30]
        AF.request(url, method: .get, parameters: parameters).responseJSON { result in
            if let error = result.error{
                completionHandler?(.failure(error))
                return
            }
            if let data = result.data{
                if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data){
                    completionHandler?(.failure(APIServiceError.error(error)))
                    return
                }
                do {
                    let response = try JSONDecoder().decode(PokemonList.self, from: data)
                    completionHandler?(.success(response))
                }
                catch{
                    completionHandler?(.failure(APIServiceError.decodeError(error)))
                    print(data)
                }
            }
            else{
                completionHandler?(.failure(APIServiceError.noDataFound))
            }
        }
    }
    
    func fetchCategories(completionHandler: ((Result<CategoriesModel, Error>) -> Void)?){
        let url = "\(self.baseUrl)/categories"
        AF.request(url, method: .get).responseJSON { result in
            if let error = result.error{
                completionHandler?(.failure(error))
                return
            }
            if let data = result.data{
                if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data){
                    completionHandler?(.failure(APIServiceError.error(error)))
                    return
                }
                do {
                    let response = try JSONDecoder().decode(CategoriesModel.self, from: data)
                    completionHandler?(.success(response))
                }
                catch{
                    completionHandler?(.failure(APIServiceError.decodeError(error)))
                    print(data)
                }
            }
            else{
                completionHandler?(.failure(APIServiceError.noDataFound))
            }
        }
    }
    
    private var cachedStars: StarsModel?
    
    func fetchStars(completionHandler: ((Result<StarsModel, Error>) -> Void)?){
        if let cachedStars = self.cachedStars {
            completionHandler?(.success(cachedStars))
            return
        }
        let url = "\(self.baseUrl)/stars_detailed"
        AF.request(url, method: .get).responseJSON { result in
            if let error = result.error{
                completionHandler?(.failure(error))
                return
            }
            if let data = result.data{
                if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data){
                    completionHandler?(.failure(APIServiceError.error(error)))
                    return
                }
                do {
                    let response = try JSONDecoder().decode(StarsModel.self, from: data)
                    completionHandler?(.success(response))
                    self.cachedStars = response
                }
                catch{
                    completionHandler?(.failure(APIServiceError.decodeError(error)))
                    print(data)
                }
            }
            else{
                completionHandler?(.failure(APIServiceError.noDataFound))
            }
        }
    }
    
    func getStarVideos(starName: String, page: Int = 1, completionHandler: ((Result<[Video], Error>) -> Void)?){
        self.sendSearchRequest(searchText: starName, category: nil, page: page) { response in
            switch response{
            case .success(let videoRes):
                var response: [Video] = []
                for item in videoRes.videos {
                    if let stars = item.pornstars{
                        for star in stars {
                            if star.pornstarName == starName{
                                response.append(item)
                            }
                        }
                    }
                }
                completionHandler?(.success(response))
            case .failure(let error):
                completionHandler?(.failure(error))
            }
        }
    }
    
    func getVideoById(id: String, completionHandler: ((Result<Video, Error>) -> Void)?){
        let url = "\(self.baseUrl)/video_by_id"
        let parameters: Parameters = [ "id" : id ]
        AF.request(url, method: .get, parameters: parameters).responseJSON { result in
            if let error = result.error{
                completionHandler?(.failure(error))
                return
            }
            if let data = result.data{
                if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data){
                    completionHandler?(.failure(APIServiceError.error(error)))
                    return
                }
                do {
                    let response = try JSONDecoder().decode(VideoResult.self, from: data)
                    completionHandler?(.success(response.video))
                }
                catch{
                    completionHandler?(.failure(APIServiceError.decodeError(error)))
                    print(data)
                }
            }
            else{
                completionHandler?(.failure(APIServiceError.noDataFound))
            }
        }
    }
    
    func getStarImages(starName: String, completionHandler: ((Result<[String], Error>) -> Void)?){
        let strUrl = "https://www.pornpictureshq.com/"
        let params: Parameters = [ "q" :  starName.lowercased().replacingOccurrences(of: " ", with: "+")]
        AF.request(strUrl, method: .get, parameters: params).responseString { response in
            if let error = response.error {
                completionHandler?(.failure(error))
                print(error)
                return
            }
            if let html = response.value {
                let groups = html.capturedGroups(withRegex: "data-src=[\"\']([^\"\']*)[\"\']").filter({ $0.contains(".jpg") }).map({ $0.replacingOccurrences(of: "data-src=", with: "").replacingOccurrences(of: "300x", with: "600x").replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\"", with: "") })
                var res: [String] = []
                for item in groups{
                    if !res.contains(item) {
                        res.append(item)
                    }
                }
                completionHandler?(.success(res))
            }
            else {
                completionHandler?(.failure(APIServiceError.noDataFound))
            }
        }
    }
    
    func fetchFeeds(completionHandler: ((Result<FeedsResponse, Error>) -> Void)?){
        AF.request(self.feedsUrl, method: .get).responseJSON { result in
            if let error = result.error{
                completionHandler?(.failure(error))
                return
            }
            if let data = result.data{
                do {
                    let response = try JSONDecoder().decode(FeedsResponse.self, from: data)
                    completionHandler?(.success(response))
                }
                catch{
                    completionHandler?(.failure(APIServiceError.decodeError(error)))
                    print(data)
                }
            }
            else{
                completionHandler?(.failure(APIServiceError.noDataFound))
            }
        }
    }
}

