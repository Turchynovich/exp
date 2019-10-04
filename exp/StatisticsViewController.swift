import UIKit

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func storyboardInstance() -> StatisticsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "StatisticsViewController") as? StatisticsViewController
    }

    @IBAction func backAction(_ sender: UIButton) {
        let testVC = ViewController.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        self.present(testVC!, animated: false, completion: nil)
    }
}
