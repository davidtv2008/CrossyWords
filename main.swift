#!/usr/bin/swift


//David Toledo, CWID: 889573168



import Foundation

func print_nth_char(forString: String,index: Int){
    print("fuction called to print out nth character")
    print(forString[forString.index(forString.startIndex, offsetBy: index + 1)], "\n\n")
    
}

func strlen(forString: String){
    print("length of string is: \(forString.count)")
}


func f2c_temp_table(start: Double, stop: Double, step: Double) {
    for temp in stride(from: start, to: stop, by: step) {
        print("\(String(format: "%6.2f", temp)) F  is  \(String(format: "%6.2f", round(5.0/9 * (temp - 32.0)))) C")
    }
    print("\n")
}

func multiple(ints: [Int])->[Int]{
    
    
    return ints
    
}



//1
let immutable: String = "cannot change me"
var mutable: String = "can change me"

print(immutable)
print(mutable)

//change the mutable to somehting else
mutable = "i am mutable and changed"
print(mutable)


//2
let message: String = "you get out of life what you put into it"
print(message)

//print 1 character at a time
for x in message{
    print(x)
}


//3
let message2: String = "abcdefghijklmnopqrstuvwxyz"

print_nth_char(forString: message2,index: 4)



//4
let message3: String = "The Good, the Bad, and the Ugly."

strlen(forString: message3)


//5
let message4: String = "This above all: to thine own self be true."

for index in message4.indices {
    print(String(format:"%02d", message4[index].unicodeScalars.first!.value), terminator: " ")
}


print("\n")
//6
for index in message4.indices {
    print(String(format:"\0x%02x", message4[index].unicodeScalars.first!.value), terminator: " ")
}


//7
let reverseIt: String = "Give thy thoughts no tongue."
print(String(reverseIt.reversed()) + "\n\n")

//8
print("\u{4e2d}\u{570d}" + "\n\n")


//9
let toLower: String = "Some are born great, Some achieve greatness, and Some have greatness thrust upon them"

print(toLower.lowercased() + "\n\n")

//10
let consonants: String = "neither a borrow nor a lender"
let formedWord  = consonants.replacingOccurrences(of: "[aeiouy]", with: "A", options: [.regularExpression, .caseInsensitive], range: nil)
print("formed word is: \(formedWord)\n\n")

//11
var word1: String = "Mississippi"

print(word1.replacingOccurrences(of: "ss", with: "FEDEX") + "\n\n")
print(word1.replacingOccurrences(of: "pp", with: "UPS") + "\n\n")


//12 incomplete








//13
print("Squares")
for i in 1 ... 10{
    print((i * i))
}

print("cubes")
for i in 1 ... 10{
    print((i * i * i))
}


//14
var type : Int = 999
print("var type: \(type) declared its type as Int\n\n")


//15
typealias novel = (title: String, author: String, isbn: String)
var agent : novel = (title: "BOOK", author: "ME", isbn: "00000")
let agent_id = Mirror(reflecting: agent)
for val in agent_id.children { print("\(val.label!) : \(val.value)", terminator: ",") }
print("\n\n")


//16
f2c_temp_table(start: 0.0, stop: 300.0, step: 25.0)




//17
var nums: [Int] = [1,2,3,4,5]

//18, 19, 20 incomplete












