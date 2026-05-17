import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/data/repositories/ingesta_repository_impl.dart';
import '../../features/admin/presentation/bloc/ingesta_bloc.dart';
import '../../features/admin/presentation/screens/admin_screen.dart';
import '../../features/cashback/presentation/screens/cashback_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_intro_screen.dart';
import '../../features/loyalty/presentation/screens/loyalty_cards_screen.dart';
import '../../features/loyalty/presentation/screens/business_detail_screen.dart';
import '../../features/fraud/presentation/screens/fraud_dashboard_screen.dart';
import '../../features/fraud/presentation/screens/fraud_alert_detail_screen.dart';
import '../../features/profitability/presentation/screens/profitability_screen.dart';
import '../../features/profitability/presentation/screens/user_profitability_screen.dart';
import '../../features/cashback_approval/presentation/screens/approval_dashboard_screen.dart';
import '../../features/cashback_approval/presentation/screens/approval_detail_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => BlocProvider(
        create: (_) => IngestaBloc(IngestaRepositoryImpl()),
        child: const AdminScreen(),
      ),
    ),
    GoRoute(
      path: '/cashback',
      builder: (context, state) => const CashbackScreen(),
    ),
    GoRoute(
      path: '/loyalty',
      builder: (context, state) => const LoyaltyIntroScreen(),
    ),
    GoRoute(
      path: '/loyalty/cards',
      builder: (context, state) => const LoyaltyCardsScreen(),
    ),
    GoRoute(
      path: '/loyalty/business/:id',
      builder: (context, state) => BusinessDetailScreen(
        businessId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/fraud',
      builder: (context, state) => const FraudDashboardScreen(),
    ),
    GoRoute(
      path: '/fraud/alert/:id',
      builder: (context, state) => FraudAlertDetailScreen(
        alertId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/profitability',
      builder: (context, state) => const ProfitabilityScreen(),
    ),
    GoRoute(
      path: '/profitability/user/:id',
      builder: (context, state) => UserProfitabilityScreen(
        userId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/approval',
      builder: (context, state) => const ApprovalDashboardScreen(),
    ),
    GoRoute(
      path: '/approval/request/:id',
      builder: (context, state) => ApprovalDetailScreen(
        requestId: state.pathParameters['id']!,
      ),
    ),
  ],
);
