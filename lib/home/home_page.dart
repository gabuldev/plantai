// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plantai/scan/entities/plant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Plant> myPlants = [];
  List<Plant> scannedPlants = [];

  void getPlants() async {
    final instance = await SharedPreferences.getInstance();
    final _myPlants = instance.getStringList("my_plants") ?? [];
    final _scannedPlants = instance.getStringList("plants") ?? [];
    myPlants = _myPlants.map((e) => Plant.fromJson(e)).toList();
    scannedPlants = _scannedPlants.map((e) => Plant.fromJson(e)).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              const Text(
                "Últimas plantas escaneadas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: scannedPlants.length,
                  itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(
                            File(scannedPlants[index].pathImage!),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Suas plantas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              for (var item in myPlants)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pushNamed(context, "/details", arguments: item);
                  },
                  title: Text(item.name),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(item.pathImage!)),
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 104,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/scan");
                },
                icon: const Icon(Icons.qr_code)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.nature))
          ],
        ),
      ),
    );
  }
}
