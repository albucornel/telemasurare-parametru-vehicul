// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// //
// // class Parameters {
// //   String id;
// //   String temp_apa;
// //   String nivel_apa;
// //   String presiune_ulei;
// //   String rotatii_min;
// //   String niv_combustibil;
// //   String device_id;
// //   String log_time;
// //
// //   Parameters({
// //     required this.id,
// //     required this.temp_apa,
// //     required this.nivel_apa,
// //     required this.presiune_ulei,
// //     required this.rotatii_min,
// //     required this.niv_combustibil,
// //     required this.device_id,
// //     required this.log_time
// //   });
// //   factory Parameters.fromJson(Map<String, dynamic> json) {
// //     return Parameters(
// //         id: json['id'],
// //         temp_apa: json['temp_apa'],
// //         nivel_apa: json['nivel_apa'],
// //         presiune_ulei: json['presiune_ulei'],
// //         rotatii_min: json['rotatii_min'],
// //         niv_combustibil: json['niv_combustibil'],
// //         device_id: json['device_id'],
// //         log_time: json['log_time']
// //     );
// //   }
// //   @override
// //   String toString() {
// //     return 'Parameters(id: $id, temp_apa: $temp_apa, nivel_apa: $nivel_apa, presiune_ulei: $presiune_ulei, rotatii_min: $rotatii_min,niv_combustibil:$niv_combustibil, device_id:$device_id, log_time:$log_time)';
// //   }
// // }
//
// class ParametersProviderApi {
//
//   final String url = 'https://telemasurare1.000webhostapp.com/getData.php';
//
//   Future<List<Parameters>> fetchAllParameters() async {
//
//     var response = await http.post(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final parameters =
//       json.decode(response.body);
//       List<Parameters> parametersList = parameters.map<Parameters>((json) {
//         return Parameters.fromJson(json);
//       }).toList();
//       return parametersList;
//     } else {
//       throw Exception('Failed to load data from Server.');
//     }
//   }
//
//   Future<List<String>> fetchWaterTemp() async {
//     List<String> list=[];
//     var parameters = await fetchAllParameters();
//
//     for(int i=0;i<parameters.length;i++){
//       list.add(parameters[i].temp_apa.toString());
//     }
//     print(list);
//
//     return list;
//   }
//   Future<List<String>> fetchWaterLevel() async {
//     List<String> list=[];
//     var parameters = await fetchAllParameters();
//
//     for(int i=0;i<parameters.length;i++){
//       list.add(parameters[i].nivel_apa.toString());
//
//     }
//     print(list);
//
//     return list;
//   }
//   Future<List<String>> fetchOilPressure() async {
//     List<String> list=[];
//     var parameters = await fetchAllParameters();
//
//     for(int i=0;i<parameters.length;i++){
//       list.add(parameters[i].presiune_ulei.toString());
//     }
//     print(list);
//     return list;
//   }
//
//   Future<List<String>> fetchCombLevel() async {
//     List<String> list=[];
//     var parameters = await fetchAllParameters();
//
//     for(int i=0;i<parameters.length;i++){
//       list.add(parameters[i].niv_combustibil.toString());
//     }
//     print(list);
//
//     return list;
//   }
//   Future<List<String>> fetchLogTime() async {
//     List<String> list=[];
//     var parameters = await fetchAllParameters();
//
//     for(int i=0;i<parameters.length;i++){
//       list.add(parameters[i].log_time.toString());
//     }
//     print(list);
//     return list;
//   }
// }