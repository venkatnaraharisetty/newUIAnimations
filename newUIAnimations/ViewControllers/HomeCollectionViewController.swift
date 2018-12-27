//
//  HomeCollectionViewController.swift
//  newUIAnimations
//
//  Created by Naraharisetty, Venkat on 12/22/18.
//  Copyright © 2018 Naraharisetty, Venkat. All rights reserved.
//

import UIKit
import Foundation

private let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController {
    
    var homeData:[Dictionary<String, String>] = []
    var selectedIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        loadData()
    }
    
    
    func loadData(){
        homeData = getDataFromPlist()
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageSegue" {
            let senderData:Dictionary<String,String> = sender as! Dictionary
            print(senderData)
            guard let image = UIImage(named: senderData["homeCellImageName"] ?? " ") else {return}
            let imageVC =  segue.destination as! ImageViewController
            imageVC.image = image
            imageVC.imageSet = senderData
        }
    }
    
    func getDataFromPlist() -> [Dictionary<String,String>]{
        let homePlistUrl = Bundle.main.url(forResource:"homeViewData", withExtension: "plist")
        let data = NSArray(contentsOf: homePlistUrl!)
        //print(data!)
        return data! as! [Dictionary<String, String>]
    }
    
}


// MARK Data Source
extension HomeCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return homeData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("view cell called")
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as? HomeCollectionViewCell else {
            fatalError("Could not create")
        }
        let cellData = homeData[indexPath.item]
        //print (cellData["homeCellImageName"])
        guard let image = UIImage(named: cellData["homeCellImageName"] ?? "") else {fatalError("NO Image found")}
        cell.homeCellLabel.text = cellData["homeCellLabel"]
        cell.backgroundImageView.image = image
        return cell
    }
    
}

//MARK : CollectionView Extensions

extension HomeCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 14;
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = homeData[indexPath.item]
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "showImageSegue", sender: data)
    }
}

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

//MARK Transition Animation

extension HomeCollectionViewController:Scaling {
    
    
    func animateImageView(transition: ImageTransitionDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath{
            guard let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell else {return nil}
            //let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell
            return cell.backgroundImageView
        }  else{
            return nil        }
        
    }
}
