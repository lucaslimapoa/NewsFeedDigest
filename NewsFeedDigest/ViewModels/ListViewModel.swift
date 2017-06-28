//
//  SourceListViewModel.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import NewsAPISwift

protocol ListViewModelType {
    var selectedCategoryListener: PublishSubject<NewsAPISwift.Category> { get }
    
    func fetchAvailableCategories() -> Observable<[NewsAPISwift.Category]>
    func fetchSources(for category: NewsAPISwift.Category) -> Observable<[NewsAPISource]>
}

class ListViewModel: ListViewModelType {
    
    let disposeBag = DisposeBag()
    let newsAPI: NewsAPIProtocol
    let availableCategories: [NewsAPISwift.Category] = [.business, .entertainment, .gaming, .general, .music, .politics, .scienceAndNature, .sport, .technology]
    
    var selectedCategoryListener = PublishSubject<NewsAPISwift.Category>()
    var delegate: SourceListViewModelDelegate?
    
    init(newsAPI: NewsAPIProtocol) {
        self.newsAPI = newsAPI
        
        setupListeners()
    }
    
    func setupListeners() {
        selectedCategoryListener
            .subscribe(onNext: { category in
                self.delegate?.sourceListViewModel(viewModel: self, didSelectCategory: category)
            })
            .addDisposableTo(disposeBag)
    }
    
    func fetchAvailableCategories() -> Observable<[NewsAPISwift.Category]> {
        return Observable.from(optional: availableCategories)
    }
    
    func fetchSources(for category: NewsAPISwift.Category) -> Observable<[NewsAPISource]> {
        return newsAPI.getSources(category: category)
            .map { self.sortAlphabetically(sources: $0) }
    }
    
    func sortAlphabetically(sources: [NewsAPISource]) -> [NewsAPISource] {
        return sources.sorted {
            guard let lhsName = $0.0.name, let rhsName = $0.1.name else { return false }
            return lhsName < rhsName
        }
    }
}

