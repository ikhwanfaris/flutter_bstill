import 'package:audio_service/audio_service.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // services
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PlaylistRepository>(() => DemoPlaylist());

  getIt.registerLazySingleton<FirebaseManager>(() => FirebaseManager());

  // page state
  getIt.registerLazySingleton<PlayerManager>(() => PlayerManager());
}
