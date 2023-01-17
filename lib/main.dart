import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request  = "https://api.hgbrasil.com/finance?format=json&key=329179a7";

void main() async{
  runApp ( MaterialApp(
    home: const Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();


  double dolar=0;
  double euro=0;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text){

    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty) {
    _clearAll();
    return;
  }
  double dolar = double.parse(text);
  realController.text = (dolar * this.dolar).toStringAsFixed(2);
  euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
  double euro = double.parse(text);
  realController.text = (euro * this.euro).toStringAsFixed(2);
  dolarController.text = (euro * this.euro/dolar).toStringAsFixed(2);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black ,
      appBar: AppBar(
        title: const Text("\$ Conversor \$") ,
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text("Carregando Dados...",
                style: TextStyle(color: Colors.amber,
                fontSize: 25.0),
                  textAlign: TextAlign.center,),
              );
            default:
              if(snapshot.hasError){
                return const Center(
                  child: Text("Erro ao Carregar Dados :(",
                    style: TextStyle(color: Colors.amber,
                        fontSize: 25.0),
                    textAlign: TextAlign.center,),
                );
              }else{
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:[
                      const Icon(Icons.monetization_on, size: 100,color: Colors.amber,),
                     builderTextField("Reais", "R\$",realController,_realChanged),
                      const Divider()
                      ,builderTextField("Dólares", "US\$",dolarController,_dolarChanged),
                      const Divider(),
                      builderTextField("Euros", "€",euroController,_euroChanged),
                    ],
                  ),
                );
              }
          }

        }
      ),
    );

  }
}
Widget builderTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    controller: c,
    onChanged: (texto){
      f(texto);
    },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
         color: Colors.amber),
        border: const OutlineInputBorder(),
        prefixText: prefix,
        prefixStyle: const TextStyle(
        fontSize: 25.0,
        color: Colors.amber),
  ),style: const TextStyle(
      color: Colors.amber,
      fontSize: 25.0),

  );
}