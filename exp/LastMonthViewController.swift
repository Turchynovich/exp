import UIKit
import CoreData

class LastMonthViewController: UIViewController {
    var summ1 = 0.0
    var datFrom = NSDate()
    var datTo = NSDate()

    @IBOutlet weak var lastMonthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCurrency()
        
    }

    //возвращает массив валют, которые были использованы вчера(первые 3)
    func countOfCurrencyLastMonth() -> [String] {
        var arrayOfCurrency = [String]()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateNow = calendar.startOfDay(for: Date()) as NSDate
        let dateFrom = calendar.date(byAdding: .day, value: -30, to: dateNow as Date)! as NSDate
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateNow as Date)! as NSDate
        
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom)
        let toPredicate = NSPredicate(format: "date < %@", dateTo)
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
    
    //считает сумму за последнюю неделю по определенной валюте
    func calculate(cur: Currency) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateNow = calendar.startOfDay(for: Date()) as NSDate
        let dateFrom = calendar.date(byAdding: .day, value: -30, to: dateNow as Date)! as NSDate
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateNow as Date)! as NSDate
        
        
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom)
        let toPredicate = NSPredicate(format: "date < %@", dateTo)
        let predicate = NSPredicate(format: "currency == %@", cur)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, predicate])
        
        datFrom = dateFrom
        datTo = dateTo
        
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
        lastMonthButton.setTitle(String(fr), for: .normal)
    }
    
    func dateString(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        dateFormatter.string(from: date as Date)
        return "\(dateFormatter.string(from: date as Date))"
    }
    
    func dateString1(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.string(from: date as Date)
        return "\(dateFormatter.string(from: date as Date))\n"
    }
    
    //добавить кнопки с валютами
    func buttonCurrency() {
        switch countOfCurrencyLastMonth().count {
        case 1:
            calculate(cur: currencyFromCode(code: countOfCurrencyLastMonth()[0]))
        case 2:
            drowCurrencyButton(x: 89, y: 46, code: countOfCurrencyLastMonth()[0], activeted: true, tag: 501)
            drowCurrencyButton(x: 145, y: 46, code: countOfCurrencyLastMonth()[1], activeted: false, tag: 502)
            calculate(cur: currencyFromCode(code: countOfCurrencyLastMonth()[0]))
        case 3:
            drowCurrencyButton(x: 55, y: 46, code: countOfCurrencyLastMonth()[0], activeted: true, tag: 501)
            drowCurrencyButton(x: 117, y: 46, code: countOfCurrencyLastMonth()[1], activeted: false, tag: 502)
            drowCurrencyButton(x: 179, y: 46, code: countOfCurrencyLastMonth()[2], activeted: false, tag: 503)
            calculate(cur: currencyFromCode(code: countOfCurrencyLastMonth()[0]))
        default:
            print("not transactions yesterday")
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
        self.lastMonthButton.addSubview(button)
    }
    
    //переключение между кнопками-валютами
    @IBAction func ImageAction(_ sender: UIButton) {
        let activeCurrencyArray = countOfCurrencyLastMonth()
        let ar = [501, 502, 503]
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
    
    @IBAction func ovalLastMonthAction(_ sender: UIButton) {
/*        var activeCurrencyArray = [(Currency, Bool)]()
        if arcu.isEmpty {
            activeCurrencyArray = ctfd.existLastPaymentCurrencyInArray()
        } else {
            activeCurrencyArray = arcu
        }
        
        let testVC = Payment1CategoryTableViewController.storyboardInstance()
        testVC?.startDate = datFrom
        testVC?.endDate = datTo
        testVC?.dataStr = (dateString(date: datFrom) + " - " + dateString1(date: datTo), "LAST MONTH")
        for i in activeCurrencyArray {
            if i.1 {
                testVC?.currency = i.0
            }
        }
        
        self.present(testVC!, animated: false, completion: nil)
*/
        
        
        let testVC = Payment1CategoryTableViewController.storyboardInstance()
        testVC?.startDate = datFrom
        testVC?.endDate = datTo
        testVC?.dataStr = (dateString(date: datFrom) + " - " + dateString1(date: datTo), "LAST MONTH")
        
        switch countOfCurrencyLastMonth().count {
        case 1:
            testVC?.currency = currencyFromCode(code: countOfCurrencyLastMonth()[0])
        default:
            for i in [501, 502, 503] {
                let tempButton1 = self.view.viewWithTag(i) as? UIButton
                if tempButton1?.backgroundColor == UIColor(white: 1, alpha: 0.3) {
                    testVC?.currency = currencyFromCode(code: tempButton1?.currentTitle ?? "")
                }
            }
        }
        self.present(testVC!, animated: false, completion: nil)
        
        
    }
}
