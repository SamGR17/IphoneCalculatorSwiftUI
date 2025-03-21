//
//  ContentView.swift
//  IphoneCalcSwiftUI
//
//  Created by StudentPM on 3/10/25.
//

import SwiftUI

struct ContentView: View {
    //variables to store what appears on screen, the numbers that are being calculated, and what operator you are using to calculate
    @State var calcScreenNum = "0"
    @State var num1 = ""
    @State var num2 = ""
    @State var chosenOperator = ""
    
    //2D array containing all the numbers and operations
    @State private var numsAndOperations: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        VStack{
            //This is what shows up on the screen on top
            Text("\(calcScreenNum)")
                .padding(50)
                .foregroundColor(.white)
                .frame(height: 237, alignment: .leading)
                .font(.custom(calcScreenNum, size: 55))
            
            //adds all button fully functioning and styled
            ForEach(numsAndOperations, id:\.self){ row in
                HStack{
                    ForEach(row, id:\.self){ num in
                        ButtonView(text: num, action: {calculatorButtonAction(text: num)})
                    }
                }
                
            }
        }
        //to style the background
        .padding()
        .background(Color.black)
    }
    
    //This function is meant for when you click a button to run what it is supposed to do
    func calculatorButtonAction(text: String){
        if text == "AC" || text == "C" || text == "+/-" || text == "%"{
            //If the AC button is clicked, it clears everything meaning what's on screen, the numbers being used, and the operator being used
            if text == "AC"{
                calcScreenNum = "0"
                num1 = ""
                num2 = ""
                chosenOperator = ""
            }
            //if the C button is clicked it removes the last number or character added to the screen
            else if text == "C"{
                calcScreenNum.removeLast()
                
                // To prevent error when deleting, if the screen is completely empty, it automatically adds a zero to the screen
                if calcScreenNum == ""{
                    calcScreenNum = "0"
                }
            }
            //when the +/- is clicked, it makes a number negative and positive when clicked again, this can be done repeatedly
            else if text == "+/-"{
                if let number = Double(calcScreenNum){
                    calcScreenNum = String(number * -1)
                    
                    //To avoid making negative zero, if the number is zero then it stays as zero
                    if number == 0{
                        calcScreenNum = "0"
                    }
                }
            }
            else{
                //when the % is clicked it runs this part of the function with gives the decimal version of the number's percentage
                if let number = Double(calcScreenNum){
                    calcScreenNum = String(number / 100)
                    //To prevent zero from becoming 0.0 to avoid errors, if the % button is clicked and the number is zero, it automatically makes it just zero again
                    if number == 0{
                        calcScreenNum = "0"
                    }
                }
            }
        }
        //if any operator button is clicked, it will run this part
        else if text == "÷" || text == "x" || text == "-" || text == "+" || text == "=" {
            //when any operator is clicked, it will add the operator to the variable and whatever is on screen is the value for num1, and it will also display zero on the screen again
            if text == "÷"{
                chosenOperator = "÷"
                num1 = calcScreenNum
                calcScreenNum = "0"
            }
            if text == "x"{
                chosenOperator = "x"
                num1 = calcScreenNum
                calcScreenNum = "0"
            }
            if text == "-"{
                chosenOperator = "-"
                num1 = calcScreenNum
                calcScreenNum = "0"
            }
            if text == "+"{
                chosenOperator = "+"
                num1 = calcScreenNum
                calcScreenNum = "0"
            }
            //when the = button is clicked it will run this part in order to run the calculate function
            if text == "="{
                //if the chosenOperator variable is empty, it will add whatever is on screen to num1 and run calculate()
                if chosenOperator == ""{
                    num1 = calcScreenNum
                    calculate()
                }
                // if the chosenOperator is not empty, assuming you clicked an operator button, it will add whatever is on screen to num2 and run calculate()
                if chosenOperator != ""{
                    num2 = calcScreenNum
                    calculate()
                }
            }
        }
        //when a number button is clicked it will run this part
        else{
            //when a number button is clicked and the screen is 0, it will display the number you clicked, and it also turns the AC button to the C button, meant for deleting the last number or character added
            if calcScreenNum == "0"{
                calcScreenNum = text
                numsAndOperations[0][0] = "C"
            } else{ //after a different number is added on screen, you can continue to add more numbers to the screen, and also for safety the AC button becomes the C button
                calcScreenNum += text
                numsAndOperations[0][0] = "C"
            }
        }
        //if the screen displays 0 then the AC button will stay the same or the C button becomes the AC button
        if calcScreenNum == "0"{
            numsAndOperations[0][0] = "AC"
        }
    }
    
    //this function is meant to calculate any equation after clicking the = button
    func calculate(){
        //these two variables convert num1 and num2 to doubles to allow them to be used as numbers for calculating
        if let left = Double(num1), let right = Double(num2){
            //depending on the chosen operator, it will run the part using the same operator for calculating the equation and make the C button the AC button again and clear all the variables
            if chosenOperator == "÷"{
                calcScreenNum = String(left / right)
                
                //if the answer is inf or -inf, it will instead display ERROR to the screen and turn the C button into the AC button
                if calcScreenNum == "inf"{
                    calcScreenNum = "ERROR"
                    numsAndOperations[0][0] = "AC"
                }
                if calcScreenNum == "-inf"{
                    calcScreenNum = "ERROR"
                    numsAndOperations[0][0] = "AC"
                }
                
                num1 = calcScreenNum
                num2 = ""
                chosenOperator = ""
                numsAndOperations[0][0] = "AC"
            }
            if chosenOperator == "x"{
                calcScreenNum = String(left * right)
                num1 = calcScreenNum
                num2 = ""
                chosenOperator = ""
                numsAndOperations[0][0] = "AC"
            }
            if chosenOperator == "-"{
                calcScreenNum = String(left - right)
                num1 = calcScreenNum
                num2 = ""
                chosenOperator = ""
                numsAndOperations[0][0] = "AC"
            }
            if chosenOperator == "+"{
                calcScreenNum = String(left + right)
                num1 = calcScreenNum
                num2 = ""
                chosenOperator = ""
                numsAndOperations[0][0] = "AC"
            }
        }
    }
}

struct ButtonView: View{
    var text: String = ""
    var action: () -> Void
    //this part is to create the appearance of the buttons
    var body: some View{
        Button(action: action,
            label: {
            Text("\(text)")
                .padding()
                .frame(width: text == "0" ? 180 : 90, height: 90) //if text inside the button is "0", then it changes the width of the button to make it longer than the other buttons
                .background(decideBackgroundColor(buttonText: text))
                .foregroundColor(text == "AC" || text == "C" || text == "+/-" || text == "%" ? .black : .white) //if the text inside the button is equal to any of these symbols then the text color for those buttons are black, if not then the text color turns white
                .cornerRadius(50.0)
                .font(.system(size: 30))
                .fontWeight(.bold)
        })
    }
    //this part is meant to color each button depending on their symbol
    func decideBackgroundColor(buttonText: String) -> Color{
        //if the text inside the button is an operator then the background color of the button turns orange
        if buttonText == "=" || buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "÷"{
            return .orange
        }
        //if the text inside the button is any of these symbols, then the background color of the button turns into the custom color
        if buttonText == "AC" || buttonText == "C" || buttonText == "+/-" || buttonText == "%"{
            return .white.opacity(0.8)
        }
        //if the text inside the button is anything else, then the background color of the button turns gray
        else{
            return .gray
        }
    }
    
}

#Preview {
    ContentView()
}
          
