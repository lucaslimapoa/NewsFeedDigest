//
//  NewsFeedViewModel.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import RxCocoa
import NewsAPISwift

protocol NewsFeedViewModelProtocol: class {
    var articles: Variable<[NewsAPIArticle]> { get }
    func fetchArticles()
    func convertUTCDateToTimePassed(utc: String) -> String
}

class NewsFeedViewModel: NewsFeedViewModelProtocol {
    
    weak var viewController: NewsFeedViewControllerProtocol!
    
    let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
    let userModel = UserModel()
    let dateConversor = PublishedTimeConversor()
    var articles = Variable<[NewsAPIArticle]>([])
    
    func fetchArticles() {
        _ = userModel.getSources()
            .filter{ $0.id != nil }
            .map{ self.newsAPI.getArticles(sourceId: $0.id!, sortBy: SortBy.top) }
            .merge()
            .map { (newArticles) -> [NewsAPIArticle] in
                var articles = newArticles
                articles.append(contentsOf: self.articles.value)
                
                return articles.sorted {
                    guard let lhsStringDate = $0.0.publishedAt, let rhsStringDate = $0.1.publishedAt else { return false }
                    
                    guard let lhsDate = self.dateConversor.dateFormatter.date(from: lhsStringDate),
                        let rhsDate = self.dateConversor.dateFormatter.date(from: rhsStringDate)
                        else { return false }
                    
                    return lhsDate > rhsDate
                }
            }
            .bind(to: articles)
    }
    
    func convertUTCDateToTimePassed(utc: String) -> String {
        return dateConversor.convertToPassedTime(publishedDate: utc) ?? ""
    }
}
