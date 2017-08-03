//
//  SourceListViewModel.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import RxSwift
import RxRealm
import RealmSwift
import NewsAPISwift

protocol ListViewModelType {
    var selectedCategoryListener: PublishSubject<NewsAPISwift.Category> { get }
    
    func fetchAvailableCategories() -> Observable<[NewsAPISwift.Category]>
    func fetchSources(for category: NewsAPISwift.Category) -> Observable<[NewsAPISource]>
    
    func createSourceCellViewModel(with source: NewsAPISource) -> SourceCellViewModel
}

class ListViewModel: ListViewModelType {
    
    let disposeBag = DisposeBag()
    var sourceInteractor: SourceInteractor!
    
    let availableCategories: [NewsAPISwift.Category] = [.business, .entertainment, .gaming, .general, .music, .politics, .scienceAndNature, .sport, .technology]
    
    var selectedCategoryListener = PublishSubject<NewsAPISwift.Category>()
    var delegate: SourceListViewModelDelegate?
    
    init(sourceInteractor: SourceInteractor) {
        self.sourceInteractor = sourceInteractor        
        setupListeners()
    }
    
    func setupListeners() {
        selectedCategoryListener
            .subscribe(onNext: { [weak self] category in
                guard let welf = self else { return }
                welf.delegate?.sourceListViewModel(viewModel: welf, didSelectCategory: category)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchAvailableCategories() -> Observable<[NewsAPISwift.Category]> {
        return Observable.from(optional: availableCategories)
    }
    
    func fetchSources(for category: NewsAPISwift.Category) -> Observable<[NewsAPISource]> {
        return sourceInteractor
            .fetchSources(for: category)
            .map { $0.map { $0.convertToNewsAPI() } }
            .flatMap { Observable.from(optional: Array($0)) }
    }
    
    func sortAlphabetically(sources: [NewsAPISource]) -> [NewsAPISource] {
        return sources.sorted {
            guard let lhsName = $0.0.name, let rhsName = $0.1.name else { return false }
            return lhsName < rhsName
        }
    }
    
    func createSourceCellViewModel(with source: NewsAPISource) -> SourceCellViewModel {
        return SourceCellViewModel(source: source, sourceInteractor: sourceInteractor)
    }
}
