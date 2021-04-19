//
//  SafariViewController.swift
//  NewTerm (iOS)
//
//  Created by Adam Demasi on 6/4/21.
//

import SwiftUI
import SafariServices

class SafariContainerViewController: UIViewController {

	var url: URL! {
		didSet { update() }
	}
	private var viewController: SFSafariViewController?

	override func viewDidLoad() {
		super.viewDidLoad()
		update()
	}

	private func update() {
		if let oldViewController = viewController {
			oldViewController.view.removeFromSuperview()
			oldViewController.removeFromParent()
		}

		guard let url = url else {
			return
		}

		#if targetEnvironment(macCatalyst)
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
		navigationController?.popViewController(animated: true)
		#else
		viewController = SFSafariViewController(url: url)
		addChild(viewController!)
		viewController!.view.frame = view.bounds
		viewController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(viewController!.view)
		#endif
	}

}

struct SafariViewControllerRepresentable: UIViewControllerRepresentable {

	typealias UIViewControllerType = SafariContainerViewController

	var url: URL?

	@Environment(\.presentationMode)
	var presentationMode

	func makeUIViewController(context: Context) -> SafariContainerViewController {
		return SafariContainerViewController()
	}

	func updateUIViewController(_ viewController: SafariContainerViewController, context: Context) {
		// Sigh. The things you take for granted in a mature UI framework.
		viewController.url = url

		#if targetEnvironment(macCatalyst)
		UIView.performWithoutAnimation {
			presentationMode.wrappedValue.dismiss()
		}
		#endif
	}

}

struct SafariViewControllerRepresentable_Previews: PreviewProvider {
	static var previews: some View {
		SafariViewControllerRepresentable(url: URL(string: "https://apple.com/")!)
	}
}
