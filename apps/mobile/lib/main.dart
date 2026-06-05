import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bcldnermnresieeabyan.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJjbGRuZXJtbnJlc2llZWFieWFuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NDA3ODksImV4cCI6MjA5NDQxNjc4OX0.aLwyb686R1xTLlPC1Szj1IczIWMKitxU5eM6yUP948E',
  );

  runApp(const UrComputerApp());
}