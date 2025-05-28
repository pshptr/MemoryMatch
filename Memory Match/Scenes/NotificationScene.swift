import SpriteKit

class NotificationScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .black

        // Фон
        let bg = SKSpriteNode(imageNamed: "BG_1")
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        bg.size = frame.size
        bg.zPosition = -1
        addChild(bg)

        // Шапка шута
        let jester = SKSpriteNode(imageNamed: "HatLogo")
        jester.setScale(0.5)
        jester.position = CGPoint(x: frame.midX, y: frame.maxY - 220)
        addChild(jester)

        // Заголовок
        let title = SKLabelNode(text: "ALLOW NOTIFICATIONS ABOUT BONUSES AND PROMOS")
        title.fontName = "AvenirNext-Bold"
        title.fontSize = 20
        title.fontColor = .white
        title.numberOfLines = 2
        title.preferredMaxLayoutWidth = frame.width - 60
        title.horizontalAlignmentMode = .center
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: frame.midX, y: frame.midY + 80)
        title.lineBreakMode = .byWordWrapping
        addChild(title)

        // Подзаголовок
        let subtitle = SKLabelNode(text: "Stay tuned with best offers from our casino")
        subtitle.fontName = "AvenirNext-Regular"
        subtitle.fontSize = 16
        subtitle.fontColor = .lightGray
        subtitle.position = CGPoint(x: frame.midX, y: frame.midY + 40)
        addChild(subtitle)

        // Кнопка "Yes"
        let yesButton = SKShapeNode(rectOf: CGSize(width: 300, height: 50), cornerRadius: 12)
        yesButton.name = "yes"
        yesButton.fillColor = .yellow
        yesButton.position = CGPoint(x: frame.midX, y: frame.midY - 40)

        let yesLabel = SKLabelNode(text: "Yes, I Want Bonuses!")
        yesLabel.fontName = "AvenirNext-Bold"
        yesLabel.fontSize = 18
        yesLabel.fontColor = .black
        yesLabel.position = .zero
        yesLabel.verticalAlignmentMode = .center
        yesLabel.name = "yes"
        yesButton.addChild(yesLabel)

        addChild(yesButton)

        // Кнопка "Skip"
        let skipLabel = SKLabelNode(text: "Skip")
        skipLabel.fontName = "AvenirNext-Regular"
        skipLabel.fontSize = 16
        skipLabel.fontColor = .white
        skipLabel.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        skipLabel.name = "skip"
        addChild(skipLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let node = atPoint(location)

        if node.name == "yes" || node.name == "skip" {
            print("Notification button tapped: \(node.name ?? "")")
        }
    }
}
