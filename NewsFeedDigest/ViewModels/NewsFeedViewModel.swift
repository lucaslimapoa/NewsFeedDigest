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
    var articles: Variable<[NewsAPIArticle]> { get }
    func fetchArticles()
    func convertToInformationText(sourceId: SourceId, publishedAt: String) -> NSAttributedString
}

class NewsFeedViewModel: NewsFeedViewModelProtocol {
    
    weak var viewController: NewsFeedViewControllerProtocol!
    
    let newsAPI = NewsAPI(key: "3d188ee285764cb196fd491913960a24")
    let userModel = UserModel()
    let dateConversor = PublishedTimeConversor()
    var articles = Variable<[NewsAPIArticle]>([])
    
    func fetchArticles() {
        _ = userModel.getSources()
            .filter{ $0.id != nil }
            .map{ self.newsAPI.getArticles(sourceId: $0.id!, sortBy: SortBy.top) }
            .merge()
            .toArray()
            .map { $0.flatMap { $0 } }        
            .map { (newArticles) -> [NewsAPIArticle] in
                return newArticles.sorted {
                    guard let lhsStringDate = $0.0.publishedAt, let rhsStringDate = $0.1.publishedAt else { return false }
                    
                    guard let lhsDate = self.dateConversor.convertToDate(string: lhsStringDate),
                        let rhsDate = self.dateConversor.convertToDate(string: rhsStringDate)
                        else { return false }
                    
                    return lhsDate > rhsDate
                }
            }
            .bind(to: articles)
    }
    
    func convertToInformationText(sourceId: SourceId, publishedAt: String) -> NSAttributedString {
        let source = userModel.getSource(by: sourceId)
        let sourceName = source?.name ?? ""
        let publishedTime = dateConversor.convertToPassedTime(publishedDate: publishedAt) ?? ""
        
        let categoryColor = source?.categoryColor ?? UIColor.black
        
        let infoText = NSMutableAttributedString(string: sourceName, attributes: [
            NSForegroundColorAttributeName: categoryColor,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)
            ])
        
        infoText.append(NSAttributedString(string: " | \(publishedTime)", attributes: [
            NSForegroundColorAttributeName: UIColor(red: 128/255, green: 130/255, blue: 137/255, alpha: 1.0),
            NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)
            ]))
        
        return infoText
    }
}
