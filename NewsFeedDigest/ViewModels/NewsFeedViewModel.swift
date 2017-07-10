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
    func newsFeedViewModel(viewModel: NewsFeedViewModelType, didSelectArticle article: NewsAPIArticle)
}

protocol NewsFeedViewModelType: class {
    var selectedItemListener: PublishSubject<NewsAPIArticle> { get }
    
    func fetchArticles() -> Observable<[ArticleSection]>
    func createCellViewModel(from article: NewsAPIArticle) -> NewsCellViewModel
}

class NewsFeedViewModel: NewsFeedViewModelType {
    
    let userStore: UserStoreType
    let newsAPIClient: NewsAPIProtocol
    let dateConversor: DateConversorType
    let disposeBag = DisposeBag()
    
    var selectedItemListener = PublishSubject<NewsAPIArticle>()
    var coordinatorDelegate: NewsFeedViewModelCoordinatorDelegate?
    
    init(userStore: UserStoreType, newsAPIClient: NewsAPIProtocol, dateConversor: DateConversor = DateConversor()) {
        self.userStore = userStore
        self.newsAPIClient = newsAPIClient
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
    
    func fetchArticles() -> Observable<[ArticleSection]> {
        return Observable.create { _ in
            return Disposables.create()
        }
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
    
    func createCellViewModel(from article: NewsAPIArticle) -> NewsCellViewModel {
        let source = userStore.find(sourceId: article.sourceId)
        return NewsCellViewModel((article, source), dateConversor: dateConversor)
    }
}
