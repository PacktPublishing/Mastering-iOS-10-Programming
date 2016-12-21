//
//  AudioViewController.swift
//  AVFoundationExploration
//
//  Created by Donny Wals on 06/09/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {
    
    let streamUrls = [
        URL(string: "https://p.scdn.co/mp3-preview/499622f2fe991f0f9757aca2f82f133c52494c43"),
        URL(string: "https://p.scdn.co/mp3-preview/a8a8741d954be0e6f6c473e93bbbcbe67b441646")]
    
    var audioPlayer: AVQueuePlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var playerItems = [AVPlayerItem]()
        for url in streamUrls {
            playerItems.append(AVPlayerItem(url: url!))
        }
        
        audioPlayer = AVQueuePlayer(items: playerItems)
    }
    
    @IBAction func startStopTapped() {
        if audioPlayer.rate == 0.0 {
            audioPlayer.play()
        } else {
            audioPlayer.pause()
        }
    }
}
