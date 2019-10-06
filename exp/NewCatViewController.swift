import UIKit
import CoreData

class NewCatViewController: UIViewController {
    
    @IBOutlet weak var cancellButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    
    let myImage = UIImageView()
    let myTextField = UITextField()
    var arrayPicture = [String]()
    var count = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printData()
        ovalButton()
        myLabel()
        sct()
    }
    
    func myLabel() {
        let myview = UIView()
        myview.frame = CGRect(x: 18, y: 97, width: 339, height: 56)
        myview.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        myview.layer.cornerRadius = 4
        view.addSubview(myview)
        
        myTextField.frame = CGRect(x: 56, y: 22, width: 270, height: 18)
        myTextField.textColor = .white
        myTextField.alpha = 1
        myTextField.font = UIFont(name: "GothamPro-Medium", size: 18)
        myTextField.textAlignment = .left
        myTextField.borderStyle = UITextField.BorderStyle.none
        myTextField.clearButtonMode = .never
        myTextField.tintColor = UIColor.white
        myTextField.modifyClearButtonWithImage(image: UIImage(named: "clearButton")!)
        myview.addSubview(myTextField)
        myTextField.autocorrectionType = .yes
        myTextField.becomeFirstResponder()
        
        myImage.frame = CGRect(x: 12, y: 12, width: 32, height: 32)
        myImage.image = UIImage(named: "pka0386-taxi")
        myImage.contentMode = .center
        myview.addSubview(myImage)
        
        let mylabe = UILabel()
        mylabe.frame = CGRect(x: 98, y: 50, width: 190, height: 18)
        mylabe.textColor = UIColor.white
        mylabe.textAlignment = .center
        mylabe.text = "New category / note"
        mylabe.font = UIFont(name: "GothamPro-Medium", size: 18)
        view.addSubview(mylabe)
    }
    
    func sct() {
        //scroll
        let myScrollView = UIScrollView()
        myScrollView.frame = CGRect(x: 0, y: 153, width: 375, height: 92)
        myScrollView.contentSize = CGSize(width: ((26 + 30) * arrayPicture.count + 30), height: 92)
        myScrollView.showsHorizontalScrollIndicator = false
        var imageViewRect = CGRect(x: 30, y: 30, width: 26, height: 26)
        for i in arrayPicture {
            myScrollView.addSubview(addImageToScroll(image: i, frame: imageViewRect))
            imageViewRect.origin.x += imageViewRect.size.width + 30
        }
        view.addSubview(myScrollView)
    }
    
    func addImageToScroll(image: String, frame: CGRect) -> UIButton {
        let result = UIButton(frame: frame)
        result.contentMode = .scaleAspectFit
        result.setImage(UIImage(named: image), for: .normal)
        result.addTarget(self, action: #selector(ImageAction), for: .touchUpInside)
        return result
    }
    
    func ovalButton() {
        
        //cancelButton.layer.borderWidth = 2
        showButton.layer.backgroundColor = UIColor.white.cgColor
        
        cancellButton.clipsToBounds = true
        let path = UIBezierPath(roundedRect: cancellButton.bounds, byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: 25, height: 25))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        cancellButton.layer.mask = maskLayer
        
        let path1 = UIBezierPath(roundedRect: cancellButton.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: 25, height: 25))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = path1.cgPath
        showButton.layer.mask = maskLayer1
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.lineWidth = 4
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = cancellButton.bounds
        cancellButton.layer.addSublayer(borderLayer)
    }
    
    func savecategory(text: String, img: String) {
        let managedObject = Category()
        managedObject.name = text
        
        var image: Image!
        let predicate = NSPredicate(format: "name == %@", img)
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Image")
        request.predicate = predicate
        do {
            let objects = try! CoreDataManager.instance.managedObjectContext.fetch(request)
            if objects.count >= 1 {
                image = objects[0] as? Image
            }
        }
        managedObject.image = image
        CoreDataManager.instance.saveContext()
    }
    
    func printData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Image")
        do {
            let results = try! CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [Image] {
                if let str = result.name {
                    arrayPicture.append(str)
                }
            }
        }
    }

    static func storyboardInstance() -> NewCatViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "NewCatViewController") as? NewCatViewController
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        let testVC = CategoryViewController.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.present(testVC!, animated: false, completion: {
            testVC?.labelCount.text = self.count
            testVC?.count = self.count
        })
    }
    
    @IBAction func showAction(_ sender: UIButton) {
        if let dft = myTextField.text {
            for i in arrayPicture {
                if (myImage.image?.isEqual(UIImage(named: i)))! {
                    savecategory(text: dft, img: i)
                }
            }
        }
        let testVC = CategoryViewController.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.present(testVC!, animated: false, completion: {
            testVC?.labelCount.text = self.count
            testVC?.count = self.count
        })
    }
    
    @IBAction func ImageAction(_ sender: UIButton) {
        if let digit = sender.currentImage {
            myImage.image = digit
        }
        
    }
}


extension UITextField {
    func modifyClearButtonWithImage(image : UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:) ), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
    
    @objc func clear(sender : AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
}
