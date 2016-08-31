import UIKit
import Swifty3Mesh

class ViewController: UIViewController {

    var manager: MeshManager?
    var alarm: Alarm?
    let colors = MeshLEDColor.availableColors

    override func viewDidAppear(_ animated: Bool) {
        self.manager = MeshManager()
        if let manager = manager {
            self.alarm = Alarm(manager: manager)
        }
        manager?.start()
    }

    @IBAction func colorTapped(_ sender: UIButton) {
        guard let colorString = sender.titleLabel?.text,
        let color = colors[colorString.lowercased()] else { return }
        
        manager?.sendToAllNodes(message: .Light(color: color))
    }

    @IBAction func alarmTapped(_ sender: UIButton) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }
            for _ in 0...1 {
                strongSelf.alarm?.run()
            }
        }
    }
}

