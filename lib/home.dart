import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String x="X";
  String o="O";

  late String currentPlayer;
  late bool endGame;
  late List<String> result;

  @override
  void initState() {
    startGame();
    super.initState();
  }

  void startGame(){
    currentPlayer=x;
    endGame=false;
    result=["","","","","","","","",""];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(

        title: Text("XO GAME",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        //backgroundColor: Color(0xffbf3eff),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff000000),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       colors: [Color(0xff0000b2),Color(0xffb5001b),],
        //     begin: Alignment.topRight,
        //     end: Alignment.bottomLeft,
        //   )
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                width: 70,
                height: 70,
                child: Center(child: Text("${currentPlayer}",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white),)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color:  currentPlayer==x? Color(0xff3D45FA):Color(0xffFA2C28),
                ), duration: Duration(milliseconds: 400),
              ),
              SizedBox(height: 5,),
              Text("TURN",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              GridView.builder(
                padding: EdgeInsets.all(15),
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0, //width: height
                  crossAxisSpacing: 10, //space between each item
                  mainAxisSpacing: 10, //space between rows
                ),
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    child: AnimatedContainer(
                      child: Center(child: Text("${result[i]}",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white),)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: result[i].isEmpty? Color(0xff606666): result[i]==x? Color(0xff3D45FA):Color(0xffFA2C28),
                      ), duration: Duration(milliseconds: 400),
                    ),
                    onTap: (){
                      if(endGame||result[i].isNotEmpty)
                        return;


                      setState(() {
                        result[i]=currentPlayer;
                        changeTern();
                        checkForWinner();
                        checkForDrow();
                      });
                    },

                  );
                },
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffffffff),
                  padding: EdgeInsets.all(20),
                  textStyle: TextStyle(color: Colors.black),
                  elevation: 10,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    startGame();
                  });
                },
                icon: Icon(Icons.restart_alt,color: Colors.black,),
                label: Text('Restart game',style:TextStyle(color: Colors.black,)),
              ),
            ],
          ),
        ),
      )
    );
  }
  changeTern(){
    if(currentPlayer==x)
      currentPlayer=o;
    else currentPlayer=x;
  }
  checkForWinner(){
    List<List<int>> winningList=[
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,3,6],
      [1,4,7],
      [2,5,8],
      [0,4,8],
      [2,4,6],
    ];
    for(var win in winningList){
      String pos1=result[win[0]];
      String pos2=result[win[1]];
      String pos3=result[win[2]];

      if(pos1.isNotEmpty)
        if(pos1==pos2&&pos3==pos1){
          snackBar('Player $pos1 is won',pos1);
          endGame=true;
          return;
        }
    }
  }
  checkForDrow(){
    if(endGame)
      return;
    bool drow=true;
    for(var x in result){
      if(x.isEmpty)
        drow=false;
    }
    if(drow){
      snackBar("Draw","a");
      endGame=true;
    }
  }
  snackBar( String message,String pos){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' $message ',textAlign: TextAlign.center,),
          duration: Duration(seconds: 4),
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(15),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: message=="Draw"? Color(0xff1BD900):pos==x? Color(0xff3D45FA):Color(0xffFA2C28),
          elevation: 10,
        )
    );
  }
}
