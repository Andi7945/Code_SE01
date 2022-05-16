import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';


class LightsOutAdvanced extends StatefulWidget {
  const LightsOutAdvanced({Key? key}) : super(key: key);

  @override
  LightsOutAdvancedState createState() => LightsOutAdvancedState();
}

class LightsOutAdvancedState extends State<LightsOutAdvanced> {

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
  List<Coordinates>  winnerPath = [];

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
                              if(winnerPath.isNotEmpty) {
                                try {
                                  print("Path depth: " + winnerPath.length.toString());
                                  print("Count " + counter.toString() + " Path_X: " + winnerPath[counter].clicked_x.toString() + " Path_y: " + winnerPath[counter].clicked_y.toString());
                                  print("klicked X: " + firstDigit.toString()  + " Y: " + secondDigit.toString());
                                  if (!(winnerPath[counter].clicked_x == firstDigit && winnerPath[counter].clicked_y == secondDigit)) {
                                    print("Delete Path");
                                    winnerPath = [];
                                  }
                                }catch(e){}
                              }
                              counter++;
                              lights = tabOnOneLight(lightsY: lights, firstDigit: firstDigit, secondDigit: secondDigit);
                              checkIfUserWonTheGame(lights: lights);
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
                                      color: isWinnterPath(count: counter, x: firstDigit, y: secondDigit) ? Colors.yellow : Colors.black ,
                                      width: isWinnterPath(count: counter, x: firstDigit, y: secondDigit) ? 6 : 1),
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
                  winnerPath = [];
                  counter = 0;
                });

              }, child: const Text("Reset Game")),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                setState(() {
                  resetLightsDoable(level: 3);
                  winnerPath = [];
                  counter = 0;
                  msg = "";
                });

              }, child: const Text("Reset Game doable")),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                setState(() {
                  counter = 0;
                  winnerPath = testIfDoable(depth: 6, lightsX: lights);
                  msg = "";
                });

              }, child: const Text("Test if game is duable")),

              const SizedBox(height: 20,),
            ],
          ),
        )
    );
  }

  bool isWinnterPath({required count, required x, required y}){
    try {
      if (winnerPath.isEmpty) return false;
      if (winnerPath[counter].clicked_x == x &&
          winnerPath[counter].clicked_y == y) return true;
    }catch(e){}
    return false;
  }

  //z   ligts array
  List<Coordinates> testIfDoable({required int depth, required List<List<int>> lightsX}){
    //remove connection from lights -> deep copy
    List<List<int>> deepLights = [];
    for (var element in lightsX) {
      List<int> deepPart = [];
      for (var element2 in element) {
        deepPart.add(int.parse(element2.toString()));
      }
      deepLights.add(deepPart);
    }

    ///calculate the overlying number, imageArrayLength=x*y,  actDepth = z;
    int getOverlayingNumber({required num actNumber, required int imageArrayLength}) {
      num returnValue = actNumber;
      int actDepth = 0;
      while(actNumber > 0){
        actDepth++;
        actNumber -= pow(imageArrayLength,actDepth);
      }
      if(actDepth == 1) return 0;
      for(int d = (actDepth-1); d > 0; d--) {
        returnValue -= pow(imageArrayLength,d);
      }
      returnValue /= imageArrayLength;
      for(int d = 1; d < (actDepth-1); d++) {
        returnValue += pow(imageArrayLength,d);
      }
      returnValue -= 0.5;
      return returnValue.round();
    }

    List<int> getPositionFromPos({required num actNumber, required int imageArrayLength}){
      print("##Input number: " + actNumber.toString());
       num relativNumber = actNumber%imageArrayLength;
      print("Relativ: " + relativNumber.toString());
      final num xy = sqrt(imageArrayLength);
      print("Root: " + xy.toString());
      int first = (relativNumber/xy-0.5).round();
      if(first <0) first = 0;
      final second = (relativNumber%xy).round();
      print("X: " + first.toString() + " Y: " + second.toString());
      return[first ,second];

    }

    ///Generate a list with all resulted images until one matches the win criterium
    List<List<List<int>>> resultImageArray = [];
    final int arrayLength = deepLights.length*deepLights.first.length;

    for (int z = 1; z < depth+1; z++) {
      for (int sqer = 0; sqer <
          pow(deepLights.length * deepLights.first.length, z);) {
        for (int x = 0; x < deepLights.length; x++) {
          for (int y = 0; y < deepLights.first.length; y++) {
            sqer++;

            //print("Tree " + z.toString() + "   " + sqer.toString() + "   " + x.toString() + "   " + y.toString());
            int bevorImagePos = getOverlayingNumber(actNumber: resultImageArray.length, imageArrayLength: arrayLength);
            //List<int> xy = getPositionFromPos(actNumber: resultImageArray.length, imageArrayLength: arrayLength);


            if(bevorImagePos <= 0){
              //so ein behinderter Fehler.. flutter kopiert immer in vorherrige variable ... workarround
              List<List<int>> deepLights2 = [];
              for (var element in lightsX) {
                List<int> deepPart = [];
                for (var element2 in element) {
                  deepPart.add(int.parse(element2.toString()));
                }
                deepLights2.add(deepPart);
              }
             resultImageArray.add(tabOnOneLight(lightsY: deepLights2, firstDigit: x, secondDigit: y));
           } else {
              //so ein behinderter Fehler.. flutter kopiert immer in vorherrige variable ... workarround
              List<List<int>> deepLights3 = [];
              for (var element in resultImageArray[bevorImagePos]) {
                List<int> deepPart = [];
                for (var element2 in element) {
                  deepPart.add(int.parse(element2.toString()));
                }
                deepLights3.add(deepPart);
              }
              resultImageArray.add(tabOnOneLight(
                  lightsY: deepLights3,
                  firstDigit: x,
                  secondDigit: y));
            }
            if(checkIfUserWonTheGame(lights: resultImageArray.last)){
              print("in #######################");
              List<Coordinates> retValue = [Coordinates(clicked_x: x, clicked_y: y)];
              int bevorImagePos = sqer;
              for(; z > 1;z--){
                bevorImagePos = getOverlayingNumber(actNumber: bevorImagePos, imageArrayLength: arrayLength) +1 ;
                List<int> xyLoop = getPositionFromPos(actNumber: bevorImagePos, imageArrayLength: arrayLength);
                retValue.add(Coordinates(clicked_x: xyLoop[0], clicked_y: xyLoop[1]));
              }
              print("out #######################");
              return retValue;
            }
         }
          }
        }
      }

    return [];
  }


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
    msg = "";
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

  List<List<int>> tabOnOneLight({required lightsY, required firstDigit, required secondDigit}){
    lightsY[firstDigit][secondDigit] = incrementColor(actColor: lightsY[firstDigit][secondDigit]);

    if(firstDigit != 0){
      lightsY[firstDigit-1][secondDigit] = incrementColor(actColor: lightsY[firstDigit-1][secondDigit]);
    }
    if(secondDigit != 0){
      lightsY[firstDigit][secondDigit-1] = incrementColor(actColor: lightsY[firstDigit][secondDigit-1]);
    }

    if(firstDigit != lightsY.length-1){
      lightsY[firstDigit+1][secondDigit] = incrementColor(actColor: lightsY[firstDigit+1][secondDigit]);
    }
    if(secondDigit != lightsY.first.length-1){
      lightsY[firstDigit][secondDigit+1] = incrementColor(actColor: lightsY[firstDigit][secondDigit+1]);
    }
    return lightsY;
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




class PossibleOptions{
  PossibleOptions();
  List<PossibleOption> _possibleOptions = [];

  bool isEmpty(){
    return _possibleOptions.isEmpty;
  }

  List<List<int>> getLastImageArray({required int lastImageID}){
    return _possibleOptions[lastImageID].ImageArray;
  }

  //ID is position of last one
  void addNewOption({required x, required y, required futureImageArray, required parentLayerID}){
    _possibleOptions.add(
        PossibleOption(
            clicked_coordinates: Coordinates(
                clicked_x: x,
                clicked_y: y),
            ImageArray: futureImageArray,
            parentPossibelOprionID: parentLayerID));
  }

  ///2D Matrix of where to klick
  List<Coordinates> getPath({required layerID}){
    int pastID = layerID;
    List<Coordinates> returnValue = [];
    while(pastID != -1){
      returnValue.add(_possibleOptions[pastID].clicked_coordinates);
      pastID = _possibleOptions[pastID].parentPossibelOprionID;
    }
    return returnValue;
  }

  int getLength() {
    return _possibleOptions.length;
  }

}

class PossibleOption{
  final int parentPossibelOprionID;
  PossibleOption({required this.clicked_coordinates, required this.ImageArray, required this.parentPossibelOprionID});
  late final Coordinates clicked_coordinates;
  late final List<List<int>> ImageArray;
}

class Coordinates{
  Coordinates({required this.clicked_x, required this.clicked_y});
  late final int clicked_x;
  late final int clicked_y;
}