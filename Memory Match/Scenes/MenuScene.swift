import SpriteKit
import SafariServices

class MenuScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .black

        let background = SKSpriteNode(imageNamed: "MenuScene") // Menu screen background Menu.png
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        background.size = frame.size
        addChild(background)

        let playButton = SKSpriteNode(imageNamed: "Game") // "game" button
        playButton.name = "play"
        playButton.setScale(0.3)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY - 180)
        playButton.zPosition = 2
        addChild(playButton)

        let policyButton = SKSpriteNode(imageNamed: "PrivacyPolicy") // "privacy policy" button
        policyButton.name = "policy"
        policyButton.setScale(0.3)
        policyButton.position = CGPoint(x: frame.midX, y: frame.midY - 250)
        policyButton.zPosition = 2
        addChild(policyButton)
    }
    
    // buttons handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)

        switch node.name {
        case "play":
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = .aspectFill
            view?.presentScene(gameScene, transition: .doorsOpenVertical(withDuration: 1))
        case "policy":
            openPrivacyPolicy()
        default:
            break
        }
    }

    private func openPrivacyPolicy() {
        if let viewController = self.view?.window?.rootViewController {
            let url = URL(string: "https://apple.com")!
            let safariVC = SFSafariViewController(url: url)
            viewController.present(safariVC, animated: true)
        }
    }
}
