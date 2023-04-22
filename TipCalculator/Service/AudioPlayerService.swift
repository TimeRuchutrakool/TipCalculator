//
//  AudioPlayerService.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/22/23.
//

import Foundation
import AVFoundation

protocol AudioPlayerService{
    func playSound()
}

final class DefaultAudioPlayer: AudioPlayerService{
    
    private var player: AVAudioPlayer?
    
    func playSound() {
        let path = Bundle.main.path(forResource: "fart", ofType: "mp3")
        let url = URL(filePath: path!)
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }
        catch (let error){
            print(error.localizedDescription)
        }
    }
    
}
