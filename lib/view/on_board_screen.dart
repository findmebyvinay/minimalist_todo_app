import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16,),
              Lottie.asset('assets/todo.json',
              
              height: 200,
              width: 200),
              const SizedBox(height: 24,),
              const Text('Make your day Productive !',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontStyle: FontStyle.italic,
                color: Colors.amber
              ),),
              const SizedBox(height: 24,),
          
              ElevatedButton(
                style:const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.amberAccent)
                ),
                onPressed: (){
                    Get.offNamed('/todoPage');
              }, child:const Text('Add your todo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),))
            ],
          ),
        ),
      ),
    );
  }
}