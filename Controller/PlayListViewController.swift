//
//  ViewController.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/19.
//

import UIKit

class PlayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var musicButton: [UIButton]!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackCensoredName: UILabel!
    
    var songs = [SongType]()
    var songIndex: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        musicButton[0].layer.cornerRadius = musicButton[0].frame.height / 4
        musicButton[1].layer.cornerRadius = musicButton[1].frame.height / 4
        
        DataController.shared.fetchMusic { result in
            switch result {
            case .success(let songs):
                self.updateUI(with: songs)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch songItem for \(self.songs)")
            }
        }
        
    }
    
    func updateUI(with songItem: [SongType]) {
        DispatchQueue.main.async {
            self.songs = songItem
            self.tableview.reloadData()
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! PlayListTableViewCell
        cell.numberLabel.text = String( indexPath.row + 1)
        cell.songNameLabel.text = songs[indexPath.row].trackName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        songIndex = tableView.indexPathForSelectedRow?.row
        performSegue(withIdentifier: "goToMusic", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
        artistLabel.text = songs[indexPath.row].artistName
        trackCensoredName.text = songs[indexPath.row].trackCensoredName
        coverImage.image = UIImage(named: "cover")
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            songIndex = 0
        } else {
            songIndex = Int.random(in: 0 ... songs.count-1)
        }
        performSegue(withIdentifier: "goToMusic", sender: self)
    }
    
    @IBSegueAction func segueAction(_ coder: NSCoder) -> MusicViewController? {
        
        let controller = MusicViewController(coder: coder)
        controller?.songIndex = songIndex
        return controller
    }
}

