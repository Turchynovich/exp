import UIKit
import CoreData

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTyping​ = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var currencySaveToData = Currency()
/*    var ctfd = CurrencyWork()
    var arcu = [(Currency, Bool)]()
*/
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addExpensesButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var enterLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var report: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myPageViewController = segue.destination as? MyPageViewController {
            myPageViewController.myDelegate = self as MyPageViewControllerDelegate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSecondPlan(bool: false)
//        printData()
//       categoryPrice()
//        test()

        
    }
    
    func showSecondPlan(bool: Bool) {
        containerView.isHidden = bool
        pageControl.isHidden = bool
        report.isHidden = bool
        settings.isHidden = bool
        label1.isHidden = bool
        label2.isHidden = bool
        
        addExpensesButton.isHidden = !bool
        categoryButton.isHidden = !bool
        priceLabel.isHidden = !bool
        currencyLabel.isHidden = !bool
        enterLabel.isHidden = !bool
        backButton.isHidden = !bool
        
        if bool {
            //buttonsCurrency()
        }
 
    }
    
    func addTextToCategoryButton(text: String) {
        categoryButton.setTitle("\(text.uppercased()) >", for: .normal)
        categoryButton.setBackgroundImage(UIImage(named: "category"), for: .normal)
        categoryButton.setTitleColor(UIColor.white, for: .normal)
        categoryButton.titleLabel?.font = UIFont(name: "GothamPro-Bold", size: 12)
        categoryButton.alpha = 1
        priceLabel.text = appDelegate.data
    }
    
    func saveDataToCoreData(count: Double) {
        let managedObject = Payment()
        managedObject.count = count
        managedObject.date = NSDate()
        
/*        for i in arcu {
            if i.1 {
                managedObject.currency = i.0
            }
        }
*/
        var lstr = categoryButton.titleLabel?.text ?? ""
        if lstr == "+ CATEGORY / NOTE" {
            lstr = "OTHER >"
        }
        lstr.remove(at: lstr.index(before: lstr.endIndex))
        lstr.remove(at: lstr.index(before: lstr.endIndex))
        lstr = lstr.lowercased()
        lstr = lstr.prefix(1).uppercased() + lstr.suffix(lstr.count - 1)
  
        
        var paymentCategory: Category!
        let toPredicate = NSPredicate(format: "name == %@", lstr)
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
        request.predicate = toPredicate
        do {
            let objects = try! CoreDataManager.instance.managedObjectContext.fetch(request)
            if objects.count >= 1 {
                paymentCategory = objects[0] as? Category
            }
        }
        managedObject.category = paymentCategory
//        managedObject.currency = currencySaveToData
        CoreDataManager.instance.saveContext()
    }
 
    func printData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Payment")
        do {
            let results = try! CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [Payment] {
                print("\(String(describing: result.category?.name)) - \(result.count) - \(String(describing: result.date))")
            }
        }
    }
    
    func categoryPrice() {
        var categoryArray = [Category]()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
        do {
            let results = try! CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [Category] {
                categoryArray.append(result)
            }
        }
        
        for i in categoryArray {
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            
            let dateNow = calendar.startOfDay(for: Date()) as NSDate
            let dateFrom = calendar.date(byAdding: .day, value: -1, to: dateNow as Date)! as NSDate
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateNow as Date)! as NSDate
            
            let fromPredicate = NSPredicate(format: "date >= %@", dateFrom)
            let toPredicate = NSPredicate(format: "date < %@", dateTo)
            let categoryPredicate = NSPredicate(format: "category == %@", i)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, categoryPredicate])
            
            
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Payment")
            request.predicate = datePredicate
            do {
                
                let objects = try! CoreDataManager.instance.managedObjectContext.fetch(request)
                
                for object in objects as! [Payment] {
                    
                    print("\(String(describing: object.category?.name)) - \(object.count) - \(String(describing: object.date))")
                }
            }
        }
    }
    /*
    func lastPaymentCurrency() -> Currency {
        var d = Currency()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Payment")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        do {
            let results = try! CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [Payment] {
                if let res = result.currency {
                    d = res
                }
            }
        }
        return d
    }
    
    
    func buttonsCurrency() {
        var arrayActiveCurrency = [Currency]()
        /*делать запрос в базу и понять сколько активных валют
        если одна
                ничего не делать, только в функцию добавления трнзакции передать валюту
        если 2 или 3
                нарисовать кнопки, передавать в функцию добавления трнзакции валюту исходя из активной кнопки транзакции
                понять какая последняя транзакция была и сделать ее активной
                активна должна быть та кнопка, которая транзакция была последней*/
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Currency")
        let statusPredicate = NSPredicate(format: "status == %@", NSNumber(value: true))
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate])
        fetchRequest.predicate = datePredicate
        do {
            let results = try! CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            arrayActiveCurrency = results as! [Currency]
        }
        
        
        switch arrayActiveCurrency.count {
        case 1:
            currencySaveToData = arrayActiveCurrency[0]
        case 2:
            
            /*
            if arrayActiveCurrency![1] == lastPaymentCurrency {
                drowCurrencyButton(x: 139, y: 125, code: arrayActiveCurrency?[0].code ?? "", activeted: false, tag: 101)
                drowCurrencyButton(x: 195, y: 125, code: arrayActiveCurrency?[1].code ?? "", activeted: true, tag: 102)
                currencySaveToData = arrayActiveCurrency?[1]
            } else {
                drowCurrencyButton(x: 139, y: 125, code: arrayActiveCurrency?[0].code ?? "", activeted: true, tag: 101)
                drowCurrencyButton(x: 195, y: 125, code: arrayActiveCurrency?[1].code ?? "", activeted: false, tag: 102)
                currencySaveToData = arrayActiveCurrency?[0]
            }
            */
            print("2")
            
            
        case 3:
            print("3")
        default:
            print("error")
        }
        
    }*/
    
/*    func createCurrency(name: String, symbol: String, code: String) {
        let managedObject = Currency()
        managedObject.name = name
        managedObject.symbol = symbol
        managedObject.code = code
        CoreDataManager.instance.saveContext()
    }
 
    //добавить активную валюту
    func test() {
        let predicate = NSPredicate(format: "code == %@", "USD")
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Currency")
        request.predicate = predicate
        do {
            let results = try! CoreDataManager.instance.managedObjectContext.fetch(request)
            for result in results as! [Currency] {
                result.activestatus = true
            }
        }
        CoreDataManager.instance.saveContext()
    }
    
    //добавить кнопки с валютами
    func buttonCurrency() {
        var activeCurrencyArray = [(Currency, Bool)]()
        if arcu.isEmpty {
            activeCurrencyArray = ctfd.existLastPaymentCurrencyInArray()
        } else {
            activeCurrencyArray = arcu
        }
        
        var lct = ""
        for i in activeCurrencyArray {
            if i.1 == true {
                if let f = i.0.symbol {
                    lct = f
                }
            }
        }

        switch activeCurrencyArray.count {
        case 1:
            currencyLabel.text = lct
            arcu = activeCurrencyArray
        case 2:
            drowCurrencyButton(x: 139, y: 125, code: activeCurrencyArray[0].0.code ?? "", activeted: activeCurrencyArray[0].1, tag: 101)
            drowCurrencyButton(x: 195, y: 125, code: activeCurrencyArray[1].0.code ?? "", activeted: activeCurrencyArray[1].1, tag: 102)
            currencyLabel.text = lct
            arcu = activeCurrencyArray
        default:
            drowCurrencyButton(x: 105, y: 125, code: activeCurrencyArray[0].0.code ?? "", activeted: activeCurrencyArray[0].1, tag: 101)
            drowCurrencyButton(x: 167, y: 125, code: activeCurrencyArray[1].0.code ?? "", activeted: activeCurrencyArray[1].1, tag: 102)
            drowCurrencyButton(x: 229, y: 125, code: activeCurrencyArray[2].0.code ?? "", activeted: activeCurrencyArray[2].1, tag: 103)
            currencyLabel.text = lct
            arcu = activeCurrencyArray
        }
    }
*/
    func drowCurrencyButton(x: Int, y: Int, code: String, activeted: Bool, tag: Int) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: x, y: y, width: 41, height: 41)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        if activeted {
            button.backgroundColor = UIColor(white: 1, alpha: 0.3)
        } else {
            button.backgroundColor = UIColor.clear
        }
        button.setTitle(code, for: .normal)
        button.tag = tag
        button.titleLabel?.font = UIFont(name: "GothamPro-Medium", size: 12)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = UIColor(white: 1, alpha: 0.45)
        button.addTarget(self, action: #selector(ImageAction), for: .touchUpInside)
        self.view.addSubview(button)
    }

    @IBAction func ImageAction(_ sender: UIButton) {
/*        var activeCurrencyArray = ctfd.existLastPaymentCurrencyInArray()
        let ar = [101, 102, 103]
        var tg = 0
        
        for (index, value) in activeCurrencyArray.enumerated() {
            if value.0.code == sender.currentTitle {
                activeCurrencyArray[index].1 = true
                sender.backgroundColor = UIColor(white: 1, alpha: 0.3)
                tg = sender.tag
                currencyLabel.text = value.0.symbol ?? ""
            } else {
                activeCurrencyArray[index].1 = false
            }
        }

        for i in ar {
            if i != tg {
                let tempButton = self.view.viewWithTag(i) as? UIButton
                tempButton?.backgroundColor = UIColor.clear
            }
        }
        arcu = activeCurrencyArray
        offCurrencyButton()
        buttonCurrency()
    }
    
    func offCurrencyButton() {
        let ar = [101, 102, 103]
        for i in ar {
            let tempButton = self.view.viewWithTag(i) as? UIButton
            tempButton?.removeFromSuperview()
        }
*/    }
    
    //для перехода на этот экран
    static func storyboardInstance() -> ViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "YourVC") as? ViewController
    }
    
    @IBAction func addExpensesAction(_ sender: UIButton) {
        let res = priceLabel.text ?? ""
        saveDataToCoreData(count: (res as NSString).doubleValue)
        showSecondPlan(bool: false)
        priceLabel.text = ""
        
        let testVC = ViewController.storyboardInstance()
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        showSecondPlan(bool: false)
        priceLabel.text = ""
/*        offCurrencyButton()
*/
        let testVC = ViewController.storyboardInstance()
        self.present(testVC!, animated: false, completion: nil)
    }
    @IBAction func numPad(_ sender: UIButton) {
/*        offCurrencyButton()
*/        showSecondPlan(bool: true)
        if let digit = sender.currentTitle {
            let textCurrentlyInDisplay = priceLabel!.text!
            priceLabel.text = textCurrentlyInDisplay + digit
        } else {
            if (priceLabel.text?.isEmpty)! {
                showSecondPlan(bool: false)
            } else {
                priceLabel.text?.remove(at: (priceLabel.text?.index(before: (priceLabel.text?.endIndex)!))!)
            }
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.data = priceLabel.text!
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        let testVC = Settings.storyboardInstance()
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func categoryAction(_ sender: UIButton) {
        let testVC = CategoryViewController.storyboardInstance()
        testVC?.count = priceLabel.text ?? ""
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func reportAction(_ sender: UIButton) {
        let testVC = StatisticsViewController.storyboardInstance()
        self.present(testVC!, animated: false, completion: nil)
    }
}


extension ViewController: MyPageViewControllerDelegate {
    
    func myPageViewController(myPageViewController: MyPageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }

    func myPageViewController(myPageViewController: MyPageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}
