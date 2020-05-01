//
//  TextScroll.swift
//  Dzikra WatchKit Extension
//
//  Created by Fitsyu  on 01/05/20.
//  Copyright © 2020 Fitsyu . All rights reserved.
//

import WatchKit

private var ScrolledTextKey: UInt8 = 0
private var OriginTextKey: UInt8 = 0
private var TimerKey: UInt8 = 0
private var EndlessKey: UInt8 = 0
private var TimerStartedKey: UInt8 = 0
private var OnceKey: UInt8 = 0

extension WKInterfaceLabel {

    // MARK: - Public method
    
    /// テキストを横方向に自動でスクロールする
    ///
    /// - Parameter text: text
    func setAutoHorizontalScrollText(_ text: String?, isEndless endless: Bool = false, isOnce once: Bool = true) {
        guard let text = text else {
            return
        }
        setEndless(endless)
        setOnce(once)
        setOriginText(NSAttributedString(string: text + "　　　　　　　　　　"))
        initializeText()
    }
    
    /// 自動スクロール開始
    @objc func startTimer() {
        // タイマーの多重起動を防ぐため、スクロール開始済の場合はreturn
        if getTimerStarted() {
            return
        }
        setTimerStarted(true)
        DispatchQueue.main.async {
            let timer = Timer.scheduledTimer(timeInterval: 0.10, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
            self.setTimer(timer)
        }
    }
    
    /// 自動スクロール停止
    func stopTimer() {
        getTimer().invalidate()
        setTimerStarted(false)
        // テキストを初期化
        initializeText()
    }
   
    // MARK: - Private method
    /// ラベルのテキストを更新
    @objc private func timerUpdate() {
        if getScrolledText().length > 1 {
            let scrolledText = NSMutableAttributedString(attributedString: getScrolledText())
            guard let firstCharacter = scrolledText.string.first else {
                return
            }
            // テキストの先頭の文字を削除
            scrolledText.deleteCharacters(in: NSRange(location: 0, length: 1))
            // エンドレスの場合はテキストの末尾に削除した文字を追加する
            if getEndless() {
                scrolledText.append(addAttribute(String(firstCharacter)))
            }
            setScrolledText(scrolledText)
            setAttributedText(getScrolledText())
        } else {
            // タイマーを停止
            stopTimer()
            
            if getOnce() {
                return
            }
            
            if !getEndless() {
                // 少し間をおき、スクロール開始
                let timer = Timer(timeInterval: 2, target: self, selector: #selector(startTimer), userInfo: nil, repeats: false)
                RunLoop.main.add(timer, forMode: .common)
            }
        }
    }
    
    /// ラベルのテキストを初期化
    private func initializeText() {
        let attributeText = addAttribute(getOriginText().string)
        setOriginText(attributeText)
        setScrolledText(getOriginText())
        setAttributedText(getScrolledText())
    }
    
    private func addAttribute(_ text: String) -> NSAttributedString {
        // ラベルにLineBreakModeのプロパティが存在しないので、NSAttributedStringで設定する
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byClipping
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    // MARK: - getter/setter
    
    private func setScrolledText(_ text: NSAttributedString) {
        objc_setAssociatedObject(self, &ScrolledTextKey, text, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func getScrolledText() -> NSAttributedString {
        guard let object = objc_getAssociatedObject(self, &ScrolledTextKey) as? NSAttributedString else {
            return NSAttributedString(string: "")
        }
        return object
    }
    
    private func setOriginText(_ text: NSAttributedString) {
        objc_setAssociatedObject(self, &OriginTextKey, text, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func getOriginText() -> NSAttributedString {
        guard let object = objc_getAssociatedObject(self, &OriginTextKey) as? NSAttributedString else {
            return NSAttributedString(string: "")
        }
        return object
    }
    
    private func setTimer(_ timer: Timer) {
        objc_setAssociatedObject(self, &TimerKey, timer, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func getTimer() -> Timer {
        guard let object = objc_getAssociatedObject(self, &TimerKey) as? Timer else {
            return Timer()
        }
        return object
    }

    private func setEndless(_ endless: Bool) {
        objc_setAssociatedObject(self, &EndlessKey, endless, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func getEndless() -> Bool {
        guard let object = objc_getAssociatedObject(self, &EndlessKey) as? Bool else {
            return false
        }
        return object
    }

    private func setTimerStarted(_ timerStarted: Bool) {
        objc_setAssociatedObject(self, &TimerStartedKey, timerStarted, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func getTimerStarted() -> Bool {
        guard let object = objc_getAssociatedObject(self, &TimerStartedKey) as? Bool else {
            return false
        }
        return object
    }
    
    private func setOnce(_ once: Bool) {
        objc_setAssociatedObject(self, &OnceKey, once, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func getOnce() -> Bool {
        guard let once = objc_getAssociatedObject(self, &OnceKey) as? Bool else {
            return false
        }
        return once
    }
}
