//
//  ViewController.swift
//  TestIOSSecuritySuite
//
//  Created by 박준하 on 2023/06/02.
//

import UIKit
import SnapKit
import Then
import IOSSecuritySuite

class ViewController: UIViewController {
    
    var IOSSecuritySuiteButton = UIButton().then {
        $0.setTitle("IOSSecuritySuite", for: .normal)
        $0.setTitleColor(UIColor(ciColor: .white), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        $0.backgroundColor = .blue
        $0.addTarget(self, action: #selector(IOSSecuritySuiteButtonDidTap(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        view.addSubview(IOSSecuritySuiteButton)
        
        IOSSecuritySuiteButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func IOSSecuritySuiteButtonDidTap(_ sender: Any) {
        let jailbreakStatus = IOSSecuritySuite.amIJailbrokenWithFailMessage()
        if jailbreakStatus.jailbroken {
            print("디바이스가 탈옥되어있습니다.")
            
            let alert = UIAlertController(title: "탈옥", message: "이 기기는 탈옥되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .default) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    exit(0)
                }
            })
            
            //탈옥 장치 판별
            let jailbreakStatus = IOSSecuritySuite.amIJailbrokenWithFailedChecks()
            if jailbreakStatus.jailbroken {
                if (jailbreakStatus.failedChecks.contains { $0.check ==
                    .existenceOfSuspiciousFiles }) && (jailbreakStatus.failedChecks.contains
                                                       { $0.check == .suspiciousFilesCanBeOpened }) {
                    print("이것은 실제 탈옥 장치입니다")
                }
            }
            
            self.present(alert, animated: true, completion: nil)
            print("사유: \(jailbreakStatus.failedChecks)")
        } else if IOSSecuritySuite.amIRunInEmulator() {
            let alert = UIAlertController(title: "시뮬레이터", message: "이 기기는 시뮬레이터입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .default) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    exit(0)
                }
            })
            self.present(alert, animated: true, completion: nil)
            print("시뮬레이터 입니다.")
        } else {
            
            let alert = UIAlertController(title: "안전", message: "이 기기는 안전합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .default) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    exit(0)
                }
            })
            self.present(alert, animated: true, completion: nil)
            print("이 디바이스는 안전합니다.")
        }
        
    }
}

