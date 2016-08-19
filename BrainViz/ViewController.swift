import UIKit
import Swifty3Mesh

class ViewController: UIViewController {

    var manager: MeshManager?

    override func viewDidAppear(_ animated: Bool) {
        self.manager = MeshManager()
        manager?.start()
    }
}

