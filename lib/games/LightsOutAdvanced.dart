import 'dart:math';

import 'package:flutter/material.dart';


class LightsOutAdvanced extends StatefulWidget {
  const LightsOutAdvanced({Key? key}) : super(key: key);

  @override
  _LightsOutAdvancedState createState() => _LightsOutAdvancedState();
}

class _LightsOutAdvancedState extends State<LightsOutAdvanced> {

  final Map<int, Color> colorMap = {
    0 : Colors.red,
    1 : Colors.green,
    2 : Colors.blue,
  };

  int grit_x = 3;
  int grid_Y = 3;

  List<List<int>> lights = [];
  String msg = "";
  int counter = 0;

  //first: interation //second: x && y
  List<List<int>> winnerPath = [];


  bool exitCalculation = false;

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
                              counter++;
                              lights = tabOnOneLight(lights: lights, firstDigit: firstDigit, secondDigit: secondDigit);

                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: colorMap[lights[firstDigit][secondDigit]],
                                  border: Border.all(
                                      color: isWinnterPath(count: counter, x: firstDigit, y: secondDigit) ? Colors.orange : Colors.black ,
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

              }, child: const Text("Reset Game")),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                setState(() {
                  resetLightsDoable(level: 1);
                  msg = "";
                });

              }, child: const Text("Reset Game doable")),
              // const SizedBox(height: 20,),
              // ElevatedButton(onPressed: (){
              //   setState(() {
              //     counter = 0;
              //     winnerPath = testIfDoable(depth: 3);
              //     msg = "";
              //   });
              //
              // }, child: const Text("Test if game is duable")),

              const SizedBox(height: 20,),
            ],
          ),
        )
    );
  }
  bool isWinnterPath({required count, required x, required y}){
    if(winnerPath.isEmpty) return false;
    if(winnerPath[counter][1] == x && winnerPath[counter][2] == y) return true;
    return false;
  }

  // List<List<List<int>>> testIfDoable({required depth}){
  //   final List<List<int>> storeLigts = lights;
  //   List<List<List<List<int>>> lightTests = [];
  //   for(int z = 0; z < depth; z++){
  //     lightTests.add([]);
  //     for(int x = 0; x < storeLigts.length; x++) {
  //       for (int y = 0; y < storeLigts.first.length; y++) {
  //         lightTests.last(tabOnOneLight(lights: lightTests.last, firstDigit:x, secondDigit:y));
  //         if(checkIfUserWonTheGame(lights: lightTests.last)){
  //           List<List<int>> returnValue = [];
  //           for(int i = 0; i < lightTests[z].length; i++){
  //             returnValue.add(lightTests[z]);
  //           }
  //           return returnValue;
  //         }
  //       }
  //     }
  //   }
  //   return [];
  // }


  void resetLightsDoable({required level}){
    Random b = Random();
    final int c =  b.nextInt(3);
    lights = List.generate(grit_x, (index) => List.generate(grid_Y, (index) => c));
    for(int x = 0; x < level; x++){
      Random r = Random();
      lights = tabOnOneLightBackwards(lights: lights, firstDigit: r.nextInt(lights.length), secondDigit: r.nextInt(lights.first.length));
    }
  }

  void resetLights(){
    Random r = Random();
    lights = List.generate(grit_x, (index) => List.generate(grid_Y, (index) => r.nextInt(3)));
  }

  int incrementColor({required int actColor}){
    int returnValue = actColor + 1;
    if(returnValue > 2) returnValue = 0;
    return returnValue;
  }

  int decrementColor({required int actColor}){
    int returnValue = actColor - 1;
    if(returnValue < 0) returnValue = 2;
    return returnValue;
  }

  bool checkIfUserWonTheGame({required lights}){
    bool allLightsOff = true;
    int firstColor = lights.first.first;
    for(int x = 0; x < lights.length; x++){
      for(int y = 0; y < lights[x].length; y++){
        if(lights[x][y] != firstColor) {
          allLightsOff = false;
          break;
        }
      }
      if(!allLightsOff) break;
    }
    if(allLightsOff){
      msg = "You have won :)";
      return true;
    }
    return false;
  }

  List<List<int>> tabOnOneLight({required lights, required firstDigit, required secondDigit}){
    lights[firstDigit][secondDigit] = incrementColor(actColor: lights[firstDigit][secondDigit]);

    if(firstDigit != 0){
      lights[firstDigit-1][secondDigit] = incrementColor(actColor: lights[firstDigit-1][secondDigit]);
    }
    if(secondDigit != 0){
      lights[firstDigit][secondDigit-1] = incrementColor(actColor: lights[firstDigit][secondDigit-1]);
    }

    if(firstDigit != lights.length-1){
      lights[firstDigit+1][secondDigit] = incrementColor(actColor: lights[firstDigit+1][secondDigit]);
    }
    if(secondDigit != lights.first.length-1){
      lights[firstDigit][secondDigit+1] = incrementColor(actColor: lights[firstDigit][secondDigit+1]);
    }
    return lights;
  }

  List<List<int>> tabOnOneLightBackwards({required lights ,required firstDigit, required secondDigit}){
    lights[firstDigit][secondDigit] = decrementColor(actColor: lights[firstDigit][secondDigit]);

    if(firstDigit != 0){
      lights[firstDigit-1][secondDigit] = decrementColor(actColor: lights[firstDigit-1][secondDigit]);
    }
    if(secondDigit != 0){
      lights[firstDigit][secondDigit-1] = decrementColor(actColor: lights[firstDigit][secondDigit-1]);
    }

    if(firstDigit != lights.length-1){
      lights[firstDigit+1][secondDigit] = decrementColor(actColor: lights[firstDigit+1][secondDigit]);
    }
    if(secondDigit != lights.first.length-1){
      lights[firstDigit][secondDigit+1] = decrementColor(actColor: lights[firstDigit][secondDigit+1]);
    }
    return lights;
  }

}
