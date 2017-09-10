//
//  NewsFeedSectionFooterView.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 7/26/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

protocol NewsFeedSectionFooterViewDelegate: class {
    func newsFeedSectionFooterView(_ footerView: NewsFeedSectionFooterView, didSelectSource source: SourceId)
}

class NewsFeedSectionFooterView: UIView {
    @IBOutlet weak var textLabel: UILabel!
    
    var sourceId: SourceId?
    weak var delegate: NewsFeedSectionFooterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        guard let sourceId = sourceId else { return }
        delegate?.newsFeedSectionFooterView(self, didSelectSource: sourceId)
    }
}
