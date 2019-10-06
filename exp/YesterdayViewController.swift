import UIKit
import CoreData

class YesterdayViewController: UIViewController {
    var summ1 = 0.0
    var datFrom = NSDate()
    var datTo = NSDate()
    
    @IBOutlet weak var yesterdayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCurrency()
    }
    
    
    
    //возвращает массив валют, которые были использованы вчера(первые 3)
    func countOfCurrencyYesterday() -> [String] {
        var arrayOfCurrency = [String]()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateNow = calendar.startOfDay(for: Date()) as NSDate
        let dateFrom = calendar.date(byAdding: .day, value: -1, to: dateNow as Date)! as NSDate
        
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom)
        let toPredicate = NSPredicate(format: "date < %@", dateNow)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Payment")
        
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["currency"]
        request.returnsObjectsAsFaults = false
        request.propertiesToGroupBy = ["currency"]
        
        request.predicate = datePredicate
        do {
            let objects = try! CoreDataManager.instance.managedObjectContext.fetch(request)
            for i in objects as! [[String: Any]] {
                let dd = try! CoreDataManager.instance.managedObjectContext.existingObject(with: i["currency"] as! NSManagedObjectID)
                if arrayOfCurrency.count < 3 {
                    arrayOfCurrency.append((dd as! Currency).code ?? "")
                }
            }
        }
        return arrayOfCurrency
    }
    
    //возвращаеь класс Currency по коду валюы
    func currencyFromCode(code: String) -> Currency {
        let toPredicate = NSPredicate(format: "code = %@", code)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [toPredicate])
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Currency")
        
        request.predicate = datePredicate
        do {
            let objects = try! CoreDataManager.instance.managedObjectContext.fetch(request)
            return objects[0] as! Currency
        }
    }
    
    //считает сумму за вчера по определенной валюте
    func calculate(cur: Currency) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateNow = calendar.startOfDay(for: Date()) as NSDate
        let dateFrom = calendar.date(byAdding: .day, value: -1, to: dateNow as Date)! as NSDate
        
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom)
        let toPredicate = NSPredicate(format: "date < %@", dateNow)
        let predicate = NSPredicate(format: "currency == %@", cur)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, predicate])
        datFrom = dateFrom
        datTo = dateNow
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Payment")
        request.predicate = datePredicate
        do {
            let objects = try! CoreDataManager.instance.managedObjectContext.fetch(request)
            var summ = 0.0
            for object in objects as! [Payment] {
                summ += object.count
            }
            summ1 = summ
        }
        let fr = (Double(round(1000*summ1)/1000))
        yesterdayButton.setTitle(String(fr), for: .normal)
    }
    
    func dateString(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.string(from: date as Date)
        return "\(dateFormatter.string(from: date as Date))\n"
    }
    
    //добавить кнопки с валютами
    func buttonCurrency() {
        switch countOfCurrencyYesterday().count {
        case 1:
            calculate(cur: currencyFromCode(code: countOfCurrencyYesterday()[0]))
        case 2:
            drowCurrencyButton(x: 89, y: 46, code: countOfCurrencyYesterday()[0], activeted: true, tag: 301)
            drowCurrencyButton(x: 145, y: 46, code: countOfCurrencyYesterday()[1], activeted: false, tag: 302)
            calculate(cur: currencyFromCode(code: countOfCurrencyYesterday()[0]))
        case 3:
            drowCurrencyButton(x: 55, y: 46, code: countOfCurrencyYesterday()[0], activeted: true, tag: 301)
            drowCurrencyButton(x: 117, y: 46, code: countOfCurrencyYesterday()[1], activeted: false, tag: 302)
            drowCurrencyButton(x: 179, y: 46, code: countOfCurrencyYesterday()[2], activeted: false, tag: 303)
            calculate(cur: currencyFromCode(code: countOfCurrencyYesterday()[0]))
        default:
            break
        }
    }
    
    //рисуем конпки валют
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
        self.yesterdayButton.addSubview(button)
    }
    
    //переключение между кнопками-валютами
    @IBAction func ImageAction(_ sender: UIButton) {
        let activeCurrencyArray = countOfCurrencyYesterday()
        let ar = [301, 302, 303]
        var tg = 0
        
        for i in activeCurrencyArray {
            if i == sender.currentTitle {
                calculate(cur: currencyFromCode(code: i))
                sender.backgroundColor = UIColor(white: 1, alpha: 0.3)
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

    //нажатие на главную круглую кпопку
    @IBAction func ovalYesterdayAction(_ sender: UIButton) {
        let testVC = Payment1CategoryTableViewController.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        testVC?.startDate = datFrom
        testVC?.endDate = datTo
        testVC?.dataStr = (dateString(date: datFrom), "YESTODAY")
        
        switch countOfCurrencyYesterday().count {
        case 1:
            testVC?.currency = currencyFromCode(code: countOfCurrencyYesterday()[0])
        default:
            for i in [301, 302, 303] {
                let tempButton1 = self.view.viewWithTag(i) as? UIButton
                if tempButton1?.backgroundColor == UIColor(white: 1, alpha: 0.3) {
                    testVC?.currency = currencyFromCode(code: tempButton1?.currentTitle ?? "")
                }
            }
        }
        
        self.present(testVC!, animated: false, completion: nil)
    }
}
