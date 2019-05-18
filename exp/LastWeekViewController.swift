import UIKit
import CoreData

class LastWeekViewController: UIViewController {

    var summ1 = 0.0
    var datFrom = NSDate()
    var datTo = NSDate()
    var currancyarr = [(symbol: String, code: String)]()
//    var ctfd = CurrencyWork()
    var arcu = [(Currency, Bool)]()
    
    @IBOutlet weak var lastWeekButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCurrency()
    }
    
    func calculate(cur: Currency) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateNow = calendar.startOfDay(for: Date()) as NSDate
        let dateFrom = calendar.date(byAdding: .day, value: -7, to: dateNow as Date)! as NSDate
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
        lastWeekButton.setTitle(String(fr), for: .normal)
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
/*
        var activeCurrencyArray = [(Currency, Bool)]()
        if arcu.isEmpty {
            activeCurrencyArray = ctfd.existLastPaymentCurrencyInArray()
        } else {
            activeCurrencyArray = arcu
        }
        
        switch activeCurrencyArray.count {
        case 1:
            for i in activeCurrencyArray {
                if i.1 {
                    calculate(cur: i.0)
                }
            }
        case 2:
            drowCurrencyButton(x: 89, y: 46, code: activeCurrencyArray[0].0.code ?? "", activeted: activeCurrencyArray[0].1, tag: 101)
            drowCurrencyButton(x: 145, y: 46, code: activeCurrencyArray[1].0.code ?? "", activeted: activeCurrencyArray[1].1, tag: 102)
            //arcu = activeCurrencyArray
            for i in activeCurrencyArray {
                if i.1 {
                    calculate(cur: i.0)
                }
            }
        default:
            drowCurrencyButton(x: 55, y: 46, code: activeCurrencyArray[0].0.code ?? "", activeted: activeCurrencyArray[0].1, tag: 101)
            drowCurrencyButton(x: 117, y: 46, code: activeCurrencyArray[1].0.code ?? "", activeted: activeCurrencyArray[1].1, tag: 102)
            drowCurrencyButton(x: 179, y: 46, code: activeCurrencyArray[2].0.code ?? "", activeted: activeCurrencyArray[2].1, tag: 103)
            //arcu = activeCurrencyArray
            for i in activeCurrencyArray {
                if i.1 {
                    calculate(cur: i.0)
                }
            }
        }
*/    }
    
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
        self.lastWeekButton.addSubview(button)
    }
    
    func offCurrencyButton() {
        let ar = [101, 102, 103]
        for i in ar {
            let tempButton = self.view.viewWithTag(i) as? UIButton
            tempButton?.removeFromSuperview()
        }
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
*/    }

    @IBAction func ovalLastWeekAction(_ sender: UIButton) {
/*        var activeCurrencyArray = [(Currency, Bool)]()
        if arcu.isEmpty {
            activeCurrencyArray = ctfd.existLastPaymentCurrencyInArray()
        } else {
            activeCurrencyArray = arcu
        }
        
        let testVC = Payment1CategoryTableViewController.storyboardInstance()
        testVC?.startDate = datFrom
        testVC?.endDate = datTo
        testVC?.dataStr = (dateString(date: datFrom) + " - " + dateString1(date: datTo), "LAST WEEK")
        for i in activeCurrencyArray {
            if i.1 {
                testVC?.currency = i.0
            }
        }
        
        self.present(testVC!, animated: false, completion: nil)
*/    }
}
