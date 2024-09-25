import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      // Map the TV remote's select button to an action
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter TV Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyHomePage(title: 'Flutter TV Demo'),
      ),
    );
  }
}

/// Home page widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// State class for the home page
class _MyHomePageState extends State<MyHomePage> {
  // Default image size for all images
  static const double defaultImageSize = 100;

  // Enlarged size when focused
  static const double focusedImageSize = 150;

  // Manage image sizes with a list for better scalability
  final List<double> _imageSizes = [
    defaultImageSize,
    defaultImageSize,
    defaultImageSize
  ];

  /// Handles focus and size changes for the images
  Widget buildImage(String imageUrl, int index) {
    return Focus(
      onKeyEvent: (node, event) {
        // Handle remote's select button press (for future use)
        if (event.logicalKey == LogicalKeyboardKey.select) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Image $index selected")),
          );
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      onFocusChange: (hasFocus) {
        setState(() {
          _imageSizes[index] = hasFocus ? focusedImageSize : defaultImageSize;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Image.network(
          imageUrl,
          width: _imageSizes[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Dynamically build the images with focus functionality
                buildImage(
                  'https://cdn.pixabay.com/photo/2022/02/24/14/28/art-7032570_960_720.jpg',
                  0,
                ),
                buildImage(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg',
                  1,
                ),
                buildImage(
                  'https://cdn.pixabay.com/photo/2022/05/21/02/40/cat-7210553_640.jpg',
                  2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
