//
//  NewsFeedTableViewHeader.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 8/14/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

class NewsFeedTableViewHeader: UIView {    
    @IBOutlet weak var messageLabel: UILabel!
    
    private let monthFormat = "MMMM dd"
    private let dayFormat = "EEEE"
    
    private lazy var dateFormatter: DateFormatter = {
        return DateFormatter()
    }()
    
    func updateMessage() {
        let date = Date()
        
        let month = getMonth(date)
        let attributedString = NSMutableAttributedString(string: month, attributes: [NSFontAttributeName: Fonts.messageDayOfWeek, NSForegroundColorAttributeName: Colors.cellInformationText])
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5.0
        
        let range = NSRange(location: 0, length: month.characters.count)
        attributedString.addAttributes([NSParagraphStyleAttributeName: paragraph], range: range)
        
        let day = getDay(date)
        attributedString.append(NSAttributedString(string: "\n\(day)", attributes: [NSFontAttributeName: Fonts.messageMonth]))
        
        messageLabel.attributedText = attributedString
    }
    
    private func getMonth(_ date: Date) -> String {
        dateFormatter.dateFormat = monthFormat
        return dateFormatter.string(from: date).localizedUppercase
    }
    
    private func getDay(_ date: Date) -> String {
        dateFormatter.dateFormat = dayFormat
        return dateFormatter.string(from: date).localizedUppercase
    }

}
