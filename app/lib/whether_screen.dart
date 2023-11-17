import 'dart:convert';
import 'dart:ui';

import 'package:app/additional.dart';
import 'package:app/secrets.dart';
import 'package:flutter/material.dart';

import 'hourlyforecast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;



class WeatherScreen extends StatefulWidget{

  WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

   double temp = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    getCurrentWeather(); 
  }

  //uniform resource identifier
  Future getCurrentWeather()async{
    try{
     
  String cityName = 'London';
  final result = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'));
    final data = jsonDecode(result.body);
    if(data['cod']!='200'){
      throw "Somthing happened please check ";
    } 
         temp = data['list'] [0] ['main'] ['temp'];

   } catch (e){
      print("Something happend please check idiot");
  }
  }


  @override
  Widget build(BuildContext context) {
   
   return Scaffold(
    appBar: AppBar(
      title: const Text("Weather App",style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,
      actions:  [
        IconButton(onPressed: (){},
         icon: const Icon(Icons.refresh))
      ],
    ),

    body:
     FutureBuilder(
     future: getCurrentWeather(),
     builder: (context , snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
        return const CircularProgressIndicator.adaptive();
      }
      if(snapshot.hasError){
        return Text(snapshot.error.toString());
      }

      final data = snapshot.data!;
       
       return Padding(
        padding: const EdgeInsets.all(16),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // main card
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Center(
                  child:  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                      child:  Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('$temp K',
                             style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold
                            ),),
                            const SizedBox(height: 16,), 
                          const  Icon(Icons.cloud,
                            size: 64,
                            ),
                           const  SizedBox(height: 16,),
                           const Text("Rain",style: TextStyle(fontSize: 20),)
                                
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
     
     
           const SizedBox(height: 16,),
           //  Text
     
          const Padding(
             padding: const EdgeInsets.all(12),
             child:  Text("Weather forecast",style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
             ),),
           ),
     
           // list of cards
     
         const  SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child:  Row(
              children:  [
               HourlyForecast(
                time: "0.0",
                icon:Icons.cloud ,
                tempreture: "301.22",
               ), 
     
               HourlyForecast(
                time: "0.0",
                icon:Icons.sunny ,
                tempreture: "301.22",
               ), 
     
               HourlyForecast(
                time: "0.0",
                icon:Icons.sunny ,
                tempreture: "301.22",
               ), 
               HourlyForecast(
                time: "0.0",
                icon:Icons.cloud ,
                tempreture: "301.22",
               ), 
               HourlyForecast(
                time: "0.0",
                icon:Icons.cloud ,
                tempreture: "301.22",
               ), 
     
              ]
             ),
          ),
     
            const SizedBox(height: 20,),
     
     
            const Text("Additional Information", style: TextStyle(
              fontSize: 22,
            ),
            ),
     
     
       const Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditonalInfo(icon: Icons.water_drop,
                   label: "Humidity",
                    value: "9.4"),
     
                    AdditonalInfo(icon: Icons.air,
                     label: "Wind Speed",
                      value: "7.67"),
     
                      AdditonalInfo(icon: Icons.beach_access,
                       label: "Pressure",
                        value: "1006") 
                ],
              ),
        ),
     
          ],
        ),
         );
     },
     ),
   );
  }
}


