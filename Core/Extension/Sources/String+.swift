//
//  String+.swift
//  CoreLayer
//
//  Created by 최재혁 on 8/14/25.
//

extension String {
  public func insertLineBreaks(every n: Int) -> String {
    var result = ""
    for (index, character) in self.enumerated() {
      result.append(character)
      if (index + 1) % n == 0 && index != self.count - 1 {
        result.append("\n")
      }
    }
    return result
  }
}
