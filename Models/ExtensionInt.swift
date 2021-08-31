//
//  ExtensionInt.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/31.
//

import Foundation

extension Int {
    var numCoverter: String {
        if self > 1000000{
            let millionNumber = self / 1000000

            let thousandNumber = String(format:"%03d",(self % 1000000) / 1000)

            let lessThanThousnadNumber = String(format:"%03d",self % 1000)
            
            return "\(millionNumber),\(thousandNumber),\(lessThanThousnadNumber)"

        }else if self > 1000{
            let thousandNumber = self / 1000
            
            let lessThanThousnadNumber = String(format:"%03d",self % 1000)
            
            return "\(thousandNumber),\(lessThanThousnadNumber)"
     
        }else{
        return String(self)
        }
    }

}
