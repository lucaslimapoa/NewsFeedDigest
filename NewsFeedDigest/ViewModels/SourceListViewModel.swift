//
//  SourceListViewModel.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import NewsAPISwift

protocol SourceListViewModelType {
    func fetchAvailableCategories() -> Observable<[NewsAPISwift.Category]>
    func fetchSources(for category: NewsAPISwift.Category) -> Observable<[NewsAPISource]>
}

class SourceListViewModel: SourceListViewModelType {
    
    let newsAPI: NewsAPIProtocol
    let availableCategories: [NewsAPISwift.Category] = [.business, .entertainment, .gaming, .general, .music, .politics, .scienceAndNature, .sport, .technology]
    
    init(newsAPI: NewsAPIProtocol) {
        self.newsAPI = newsAPI
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

