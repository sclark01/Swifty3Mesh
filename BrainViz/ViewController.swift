import UIKit
import Swifty3Mesh

class ViewController: UIViewController {

    var manager: MeshManager?

    override func viewDidAppear(_ animated: Bool) {
        self.manager = MeshManager()
        manager?.start()
    }
    @IBAction func sendMessageTouched(_ sender: UIButton) {
        guard let nodes = manager?.listConnectedNodes() else { return }
        for node in nodes {
            manager?.send(message: MeshMessages.Light(color: UIColor.blue), toNodeNamed: node)
        }
    }
}

