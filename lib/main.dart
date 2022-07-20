import 'package:flutter/material.dart';
import 'package:json_file_deserializer_example/models/models.dart';
import 'package:json_file_deserializer_example/utils/utils.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Welcome? _welcome;

  Future<void> _loadWelcome() async {
    final jsonFileParser = JsonFileParser<Welcome>(
      fromJson: Welcome.fromJson,
      toJson: (welcome) => welcome.toJson(),
    );

    final welcome = await jsonFileParser.deserialize(
      assetPath: 'assets/welcome.json',
    );

    setState(() => _welcome = welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_welcome != null)
              WelcomeWidget(welcome: _welcome!)
            else
              const Text('No welcome yet'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadWelcome,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({
    super.key,
    required this.welcome,
  });

  final Welcome welcome;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          welcome.greeting,
          style: textTheme.displayMedium,
        ),
        const SizedBox(height: 10),
        for (final instruction in welcome.instructions)
          Text(
            instruction,
            style: textTheme.bodyLarge,
          ),
      ],
    );
  }
}
