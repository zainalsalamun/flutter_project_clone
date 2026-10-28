import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sonner/flutter_sonner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_island/liquid_island.dart';
import 'package:project_clone/page/all_pages_demo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Safe load .env
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Info: .env file not found or already loaded, proceeding with defaults.");
  }

  // Configure GoogleFonts runtime behavior for Web
  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Clone',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return LiquidIslandOverlay(
          child: SonnerOverlay(child: child),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        fontFamilyFallback: const ['Roboto', 'Arial', 'sans-serif'],
      ),
      home: const AllPagesDemo(),
    );
  }
}
