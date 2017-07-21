//
//  NewsFeedViewModel.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import RealmSwift
import NewsAPISwift

protocol NewsFeedViewModelCoordinatorDelegate {
    func newsFeedViewModel(viewModel: NewsFeedViewModelType, didSelectArticle article: ArticleObject)
}

protocol NewsFeedViewModelType: class {
    var articleSections: Variable<[ArticleSection]> { get }
    var selectedItemListener: PublishSubject<ArticleObject> { get }
    
    func fetchArticles()
    func createCellViewModel(from article: ArticleObject) -> NewsCellViewModel
}

class NewsFeedViewModel: NewsFeedViewModelType {
    
    let userStore: UserStoreType
    let dateConversor: DateConversorType
    
    let articleInteractor: ArticleInteractor
    let sourceInteractor: SourceInteractor
    
    let disposeBag = DisposeBag()
    
    var selectedItemListener = PublishSubject<ArticleObject>()
    var coordinatorDelegate: NewsFeedViewModelCoordinatorDelegate?
    var articleSections = Variable<[ArticleSection]>([])
    
    init(userStore: UserStoreType, articleInteractor: ArticleInteractor, sourceInteractor: SourceInteractor, dateConversor: DateConversor = DateConversor()) {
        self.userStore = userStore
        self.articleInteractor = articleInteractor
        self.sourceInteractor = sourceInteractor
        self.dateConversor = dateConversor
        
        setupListeners()
    }
    
    func setupListeners() {
        selectedItemListener
            .subscribe(onNext: { article in
                self.coordinatorDelegate?.newsFeedViewModel(viewModel: self, didSelectArticle: article)
            })
            .addDisposableTo(disposeBag)
    }
    
    func fetchArticles() {
        self.articleSections.value.removeAll()
        
        let sourcesObservable = sourceInteractor.fetchSources(predicate: "isFavorite == true")
            .flatMap { Observable.array(from: $0) }
            .flatMap { Observable.from($0) }

        _ = articleInteractor.fetchArticles(observable: sourcesObservable)
        
        sourcesObservable
            .map { (sourceObject: SourceObject) -> ArticleSection in
                let sectionItems = self.articleInteractor.fetchArticles(from: sourceObject.id)
                let articleSection = ArticleSection(header: sourceObject.name, items: sectionItems)
                
                return articleSection
            }
            .subscribe(onNext: { section in
                self.articleSections.value.append(section)
            })
            .dispose()
    }

    func sortByDate(_ articles: [NewsAPIArticle]) -> [NewsAPIArticle] {
        return articles.sorted {
            guard let lhsPublishedTime = $0.0.publishedAt,
                let rhsPublishedTime = $0.1.publishedAt else { return false }
            
            guard let lhsDate = dateConversor.convertToDate(string: lhsPublishedTime),
                let rhsDate = dateConversor.convertToDate(string: rhsPublishedTime) else { return false }
            
            return lhsDate > rhsDate
        }
    }
    
    func createCellViewModel(from article: ArticleObject) -> NewsCellViewModel {
        let source = userStore.find(sourceId: article.sourceId)
        return NewsCellViewModel((article, source), dateConversor: dateConversor)
    }
}
