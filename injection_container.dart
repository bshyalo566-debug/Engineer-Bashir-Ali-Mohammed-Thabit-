import 'package:get_it/get_it.dart';
import 'package:usb_serial/usb_serial.dart';
import '../database/database_helper.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/scanning/data/repositories/ocr_repository_impl.dart';
import '../../features/scanning/domain/repositories/ocr_repository.dart';
import '../../features/scanning/domain/usecases/process_image_usecase.dart';
import '../../features/scanning/presentation/bloc/scanning_bloc.dart';
import '../../features/printing/data/drivers/printer_driver.dart';
import '../../features/printing/data/drivers/zebra_driver.dart';
import '../../features/printing/data/repositories/printer_repository_impl.dart';
import '../../features/printing/domain/repositories/printer_repository.dart';
import '../../features/printing/domain/usecases/print_label_usecase.dart';
import '../../features/printing/domain/usecases/discover_printers_usecase.dart';
import '../../features/printing/presentation/bloc/printer_bloc.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => UsbSerial());

  // Database
  sl.registerLazySingleton(() => DatabaseHelper);

  // Auth
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Drivers
  sl.registerLazySingleton<PrinterDriver>(() => ZebraUsbDriver());

  // Repositories
  sl.registerLazySingleton<OcrRepository>(() => OcrRepositoryImpl());
  sl.registerLazySingleton<PrinterRepository>(() => PrinterRepositoryImpl(
    driver: sl(),
    usbSerial: sl(),
  ));
  sl.registerLazySingleton<HistoryRepository>(() => HistoryRepositoryImpl());

  // Use Cases
  sl.registerLazySingleton(() => ProcessImageUseCase(sl()));
  sl.registerLazySingleton(() => PrintLabelUseCase(sl()));
  sl.registerLazySingleton(() => DiscoverPrintersUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => ScanningBloc(processImageUseCase: sl()));
  sl.registerFactory(() => PrinterBloc(
    printLabelUseCase: sl(),
    discoverPrintersUseCase: sl(),
  ));
  sl.registerFactory(() => HistoryBloc(historyRepository: sl()));
}
