import UIKit

class VoiceWaveView: UIView {
    
    private var bars: [UIView] = []
    private var displayLink: CADisplayLink?
    
    private let barCount = 10
    private let barWidth: CGFloat = 4
    private let barSpacing: CGFloat = 6
    private let minHeight: CGFloat = 5
    private let maxHeight: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBars()
        startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBars()
        startAnimating()
    }
    
    private func setupBars() {
        let totalWidth = CGFloat(barCount) * (barWidth + barSpacing)
        let startX = (bounds.width - totalWidth) / 2
        
        for i in 0..<barCount {
            let xPos = startX + CGFloat(i) * (barWidth + barSpacing)
            let bar = UIView(frame: CGRect(x: xPos, y: bounds.midY - minHeight / 2, width: barWidth, height: minHeight))
            bar.backgroundColor = .systemBlue
            bar.layer.cornerRadius = barWidth / 2
            addSubview(bar)
            bars.append(bar)
        }
    }
    
    func startAnimating() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stopAnimating() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateWave() {
        for bar in bars {
            let randomHeight = CGFloat.random(in: minHeight...maxHeight)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
                bar.frame.size.height = randomHeight
                bar.frame.origin.y = self.bounds.midY - randomHeight / 2
            }
        }
    }
}
