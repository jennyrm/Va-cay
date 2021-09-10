//
//  QueuePlayerUIView.swift
//  Va-cay
//
//  Created by James Lea on 9/7/21.
//

import UIKit
import AVFoundation
import AVKit

class QueuePlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        setupVideo()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupVideo(){
        //Load Video
        guard let path = Bundle.main.path(forResource: "VacayVid", ofType: "mp4") else {return}
        let videoAsset = AVURLAsset(url: URL(fileURLWithPath: path))
        let playerItem = AVPlayerItem(asset: videoAsset)
        
        // Setup Player
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        //Loops
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        //Play
        player.play()
    }
    
}//End of class
