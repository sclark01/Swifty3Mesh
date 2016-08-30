import UIKit
import Swifty3Mesh

class ViewController: UIViewController {

    var manager: MeshManager?
    let colors = MeshLEDColor.availableColors
    var lightButtonTapCount = 0

    override func viewDidAppear(_ animated: Bool) {
        self.manager = MeshManager()
        manager?.start()
    }

    @IBAction func colorTapped(_ sender: UIButton) {
        guard let colorString = sender.titleLabel?.text,
        let color = colors[colorString.lowercased()] else { return }
        
        sendMessageToAllNodes(message: .Light(color: color))
    }

    @IBAction func alarmTapped(_ sender: UIButton) {
        
    }

    private func sendMessageToAllNodes(message: MeshMessages) {
        guard let nodes = manager?.listConnectedNodes() else { return }
        for node in nodes {
            manager?.send(message: message, toNodeNamed: node)
        }
    }
}

