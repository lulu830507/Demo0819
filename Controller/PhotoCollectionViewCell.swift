//
//  PhotoCollectionViewCell.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/31.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var likeButtonStatus: Bool = false
    var edges: IGData.Graphql.User.Edge_owner_to_timeline_media.Edges!
    
    @IBOutlet weak var showPostImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postCaptionTextView: UITextView!
    @IBOutlet weak var postLikeLabel: UILabel!
    @IBOutlet weak var postLikeButton: UIButton!
    @IBOutlet weak var postDateLabel: UILabel!
    
    func set(for edges: IGData.Graphql.User.Edge_owner_to_timeline_media.Edges) {
        
        self.edges = edges
        postLikeButton.setImage(UIImage(named: "iconLove"), for: .normal)
        let postLikeCont = edges.node.edge_liked_by.count.numCoverter
        self.postLikeLabel.text = "Like by SomeOne and \(postLikeCont) others"
        self.postCaptionTextView.isScrollEnabled = false
        self.postCaptionTextView.text = edges.node.edge_media_to_caption.edges.first?.node.text ?? ""
        //Post Time Transfor
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        let dateString = dateFormatter.string(from: edges.node.taken_at_timestamp)
        self.postDateLabel.text = "\(dateString)"
        
        downloadPhoto()
    }
    
    func downloadPhoto() {
        let url = self.edges.node.display_url
        
        PhotoManager.shsared.downloadImage(url: edges.node.display_url) { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self, url == self.edges.node.display_url else { return}
                let border = CALayer()
                border.backgroundColor = UIColor.systemGray3.cgColor
                border.frame = CGRect(x: 0, y: 0, width: self.showPostImageView.frame.width, height: 0.3)
                self.showPostImageView.layer.addSublayer(border)
                self.showPostImageView.image = image
            }
        }
    }
    
    @IBAction func pressButton(_ sender: Any) {
        likeButtonStatus = !likeButtonStatus
        if likeButtonStatus {
            postLikeButton.setImage(UIImage(named: "iconRedLove"), for: .normal)
        } else {
            postLikeButton.setImage(UIImage(named: "iconLove"), for: .normal)
        }
    }
}
