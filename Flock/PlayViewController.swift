//
//  PlayViewController.swift
//  Flock
//
//  Created by Rishabh Yadav on 6/22/17.
//  Copyright © 2017 Flock. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    
    var song:SPTPartialTrack?
    var player:SPTAudioStreamingController?
    
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if self.song != nil {
            displayInfo()
        } else {
            print("song is nil")
        }
    }
    
    func displayInfo() {
        self.songName.text = self.song?.name
        self.songArtist.text = (self.song?.artists[0] as! SPTPartialArtist).name
        let data = try? Data(contentsOf: (self.song?.album.largestCover!.imageURL)!)
        self.albumArt.image = UIImage(data: data!)
        print("hello")
        if self.player?.playbackState == nil {
            self.player?.playSpotifyURI(song!.playableUri.absoluteString, startingWith: 0, startingWithPosition: 0, callback: { (error) in
                if error != nil {
                    print("Track lookup got error \(String(describing: error))")
                }
            })
        } else {
            if (self.player?.playbackState.isPlaying)! {
                self.player?.queueSpotifyURI(song!.playableUri.absoluteString, callback: { (error) in
                    if error != nil {
                        print("Track lookup got error \(String(describing: error))")
                    } else {
                        print("Queued")
                    }
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
