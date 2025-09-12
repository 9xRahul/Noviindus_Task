import 'package:flutter/material.dart';
import 'package:noviindus_task/core/size_config.dart';
import 'package:noviindus_task/core/storage_helper.dart';
import 'package:noviindus_task/data/data_sources/auth_remote_data_sourse.dart';
import 'package:noviindus_task/presentation/providers/auth_provider.dart';
import 'package:noviindus_task/presentation/ui/home_screen.dart';
import 'package:noviindus_task/presentation/ui/login_screen/login_screen.dart';
import 'package:noviindus_task/presentation/ui/splashscreen.dart';
import 'package:provider/provider.dart';

import 'core/api_client.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //dependenct injection
  final apiClient = ApiClient();
  final storageHelper = StorageHelper();
  final authRemote = AuthRemoteDataSourceImpl(apiClient);
  final authRepo = AuthRepositoryImpl(authRemote, storageHelper);
  final loginUsecase = LoginUsecase(authRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUsecase: loginUsecase,
            authRepository: authRepo,
          ),
        ),
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
      title: 'test-task',
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
