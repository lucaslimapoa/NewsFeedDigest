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

protocol SourceArticleViewModelDelegate: class {
    func sourceArticleViewModel(viewMode: SourceArticleViewModel, didSelectArticle article: ArticleObject)
}

protocol SourceArticleViewModelType {
    var selectedItemListener: PublishSubject<ArticleObject> { get set }
    
    func fetchTitle() -> Observable<String>
    func fetchDescription() -> Observable<String>
    func fetchArticles() -> Observable<[ArticleObject]>
    func createCellViewModel(from article: ArticleObject) -> NewsCellViewModel
    
    func fetchArticle(indexPath: IndexPath) -> ArticleObject?
}

class SourceArticleViewModel: SourceArticleViewModelType {
    
    weak var delegate: SourceArticleViewModelDelegate?
    
    let disposeBag = DisposeBag()
    var selectedItemListener = PublishSubject<ArticleObject>()
    
    private var sourceObject: SourceObject
    private var articleInteractor: ArticleInteractor
    private let dateConversor = DateConversor(currentDate: Date())
    
    init(sourceObject: SourceObject, articleInteractor: ArticleInteractor) {
        self.sourceObject = sourceObject
        self.articleInteractor = articleInteractor
        
        setupListeners()
    }
    
    func setupListeners() {
        selectedItemListener
            .subscribe(onNext: { [weak self] article in
                guard let welf = self else { return }
                welf.delegate?.sourceArticleViewModel(viewMode: welf, didSelectArticle: article)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchTitle() -> Observable<String> {
        return Observable.just(sourceObject.name)
    }
    
    func fetchDescription() -> Observable<String> {
        return Observable.just(sourceObject.sourceDescription)
    }
    
    func fetchArticles() -> Observable<[ArticleObject]> {
        let articles = articleInteractor
            .fetchArticles(from: sourceObject.id)
            .sorted { lhs, rhs in
                return lhs.timeInterval > rhs.timeInterval
            }
        
        return Observable.from(optional: articles)
    }
    
    func createCellViewModel(from article: ArticleObject) -> NewsCellViewModel {
        return NewsCellViewModel((article, sourceObject), dateConversor: dateConversor)
    }
    
    func fetchArticle(indexPath: IndexPath) -> ArticleObject? {
        let articles = articleInteractor.fetchArticles(from: sourceObject.id)
        
        if indexPath.row < 0 || indexPath.row > articles.count {
            return nil
        }
        
        return articles[indexPath.row]
    }
}
