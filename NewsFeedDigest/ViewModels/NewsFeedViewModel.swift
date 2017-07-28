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
    
    let dateConversor: DateConversorType
    
    let articleInteractor: ArticleInteractor
    let sourceInteractor: SourceInteractor
    
    let disposeBag = DisposeBag()
    
    var selectedItemListener = PublishSubject<ArticleObject>()
    var coordinatorDelegate: NewsFeedViewModelCoordinatorDelegate?
    var articleSections = Variable<[ArticleSection]>([])
    
    init(articleInteractor: ArticleInteractor, sourceInteractor: SourceInteractor, dateConversor: DateConversor = DateConversor()) {        
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
                let sectionItems = self.articleInteractor.fetchArticles(from: sourceObject.id).sorted {
                    return $0.0.timeInterval > $0.1.timeInterval
                }.prefix(4)                
                
                let categoryColor = Colors.color(for: Category(rawValue: sourceObject.category))
                let sectionItemsArray = Array(sectionItems)
                let articleSection = ArticleSection(header: sourceObject.name, items: sectionItemsArray, color: categoryColor)
                
                return articleSection
            }
            .subscribe(onNext: { section in
                self.articleSections.value.append(section)
            })
            .dispose()
    }
    
    func createCellViewModel(from article: ArticleObject) -> NewsCellViewModel {
        let source = sourceInteractor.fetchSource(with: article.sourceId)
        return NewsCellViewModel((article, source), dateConversor: dateConversor)
    }
}
