import UIKit
import Swifty3Mesh

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let mm = MeshManager(withStartingValue: 10)
        label.text = "\(mm.start())"
    }

}

