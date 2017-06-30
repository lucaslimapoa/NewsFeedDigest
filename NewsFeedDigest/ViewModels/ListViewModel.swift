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
            .subscribe(onNext: { category in
                self.delegate?.sourceListViewModel(viewModel: self, didSelectCategory: category)
            })
            .addDisposableTo(disposeBag)
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
        return SourceCellViewModel(source: source, interactor: sourceInteractor)
    }
}

struct SourceCellViewModel {
    
    private(set) var sourceDescription: NSAttributedString!
    private(set) var interactor: SourceInteractor!    
    
    private(set) var didFavorite: (() -> Void)?
    private(set) var didUnfavorite: (() -> Void)?
    
    var viewState: Observable<FavoriteViewState>?
    
    init(source: NewsAPISource, interactor: SourceInteractor) {
        self.interactor = interactor
        sourceDescription = createSourceDescription(source: source)
        
        if let sourceId = source.id {
            viewState = interactor.isFavorite(sourceId)
                .map { ($0.isEmpty) ?
                    FavoriteViewState.isNotFavorite : FavoriteViewState.isFavorite
                }
            
            didFavorite = {
                interactor.setFavorite(for: sourceId, isFavorite: true)
            }
            
            didUnfavorite = {
                interactor.setFavorite(for: sourceId, isFavorite: false)
            }
        }
    }
    
    private func createSourceDescription(source: NewsAPISource) -> NSAttributedString {
        guard let name = source.name, let description = source.sourceDescription else {
            return NSAttributedString()
        }
        
        let attributedText = NSMutableAttributedString(string: "\(name)\n", attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16.0),
            NSForegroundColorAttributeName: UIColor(r: 0, g: 92, b: 208)
            ])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        
        attributedText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: range)
        
        attributedText.append(NSAttributedString(string: description, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 13.0),
            NSForegroundColorAttributeName: UIColor(r: 78, g: 85, b: 94)
            ]))
        
        return attributedText
    }
}
