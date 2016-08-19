import UIKit
import Swifty3Mesh

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = MeshManager()
        manager.start()
    }
    
}

