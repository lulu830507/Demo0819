//
//  IGCollectionViewController.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/31.
//

import UIKit


class IGCollectionViewController: UICollectionViewController {
    
    var instagramData: IGData?
    var instagramPostPicture = [IGData.Graphql.User.Edge_owner_to_timeline_media.Edges]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    func fetchData() {
        IGData.sendRequest(method: .get, reponse: IGData.self) { result in
            switch result {
            case .success(let data):
                self.instagramData = data
                DispatchQueue.main.async {
                    self.instagramPostPicture = data.graphql.user.edge_owner_to_timeline_media.edges
                    self.navigationItem.backButtonTitle = "BACK"
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return instagramPostPicture.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(IGCollectionViewCell.self)", for: indexPath) as? IGCollectionViewCell else { return UICollectionViewCell()}
        
        cell.set(for: instagramPostPicture[indexPath.row])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let resuableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(IGCollectionReusableView.self)", for: indexPath) as? IGCollectionReusableView else {return UICollectionReusableView()}
        
        guard let instagramData = self.instagramData else { return resuableView }
        resuableView.set(for: instagramData)
        
        return resuableView
    }
    
    @IBSegueAction func showDetail(_ coder: NSCoder) -> PhotoCollectionViewController? {
        
        guard let row = collectionView.indexPathsForSelectedItems?.first?.row else {
            return nil
        }
        print("row:\(row)")
        return PhotoCollectionViewController(coder: coder, instagramData: instagramData!, indexPath: row)
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
