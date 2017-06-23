//
//  ViewController.swift
//  Flock
//
//  Created by Rishabh Yadav on 6/13/17.
//  Copyright © 2017 Flock. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    let kClientID = "ea6b21a095c64540bc38f6a436240f25"
    let kCallbackURL = "flock-login://return-after-login"
    let kTokenSwapURL = "http://localhost:1234/swap"
    let kTokenRefreshServiceURL = "http://localhost:1234/refresh"
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var session:SPTSession?
    var player:SPTAudioStreamingController?
    var search:SPTSearch?
    var res:[SPTPartialTrack]?
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isHidden = true
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "loginSuccessful"), object: nil, queue: nil){
            notification in
            self.updateAfterFirstLogin()
        }
        print("hello")
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? { // session available
            print("here1")
            let sessionDataObj = sessionObj as! NSData
            
            let session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj as Data) as! SPTSession
            playUsingSession(sessionObj: session)
            if !session.isValid() {
                SPTAuth.defaultInstance().renewSession(session, callback: {error, renewedsession -> Void in
                    if error == nil {
                        let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
                        userDefaults.set(sessionData, forKey: "SpotifySession")
                        userDefaults.synchronize()
                        
                        self.session = renewedsession!
                        self.playUsingSession(sessionObj: renewedsession)
                    } else {
                        print("Error refreshing session")
                        self.loginButton.isHidden = false
                    }
                })
            } else {
                print("Session valid")
                playUsingSession(sessionObj: session)
            }
            
        } else {
            print("heres")
            loginButton.isHidden = false
        }
    }
    
    func updateAfterFirstLogin() {
        print("here11")
        loginButton.isHidden = true
        
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! NSData
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj as Data) as! SPTSession
            playUsingSession(sessionObj: firstTimeSession)
        }
    }
    
    
    @IBAction func didPressSearch(_ sender: Any) {
        print("here11111555555")
        if self.player != nil {
            if textField.text != "" {
                SPTSearch.perform(withQuery: textField.text, queryType: .queryTypeTrack, accessToken: self.session?.accessToken, callback: {(error, search) in
                    if error != nil {
                        print(error as Any)
                    }
                    if let r = search as? SPTListPage {
                        self.res = r.items as? [SPTPartialTrack]
                        print("hello!!!!!!!!!!!!!!!!")
                        print(self.res)
                        self.performSegue(withIdentifier: "Results", sender: nil)
                        /*
                         if let items = r.items {
                         track = items[0] as? SPTPartialTrack
                         if track != nil {
                         self.player?.playSpotifyURI(track!.playableUri.absoluteString, startingWith: 0, startingWithPosition: 0, callback: { (error) in
                         if error != nil {
                         print("Track lookup got error \(String(describing: error))")
                         }
                         })
                         }
                         } else {
                         print("could not access Items")
                         }
                         */
                    } else {
                        print("could not typecast to SPTListPage")
                    }
                })
            } else {
                print("Nothing Searched")
            }
        } else {
            print("Not logged in")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.res != nil {
            if segue.identifier == "Results" {
                let svc = segue.destination as! Search_ResultTableViewController
                svc.songs = self.res!
                svc.player = self.player!
            }
        }
    }
    
    func playUsingSession(sessionObj: SPTSession!) {
        print("here")
        if self.player == nil {
            self.session = sessionObj
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: kClientID)
            self.player!.login(withAccessToken: sessionObj.accessToken)
        } else {
            print("player")
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        /*
         var track:SPTPartialTrack?
         SPTSearch.perform(withQuery: "DNA", queryType: .queryTypeTrack, accessToken: self.session?.accessToken, callback: {(error, search) in
         if error != nil {
         print(error as Any)
         }
         if let r = search as? SPTListPage {
         print(r)
         if let items = r.items {
         track = items[0] as? SPTPartialTrack
         print(items[0])
         print(track as Any)
         print("1")
         if track != nil {
         print(track?.playableUri.absoluteString as Any)
         self.player?.playSpotifyURI(track!.playableUri.absoluteString, startingWith: 0, startingWithPosition: 0, callback: { (error) in
         if error != nil {
         print("Track lookup got error \(String(describing: error))")
         }
         })
         }
         } else {
         print("could not access Items")
         }
         } else {
         print("could not typecast to SPTListPage")
         }
         })
         */
    }
    
    @IBAction func loginWithSpotify(_ sender: Any) {
        let auth = SPTAuth.defaultInstance()!
        
        auth.clientID = kClientID
        auth.redirectURL = NSURL(string: kCallbackURL)! as URL
        auth.tokenRefreshURL = NSURL(string: kTokenRefreshServiceURL)! as URL
        auth.tokenSwapURL = NSURL(string: kTokenSwapURL)! as URL
        auth.requestedScopes = [SPTAuthStreamingScope]
        
        let loginURL = auth.spotifyWebAuthenticationURL()!
        
        UIApplication.shared.open(loginURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

