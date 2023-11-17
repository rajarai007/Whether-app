import 'package:flutter/material.dart';


class HourlyForecast extends StatelessWidget {
  final String time;
  final String tempreture;
  final  IconData icon;
  const HourlyForecast({super.key,
    required this.time,
    required this.tempreture,
    required this.icon
  
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
                width: 100,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(children: [
                      Text(time,style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),),
                  
                       SizedBox(height: 8,),
                  
                      Icon(icon),
                  
                      SizedBox(height: 8,),
                  
                      Text(tempreture)
                  
                    ]),
                  ),
                ),
              );
  }
}