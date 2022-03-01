//
//  main.swift
//  hw1
//
//  Created by Mike I on 24.02.2022.
//

import Foundation


func squareFunc(a:Float,b:Float,c:Float)->[Float]{// функция, возвращающая корни квадратного уравнения
    let d = pow(b, 2) - 4 * a * c
    if(d < 0){
        return []
    }
    else{
        if(d == 0){
            return [(0 - b) / (2 * a)]
        }
        else{
            return[(-b - sqrt(d)) / (2 * a),(-b + sqrt(d))/(2 * a)]
        }
    }
}



func cubicFunc(a: Float, b: Float, c: Float, d: Float) -> [Float] {// функция, решающая уравнение 3 степени
    if (a == 0 && b == 0){
        return [(-d * 1.0) / c]
    }
    else{
        if (a == 0){
            return squareFunc(a: b, b: c, c: d)
        }
        else{
            let f = ((3.0 * c / a) - ((pow(b,2)) / (pow(a,2)))) / 3.0
            let g = (((2.0 * (pow(b,3))) / (pow(a,3))) - ((9.0 * b * c) / (pow(a,2))) + (27.0 * d / a)) / 27.0
            let h = ((pow(g,2)) / 4.0 + (pow(f,3)) / 27.0)
            if (f == 0 && g == 0 && h == 0){
                if (d / a) >= 0{
                           return [pow((d / (1.0 * a)) , (1 / 3.0)) * -1]
                }
                else{
                           return [pow((-d / (1.0 * a)), (1 / 3.0))]
                }
            }
            else{
                if h<=0{
                    let i = sqrt((pow(g,2)/4.0) - h)
                    let j = pow(i,(1 / 3.0))
                    let k = acos(-(g / (2 * i)))
                    let l = j * -1
                    let m = cos(k / 3.0)
                    let n = sqrt(3) * sin( k / 3.0)
                    let p = (b / (3.0 * a)) * -1
                    return [2 * j * cos(k / 3.0) - (b / (3.0 * a)),
                    l * (m + n) + p,
                    l * (m - n) + p
                    ]
                }
                else{
                    let R = -(g / 2.0) + sqrt(h)
                    var S:Float = 0
                    var U:Float = 0
                    if R >= 0{
                        S = pow(R, (1 / 3.0))
                    }
                    else{
                        S = pow((-R),(1 / 3.0)) * -1
                    }
                     let T = -(g / 2.0) - sqrt(h)
                    if T >= 0{
                         U = (pow(T,(1 / 3.0)))
                    }
                    else{
                         U = pow((-T),(1 / 3.0)) * -1
                    }
                    return [(S + U) - (b / (3.0 * a))]
                }
            }
        }
    }
}

func findFibonacci(index:Int) -> Int{// функция поиска числа Фибоначчи по порядковому номеру
    if (index == 1 || index == 2) {
            return 1
        }
    else {
         return findFibonacci(index: index - 1) + findFibonacci(index: index - 2)
    }
}


func fillFibonacciArray(_ array: inout [Int], length n:Int){// функция добавления в массив чисел Фибоначчи
    for _ in 0 ..< n {
        fibonacciArray.append(findFibonacci(index: fibonacciArray.count+1))
    }
}


func sieveOfEratosthenes(array: inout [Int], p:Int, firstIndex:Int) -> Int{// функция, реализующая шаг просеивания в методе Эратосфена
   var i:Int = firstIndex
   array.removeAll(where: (Int) throws -> Bool)
       if (array[i] % p == 0)
       {
           array.remove(at: i)
           
       }
       else{
           i += 1
       }
   }
    array.forEach()
       if(array[i] > p){
           return array[i]
       }
   }
   return array.first!
}



func primeArray(n: Int) -> [Int] {// функция, возвращающая массив простыми чисел
    let spisok = [Int](2...n)
    var i = 2
     while (i < array.count){
         i = sieveOfEratosthenes(array: &array, p: i, firstIndex: i)
     }
    return spisok
}


print("Корни квадратного уравнения: ", squareFunc(a: 1, b: 4, c: 1))
print("Корни уравнения 3 степени: ", cubicFunc(a: 1, b: -3, c: -13, d: 15))

var array = [Int]()
fibonacciArray(fibonacciArray: &array,n: 10)
print("Массив чисел Фибоначчи: ", array)

print("Массив простых чисел: ", primeArray(n: 50))


