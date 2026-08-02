import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Profile', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0.5,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'johndoe@example.com',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildProfileItem(Icons.shopping_bag, 'My Orders', () {}),
            _buildProfileItem(Icons.location_on, 'Shipping Address', () {}),
            _buildProfileItem(Icons.payment, 'Payment Methods', () {}),
            _buildProfileItem(Icons.settings, 'Settings', () {}),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(LoggedOut());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
