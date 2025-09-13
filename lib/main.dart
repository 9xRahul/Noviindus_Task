import 'package:flutter/material.dart';
import 'package:noviindus_task/domain/repositories/patient_repository.dart';
import 'package:provider/provider.dart';

import 'core/api_client.dart';
import 'core/storage_helper.dart';

import 'data/data_sources/auth_remote_data_sourse.dart';
import 'data/data_sources/patient_remote_data_sourse.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/patient_repository_impl.dart';

import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/patient_usecase.dart';
import 'domain/usecases/save_patient_use_case.dart';

import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/patient_provider.dart';
import 'presentation/providers/register_provider.dart';
import 'presentation/providers/treatment_provider.dart';
import 'presentation/providers/branch_provider.dart';
import 'presentation/providers/payment_provider.dart';

import 'presentation/ui/home_screen/home_screen.dart';
import 'presentation/ui/login_screen/login_screen.dart';
import 'presentation/ui/splashscreen.dart';
import 'core/size_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  final storageHelper = StorageHelper();

  final authRemote = AuthRemoteDataSourceImpl(apiClient);
  final authRepo = AuthRepositoryImpl(authRemote, storageHelper);
  final loginUsecase = LoginUsecase(authRepo);

  final patientRemote = PatientRemoteDataSourceImpl(apiClient);

  final PatientRepository patientRepo = PatientRepositoryImpl(patientRemote);

  final getPatientsUsecase = GetPatientsUsecase(patientRepo);
  final savePatientUsecase = SavePatientUsecase(patientRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUsecase: loginUsecase,
            authRepository: authRepo,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => PatientProvider(
            getPatients: getPatientsUsecase,
            savePatient: savePatientUsecase,
          ),
        ),

        ChangeNotifierProvider(create: (_) => RegisterProvider(apiClient)),

        ChangeNotifierProvider(create: (_) => TreatmentProvider(apiClient)),
        ChangeNotifierProvider(create: (_) => BranchProvider(apiClient)),
        ChangeNotifierProvider(create: (_) => PaymentOptionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authProvider = context.read<AuthProvider>();
      _authProvider.tryAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Noviindus Task',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          SizeConfig.initialize(context);
          switch (auth.status) {
            case AuthStatus.loading:
            case AuthStatus.unknown:
              return const Scaffold(body: SplashScreen());
            case AuthStatus.authenticated:
              return const HomeScreen();
            case AuthStatus.unauthenticated:
            default:
              return const LoginScreen();
          }
        },
      ),
    );
  }
}
