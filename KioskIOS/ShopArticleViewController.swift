//
//  ShopArticleViewController.swift
//  KioskIOS
//
//  Created by Metz, Oliver, NMM-NM on 7/6/16.
//  Copyright © 2016 techlung. All rights reserved.
//

import UIKit

class ShopArticleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    
    var articles:[Database.Article] = []
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        /*
        articleCollectionView.registerClass(ShopArticleViewControllerCell.self, forCellWithReuseIdentifier: "cell")
        */
        loadData()
    }
    
    func loadData() {
        articles.removeAll()
        articles.appendContentsOf(Database.loadArticles())
        articleCollectionView.reloadData()
        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ShopArticleViewControllerCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let article = self.articles[indexPath.item]
        
        cell.name.text = article.name
        cell.price.text = article.price.description
        
        cell.backgroundColor = UIColor.yellowColor() // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}

