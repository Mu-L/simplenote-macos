import Appkit

class BlockingActivityIndicator: NSView {
    let activityIndicator: NSProgressIndicator

    init(indicatorFrame: NSRect) {
        self.activityIndicator = NSProgressIndicator(frame: indicatorFrame)
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.withAlphaComponent(0.3).cgColor
        translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.style = .spinning
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

    override func mouseDown(with event: NSEvent) {
        // Blocking lower views from receiving events
    }

    func startAnimation() {
        activityIndicator.startAnimation(nil)
    }

    func stopAnimation() {
        activityIndicator.stopAnimation(nil)
        removeFromSuperview()
    }

    static func showIndicator(in view: NSView, spinnerRect: NSRect = NSRect(x: 0, y: 0, width: 50, height: 50)) -> BlockingActivityIndicator {
        let indicator = BlockingActivityIndicator(indicatorFrame: spinnerRect)

        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            indicator.topAnchor.constraint(equalTo: view.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        indicator.startAnimation()

        return indicator
    }
}
