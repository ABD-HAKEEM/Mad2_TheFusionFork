import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mad1_thefusionfork/theme_provider.dart';
import 'package:mad1_thefusionfork/views/Screens/CartPage.dart' show Cart;
import 'package:mad1_thefusionfork/views/Screens/HomeScreen.dart' show homepage;
import 'package:mad1_thefusionfork/views/Screens/login.dart';
import 'package:provider/provider.dart';

import '../../views/Screens/Menupage.dart';

class Accpage extends StatefulWidget {
  const Accpage({super.key});

  @override
  _AccpageState createState() => _AccpageState();
}

class _AccpageState extends State<Accpage> {
  int _selectedIndex = 3;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _oldEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailController.text = user.email ?? '';
      _oldEmailController.text = user.email ?? '';
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const homepage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MenuPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Cart(item: {})),
        );
        break;
    }
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void updateEmail() async {
    try {
      await FirebaseAuth.instance.currentUser?.updateEmail(
        emailController.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email updated!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update email: $e')));
    }
  }

  void changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(
        newPasswordController.text,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Password changed!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to change password: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthGate()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: _oldEmailController,
                decoration: const InputDecoration(
                  labelText: 'Current Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'New Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: updateEmail,
                child: const Text('Update Email'),
              ),
              const Divider(height: 30),
              const Text(
                'Change Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: changePassword,
                child: const Text('Change Password'),
              ),
              const Divider(height: 30),
              const Text(
                'Notification Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Enable Notifications'),
                onTap:
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifications Enabled')),
                    ),
              ),
              const Divider(height: 30),
              const Text(
                'Privacy Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Change Privacy Settings'),
                onTap:
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Privacy settings updated.'),
                      ),
                    ),
              ),
              const Center(
                child: Text(
                  '© 2025 Abdul Hakeem. All rights reserved.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Carts',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
        ),
        // bottomSheet: Container(
        //   height: 50,
        //   padding: const EdgeInsets.all(10),
        //   child: const Center(
        //     child: Text(
        //       '© 2025 Abdul Hakeem. All rights reserved.',
        //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
