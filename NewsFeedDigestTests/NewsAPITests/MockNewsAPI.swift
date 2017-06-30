//
//  MockNewsAPI.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/21/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import NewsAPISwift

class MockNewsAPI: NewsAPI {
    
    override func getArticles(sourceId: SourceId, sortBy: SortBy?, completionHandler: @escaping (Result<[NewsAPIArticle]>) -> Void) {
        
        switch sourceId {
        case "invalid-id":
            completionHandler(Result.error(NewsAPIError.invalidUrl))
        default:
            completionHandler(Result.success(createMockArticles()))
        }
    }
    
    override func getSources(category: Category?, language: Language?, country: Country?, completionHandler: @escaping (Result<[NewsAPISource]>) -> Void) {
        completionHandler(Result.success(createMockSources()))
    }
}

func createMockArticles() -> [NewsAPIArticle] {
    return [
        NewsAPIArticle(sourceId: "valid-id", author: nil, title: "Mock 1", articleDescription: "Article Mock 1 description", url: nil, urlToImage: nil, publishedAt: "2017-06-13T15:25:00Z"),
        NewsAPIArticle(sourceId: "valid-id", author: nil, title: "Mock 2", articleDescription: "Article Mock 2 description", url: nil, urlToImage: nil, publishedAt: "2017-06-13T16:35:00Z"),
        NewsAPIArticle(sourceId: "valid-id", author: nil, title: "Mock 3", articleDescription: "Article Mock 3 description", url: nil, urlToImage: nil, publishedAt: "2017-06-13T17:25:00Z")
    ]
}

func createMockSources() -> [NewsAPISource] {
    return [
        NewsAPISource(id: "a", name: "A", sourceDescription: "", url: "", category: Category.business, language: .english, country: .unitedStates, sortBysAvailable: [.top]),
        NewsAPISource(id: "c", name: "C", sourceDescription: "", url: "", category: Category.business, language: .english, country: .unitedStates, sortBysAvailable: [.top]),
        NewsAPISource(id: "b", name: "B", sourceDescription: "", url: "", category: Category.business, language: .english, country: .unitedStates, sortBysAvailable: [.top]),
        NewsAPISource(id: "f", name: "F", sourceDescription: "", url: "", category: Category.business, language: .english, country: .unitedStates, sortBysAvailable: [.top]),
        NewsAPISource(id: "e", name: "E", sourceDescription: "", url: "", category: Category.business, language: .english, country: .unitedStates, sortBysAvailable: [.top])
    ]
}
