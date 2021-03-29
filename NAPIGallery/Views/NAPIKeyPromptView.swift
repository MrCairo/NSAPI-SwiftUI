//
//  NAPIKeyPromptView.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/28/21.
//

import SwiftUI
import Combine


class NAPIKeyPromptViewController: UIViewController {
    var apiKeyString: String?
    
    /// Presents a UIAlertController (alert style) with a UITextField and a `Done` button
    /// - Parameters:
    ///   - title: to be used as title of the UIAlertController
    ///   - message: to be used as optional message of the UIAlertController
    ///   - text: binding for the text typed into the UITextField
    ///   - isPresented: binding to be set to false when the alert is dismissed (`Done` button tapped)
    init(title: String, message: String?, isPresented: Binding<Bool>?) {
        self.alertTitle = title
        self.message = message
        self.isPresented = isPresented
        super.init(nibName: nil, bundle: nil)
//        self.apiKeyString = NAPIKey.shared.value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Dependencies
    private let alertTitle: String
    private let message: String?

//    @Binding private var text: String?
    private var isPresented: Binding<Bool>?
    
    // MARK: - Private Properties
    private var subscription: AnyCancellable?
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentPromptController()
    }
    
    private func presentPromptController() {
        guard subscription == nil else { return } // present only once
        
        let vc = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        // add a textField and create a subscription to update the `text` binding
        vc.addTextField { [weak self] textField in
            guard let self = self else { return }
            textField.text = NAPIKey.shared.value
            self.subscription = NotificationCenter.default
                .publisher(for: UITextField.textDidEndEditingNotification, object: textField)
                .map { ($0.object as? UITextField)?.text }
                .assign(to: \.apiKeyString, on: self)
        }
        
        // create a `Done` action that updates the `isPresented` binding when tapped
        // this is just for Demo only but we should really inject
        // an array of buttons (with their title, style and tap handler)
        let action = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            self?.isPresented?.wrappedValue = false
            NAPIKey.shared.value = self?.apiKeyString ?? ""
        }
        vc.addAction(action)
        present(vc, animated: true, completion: nil)
    }
}

struct NAPIKeyPromptView {
    
    // MARK: Properties
    let title: String
    let message: String?
    var isPresented: Binding<Bool>? = nil

    // MARK: Modifiers
    func dismissable(_ isPresented: Binding<Bool>) -> NAPIKeyPromptView {
        NAPIKeyPromptView(title: title, message: message, isPresented: isPresented)
    }
}

extension NAPIKeyPromptView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = NAPIKeyPromptViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NAPIKeyPromptView>) -> UIViewControllerType {
        NAPIKeyPromptViewController(title: title, message: message, isPresented: isPresented)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: UIViewControllerRepresentableContext<NAPIKeyPromptView>) {
        // no update needed
    }
}

struct NAPIKeyTextFieldWrapper<PresentingView: View>: View {
    
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    let content: () -> NAPIKeyPromptView
    
    var body: some View {
        ZStack {
            if (isPresented) { content().dismissable($isPresented) }
            presentingView
        }
    }
}

extension View {
    func keyTextFieldAlert(isPresented: Binding<Bool>,
                           content: @escaping () -> NAPIKeyPromptView) -> some View {
        NAPIKeyTextFieldWrapper(isPresented: isPresented,
                                presentingView: self,
                                content: content)
    }
}
