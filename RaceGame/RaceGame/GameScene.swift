//
//  GameScene.swift
//  RaceGame
//
//  Created by Dylan on 3/4/18.
//  Copyright © 2018 rbf. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode?
    var tracksArray : [SKSpriteNode]? = [SKSpriteNode]()
    var currentTrack = 1
    var car: SKSpriteNode?
    var backGroundMusic: SKAudioNode!
    var movingTotrack = false
    var trackVelocities = [100,200,300]
    var velocityArray = [Int]()
    var score = 0
    var scorelbl: SKLabelNode?
    var failLabel: SKLabelNode?
    var startScene: SKScene!
    var playAgain: SKLabelNode?
    var gameover = false
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: true)
    let crashSound = SKAction.playSoundFileNamed("crash.mp3", waitForCompletion: true)
    let track = [0,1,2]
    let carCat:UInt32  = 0x1 << 0
    let playerCat:UInt32 = 0x1 << 1
    
    
     //*NEED TO INITALIZE SLOW ENEMY*
    enum Enemy{
        case fast
    
    }
    
    //Load the track array
    func loadTracks(){
        for i in 0 ... 2{
            if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
                tracksArray?.append(track)
            }
        }
      
    }
    
    
    //Checks if a move is valid before switching player to track
    func switchTracks(_ right: Bool){
        if(!gameover) {
          
        movingTotrack = true
        if (right){
            if (currentTrack == 0 || currentTrack == 1){
                currentTrack += 1
                let movePlayer = SKAction.moveTo(x: tracksArray![currentTrack].position.x, duration: 0.25)
                player?.run(movePlayer, completion: {
                    self.movingTotrack = false
                })
            }
            
        }else{
            if (currentTrack == 1 || currentTrack == 2){
                currentTrack -= 1
                let movePlayer = SKAction.moveTo(x: tracksArray![currentTrack].position.x, duration: 0.25)
                player?.run(movePlayer, completion: {
                    self.movingTotrack = false
                })
            }
            
        }
        self.run(moveSound)
        }
    }
   
    func createEnemy(_ type: Enemy,forTrack track: Int) {
        switch type{
        case .fast:
            if let cr = self.childNode(withName: "car") as? SKSpriteNode{
                car = cr
            }
            car?.position.x = tracksArray![track].position.x
            car?.position.y = 850
        }
    }
    
    func createPlayer(){
        if let char = self.childNode(withName: "player") as? SKSpriteNode{
            player = char
        }
        player?.position.x = (tracksArray?[1].position.x)!
        player?.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: player!.size.width/2, height: player!.size.height/1.2))
        player!.physicsBody?.categoryBitMask = playerCat
        player!.physicsBody?.contactTestBitMask = carCat
        player?.physicsBody?.affectedByGravity = false
        
    }
    func spawnEnemies(){
        createEnemy(.fast, forTrack: GKRandomSource.sharedRandom().nextInt(upperBound: 3))
        car?.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: car!.size.width/2, height: car!.size.height/1.2))
        car!.physicsBody?.categoryBitMask = carCat
        car!.physicsBody?.contactTestBitMask = playerCat
        car!.physicsBody?.affectedByGravity = true
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.12 - Double(score))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            
            if(node?.name == "right" ){
               self.switchTracks(true)
                
            }
            else if (node?.name == "left"){
                self.switchTracks(false)
            }
            else if (node?.name == "playagain" && gameover){
                let transition = SKTransition.fade(withDuration: 1)
                startScene = SKScene(fileNamed: "StartScene")
                startScene.scaleMode = .aspectFit
                self.view?.presentScene(startScene, transition: transition)
            }
        
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!movingTotrack) {player?.removeAllActions()}
    }
    
    override func didMove(to view: SKView) {
        
        if let musicURL = Bundle.main.url(forResource: "mainTheme", withExtension: "wav"){
            backGroundMusic = SKAudioNode(url: musicURL)
            addChild(backGroundMusic)
        }
   
        if let numberOfTracks = tracksArray?.count{
            for _ in 0 ... numberOfTracks{
                let randomNumberForVelocity = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
                velocityArray.append(trackVelocities[randomNumberForVelocity])
                
            }
            
        }
         scorelbl = self.childNode(withName: "score") as? SKLabelNode
        failLabel = self.childNode(withName: "gameover") as? SKLabelNode
        playAgain = self.childNode(withName: "playagain") as? SKLabelNode
        self.physicsWorld.contactDelegate = self
        loadTracks()
        createPlayer()
        spawnEnemies()
        failLabel?.isHidden = true
        playAgain?.isHidden = true
    }

    func didBegin(_ contact: SKPhysicsContact){
        let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == playerCat | carCat {
            self.run(crashSound)
            failLabel?.isHidden = false
            playAgain?.isHidden = false
            gameover = true
        }
        
    }
    override func update(_ currentTime: TimeInterval) {
        if(car!.position.y < -700 && player!.position.y >= -550){
            spawnEnemies()
            score += 1
            scorelbl!.text = "SCORE: \(score)"
        }
    }
}
