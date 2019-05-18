import UIKit

class Settings: UIViewController {
    
    @IBOutlet weak var currencies: UIButton!
    @IBOutlet weak var iCloudSync: UIButton!
    @IBOutlet weak var backgroundColor: UIButton!
    @IBOutlet weak var dateFormat: UIButton!
    @IBOutlet weak var categories: UIButton!
    @IBOutlet weak var about: UIButton!
    @IBOutlet weak var erase: UIButton!
//    var currWork = CurrencyWork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLabetToButton(text: "Currencies", nameButton: currencies, image: true, currencyList: true)
        addLabetToButton(text: "iCloud sync", nameButton: iCloudSync, image: false, currencyList: false)
        addLabetToButton(text: "Background color", nameButton: backgroundColor, image: true, currencyList: false)
        addLabetToButton(text: "Date format", nameButton: dateFormat, image: true, currencyList: false)
        addLabetToButton(text: "Categories", nameButton: categories, image: true, currencyList: false)
        addLabetToButton(text: "About", nameButton: about, image: true, currencyList: false)
        LabetToButton(text: "Erase all data & categories", nameButton: erase)
        
        addLine(y: 155.0)
        addLine(y: 212.0)
        addLine(y: 269.0)
        addLine(y: 326.5)
        addLine(y: 383.5)
        addLine(y: 439.5)
        addLine(y: 608.5)    }
    
    func addLabetToButton(text: String, nameButton: UIButton, image: Bool, currencyList: Bool) {
        let label = UILabel(frame: CGRect(x: 1, y: 20, width: 190, height: 19))
        label.font = UIFont(name: "GothamPro-Medium", size: 18)
        label.textColor = UIColor.white
        label.text = text
        label.tag = 101
        label.textAlignment = .left
        nameButton.addSubview(label)
        
        if image {
            let image = UIImageView(frame: CGRect(x: 333, y: 23, width: 6, height: 10))
            image.image = UIImage(named: "Shape")
            nameButton.addSubview(image)
        }
/*
        if currencyList {
            let label = UILabel(frame: CGRect(x: 162, y: 21, width: 159, height: 18))
            var text = ""
            for (index, value) in currWork.currencyActiveArray.enumerated() {
                text += value.0.code ?? ""
                if index + 1 != currWork.currencyActiveArray.count {
                    text += ", "
                }
            }
            label.font = UIFont(name: "GothamPro-Medium", size: 18)
            label.textColor = UIColor(white: 1, alpha: 0.4391)
            label.text = text
            label.tag = 101
            label.textAlignment = .right
            nameButton.addSubview(label)
        }
        
*/    }

    func LabetToButton(text: String, nameButton: UIButton) {
        let label = UILabel(frame: CGRect(x: 40, y: 20, width: 250, height: 18))
        label.font = UIFont(name: "GothamPro-Medium", size: 18)
        label.textColor = UIColor.white
        label.text = text
        label.tag = 101
        label.textAlignment = .center
        nameButton.addSubview(label)
    }
    
    func addLine(y: Double) {
        let lineView = UIView(frame: CGRect(x: 18.0, y: y, width: 375.0, height: 0.5))
        lineView.backgroundColor = UIColor(white: 1, alpha: 0.24)
        self.view.addSubview(lineView)
    }
    
    static func storyboardInstance() -> Settings? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "Settings") as? Settings
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        let testVC = ViewController.storyboardInstance()
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func currecyAction(_ sender: UIButton) {
        let testVC = Currencies.storyboardInstance()
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func eraseAction(_ sender: UIButton) {
/*        let alert = UIAlertController(title: "Are you sure?", message: "Erase all data & categories", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(_: UIAlertAction!) in
            MyPageViewController().createNewCoreData()
            MyPageViewController().currencyDegault()
            let testVC = ViewController.storyboardInstance()
            self.present(testVC!, animated: false, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
*/    }
}
