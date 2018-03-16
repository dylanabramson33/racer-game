//
//  StartScene.swift
//  RaceGame
//
//  Created by Dylan on 3/4/18.
//  Copyright © 2018 rbf. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    
    var backGroundMusic: SKAudioNode!
    var gameScene: SKScene!
    var playButton: SKSpriteNode?
    var playBackground: SKSpriteNode?
    var background: SKSpriteNode?
    var drive: SKSpriteNode?
    var label: SKSpriteNode?
    var start: SKSpriteNode?
    
    func loadBackGround(){
        background = self.childNode(withName: "towkyo") as? SKSpriteNode
        label = self.childNode(withName: "label") as? SKSpriteNode
        playBackground = self.childNode(withName: "startButton") as? SKSpriteNode
        playButton = self.childNode(withName: "start") as? SKSpriteNode
        drive = self.childNode(withName: "Drive") as? SKSpriteNode
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            
            if(node?.name == "start" || node?.name == "startButton" ){
                let transition = SKTransition.fade(withDuration: 1)
                gameScene = SKScene(fileNamed: "GameScene")
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene, transition: transition)
            
            }
        }
    }
    
    override func didMove(to view: SKView) {
        loadBackGround()
        if let musicURL = Bundle.main.url(forResource: "MenuSong", withExtension: "wav"){
            backGroundMusic = SKAudioNode(url: musicURL)
            addChild(backGroundMusic)
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
      
    }
}
