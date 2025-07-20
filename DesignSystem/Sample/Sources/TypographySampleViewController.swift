import UIKit
import DesignSystem
import SwiftRichString

final class TypographySampleViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        populateTypographySamples()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    private func populateTypographySamples() {
        let allSamples: [(String, Style)] = [
            ("Display_28_B", Typography.Display_28_B),
            ("Display_26_B", Typography.Display_26_B),

            ("Heading_24_B", Typography.Heading_24_B),
            ("Heading_24_SB", Typography.Heading_24_SB),
            ("Heading_22_B", Typography.Heading_22_B),
            ("Heading_22_SB", Typography.Heading_22_SB),
            ("Heading_20_B", Typography.Heading_20_B),
            ("Heading_20_SB", Typography.Heading_20_SB),
            ("Heading_20_M", Typography.Heading_20_M),
            ("Heading_20_R", Typography.Heading_20_R),

            ("Body_18_B", Typography.Body_18_B),
            ("Body_18_SB", Typography.Body_18_SB),
            ("Body_18_M", Typography.Body_18_M),
            ("Body_18_R", Typography.Body_18_R),
            ("Body_16_B", Typography.Body_16_B),
            ("Body_16_SB", Typography.Body_16_SB),
            ("Body_16_M", Typography.Body_16_M),
            ("Body_16_R", Typography.Body_16_R),
            ("Body_14_B", Typography.Body_14_B),
            ("Body_14_SB", Typography.Body_14_SB),
            ("Body_14_M", Typography.Body_14_M),
            ("Body_14_R", Typography.Body_14_R),

            ("Caption_12_B", Typography.Caption_12_B),
            ("Caption_12_SB", Typography.Caption_12_SB),
            ("Caption_12_M", Typography.Caption_12_M),
            ("Caption_12_R", Typography.Caption_12_R),
        ]

        for (name, style) in allSamples {
            let label = UILabel()
            label.numberOfLines = 0
            label.attributedText = "(\(name))\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n".set(style: style)
            contentStack.addArrangedSubview(label)
        }
    }
}
