
import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    
    func verification()
    {
        showAlert(message: "Please make sure you enter valid user information")
         return
    }
    func showAlert(message: String) 
    {
       
            let alert = UIAlertController(title: "Invalid-Input", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
  
  
    @IBAction func loginPressed(_ sender: UIButton)
    {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text
        {
            passwordTextfield.textContentType = .oneTimeCode
            
          
            
            Auth.auth().signIn(withEmail: email, password: password)
            {
                [weak self] authResult, error in
                guard let strongSelf = self else { return }
                // ...
                
                
                
                if let e = error
                {
                    self!.emailTextfield.text = ""
                    self!.passwordTextfield.text = ""
                    
                    self!.verification()
                    print(e)
                    
                }
                else
                {
                    
                    self!.performSegue(withIdentifier: K.loginSegue, sender: self)
                    
                }
                
            }
            
        }
    }
    
    
}
