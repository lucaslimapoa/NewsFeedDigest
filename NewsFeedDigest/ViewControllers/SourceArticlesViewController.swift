//
//  SourceArticlesViewController.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 8/17/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit
import NewsAPISwift

fileprivate let tabBarHeight: CGFloat = 49.0
fileprivate let navigationBarHeight: CGFloat = 64.0

class SourceArticlesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var tableViewInitialPos: CGPoint = .zero
    
    var tableViewContentOffsetY: CGFloat = 0 {
        didSet {
            updateTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
//        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {
        tableViewInitialPos = tableView.frame.origin
    }
 
    private func calculateTableViewSize() -> CGSize {
        let screenHeight = view.frame.height
        let newTableViewHeight = screenHeight - tableView.frame.origin.y - tabBarHeight
        
        return CGSize(width: tableView.frame.width, height: newTableViewHeight)
    }
    
    private func updateTableView() {
        let newY = max(tableViewInitialPos.y - tableViewContentOffsetY, navigationBarHeight)
        tableView.frame.origin = CGPoint(x: tableViewInitialPos.x, y: newY)
        tableView.frame.size = calculateTableViewSize()
    }
}

extension SourceArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)        
        cell.textLabel?.text = UUID().uuidString
        
        return cell
    }
    
}

extension SourceArticlesViewController: UIScrollViewDelegate {
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewContentOffsetY = scrollView.contentOffset.y
    }
    
}
