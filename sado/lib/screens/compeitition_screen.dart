import 'package:flutter/material.dart';
import 'package:sado/model/user.dart';
import 'package:sado/screens/recommendation_screen.dart';
import 'package:sado/services/http_services.dart';

class CompeititionScreen extends StatefulWidget {
  const CompeititionScreen({Key? key}) : super(key: key);

  @override
  _CompeititionScreenState createState() => _CompeititionScreenState();
}

class _CompeititionScreenState extends State<CompeititionScreen> {
  final _formKey = GlobalKey<FormState>();
  late String dropdownCompeitition = "No";
  late String dropdownIntensity = "Low";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SADO"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: 500,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: "Do you participate in competition?",
                          border: OutlineInputBorder(),
                        ),
                        isExpanded: true,
                        value: dropdownCompeitition,
                        onChanged: (String? value) {
                          setState(() {
                            dropdownCompeitition = value!;
                          });
                        },
                        items: <String>['Yes', 'No']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  dropdownCompeitition == "Yes"
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            width: 500,
                            child: Column(
                              children: [
                                DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Intensity of training",
                                    border: OutlineInputBorder(),
                                  ),
                                  isExpanded: true,
                                  value: dropdownIntensity,
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownIntensity = value!;
                                    });
                                  },
                                  items: <String>['Low', 'Moderate', "High"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            user.setCompetition(
                              dropdownCompeitition,
                              dropdownIntensity,
                            );
                            user.calculateBMI();
                            user.calculateEquation();
                            httpServices.callEngine().then(
                                  (recommendation) => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecommendationScreen(
                                          recommend: recommendation,
                                        ),
                                      ),
                                    )
                                  },
                                );
                          }
                        },
                        child: Text("Submit"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
