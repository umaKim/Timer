//
//  NetworkService.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/03.
//
import Firebase
import GoogleSignIn

import FirebaseFirestore
import FirebaseDatabase
import Combine
import FirebaseAuth
import Foundation
import UIKit

protocol Networkable {
    func fetchData(completion: @escaping (Result<[TimeLap], Error>) -> Void)
    func saveData(_ lap: TimeLap)
}

protocol SocialAuthorizable {
    func signIn(with presenting: UIViewController, completion: @escaping (String) -> Void)
    func signOut()
}

final class NetworkService: Networkable {
    private let uid = Auth.auth().currentUser?.uid
    private let database = Firestore.firestore()
    
    public func fetchData(completion: @escaping (Result<[TimeLap], Error>) -> Void)  {
        guard let uid = uid else { return }

        database.collection("\(uid)").getDocuments { snapshot, error in

            var laps = [TimeLap]()
            
            snapshot?.documents.forEach({ snapshot in
                print(snapshot.data())
                
                let dictionary = snapshot.data()
                
                guard
                    let title = dictionary["title"] as? Int,
                    let timerSeconds = dictionary["timerSeconds"] as? Float,
                    let minute = dictionary["minute"] as? String,
                    let seconds = dictionary["seconds"] as? String
                else { return }
                
                let timeLap = TimeLap(
                    title: title,
                    timerSeconds: timerSeconds,
                    minute: minute,
                    seconds: seconds,
                    textColor: .label
                )
                
                laps.append(timeLap)
            })
            
            completion(.success(laps))
        }
    }
    
    public func saveData(_ lap: TimeLap) {
        guard let uid = uid else { return }
        let ref = database.document("\(uid)/\(lap.title)")
        
        let value = [
            "title": lap.title,
            "timerSeconds": lap.timerSeconds,
            "minute": lap.minute,
            "seconds": lap.seconds
        ] as [String : Any]
        
        ref.setData(value)
    }
}

extension NetworkService: SocialAuthorizable {
    func signIn(with presenting: UIViewController, completion: @escaping (String) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: presenting) { [unowned self] user, error in
            
            if error != nil { return }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) {[unowned self] result, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                completion(uid)
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
