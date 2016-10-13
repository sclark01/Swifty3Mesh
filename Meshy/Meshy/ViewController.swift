import Swifty3Mesh
import UIKit

class ViewController: UIViewController {
    var manager: MeshManager?
    
    override func viewDidAppear(_ animated: Bool) {
        self.manager = MeshManager()
        manager?.start()
    }
}

