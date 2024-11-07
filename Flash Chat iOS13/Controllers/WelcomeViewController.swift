

import UIKit


class WelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
       

//        titleLabel.text = K.appName
                var charIndex = 0.0
                titleLabel.text = ""
        
                let titleText = "⚡️FlashChat"
        
                for letter in titleText
                {
            
                    Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false)
                     { (timer) in
                         self.titleLabel.text?.append(letter)
                     }
                   charIndex += 1
                }
       
    }
    

}
