import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }
      final success = await context.read<AuthProvider>().register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful. Please login.')),
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed. Email might already be in use.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join our team today',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter email' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 chars' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) => value == null || value.isEmpty ? 'Please confirm password' : null,
                ),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => CustomButton(
                    text: 'Register',
                    isLoading: auth.isLoading,
                    onPressed: _register,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
