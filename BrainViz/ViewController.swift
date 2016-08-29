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
        let k: UInt16 = 50
        let duration: UInt16 = 400
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.sendMessageToAllNodes(message: .Buzzer(frequency: k, duration: duration))
        }
    }

    private func sendMessageToAllNodes(message: MeshMessages) {
        guard let nodes = manager?.listConnectedNodes() else { return }
        for node in nodes {
            manager?.send(message: message, toNodeNamed: node)
        }
    }
}

