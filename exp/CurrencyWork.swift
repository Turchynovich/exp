import Foundation
import CoreData
import UIKit
/*
public class CurrencyWork {
    //массив валют, котрые являются активными от 1 до 3
    var currencyActiveArray: [(Currency, Bool)] {
        get {
            var arr = [(Currency, Bool)]()
            let predicate = NSPredicate(format: "activestatus == %@", "1")
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Currency")
            fetchRequest.predicate = predicate
            do {
                let results = try! CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
                for result in results as! [Currency] {
                    arr.append((result, false))
                }
            }
            return arr
        }
    }
    
    //валюта последней транзакции
    var lastPaymentCurrency: Currency {
        get {
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
    }
    
    //присуствует ли валюта последней транзакции в списке активных валют
    func existLastPaymentCurrencyInArray() -> [(Currency, Bool)] {
        var arr = currencyActiveArray
        var count = 0
        for (index, value) in arr.enumerated() {
            if value.0 == lastPaymentCurrency {
                arr[index].1 = true
                count += 1
            }
        }
        if count == 0 {
            arr[0].1 = true
        }
        return arr
    }
    
    //добавление несколькоих конопок на экран транзакции
    func buttonCurrency(label: UILabel, view: UIView) {
        var lct = ""
        for i in existLastPaymentCurrencyInArray() {
            if i.1 == true {
                if let f = i.0.symbol {
                    lct = f
                }
            }
        }
        
        switch existLastPaymentCurrencyInArray().count {
        case 1:
            label.text = lct
        case 2:
            drowCurrencyButton(x: 139, y: 125, code: existLastPaymentCurrencyInArray()[0].0.code ?? "", activeted: existLastPaymentCurrencyInArray()[0].1, view1: view)
            drowCurrencyButton(x: 195, y: 125, code: existLastPaymentCurrencyInArray()[1].0.code ?? "", activeted: existLastPaymentCurrencyInArray()[1].1, view1: view)
            label.text = lct
        default:
            drowCurrencyButton(x: 105, y: 125, code: existLastPaymentCurrencyInArray()[0].0.code ?? "", activeted: existLastPaymentCurrencyInArray()[0].1, view1: view)
            drowCurrencyButton(x: 167, y: 125, code: existLastPaymentCurrencyInArray()[1].0.code ?? "", activeted: existLastPaymentCurrencyInArray()[1].1, view1: view)
            drowCurrencyButton(x: 229, y: 125, code: existLastPaymentCurrencyInArray()[2].0.code ?? "", activeted: existLastPaymentCurrencyInArray()[2].1, view1: view)
            label.text = lct
        }
    }
    
    //создание кнопки валюты
    func drowCurrencyButton(x: Int, y: Int, code: String, activeted: Bool, view1: UIView) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: x, y: y, width: 41, height: 41)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        if activeted {
            button.backgroundColor = UIColor(white: 1, alpha: 0.3)
        } else {
            button.backgroundColor = UIColor.clear
        }
        button.setTitle(code, for: .normal)
        button.titleLabel?.font = UIFont(name: "GothamPro-Medium", size: 12)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = UIColor(white: 1, alpha: 0.45)
        
        view1.addSubview(button)
    }
    
}
*/
