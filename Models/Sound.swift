//
//  Sound.swift
//  Millionaire
//
//  Created by dmitry shcherba on 06.02.2023.
//

import Foundation
import AVFoundation


// Sound

var player: AVAudioPlayer?

func playSound(_ name: String) {
    guard let path = Bundle.main.path(forResource: name, ofType:"mp3") else {
        return }
    let url = URL(fileURLWithPath: path)

    do {
        player = try AVAudioPlayer(contentsOf: url)
        player?.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
}

func stopSound () {
    player?.stop()
}

// end of Sound






