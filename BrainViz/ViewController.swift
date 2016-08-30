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
        for _ in 0...1 {
            runAlarm()
        }
    }

    private func sendMessageToAllNodes(message: MeshMessages) {
        guard let nodes = manager?.listConnectedNodes() else { return }
        for node in nodes {
            manager?.send(message: message, toNodeNamed: node)
        }
    }

    private func runAlarm() {
        let colorsAsArray = Array(colors.values)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.manager?.listConnectedNodes().forEach { node in
                let color = colorsAsArray[strongSelf.randomInt(min: 0, max: colorsAsArray.count - 1)]
                strongSelf.manager?.send(message: .Light(color: color), toNodeNamed: node)
                strongSelf.manager?.send(message: .Buzzer(frequency: UInt16(strongSelf.randomInt(min: 10, max: 99)), duration: 500), toNodeNamed: node)
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }

    private func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}

