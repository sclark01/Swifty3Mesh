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

    @IBAction func activateLightTouched(_ sender: UIButton) {
        sendMessageToAllNodes(message: .Light(color: colors[lightButtonTapCount]))
        lightButtonTapCount = (lightButtonTapCount + 1) % colors.count
    }

    @IBAction func activateBuzzerTouched(_ sender: UIButton) {
        sendMessageToAllNodes(message: .Buzzer(volume: 100))
    }

    private func sendMessageToAllNodes(message: MeshMessages) {
        guard let nodes = manager?.listConnectedNodes() else { return }
        for node in nodes {
            manager?.send(message: message, toNodeNamed: node)
        }
    }
}

