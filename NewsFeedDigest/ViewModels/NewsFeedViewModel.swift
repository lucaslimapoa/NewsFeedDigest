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
    func fetchArticles() -> Observable<[NewsAPIArticle]>
}

class NewsFeedViewModel: NewsFeedViewModelProtocol {
    
    let userStore: UserStoreProtocol
    let newsAPIClient: NewsAPIProtocol
    let dateConversor: DateConversorProtocol
    
    init(userStore: UserStoreProtocol, newsAPIClient: NewsAPIProtocol, dateConversor: DateConversor = DateConversor()) {
        self.userStore = userStore
        self.newsAPIClient = newsAPIClient
        self.dateConversor = dateConversor
    }
    
    func fetchArticles() -> Observable<[NewsAPIArticle]> {
        let articlesStream = userStore.fetchFollowingSources()
            .filter { $0.id != nil }
            .map { $0.id! }
            .map{ self.newsAPIClient.getArticles(sourceId: $0) }
            .merge()
        
        let sortedStream = articlesStream
            .toArray()
            .map { $0.flatMap { $0 } }
            .map{ self.sortByDate($0) }
        
        return sortedStream
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
}
