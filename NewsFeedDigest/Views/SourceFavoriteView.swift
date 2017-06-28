//
//  SourceFavoriteView.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/28/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import RxRealm
import RxSwift
import NewsAPISwift

class SourceFavoriteView: FavoriteView {
    
    let disposeBag = DisposeBag()
    
    var sourceId: SourceId!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This view is not supposed to be initialized by Storyboards")
    }
    
    func setup(with sourceId: SourceId) {
        self.sourceId = sourceId
        
        didFavorite = { [weak self] in
            // save on database
        }
        
        didUnfavorite = { [weak self] in
            // remove from database
        }
    }
}
