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
}

func createMockArticles() -> [NewsAPIArticle] {
    return [
        NewsAPIArticle(sourceId: "valid-id", author: nil, title: "Mock 1", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: "2017-06-13T15:25:00Z"),
        NewsAPIArticle(sourceId: "valid-id", author: nil, title: "Mock 2", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: "2017-06-13T16:35:00Z"),
        NewsAPIArticle(sourceId: "valid-id", author: nil, title: "Mock 3", articleDescription: nil, url: nil, urlToImage: nil, publishedAt: "2017-06-13T17:25:00Z")
    ]
}
