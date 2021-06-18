//
//  JuiceMaker - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit


class ViewController: UIViewController {
    let juiceMaker = JuiceMaker()
    
    @IBOutlet private weak var strawberryStockLabel: UILabel!
    @IBOutlet private weak var bananaStockLabel: UILabel!
    @IBOutlet private weak var pineappleStockLabel: UILabel!
    @IBOutlet private weak var kiwiStockLabel: UILabel!
    @IBOutlet private weak var mangoStockLabel: UILabel!
    
    @IBOutlet private weak var ddalbaBtn: UIButton!
    @IBOutlet private weak var mangkiBtn: UIButton!
    @IBOutlet private weak var strawberryBtn: UIButton!
    @IBOutlet private weak var bananaBtn: UIButton!
    @IBOutlet private weak var pineappleBtn: UIButton!
    @IBOutlet private weak var kiwiBtn: UIButton!
    @IBOutlet private weak var mangoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applyChangedStock(_:)), name: Notification.Name("changeFruitStock"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("changeFruitStock"), object: nil)
    }
    
    func showFruitLabel() {
        strawberryStockLabel.text = String(juiceMaker.getAmount(.strawberry))
        bananaStockLabel.text = String(juiceMaker.getAmount(.banana))
        pineappleStockLabel.text = String(juiceMaker.getAmount(.pineapple))
        kiwiStockLabel.text = String(juiceMaker.getAmount(.kiwi))
        mangoStockLabel.text = String(juiceMaker.getAmount(.mango))
    }
    
    @objc func applyChangedStock(_ notification: Notification)  {
        showFruitLabel()
    }
    
    private func succeededMakingJuiceAlert(_ message: JuiceMaker.JuiceType) {
        let alert = UIAlertController(title: nil,
                                      message: "\(message.rawValue) 나왔습니다! 맛있게 드세요!",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인" ,
                                     style: . default) { (action) in
            self.juiceMaker.makeJuice(order: message)
            self.showFruitLabel()
            
        }
        alert.addAction(okAction)
        present(alert,
                animated: true,
                completion: nil)
    }
    
    private func failedMakingJuiceAlert() {
        let alert = UIAlertController(title: nil,
                                      message: "재료가 모자라요. 재고를 수정할까요?",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default) { (action) in
            self.changeView()
        }
        let noAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert,
                animated: true,
                completion: nil)
    }
    
    @IBAction private func orderFruitJuice(_ sender: UIButton) {
        switch sender {
        case ddalbaBtn:
            judgingPossibilityOfStock(.ddalbaJuice)
        case mangkiBtn:
            judgingPossibilityOfStock(.mangoKiwiJuice)
        case strawberryBtn:
            judgingPossibilityOfStock(.strawberryJuice)
        case bananaBtn:
            judgingPossibilityOfStock(.bananaJuice)
        case pineappleBtn:
            judgingPossibilityOfStock(.pineappleJuice)
        case kiwiBtn:
            judgingPossibilityOfStock(.kiwiJuice)
        case mangoBtn:
            judgingPossibilityOfStock(.mangoJuice)
        default:
            return
        }
    }
    
    private func judgingPossibilityOfStock(_ juice: JuiceMaker.JuiceType) {
        if juiceMaker.checkStock(fruit: juice) {
            succeededMakingJuiceAlert(juice)
        } else {
            failedMakingJuiceAlert()
        }
    }
    
    private func changeView() {
        guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "AddStock") as? UINavigationController else {
            return
        }
        let second = mainVC.visibleViewController as? ViewController2
        second?.updateJuiceMaker(juiceMaker: juiceMaker)
        mainVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        mainVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(mainVC, animated: true)
    }
    
    @IBAction func changeViewBtn(_ sender: UIBarButtonItem) {
        changeView()
    }
    
}
