import SpriteKit

class LoadingScene: SKScene {

    private var fireNode: SKSpriteNode!

    override func didMove(to view: SKView) {
        backgroundColor = .black

        let background = SKSpriteNode(imageNamed: "LoadingScene")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        background.size = frame.size
        addChild(background)

        fireNode = SKSpriteNode(imageNamed: "Fire_icon")
        fireNode.setScale(0.35)
        fireNode.position = CGPoint(x: frame.midX, y: frame.midY + 180)
        addChild(fireNode)
        animateFire()

        // menu in 5 sec
        run(SKAction.sequence([
            SKAction.wait(forDuration: 5),
            SKAction.run {
                let menu = MenuScene(size: self.size)
                self.view?.presentScene(menu, transition: .crossFade(withDuration: 1))
            }
        ]))
    }

    private func animateFire() {
        let moveUp = SKAction.moveBy(x: 0, y: 20, duration: 0.5)
        let moveDown = SKAction.moveBy(x: 0, y: -20, duration: 0.5)
        let sequence = SKAction.sequence([moveUp, moveDown])
        fireNode.run(SKAction.repeatForever(sequence))
    }
}
