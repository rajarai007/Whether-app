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

  

  //uniform resource identifier
  Future <Map<String,dynamic>> getCurrentWeather()async{
    try{
     
  String cityName = 'London';
  final result = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'));
    final data = jsonDecode(result.body);

        //  temp = data['list'] [0] ['main'] ['temp'];
       
      if(data["cod"]!='200'){
        throw 'An unexpected thing happened';
      } 
       return data;
   } catch (e){
      print("Something happend please check idiot");
     throw e.toString();
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
        return const Center(child:  CircularProgressIndicator.adaptive());
      }
      if(snapshot.hasError){
        return Text(snapshot.error.toString());
      }

      final data = snapshot.data!;
      
      final currentWeatherData = data['list'] [0];

      final currentTemp = currentWeatherData ['main'] ['temp']; 

      final currentSky = currentWeatherData['weather'][0]['main'];

      final currentPressure = currentWeatherData['main']['pressure'];

      final currentWindSpeed =  currentWeatherData ['wind']['speed'];

      final currentHumidity = currentWeatherData['main']['humidity'];
       
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
                        padding:  EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('$currentTemp K',
                             style: const  TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold
                            ),),
                             SizedBox(height: 16,), 
                            Icon(
                              currentSky == 'Cloud' ||  currentSky == 'Rain'? Icons.cloud : Icons.sunny,

                            size: 64,
                            ),
                           const  SizedBox(height: 16,),
                            Text(currentSky,style: TextStyle(fontSize: 20),)
                                
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
     
           SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child:  Row(
              children:  [
                for(int i = 0 ;i<5;i++)
                   HourlyForecast(
                time: data['list'][i+1]['dt'].toString(),
                icon:  data['list'][i+1]['weather'][0]['main'] == 'Clouds' || data['list'][i+1]['weather'][0]['main'] == 'Rain' ? Icons.cloud : Icons.sunny,
                tempreture: data['list'][i+1]['main']['temp'].toString(),
               ), 
                
              
              ]
             ),
          ),
     
            const SizedBox(height: 20,),
     
     
            const Text("Additional Information", style: TextStyle(
              fontSize: 22,
            ),
            ),
     
     
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditonalInfo(icon: Icons.water_drop,
                   label: "Humidity",
                    value: currentHumidity.toString()),
     
                    AdditonalInfo(icon: Icons.air,
                     label: "Wind Speed",
                      value: currentWindSpeed.toString()),
     
                      AdditonalInfo(icon: Icons.beach_access,
                       label: "Pressure",
                        value:currentPressure.toString()) 
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


