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

protocol NewsFeedViewModelType: class {
    func fetchArticles() -> Observable<[NewsAPIArticle]>    
    func createCellViewModel(from article: NewsAPIArticle) -> NewsCellViewModel
}

class NewsFeedViewModel: NewsFeedViewModelType {
    
    let userStore: UserStoreType
    let newsAPIClient: NewsAPIProtocol
    let dateConversor: DateConversorType
    
    init(userStore: UserStoreType, newsAPIClient: NewsAPIProtocol, dateConversor: DateConversor = DateConversor()) {
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
    
    func createCellViewModel(from article: NewsAPIArticle) -> NewsCellViewModel {
        let source = userStore.find(sourceId: article.sourceId)
        return NewsCellViewModel((article, source), dateConversor: dateConversor)
    }
}

struct NewsCellViewModel {
    
    private(set) var articleDescription: NSAttributedString!
    private(set) var articleInfo: NSAttributedString!
    private(set) var urlToImage: URL?
    private(set) var url: URL?
    
    init(_ tuple: (article: NewsAPIArticle, source: NewsAPISource?), dateConversor: DateConversorType) {
        var date: String?
        
        if let publishedAt = tuple.article.publishedAt {
            date = dateConversor.convertToPassedTime(publishedDate: publishedAt)
        }
        
        articleInfo = createInformation(source: tuple.source, publishedAt: date)
        articleDescription = createDescription(title: tuple.article.title, description: tuple.article.articleDescription)
        
        urlToImage = tuple.article.urlToImage
        url = tuple.article.url
    }
    
    func createDescription(title: String?, description: String?) -> NSAttributedString {
        guard let title = title, let articleDescription = description else { return NSAttributedString() }
        
        let attributedText = NSMutableAttributedString(string: "\(title)\n", attributes: [NSFontAttributeName: Fonts.cellTitleFont])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        
        attributedText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attributedText.string.characters.count))
        attributedText.append(NSAttributedString(string: articleDescription, attributes: [NSForegroundColorAttributeName: Colors.cellInformationText, NSFontAttributeName: Fonts.cellDescriptionFont]))
        
        return attributedText
    }
    
    func createInformation(source: NewsAPISource?, publishedAt: String?) -> NSAttributedString {
        let sourceName = source?.name ?? ""
        
        let categoryColor = getCategoryColor(source?.category)
        
        let infoText = NSMutableAttributedString(string: sourceName, attributes: [
            NSForegroundColorAttributeName: categoryColor,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)
            ])
        
        if let publishedAt = publishedAt {
            infoText.append(NSAttributedString(string: " | \(publishedAt)", attributes: [
                NSForegroundColorAttributeName: UIColor(red: 128/255, green: 130/255, blue: 137/255, alpha: 1.0),
                NSFontAttributeName: UIFont.systemFont(ofSize: 11.0)
                ]))
        }
        
        return infoText
    }
}
