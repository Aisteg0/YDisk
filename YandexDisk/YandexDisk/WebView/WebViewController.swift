import UIKit
import WebKit

class WebViewController: UIViewController {
    let responseType = "code"
    let clientID = "60f55f475b9a4363a5f9ff050989c586"
    let redirectURL = "https://oauth.yandex.ru/verification_code"
    let baseURL = "https://oauth.yandex.ru/authorize"
    let tokenURL = "https://www.example.com/token?code="
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        URLFormation()
        view.addSubview(webView)
    }
    
    private func URLFormation() {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: responseType),
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURL)
        ]
        if let url = components?.url{
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func exchangeCodeForToken(code: String) {
        let clientSecret = "4dcb1c1bd95248ac8acb18b3eb8b8d8a"
           let clientCredentails = "\(clientID):\(clientSecret)"
        guard let clientCredentailsData = clientCredentails.data(using: .utf8) else {
            return
        }
        let basicAuthString = clientCredentailsData.base64EncodedString()
           let tokenEndpoint = "https://oauth.yandex.ru/token"
           
           var request = URLRequest(url: URL(string: tokenEndpoint)!)
           request.httpMethod = "POST"
           request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           request.setValue("Basic \(basicAuthString)", forHTTPHeaderField: "Authorization")
           
           let body = "grant_type=authorization_code&code=\(code)&client_id=\(clientID)&client_secret=\(clientSecret)"
           request.httpBody = body.data(using: .utf8)
           
        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
               if let data = data {
                   do {
                       let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                       print(json)
                       if let accessToken = json?["access_token"] as? String {
                           print("Токен успешно получен:", accessToken)
                           fetchUserInfo(accessToken: accessToken)
                       } else {
                           print("Ошибка при получении токена")
                       }
                   } catch {
                       print("Ошибка JSON:", error)
                   }
               } else if let error = error {
                   print("Ошибка:", error)
               }
           }
           task.resume()
        
    }
    
    private func fetchUserInfo(accessToken: String) {
        let userInfoEndpoint = "https://login.yandex.ru/info?format=json"
        var request = URLRequest(url: URL(string: userInfoEndpoint)!)
        request.httpMethod = "GET"
        request.setValue("OAuth \(accessToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data,response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print(json)
                }
                catch {
                    print("Ошибка JSON:", error)
                }
            } else if let error = error {
                print("ОшИбка:", error)
            }
            
        }
        task.resume()
    }


}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Страница загружена")
        if let url = webView.url,
           let code = getCodeFromURL(url) {
            exchangeCodeForToken(code: code)
            
            print(code)
        }
       
        
        
    }
    
    private func getCodeFromURL(_ url: URL) -> String? {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            for queryItem in queryItems {
                if queryItem.name == "code" {
                    return queryItem.value
                }
            }
        }
        return nil
    }

}
