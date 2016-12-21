//
//  VideoViewController.swift
//  AVFoundationExploration
//
//  Created by Donny Wals on 06/09/16.
//  Copyright © 2016 DonnyWals. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoViewController: UIViewController {
    
    // video Big Buck Bunny source: https://peach.blender.org
    let url = URL(string: "https://ia800201.us.archive.org/12/items/BigBuckBunny_328/BigBuckBunny_512kb.mp4")
    var videoPlayer: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    var playerController: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoItem = AVPlayerItem(url: url!)
        videoPlayer = AVPlayer(playerItem: videoItem)
        playerLayer = AVPlayerLayer(player: videoPlayer)
        
        playerLayer.backgroundColor = UIColor.black.cgColor
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        view.layer.addSublayer(playerLayer)
        
        videoPlayer.play()
        
        playerController = AVPlayerViewController()
        playerController.willMove(toParentViewController: self)
        addChildViewController(playerController)
        playerController.didMove(toParentViewController: self)

        playerController.player = videoPlayer
        view.addSubview(playerController.view)
        playerController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            playerController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20),
            playerController.view.heightAnchor.constraint(equalTo: playerController.view.widthAnchor, multiplier: 9/16),
            playerController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerController.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -70)
        ])
    }

    override func viewDidLayoutSubviews() {
        let playerWidth = view.bounds.width - 20
        let playerHeight = playerWidth / (16/9)
        
        playerLayer.frame = CGRect(x: 10,
                                   y: 10,
                                   width: playerWidth,
                                   height: playerHeight)
    }
}
