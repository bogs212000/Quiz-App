import 'package:audioplayers/audioplayers.dart';

class AppSounds {
  static const success  = 'assets/sounds/success.mp3';
  static const error  = 'assets/sounds/error.mp3';

  late AudioPlayer player = AudioPlayer();
  void tap() {
    player.play(AssetSource('sounds/tap.mp3'));
  }
}

