//
//  SourceArticleViewModel.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 8/24/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import Foundation
import RxSwift
import NewsAPISwift
import RealmSwift

protocol SourceArticleViewModelType {
    func fetchTitle() -> Observable<String>
    func fetchDescription() -> Observable<String>
    func fetchArticles() -> Observable<[ArticleObject]>
    func createCellViewModel(from article: ArticleObject) -> NewsCellViewModel
}

struct SourceArticleViewModel: SourceArticleViewModelType {
    
    private var sourceObject: SourceObject
    private var articleInteractor: ArticleInteractor
    private let dateConversor = DateConversor(currentDate: Date())
    
    init(sourceObject: SourceObject, articleInteractor: ArticleInteractor) {
        self.sourceObject = sourceObject
        self.articleInteractor = articleInteractor
    }
    
    func fetchTitle() -> Observable<String> {
        return Observable.just(sourceObject.name)
    }
    
    func fetchDescription() -> Observable<String> {
        return Observable.just(sourceObject.sourceDescription)
    }
    
    func fetchArticles() -> Observable<[ArticleObject]> {
        let articles = articleInteractor.fetchArticles(from: sourceObject.id)
        return Observable.from(optional: articles)
    }
    
    func createCellViewModel(from article: ArticleObject) -> NewsCellViewModel {
        return NewsCellViewModel((article, sourceObject), dateConversor: dateConversor)
    }
    
}
