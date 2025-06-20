// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:gwenchana/presentation/bloc/auth/auth_bloc.dart';
// import 'package:gwenchana/presentation/bloc/auth/auth_event.dart';
// import 'package:gwenchana/presentation/bloc/auth/auth_state.dart';
// import 'package:mockito/mockito.dart';
// import 'package:gwenchana/core/services/auth_service.dart';

// class MockAuthService extends Mock implements AuthService {}

// void main() {
//   group('AuthBloc', () {
//     late AuthBloc authBloc;
//     late MockAuthService mockAuthService;

//     setUp(() {
//       mockAuthService = MockAuthService();
//       authBloc = AuthBloc(authService: mockAuthService);
//     });

//     blocTest<AuthBloc, AuthState>(
//       'emits [AuthLoading, AuthAuthenticated] when login succeeds',
//       build: () => authBloc,
//       act: (bloc) => bloc.add(AuthLoginRequested(
//         email: 'test@example.com',
//         password: 'password123',
//       )),
//       expect: () => [
//         AuthLoading(),
//         isA<AuthAuthenticated>(),
//       ],
//     );
//   });
// }
