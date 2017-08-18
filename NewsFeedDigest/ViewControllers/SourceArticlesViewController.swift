//
//  SourceArticlesViewController.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 8/17/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

class SourceArticlesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var tableViewTopViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopDescriptionConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionBottomTableView: NSLayoutConstraint!
    @IBOutlet weak var descriptionBottomSpacing: NSLayoutConstraint!
    
    var topViewSpacing: CGFloat = 0 {
        didSet {
            if topViewSpacing < 0 {
                topViewSpacing = 0                
            }
        }
    }
    
    var previousTopViewSpacing: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
    }

}

extension SourceArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Teste"
        
        return cell
    }
    
}

extension SourceArticlesViewController: UIScrollViewDelegate {
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        previousTopViewSpacing = tableViewTopViewConstraint.constant
        
        let descriptionPositionY = descriptionTextView.frame.origin.y + descriptionTextView.frame.size.height
        let tableViewPositionY = tableView.frame.origin.y
        
        if tableViewPositionY > descriptionPositionY + 16 {
            tableViewTopViewConstraint.priority = 998
            tableViewTopDescriptionConstraint.priority = 999
            
            descriptionBottomSpacing.priority = 998
            descriptionBottomTableView.priority = 999
        } else {
            tableViewTopDescriptionConstraint.priority = 998
            tableViewTopViewConstraint.priority = 999
            
            descriptionBottomSpacing.priority = 999
            descriptionBottomTableView.priority = 998
        }
        
        let contentOffsetY = scrollView.contentOffset.y
        
        topViewSpacing = previousTopViewSpacing - contentOffsetY
        tableViewTopViewConstraint.constant = topViewSpacing
    }
    
}
