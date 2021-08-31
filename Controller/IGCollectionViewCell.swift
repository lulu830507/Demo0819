//
//  IGCollectionViewCell.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/31.
//

import UIKit

class IGCollectionViewCell: UICollectionViewCell {
    var edges:IGData.Graphql.User.Edge_owner_to_timeline_media.Edges!
    
   
    @IBOutlet weak var showImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
    }
    
    func set(for edges:IGData.Graphql.User.Edge_owner_to_timeline_media.Edges) {
        self.edges = edges
        downloadPhoto()
    }
    
    private func downloadPhoto(){
        let url = edges.node.display_url
        
        PhotoManager.shsared.downloadImage(url: edges.node.display_url) { [weak self] image in
            guard let self = self,
                  url == self.edges.node.display_url else {return}
            DispatchQueue.main.async {
                self.showImageView.image = image
            }
        }
    }
}
