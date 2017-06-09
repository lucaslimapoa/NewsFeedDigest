//
//  NewsFeedViewModel.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import NewsAPISwift

protocol NewsFeedViewModelProtocol: class {
    func requestArticles() -> Observable<[NewsAPIArticle]>
}

class NewsFeedViewModel: NewsFeedViewModelProtocol {
    
    let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
    
    weak var viewController: NewsFeedViewControllerProtocol!
    
    private func getUserSources() -> [NewsAPISource] {
        return [
            NewsAPISource(id: "the-verge", name: "The Verge", sourceDescription: "", url: "", category: Category.technology, language: Language.english, country: Country.unitedStates, sortBysAvailable: [SortBy.latest])
        ]
    }
    
    func requestArticles() -> Observable<[NewsAPIArticle]> {
        return newsAPI.getArticles(from: getUserSources(), sortBy: SortBy.latest)
    }
}
