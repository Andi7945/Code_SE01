import 'dart:math';

import 'package:flutter/material.dart';


class LightsOut extends StatefulWidget {
  const LightsOut({Key? key}) : super(key: key);

  @override
  _LightsOutState createState() => _LightsOutState();
}

class _LightsOutState extends State<LightsOut> {


  List<List<bool>> lights = [];
  String msg = "";

  @override
  Widget build(BuildContext context) {

    //Will only normaly only executed in the beginning
    if(lights.isEmpty){
      resetLights();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Lights Out"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Column(
                children: List<int>.generate(lights.length, (i) => i).map((firstDigit) =>
                    Row(
                      children: List<int>.generate(lights[firstDigit].length, (i) => i).map((secondDigit) =>
                          GestureDetector(
                            onTap: (){
                              lights[firstDigit][secondDigit] = !lights[firstDigit][secondDigit];

                              if(firstDigit != 0){
                                lights[firstDigit-1][secondDigit] = !lights[firstDigit-1][secondDigit];
                              }
                              if(secondDigit != 0){
                                lights[firstDigit][secondDigit-1] = !lights[firstDigit][secondDigit-1];
                              }

                              if(firstDigit != lights.length-1){
                                lights[firstDigit+1][secondDigit] = !lights[firstDigit+1][secondDigit];
                              }
                              if(secondDigit != lights.first.length-1){
                                lights[firstDigit][secondDigit+1] = !lights[firstDigit][secondDigit+1];
                              }

                              checkIfUserWonTheGame();
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: lights[firstDigit][secondDigit] ? const Color(0xFFD3E03A) : const Color(0x22D3E03A),
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 1),
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(
                                          30.0) //
                                  ),),
                              ),
                            ),
                          )
                      ).toList(),
                    )
                ).toList(),
              ),
              const SizedBox(height: 20,),
              Text(msg, style: const TextStyle(color: Colors.green),),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                setState(() {
                  resetLights();
                  msg = "";
                });

              }, child: const Text("Reset Game"))
            ],
          ),
        )
    );
  }



  void resetLights(){
    Random r = Random();
    lights = List.generate(3, (index) => List.generate(3, (index) => r.nextBool()));
  }

  void checkIfUserWonTheGame({required }){
    bool allLightsOff = true;
    for(int x = 0; x < lights.length; x++){
      for(int y = 0; y < lights[x].length; y++){
        if(lights[x][y]) {
          allLightsOff = false;
        break;
        }
      }
      if(!allLightsOff) break;
    }
    if(allLightsOff){
      msg = "You have won :)";
    }
  }

}
