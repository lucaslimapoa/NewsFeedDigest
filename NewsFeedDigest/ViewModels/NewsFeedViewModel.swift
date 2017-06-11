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
}

class NewsFeedViewModel: NewsFeedViewModelProtocol {
    
    weak var viewController: NewsFeedViewControllerProtocol!
    
    let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
    let userModel = UserModel()
    let disposeBag = DisposeBag()
    
    var articles = Variable<[NewsAPIArticle]>([])
    
    init() {
        
    }
    
    func fetchArticles() {
        _ = userModel
            .getSources()
            .filter{ $0.id != nil }
            .map { $0.id! }
            .flatMap { sourceId in
                return self.newsAPI.getArticles(sourceId: sourceId, sortBy: SortBy.latest)
            }
            .catchErrorJustReturn([])
            .map { self.articles.value.append(contentsOf: $0) }
            .subscribe()
            .addDisposableTo(disposeBag)
    }
}
