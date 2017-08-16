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
    func newsFeedViewModel(viewModel: NewsFeedViewModelType, didSelectSource source: SourceObject)
}

protocol NewsFeedViewModelType: class {
    var articleSections: Variable<[ArticleSection]> { get }
    var selectedItemListener: PublishSubject<ArticleObject> { get }
    var selectedSourceListener: PublishSubject<SourceId> { get }
    
    func fetchArticles()
    func createCellViewModel(from article: ArticleObject) -> NewsCellViewModel
}

class NewsFeedViewModel: NewsFeedViewModelType {
    
    let dateConversor: DateConversorType
    
    let articleInteractor: ArticleInteractor
    let sourceInteractor: SourceInteractor
    
    let disposeBag = DisposeBag()
    
    var selectedItemListener = PublishSubject<ArticleObject>()
    var selectedSourceListener = PublishSubject<SourceId>()
    
    var coordinatorDelegate: NewsFeedViewModelCoordinatorDelegate?
    var articleSections = Variable<[ArticleSection]>([])
    
    init(articleInteractor: ArticleInteractor, sourceInteractor: SourceInteractor, dateConversor: DateConversor = DateConversor()) {        
        self.articleInteractor = articleInteractor
        self.sourceInteractor = sourceInteractor
        self.dateConversor = dateConversor
        
        setupListeners()
        setupRx()
    }
    
    func setupListeners() {
        selectedItemListener
            .subscribe(onNext: { article in
                self.coordinatorDelegate?.newsFeedViewModel(viewModel: self, didSelectArticle: article)
            })
            .disposed(by: disposeBag)
        
        selectedSourceListener
            .map { self.sourceInteractor.fetchSource(with: $0) }
            .flatMap { Observable.from(optional: $0) }
            .subscribe(onNext: { sourceObject in
                self.coordinatorDelegate?.newsFeedViewModel(viewModel: self, didSelectSource: sourceObject)
            })
            .disposed(by: disposeBag)
    }
    
    func setupRx() {
        let favoriteSources = sourceInteractor.fetchSources(predicate: "isFavorite == true")
            .map { $0.toArray() }
            .map { $0.map { $0.id } }
            .flatMap { Observable.from(optional: $0) }
        
        articleInteractor.fetchArticles(favoritesStream: favoriteSources)
            .map { $0.sorted { $0.0.timeInterval > $0.1.timeInterval } }
            .map { (articles: [ArticleObject]) -> [String: [ArticleObject]] in
                var groups = [String: [ArticleObject]]()
                
                articles.forEach { article in
                    if groups[article.sourceId] == nil {
                        groups[article.sourceId] = [ArticleObject]()
                    }
                    
                    groups[article.sourceId]?.append(article)
                }
                
                return groups
            }
            .map { [weak self] (groups: [String: [ArticleObject]]) -> [ArticleSection]? in
                var sections = [ArticleSection]()
                
                groups.forEach { groupName, items in
                    let sectionName = groupName.uppercased(with: Locale.current)
                    let sectionItems = Array(items.prefix(4))
                    var color: UIColor = .black
                    
                    if let sourceId = sectionItems.first?.sourceId {
                        if let categoryString = self?.sourceInteractor.fetchSource(with: sourceId)?.category {
                            if let category = Category(rawValue: categoryString) {
                                color = Colors.color(for: category)
                            }
                        }
                        
                        let articleSection = ArticleSection(header: sectionName, items: sectionItems, color: color, sourceId: sourceId)                        
                        sections.append(articleSection)
                    }
                }
                
                return sections
            }
            .flatMap { Observable.from(optional: $0) }
            .filter { $0.count > 0 }
            .subscribe(onNext: { [weak self] sections in
                guard let welf = self else { return }                                
                
                welf.articleSections.value.removeAll()
                welf.articleSections.value.append(contentsOf: sections)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchArticles() {
        let sourcesObservable = sourceInteractor.fetchSources(predicate: "isFavorite == true")
            .flatMap { Observable.array(from: $0) }
            .flatMap { Observable.from($0) }
        
        articleInteractor.fetchArticles(observable: sourcesObservable)
    }
    
    func createCellViewModel(from article: ArticleObject) -> NewsCellViewModel {
        let source = sourceInteractor.fetchSource(with: article.sourceId)
        return NewsCellViewModel((article, source), dateConversor: dateConversor)
    }
}
