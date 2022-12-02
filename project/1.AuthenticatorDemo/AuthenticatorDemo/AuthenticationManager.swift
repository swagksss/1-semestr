//
//  AuthenticationManager.swift
//  AuthenticatorDemo
//
//
import Foundation
import LocalAuthentication

class AuthenticationManager: ObservableObject {
    private(set) var context = LAContext()
    @Published private(set) var biometryType: LABiometryType = .none
    private(set) var canEvaluatePolicy = false
    @Published private(set) var isAuthenticated = false
    @Published private(set) var errorDescription: String?
    @Published var showAlert = false
    
    // Після ініціалізації цього класу отримати biometryType
    init() {
        getBiometryType()
    }
    
    func getBiometryType() {
        // canEvaluatePolicy повідомить нам, чи підтримує пристрій користувача біометричну автентифікацію
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        // Отримання biometryType - іншими словами, якщо пристрій підтримує FaceID, TouchID або не підтримує біометричну авторизацію
        biometryType = context.biometryType
    }
    
    func authenticateWithBiometrics() async {
        // Скидання LAContext, щоб під час наступного входу біометричні дані перевірялися знову
        context = LAContext()
        
        // evaluatePolicy, лише якщо пристрій підтримує біометричну авторизацію
        if canEvaluatePolicy {
            let reason = "Log into your account"
            
            do {
                // evaluatePolicy перевірить, чи є користувач власником пристрою, поверне логічне значення, яке повідомить нам, чи успішно ідентифіковано користувача
                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                
                // Лише в разі успіху ми встановимо для isAuthenticated значення true
                if success {
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        print("isAuthenticated", self.isAuthenticated)
                    }
                }
            } catch {
                print(error.localizedDescription)
                
                // Якщо ми зіткнемося з помилкою, ми встановимо errorDescription, ми покажемо сповіщення та встановимо для biometryType значення none, щоб користувач міг увійти за допомогою облікових даних
                DispatchQueue.main.async {
                    self.errorDescription = error.localizedDescription
                    self.showAlert = true
                    self.biometryType = .none
                }
            }
        }
    }
    
    // Фіктивна функція для входу в програму
    func authenticateWithCredentials(username: String, password: String) {
        if username == "Ksenia" && password == "123456" {
            isAuthenticated = true
        } else {
            errorDescription = "Wrong credentials"
            showAlert = true
        }
    }
    
    // Вийти з системи користувача - просто встановити назад isAuthenticated на false
    func logout() {
        isAuthenticated = false
    }
}
