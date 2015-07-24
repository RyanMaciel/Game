//
//  GameScene.swift
//  Game
//
//  Created by Ryan Maciel on 6/10/15.
//  Copyright (c) 2015 RyanMaciel. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var userIsDragging = false
    var sprite:SKShapeNode = SKShapeNode()
    var cropNode = SKCropNode()

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        tileBackground()
        
        sprite.position = CGPointMake(100, 100)
        
        
        var circleMask = SKShapeNode()
        var path = CGPathCreateMutable()
        CGPathAddArc(path, nil, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), CGFloat(50), CGFloat(0), CGFloat(M_PI*2), true);
        sprite.path = path
    
        
        cropNode.maskNode = sprite
        cropNode.position = CGPointMake(100, 100)
        
        var circle = SKSpriteNode();
        self.addChild(sprite)
        
        
        var backgroundNode = SKSpriteNode();
        backgroundNode.size = CGSizeMake(1000, 1000)
        backgroundNode.color = UIColor.blackColor()
        self.addChild(backgroundNode)
        backgroundNode.addChild(circle)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        var touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        
        if CGRectContainsPoint(cropNode.frame, location){
            userIsDragging = true
            cropNode.position = location
        } else {
            
            add( mult(norm(CGVectorMake(location.x - cropNode.position.x, location.y - cropNode.position.y)), s: 1000), CGVectorMake(cropNode.position.x, cropNode.position.y))
            
            let projectile = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(10, 10))
            projectile.runAction(SKAction.repeatActionForever(SKAction.moveBy(CGVectorMake(location.x - self.cropNode.position.x, location.y - self.cropNode.position.y), duration: 1)))
            projectile.position = cropNode.position
            self.addChild(projectile)
        }
        
    }
    
    func tileBackground(){
        var farthestX:CGFloat = 0
        var farthestY:CGFloat = 0
        
        for var i = 0; i<10; i++ {
            
            for var j = 0; j<10; j++ {
                println(farthestX + 50)
                println(farthestY + 50)
                var newTile = SKSpriteNode()
                newTile.size = CGSizeMake(100, 100)
                newTile.position = CGPointMake(farthestX + 50, farthestY + 50);
                newTile.color = UIColor(red: CGFloat(Float(i)/10.0), green: CGFloat(Float(j)/10.0), blue: CGFloat(0.7), alpha: 1);
                farthestX += 100
                self.addChild(newTile)
                
            }
            farthestX = 0
            farthestY += 100
        }
    }
    
    func norm(v:CGVector)->CGVector{
        var dist = sqrt(v.dx * v.dx + v.dy * v.dy)
        return CGVectorMake(v.dx/dist, v.dy/dist)
        
    }
    
    func mult(v:CGVector, s:CGFloat)->CGVector{
        return CGVectorMake(v.dx*s, v.dy*s)
    }
    
    func add(v1: CGVector, _ v2: CGVector)->CGVector{
        return CGVectorMake(v1.dx - v2.dx, v1.dy - v2.dy)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        if userIsDragging {
            cropNode.position = location
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if userIsDragging {userIsDragging = false}
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
