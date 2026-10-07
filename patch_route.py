import re

with open('lib/route/app_route.dart', 'r') as f:
    content = f.read()

imports = """
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tommy/core/network/api_service.dart';
import 'package:tommy/view/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tommy/view/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tommy/view/features/auth/domain/usecases/login_usecase.dart';
import 'package:tommy/view/features/auth/presentation/bloc/auth_bloc.dart';
"""

content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';" + imports)

route_patch = """
      login => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: LoginUseCase(
              AuthRepositoryImpl(
                AuthRemoteDataSourceImpl(
                  context.read<ApiService>(),
                ),
              ),
            ),
          ),
          child: const LoginPage(),
        ),
      ),
"""

content = re.sub(
    r"      login => MaterialPageRoute<void>\(\s*settings: settings,\s*builder: \(_\) => const LoginPage\(\),\s*\),",
    route_patch,
    content
)

with open('lib/route/app_route.dart', 'w') as f:
    f.write(content)
