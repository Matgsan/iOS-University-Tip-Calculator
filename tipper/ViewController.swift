import UIKit

class ViewController: UIViewController {
    
    var tipPercentage = 0.15
    let tipPercentages = [0.15, 0.18, 0.2]
    
    @IBOutlet weak var topViewContainer: UIView!
    @IBOutlet weak var bottomViewContainer: UIView!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var currencyLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var totalContainer: UIStackView!
    @IBOutlet weak var partySizeContainer: UIStackView!
    @IBOutlet weak var tipPerPersonContainer: UIStackView!
    @IBOutlet weak var totalPerPersonContainer: UIStackView!
    
    @IBOutlet weak var totalValue: UILabel!
    
    @IBOutlet weak var partySizeValue: UILabel!
    @IBOutlet weak var partySizeStepper: UIStepper!
    
    @IBOutlet weak var tipPerPersonValue: UILabel!
    
    @IBOutlet weak var totalPerPersonValue: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        if(!billAmountTextField.hasText){
            tipControl.alpha = 0
            currencyLabel.alpha = 0
            bottomViewContainer.isHidden = true
            bottomViewContainer.alpha = 0
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        billAmountTextField.becomeFirstResponder()
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    
        

    }
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        billAmountTextField.endEditing(true)
    }
    
    @IBAction func partySizeChange(_ sender: UIStepper) {
        partySizeValue.text = String(Int(sender.value))
        calculateValues();
    }
    
    @IBAction func tipAmountChange(_ sender: UISegmentedControl) {
        tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        calculateValues();
    }
    
    @IBAction func billAmountChanged(_ sender: UITextField) {
        if(sender.hasText){
            bottomViewContainer.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.tipControl.alpha = 1
                self.currencyLabel.alpha = 1
                self.bottomViewContainer.alpha = 1
            }
            calculateValues();
        }else{
            bottomViewContainer.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.tipControl.alpha = 0
                self.currencyLabel.alpha = 0
                self.bottomViewContainer.alpha = 0
            }
        }
    }
    
    func calculateValues(){
        let formatter = NumberFormatter()
        
        var billAmount = Double(billAmountTextField.text!) ?? 0
        var partySize = Int(partySizeValue.text!) ?? 0
        if(billAmount < 0){
            billAmount = 0;
            billAmountTextField.text = String(billAmount);
        }
        if(partySize < 0){
            partySize = 0;
            partySizeValue.text = String(partySize);
        }
        
        let tipTotal = billAmount * tipPercentage;
        let tipPerPerson = tipTotal / Double(partySize);
        let total = billAmount + tipTotal;
        let totalPerPerson = total /  Double(partySize);
        
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        
        tipPerPersonValue.text = formatter.string(from: NSNumber(value: tipPerPerson));
        totalPerPersonValue.text =  formatter.string(from:NSNumber(value: totalPerPerson));
        totalValue.text =  formatter.string(from:NSNumber(value:total));
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
        }
        self.partySizeContainer.isHidden = true
        self.tipPerPersonContainer.isHidden = true
        self.totalPerPersonContainer.isHidden = true
        self.tipPerPersonContainer.alpha = 0
        self.partySizeContainer.alpha = 0
        self.totalPerPersonContainer.alpha = 0
                
        stackViewBottomConstraint.constant = keyboardSize.height;
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        stackViewBottomConstraint.constant = 0;
        self.partySizeContainer.isHidden = false
        self.tipPerPersonContainer.isHidden = false
        self.totalPerPersonContainer.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.tipPerPersonContainer.alpha = 1
            self.partySizeContainer.alpha = 1
            self.totalPerPersonContainer.alpha = 1
            }, completion:  nil)
    }

}

