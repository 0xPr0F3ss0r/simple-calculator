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
      // Check if there is a first number, second number, and operation
      if (firstNumber.isNotEmpty &&
          secondNumber.isNotEmpty &&
          operation.isNotEmpty) {
        try {
          num firstNum = int.tryParse(firstNumber) ?? double.parse(firstNumber);
          num secondNum =
              int.tryParse(secondNumber) ?? double.parse(secondNumber);
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
                result = (firstNum / secondNum).toString();
              }
              break;
          }

          // Remove ".0" from the result if it exists
          List<String> parts = result.split('.');
          if (parts.length == 2 && parts[1] == "0") {
            result = parts[0];
          }
          showText.value = result;
          history.value = "$firstNumber $operation $secondNumber";
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
    } else if (text == "%" && firstNumber.isNotEmpty) {
      // Handle percentage logic
      if (firstNumber.isNotEmpty && secondNumber.isEmpty) {
        double firstNum = double.parse(firstNumber);
        firstNumber = (firstNum / 100).toString();
        showText.value = firstNumber;
      } else if (firstNumber.isNotEmpty && secondNumber.isNotEmpty) {
        double secondNum = double.parse(secondNumber);
        secondNumber = (secondNum / 100).toString();
        showText.value = "$firstNumber $operation $secondNumber";
      }
    } else if (text == "<") {
      // Remove the last character
      if (showText.value.length == 1) {
        showText.value = "0";
      } else {
        if (operation.isEmpty) {
          firstNumber = firstNumber.substring(0, firstNumber.length - 1);
          showText.value = firstNumber;
        } else if (secondNumber.isEmpty) {
          operation = "";
          showText.value = "$firstNumber $operation";
        } else {
          secondNumber = secondNumber.substring(0, secondNumber.length - 1);
          showText.value = "$firstNumber $operation $secondNumber";
        }
      }
    } else if (operations.contains(text)) {
      // If an operation is pressed
      if (firstNumber.isNotEmpty && secondNumber.isEmpty) {
        operation = text;
        showText.value = "$firstNumber $operation";
      } else if (firstNumber.isNotEmpty && secondNumber.isNotEmpty) {
        // Perform the previous operation and update the first number
        num firstNum = int.tryParse(firstNumber) ?? double.parse(firstNumber);
        num secondNum =
            int.tryParse(secondNumber) ?? double.parse(secondNumber);
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
              result = (firstNum / secondNum).toString();
            }
            break;
        }

        // Remove ".0" from the result if it exists
        List<String> parts = result.split('.');
        if (parts.length == 2 && parts[1] == "0") {
          result = parts[0];
        }
        history.value = "$firstNumber $operation $secondNumber";
        firstNumber = result;
        secondNumber = "";
        operation = text;
        showText.value = "$firstNumber $operation";
        
      }
    } else {
      // If a number or decimal is pressed
      if (text.isNumericOnly || text == ".") {
        if (operation.isEmpty) {
          firstNumber += text;
          showText.value = firstNumber;
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
                border: const Border(top: BorderSide(color: Colors.black12))),
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
