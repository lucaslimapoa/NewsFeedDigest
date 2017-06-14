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
    func getItem(for indexPath: IndexPath) -> NewsAPIArticle
}

class NewsFeedViewModel: NewsFeedViewModelProtocol {
    
    weak var viewController: NewsFeedViewControllerProtocol!
    
    let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
    let userModel = UserModel()
    let disposeBag = DisposeBag()
    let publishedTimeConversor = PublishedTimeConversor()
    
    var articles = Variable<[NewsAPIArticle]>([])    
    
    func fetchArticles() {
        _ = userModel
            .getSources()
            .filter{ $0.id != nil }
            .map { $0.id! }
            .flatMap { sourceId in
                return self.newsAPI.getArticles(sourceId: sourceId, sortBy: SortBy.top)
            }
            .catchErrorJustReturn([])
            .map { articles in
                for var article in articles {
                    self.convertPublishedDate(article: &article)
                    self.articles.value.append(article)
                }
            }
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    func getItem(for indexPath: IndexPath) -> NewsAPIArticle {
        return articles.value[indexPath.item]
    }
    
    private func convertPublishedDate(article: inout NewsAPIArticle) {
        guard let publishedDate = article.publishedAt else {
            article.publishedAt = nil
            return
        }
        
        article.publishedAt = publishedTimeConversor.convertToPassedTime(publishedDate: publishedDate)
    }
}
