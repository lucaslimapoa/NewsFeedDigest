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
}

class SourceListViewModel: SourceListViewModelType {
    
    let availableCategories: [NewsAPISwift.Category] = [.business, .entertainment, .gaming, .general, .music, .politics, .scienceAndNature, .sport, .technology]
    
    func fetchAvailableCategories() -> Observable<[NewsAPISwift.Category]> {
        return Observable.from(optional: availableCategories)
    }
}

