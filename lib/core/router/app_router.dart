import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/data/repositories/ingesta_repository_impl.dart';
import '../../features/admin/presentation/admin_screen.dart';
import '../../features/admin/presentation/bloc/ingesta_bloc.dart';
import '../../features/home/presentation/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => BlocProvider(
        create: (_) => IngestaBloc(const IngestaRepositoryImpl()),
        child: const AdminScreen(),
      ),
    ),
  ],
);
