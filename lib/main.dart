import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '一言',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '一言'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dio = Dio();
  late Future<String?> future;

  @override
  void initState() {
    super.initState();
    future = fetchHitokoto();
  }

  Future<String?> fetchHitokoto() async {
    try {
      var response = await dio.get<String>("https://v1.hitokoto.cn/");
      var resMap = json.decode(response.data.toString());
      return resMap['hitokoto'];
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void _refresh() {
    setState(() {
      future = fetchHitokoto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.title),
      ),
      body: FutureBuilder<String?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Padding(padding: const EdgeInsets.all(30),child: Text('出错辣! ${snapshot.error}')));
          } else if (snapshot.hasData) {
            return Center(child: Padding(padding: const EdgeInsets.all(30),child: Text(snapshot.data!)));
          } else {
            return Center(child: Padding(padding: const EdgeInsets.all(30),child: Text('请求失败,我们完蛋辣！')));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
