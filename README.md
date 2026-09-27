# Tommy

Flutter starter structured around Dio and BLoC.

## Structure

```text
lib/
├── app/                         # Root app widget and app-wide Cubits
├── core/
│   ├── bloc/                    # Shared states and BlocObserver
│   ├── config/                  # Environment configuration
│   ├── di/                      # App dependency composition
│   ├── errors/                  # Exceptions, failures, and mapping
│   ├── network/                 # Dio service, interceptors, responses
│   ├── result/                  # Success/Error result type
│   ├── usecase/                 # Base use-case contract
│   └── utils/                   # Framework-independent helpers
├── features/
│   └── <feature>/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/            # Bloc/Cubit, events, and states
│           ├── pages/
│           └── widgets/
├── route/                       # Navigator routes
└── view/component/              # Shared reusable UI components
```

## Network flow

`AppDependencies` creates one configured Dio instance. `ApiService` is exposed
at the app root through `RepositoryProvider`, so a feature repository can receive
it from its Bloc provider:

```dart
BlocProvider(
  create: (context) => UsersCubit(
    UsersRepository(context.read<ApiService>()),
  )..load(),
  child: const UsersPage(),
)
```

Inside a repository, decode API JSON into feature models and convert exceptions
to failures:

```dart
Future<Result<List<User>>> getUsers() async {
  try {
    final response = await api.getData<List<User>>(
      '/users',
      decoder: (json) => (json as List)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    return ResultSuccess(response.data);
  } catch (error) {
    return ResultFailure(FailureMapper.from(error));
  }
}
```

The Cubit/Bloc emits `UiLoading`, `UiSuccess`, `UiEmpty`, or `UiFailure`, and
`BlocStateView` handles the common loading/error/empty UI.

## Configuration

Pass the API URL at build/run time:

```bash
flutter run --dart-define=BASE_URL=https://api.example.com
```

The auth interceptor reads `PrefsHelper.token` and attaches it as a Bearer token.
Set the token with `PrefsHelper.setString('token', value)` after login.

## Verification

```bash
flutter analyze
flutter test
```
