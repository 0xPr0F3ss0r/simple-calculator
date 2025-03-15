// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Calculator extends StatelessWidget {
  // Define our variables
  List<String> operations = ["X", "+", "-", "÷"];
  String firstNumber = "";
  String secondNumber = "";
  String operation = '';
  String result = "";
  var showText = "0".obs;
  RxString history = "".obs;
  void OnbtnClick(String text) {
    if (text == "=") {
      // Check if there is a first number, second number, and operation do login operation
      if (firstNumber.isNotEmpty &&
          secondNumber.isNotEmpty &&
          operation.isNotEmpty) {
        try {
          double firstNum = double.parse(firstNumber);
          double secondNum = double.parse(secondNumber);
          switch (operation) {
            case "+":
              result = (firstNum + secondNum).toString();
              break;
            case "-":
              result = (firstNum - secondNum).toString();
              break;
            case "X":
              result = (firstNum * secondNum).toString();
              break;
            case "÷":
              if (secondNum == 0) {
                result = "Error: Division by zero";
              } else {
                try {
                  result = (firstNum / secondNum).toString();
                } catch (e) {
                  result = "error $e";
                }
              }
              break;
          }
          history.value = "$firstNumber $operation $secondNumber";
          showText.value = result;
        } catch (e) {
          showText.value = "Error: Invalid input";
        }
      }
    } else if (text == "C") {
      // Reset all variables
      showText.value = '0';
      firstNumber = '';
      secondNumber = "";
      result = "";
      operation = "";
      history.value = "";
      //if button clicked in % divide first number or second number from 100
    } else if (text == "%" && firstNumber.isNotEmpty) {
      //if there is just first number
      if (firstNumber.isNotEmpty && secondNumber.isEmpty) {
        double firstNum = double.parse(firstNumber);
        firstNumber = (firstNum / 100).toString();
        showText.value = firstNumber;
        //if there is second number
      } else if (firstNumber.isNotEmpty && secondNumber.isNotEmpty) {
        double secondNum = double.parse(secondNumber);
        secondNumber = (secondNum / 100).toString();
        showText.value = "$firstNumber $operation $secondNumber";
        //if we have operation don't do any thing
      } else {
        return;
      }
    } else if (text == "<") {
      // Remove the last character
      if (showText.value.length == 1) {
        showText.value = "0";
      } else {
        //remove last character from first number
        if (firstNumber.isNotEmpty && operation.isEmpty) {
          firstNumber = firstNumber.substring(0, firstNumber.length - 1);
          showText.value = firstNumber;
          // remove operation
        } else if (firstNumber.isNotEmpty &&
            operation.isNotEmpty &&
            secondNumber.isEmpty) {
          operation = "";
          showText.value = "$firstNumber $operation";
          //remove last character from second number
        } else {
          secondNumber = secondNumber.substring(0, secondNumber.length - 1);
          showText.value = "$firstNumber $operation $secondNumber";
        }
      }
    } else if (operations.contains(text)) {
      // If an operation is pressed
      //if there is just first number
      if (firstNumber.isNotEmpty && secondNumber.isEmpty) {
        operation = text;
        showText.value = "$firstNumber $operation";
        //if there is first number and second number d operation
      } else {
        //if there is first number and second number do logic operation
        double firstNum = double.parse(firstNumber);
        double secondNum = double.parse(secondNumber);
        switch (operation) {
          case "+":
            result = (firstNum + secondNum).toString();
            history.value = "$firstNum + $secondNum";
            break;
          case "-":
            result = (firstNum - secondNum).toString();
            history.value = "$firstNum - $secondNum";
            break;
          case "X":
            result = (firstNum * secondNum).toString();
            history.value = "$firstNum * $secondNum";
            break;
          case "÷":
            if (secondNum == 0) {
              result = "Error: Division by zero";
            } else {
              try {
                result = (firstNum / secondNum).toString();
              } catch (e) {
                result = "error $e";
              }
            }
            history.value = "$firstNum / $secondNum";
            break;
        }
        operation = text;
        showText.value = "$result $text";
      }
    } else {
      // If a number or dot is pressed
      if (text.isNumericOnly || text == ".") {
        //if operation is empty assign value to it
        if (operation.isEmpty) {
          firstNumber += text;
          showText.value = firstNumber;
          //if there is result and operation assign result value to first number and text input to second number
        } else if (result.isNotEmpty && operation.isNotEmpty) {
          firstNumber = result;
          secondNumber = text;
          showText.value = '$firstNumber $operation $secondNumber';
          //if there is second number
        } else {
          secondNumber += text;
          showText.value = secondNumber;
        }
      }
    }
  }

  Widget bntText(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      height: text == "=" ? 140 : 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: text != '='
              ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))
              : null,
          backgroundColor: operations.contains(text) ||
                  text == "=" ||
                  text == "<" ||
                  text == "C"
              ? Colors.blue
              : Colors.white,
          foregroundColor: Colors.black,
        ),
        onPressed: () {
          OnbtnClick(text);
        },
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 30)),
        ),
      ),
    );
  }

  Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Calculator",
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Obx(
                          () => Text(
                            history.value,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(
                                fontSize: 70, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 20),
                        child: Obx(
                          () => Text(
                            showText.value,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(
                                fontSize: 70, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 420,
            width: 500,
            decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: Colors.black12)),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          bntText("C"),
                          const SizedBox(width: 25),
                          bntText("<"),
                          const SizedBox(width: 25),
                          bntText("÷"),
                          const SizedBox(width: 25),
                          bntText("X"),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          bntText("7"),
                          const SizedBox(width: 25),
                          bntText("8"),
                          const SizedBox(width: 25),
                          bntText("9"),
                          const SizedBox(width: 25),
                          bntText("-"),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          bntText("4"),
                          const SizedBox(width: 25),
                          bntText("5"),
                          const SizedBox(width: 25),
                          bntText("6"),
                          const SizedBox(width: 25),
                          bntText("+"),
                        ]),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          bntText("1"),
                          const SizedBox(height: 10),
                          bntText("%"),
                        ],
                      ),
                      const SizedBox(width: 25),
                      Column(
                        children: [
                          bntText("2"),
                          const SizedBox(height: 10),
                          bntText("0"),
                        ],
                      ),
                      const SizedBox(width: 25),
                      Column(
                        children: [
                          bntText("3"),
                          const SizedBox(height: 10),
                          bntText("."),
                        ],
                      ),
                      const SizedBox(width: 25),
                      Column(
                        children: [
                          bntText("="),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
