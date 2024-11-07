

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
   
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
   
    
    @IBAction func registerPressed(_ sender: UIButton)
    {
        
        
        if let email = emailTextfield.text, let password = passwordTextfield.text
        {
           
            passwordTextfield.textContentType = .oneTimeCode
            
            if password.count < 8
            {
                       showAlert(message: "Password must be at least 8 characters long.")
                       return
                   }
            
            Auth.auth().createUser(withEmail: email, password: password)
            { authResult, error in
                
                if let e = error
                {
                    print(error!)
                }
                else
                {
                    
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                    
                }
            }
            
        }
        
    }
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Invalid Password", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
}




