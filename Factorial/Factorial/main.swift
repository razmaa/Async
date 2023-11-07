//
//  main.swift
//  Factorial
//
//  Created by nika razmadze on 08.11.23.
//

import Foundation
import BigInt

func generateRandomNumber(min: Int, max: Int) -> Int { Int.random(in: min...max) }

func calculateFactorial(_ number: Int) -> BigInt {
    var result: BigInt = 1
    for i in 1...number {
        result *= BigInt(i)
    }
    return result
}

func asyncFactorialCalculator(number: Int, completion: @escaping (BigInt) -> Void) {
    DispatchQueue.global().async {
        let factorial = calculateFactorial(number)
        completion(factorial)
    }
}

func findWinnerThread(completion: @escaping (String) -> Void) {
    let firstNumber = generateRandomNumber(min: 20, max: 50)
    let secondNumber = generateRandomNumber(min: 20, max: 50)
    
    var winner: String?
    
    let group = DispatchGroup()
    
    group.enter()
    asyncFactorialCalculator(number: firstNumber) { result in
        if winner == nil {
            winner = "Thread 1"
        }
        group.leave()
    }
    
    group.enter()
    asyncFactorialCalculator(number: secondNumber) { result in
        if winner == nil {
            winner = "Thread 2"
        }
        group.leave()
    }
    
    group.notify(queue: .main) {
        completion(winner ?? "No winner found")
    }
}

findWinnerThread { winnerThread in
    print("The winner is: \(winnerThread)")
}

dispatchMain()
