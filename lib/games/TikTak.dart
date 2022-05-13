import 'package:flutter/material.dart';

class TikTak extends StatefulWidget {
  const TikTak({Key? key}) : super(key: key);

  @override
  _TikTakState createState() => _TikTakState();
}

class _TikTakState extends State<TikTak> {

  List<String> fields = List.generate(9, (index) => " ");
  bool playerTurn = false;
  String msg = "";


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("TickTak"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              playerTurn ? const Text("It is Player 'X' turn") : const Text("It is Player 'O' turn"),
              const SizedBox(height: 20,),

              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: (1 / .6),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                shrinkWrap: true,
                crossAxisCount: 3,
                children:
                List<int>.generate(fields.length, (i) => i).map((index) {

                  return GestureDetector(
                      onTap: (){
                        if(fields[index] != " "){
                          setState(() {
                            msg = "Not allowed to set on the same field";
                          });
                          return;
                        }
                        setState(() {
                          msg = "";
                          print("Index: " + index.toString());
                          fields[index] = playerTurn ? "X" : "O";
                          playerTurn = !playerTurn;
                        });

                        //Columns
                        if(fields[0] == fields[1] && fields[1] == fields[2] && fields[2] != " ") {
                          setState(() {
                            msg = "We have a Winner: " + (!playerTurn ? "X" : "O");
                          });
                        }
                        if(fields[3] == fields[4] && fields[4] == fields[5] && fields[5] != " ") {
                          setState(() {
                            msg = "We have a Winner: " + (!playerTurn ? "X" : "O");
                          });
                        }
                        if(fields[6] == fields[7] && fields[7] == fields[8] && fields[8] != " ") {
                          setState(() {
                            msg = "We have a Winner: " + (!playerTurn ? "X" : "O");
                          });
                        }
                        //Rows
                        if(fields[0] == fields[3] && fields[3] == fields[6] && fields[6] != " ") {
                          setState(() {
                            msg = "We have a Winner: " + (!playerTurn ? "X" : "O");
                          });
                        }
                        if(fields[1] == fields[4] && fields[4] == fields[7] && fields[7] != " ") {
                          setState(() {
                            msg = "We have a Winner: " + (!playerTurn ? "X" : "O");
                          });
                        }
                        if(fields[2] == fields[5] && fields[5] == fields[8] && fields[8] != " ") {
                          setState(() {
                            msg = "We have a Winner: " + (!playerTurn ? "X" : "O");
                          });
                        }
                        //Diagonals
                        if(fields[0] == fields[4] && fields[4] == fields[8] && fields[8] != " ") {
                          setState(() {
                            msg = "We have a Winner: " + (!playerTurn ? "X" : "O");
                          });
                        }
                        if(fields[2] == fields[4] && fields[4] == fields[7] && fields[7] != " ") {
                          setState(() {
                            msg = "We have a Winner: " + (!playerTurn ? "X" : "O");
                          });
                        }

                      },
                      child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD3E03A),
                            border: Border.all(
                                color: Colors.grey,
                                width: 0.5),
                            borderRadius:
                            const BorderRadius.all(
                                Radius.circular(
                                    5.0) //
                            ),
                          ),
                          child: Center(child: Text(fields[index]))
                      )
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              Text(msg, style: const TextStyle(color: Colors.red),),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                setState(() {
                  fields = List.generate(9, (index) => " ");
                  msg = "";
                });

              }, child: const Text("Reset Game"))
            ],
          ),
        )
    );
  }
}
