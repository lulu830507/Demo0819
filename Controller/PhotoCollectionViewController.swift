//
//  PhotoCollectionViewController.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/31.
//

import UIKit


class PhotoCollectionViewController: UICollectionViewController {
    
    @IBOutlet var postCollectionView: UICollectionView!
    var isShow = false
    
    let instagramPostInfo: IGData.Graphql.User.Edge_owner_to_timeline_media
    let instagramProfileUserName: String
    let instagramProfilePicURL: URL
    let indexPath: Int
    
    init?(coder: NSCoder, instagramData: IGData, indexPath: Int) {
        self.instagramPostInfo = instagramData.graphql.user.edge_owner_to_timeline_media
        self.instagramProfileUserName = instagramData.graphql.user.username
        self.instagramProfilePicURL = instagramData.graphql.user.profile_pic_url_hd
        self.indexPath = indexPath
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.textColor = .black
        let userNameUpper = self.instagramProfileUserName.uppercased()
        label.text = "\(userNameUpper)\n Posts"
        self.navigationItem.titleView = label
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShow == false {
            postCollectionView.scrollToItem(at: IndexPath(item: self.indexPath, section: 0), at: .top, animated: false)
            isShow = true
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return instagramPostInfo.edges.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PhotoCollectionViewCell.self)", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell()}
        
        //Config Profile Data
        cell.userNameLabel.text = "\(instagramProfileUserName)"
        
        PhotoManager.shsared.downloadImage(url: instagramProfilePicURL) { [weak self] image in
            DispatchQueue.main.async {
                guard let _ = self else{
                    return
                }
                cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
                cell.profileImageView.image = image
            }
        }
        
        //Config PostData
        cell.set(for: instagramPostInfo.edges[indexPath.row])
        
        return cell
        
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
