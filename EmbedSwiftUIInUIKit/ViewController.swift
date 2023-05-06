//
//  ViewController.swift
//  EmbedSwiftUIInUIKit
//
//  Created by Upkesh Thakur on 06/05/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    private var customSwitch = UISwitch()
    private var customSwitchHostingController: UIHostingController<CustomSwitch>?
    var model: ViewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customSwitch)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: customSwitch.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: customSwitch.centerYAnchor)
        ])
        // Configure the UIKit component
        customSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

        // Create a SwiftUI view hosting the micro SwiftUI component
        let customSwitchView = CustomSwitch(model: model)
        customSwitchHostingController = UIHostingController(rootView: customSwitchView)
        customSwitchHostingController?.view.translatesAutoresizingMaskIntoConstraints = false

        // Add the SwiftUI view to the UIKit view hierarchy
        if let customSwitchHostingView = customSwitchHostingController?.view {
            addChild(customSwitchHostingController!)
            view.addSubview(customSwitchHostingView)
            customSwitchHostingController?.didMove(toParent: self)
        }
    }

    @objc func switchValueChanged(_ sender: UISwitch) {
        // Handle the value change event
        model.setToggle(value: sender.isOn)
    }
}

final class ViewModel: ObservableObject {
    @Published var isOn: Bool = false

    func setToggle(value: Bool) {
        self.isOn = value
    }
}

struct CustomSwitch: View {
    @ObservedObject
    var model: ViewModel

    var body: some View {
        let isOn = $model.isOn
        Toggle(isOn: isOn) {
            Text("Custom Switch")
                .foregroundColor(isOn.wrappedValue ? .red : .green)
        }
        .padding()
        .toggleStyle(SwitchToggleStyle(tint: .blue))
    }
}
