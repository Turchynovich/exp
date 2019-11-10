import UIKit
import CoreData

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTyping​ = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var currencySaveToData = ""
    
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
        settings.isHidden = false
        report.isHidden = false
        backButton.isHidden = !false
        label1.isHidden = false
        label2.isHidden = false
        enterLabel.isHidden = !false
        labelDate(index: 0)
    }
    

    
    func showSecondPlan(bool: Bool) {
        containerView.isHidden = bool
        pageControl.isHidden = bool
        //report.isHidden = bool
        //settings.isHidden = bool
        //label1.isHidden = bool
        //label2.isHidden = bool
        
        addExpensesButton.isHidden = !bool
        categoryButton.isHidden = !bool
        priceLabel.isHidden = !bool
        currencyLabel.isHidden = !bool
        //enterLabel.isHidden = !bool
        //backButton.isHidden = !bool

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
        
        //извлечть валюту из переменной currencySaveToData
        var paymentCurrency: Currency!
        let to1Predicate = NSPredicate(format: "code == %@", currencySaveToData)
        let request1: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Currency")
        request1.predicate = to1Predicate
        do {
            let objects = try! CoreDataManager.instance.managedObjectContext.fetch(request1)
            if objects.count >= 1 {
                paymentCurrency = objects[0] as? Currency
            }
        }
        
        managedObject.category = paymentCategory
        managedObject.currency = paymentCurrency
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
    
    func lastPaymentCurrency() -> String {
        var d = ""
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Payment")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        do {
            let results = try! CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [Payment] {
                if let res = result.currency?.code {
                    d = res
                }
            }
        }
        return d
    }

    
    func buttonsCurrency() {
        var arrayActiveCurrency = [String]()
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
            for i in results as! [Currency] {
                arrayActiveCurrency.append(i.code ?? "")
            }
        }
        
        
        switch arrayActiveCurrency.count {
        case 1:
            currencySaveToData = arrayActiveCurrency[0]
        case 2:
            if arrayActiveCurrency[0] == lastPaymentCurrency() {
                drowCurrencyButton(x: 139, y: 125, code: arrayActiveCurrency[0], activeted: true, tag: 101)
                drowCurrencyButton(x: 195, y: 125, code: arrayActiveCurrency[1], activeted: false, tag: 102)
                currencySaveToData = arrayActiveCurrency[0]
            } else if arrayActiveCurrency[1] == lastPaymentCurrency() {
                drowCurrencyButton(x: 139, y: 125, code: arrayActiveCurrency[1], activeted: true, tag: 101)
                drowCurrencyButton(x: 195, y: 125, code: arrayActiveCurrency[0], activeted: false, tag: 102)
                currencySaveToData = arrayActiveCurrency[1]
            } else {
                drowCurrencyButton(x: 139, y: 125, code: arrayActiveCurrency[0], activeted: true, tag: 101)
                drowCurrencyButton(x: 195, y: 125, code: arrayActiveCurrency[1], activeted: false, tag: 102)
                currencySaveToData = arrayActiveCurrency[0]
            }
        case 3:
            if arrayActiveCurrency[0] == lastPaymentCurrency() {
                drowCurrencyButton(x: 105, y: 125, code: arrayActiveCurrency[0], activeted: true, tag: 101)
                drowCurrencyButton(x: 167, y: 125, code: arrayActiveCurrency[1], activeted: false, tag: 102)
                drowCurrencyButton(x: 229, y: 125, code: arrayActiveCurrency[2], activeted: false, tag: 103)
                currencySaveToData = arrayActiveCurrency[0]
            } else if arrayActiveCurrency[1] == lastPaymentCurrency() {
                drowCurrencyButton(x: 105, y: 125, code: arrayActiveCurrency[1], activeted: true, tag: 101)
                drowCurrencyButton(x: 167, y: 125, code: arrayActiveCurrency[0], activeted: false, tag: 102)
                drowCurrencyButton(x: 229, y: 125, code: arrayActiveCurrency[2], activeted: false, tag: 103)
                currencySaveToData = arrayActiveCurrency[1]
            } else if arrayActiveCurrency[2] == lastPaymentCurrency() {
                drowCurrencyButton(x: 105, y: 125, code: arrayActiveCurrency[2], activeted: true, tag: 101)
                drowCurrencyButton(x: 167, y: 125, code: arrayActiveCurrency[1], activeted: false, tag: 102)
                drowCurrencyButton(x: 229, y: 125, code: arrayActiveCurrency[0], activeted: false, tag: 103)
                currencySaveToData = arrayActiveCurrency[2]
            } else {
                drowCurrencyButton(x: 105, y: 125, code: arrayActiveCurrency[0], activeted: true, tag: 101)
                drowCurrencyButton(x: 167, y: 125, code: arrayActiveCurrency[1], activeted: false, tag: 102)
                drowCurrencyButton(x: 229, y: 125, code: arrayActiveCurrency[2], activeted: false, tag: 103)
                currencySaveToData = arrayActiveCurrency[0]
            }
        default:
            print("error")
        }
    }
    
    func drowCurrencyButton(x: Int, y: Int, code: String, activeted: Bool, tag: Int) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: x, y: y, width: 41, height: 41)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        if activeted {
            button.backgroundColor = UIColor(white: 1, alpha: 0.1)
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
    
    //анимация view
    func animationViews(screenShowExpenses: Bool) {
        
        
        func aminate(view: UIView, up: Bool) {
            var y1: CGFloat
            var y2: CGFloat
            if !screenShowExpenses {
                y1 = -38
                y2 = 41
            } else {
                y1 = 41
                y2 = -38
            }
            
            if up {
                UIView.animate(withDuration: 0.25, animations: {
                    view.transform = CGAffineTransform(translationX: 0, y: y1)
                    view.alpha = 0
                }, completion: {if $0 {view.isHidden = true}})
            } else {
                view.isHidden = false
                view.transform = CGAffineTransform(translationX: 0, y: y2)
                view.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    view.transform = CGAffineTransform(translationX: 0, y: 0)
                    view.alpha = 1
                }
            }
        }
        
        func animate_2(view: UIView, alpha: CGFloat) {
            view.isHidden = false
            view.transform = CGAffineTransform(translationX: 0, y: 30)
            view.alpha = 0
            UIView.animate(withDuration: 0.15) {
                view.transform = CGAffineTransform(translationX: 0, y: 0)
                view.alpha = alpha
            }
        }
        
        func animate_3(view: UIView) {
            view.isHidden = false
            view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            view.alpha = 0
            UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
                view.alpha = 1
            }, completion: nil)
        }
        
        func animationOval() {
            //понять какой экран сейчас показывается
            //запустить функцию именно с нужного экрана
            NotificationCenter.default.post(name: NSNotification.Name("viewLoaded()"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                //self.showSecondPlan(bool: true)
                self.containerView.isHidden = true
                self.pageControl.isHidden = true
                animate_2(view: self.categoryButton, alpha: 0.45)
                animate_2(view: self.priceLabel, alpha: 1)
                animate_2(view: self.currencyLabel, alpha: 1)
                animate_3(view: self.addExpensesButton)
            }
        }
        
        func animate_5(view: UIView) {
            UIView.animate(withDuration: 0.3, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: 30)
                view.alpha = 0
            }, completion: {if $0 {view.isHidden = true}})
        }
        
        func animate_6(view: UIView) {
            
            
            UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
                view.alpha = 0
            }, completion: {if $0 {view.isHidden = true}})
        }
        
        func animate_4() {
            animate_5(view: self.categoryButton)
            animate_5(view: self.priceLabel)
            animate_5(view: self.currencyLabel)
            animate_6(view: self.addExpensesButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.containerView.isHidden = false
                self.pageControl.isHidden = false
                NotificationCenter.default.post(name: NSNotification.Name("viewLoaded1()"), object: nil)
            }
            
            
        }

        
        if screenShowExpenses {
            aminate(view: self.report, up: false)
            aminate(view: self.settings, up: false)
            aminate(view: self.backButton, up: true)
            aminate(view: self.label1, up: false)
            aminate(view: self.label2, up: false)
            aminate(view: self.enterLabel, up: true)
            animate_4()
            
        } else {
            aminate(view: self.report, up: true)
            aminate(view: self.settings, up: true)
            aminate(view: self.backButton, up: false)
            aminate(view: self.label1, up: true)
            aminate(view: self.label2, up: true)
            aminate(view: self.enterLabel, up: false)
            animationOval()
        }
    }
    
    
    
    

    @IBAction func ImageAction(_ sender: UIButton) {
        var activeCurrencyArray = [String]()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Currency")
        let statusPredicate = NSPredicate(format: "status == %@", NSNumber(value: true))
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate])
        fetchRequest.predicate = datePredicate
        do {
            let results = try! CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for i in results as! [Currency] {
                activeCurrencyArray.append(i.code ?? "")
            }
        }
        
        let ar = [101, 102, 103]
        var tg = 0
        
        for i in activeCurrencyArray {
            if i == sender.currentTitle {
                currencySaveToData = i
                sender.backgroundColor = UIColor(white: 1, alpha: 0.1)
                tg = sender.tag
            }
        }

        for i in ar {
            if i != tg {
                let tempButton = self.view.viewWithTag(i) as? UIButton
                tempButton?.backgroundColor = UIColor.clear
            }
        }
    }
    
    
    //для перехода на этот экран
    static func storyboardInstance() -> ViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "YourVC") as? ViewController
    }
    
    //функия для даты всерху экрана
    func labelDate(index: Int) {
        func dateFormat(day: Int) -> String {
            var calendar = Calendar.current
            calendar.timeZone = .current
            let date = calendar.date(byAdding: .day, value: day, to: Date())
            if let dt = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                dateFormatter.timeZone = .current
                return dateFormatter.string(from: dt)
            } else {
                return ""
            }
        }
        
        switch index {
        case 1:
            label1.text = "YESTERDAY EXPENSES"
            label2.text = dateFormat(day: -1)
        case 2:
            label1.text = "LAST WEEK EXPENSES"
            label2.text = dateFormat(day: -7) + " - " + dateFormat(day: 0)
        case 3:
            label1.text = "LAST MONTH EXPENSES"
            label2.text = dateFormat(day: -30) + " - " + dateFormat(day: 0)
        default:
            label1.text = "TODAY EXPENSES"
            label2.text = dateFormat(day: 0)
        }
    }
    
    @IBAction func addExpensesAction(_ sender: UIButton) {
        let res = priceLabel.text ?? ""
        saveDataToCoreData(count: (res as NSString).doubleValue)
        showSecondPlan(bool: false)
        priceLabel.text = ""
        
        let testVC = ViewController.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        animationViews(screenShowExpenses: true)
        priceLabel.text = ""
        containerView.isHidden = false
    }
    @IBAction func numPad(_ sender: UIButton) {
        animationViews(screenShowExpenses: false)

//        if !containerView.isHidden {
//            showSecondPlan(bool: true)
//        }
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
        testVC?.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func categoryAction(_ sender: UIButton) {
        let testVC = CategoryViewController.storyboardInstance()
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        testVC?.modalPresentationStyle = .fullScreen
        testVC?.count = priceLabel.text ?? ""
        self.present(testVC!, animated: false, completion: nil)
    }
    
    @IBAction func reportAction(_ sender: UIButton) {
        let testVC = StatisticsViewController.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
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
