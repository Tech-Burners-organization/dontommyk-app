import re

with open('lib/view/features/auth/presentation/pages/login_page.dart', 'r') as f:
    content = f.read()

content = content.replace("class LoginPage extends StatelessWidget {", """
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tommy/view/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
""")
content = content.replace("  const LoginPage({super.key});", "")
content = content.replace("  @override\n  Widget build(BuildContext context) {", "  @override\n  Widget build(BuildContext context) {")
# Replace CustomTextField
content = content.replace("CustomTextField(\n                hintText: 'Enter Your Email',", "CustomTextField(\n                controller: _emailController,\n                hintText: 'Enter Your Email',")
content = content.replace("CustomTextField(\n                hintText: '••••••••',", "CustomTextField(\n                controller: _passwordController,\n                hintText: '••••••••',")

button_code = """
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.pushReplacementNamed(context, AppRoute.dashboard);
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  return CommonButton(
                    isLoading: state is AuthLoading,
                    titleText: 'Continue',
                    titleColor: Colors.black,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    onTap: () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text;
                      if (email.isNotEmpty && password.isNotEmpty) {
                        context.read<AuthBloc>().add(
                          LoginSubmitted(email: email, password: password),
                        );
                      }
                    },
                  );
                },
              ),
"""

content = re.sub(
    r"              CommonButton\([\s\S]*?onTap: \(\) \{[\s\S]*?\},[\s\S]*?\),",
    button_code,
    content
)

with open('lib/view/features/auth/presentation/pages/login_page.dart', 'w') as f:
    f.write(content)
