import 'package:flutter/material.dart';
import 'package:mad1_thefusionfork/theme_provider.dart';
import 'package:mad1_thefusionfork/views/Screens/CartPage.dart';
import 'package:mad1_thefusionfork/views/Screens/accountscreen.dart';
import 'package:mad1_thefusionfork/views/Screens/menupage.dart';
import 'package:provider/provider.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<homepage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MenuPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Cart(item: {})),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Accpage()),
        );
        break;
    }
  }

  Widget _buildProductCard(
    BuildContext context,
    String imagePath,
    String title,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MenuPage()),
        );
      },
      child: SizedBox(
        width: 150,
        child: Column(
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            Text(title),
            const Text("\$10.99"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to The Fusion Fork',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Flavors Are Our Passion',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto-Italic',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    themeProvider.themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search Food',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/images/poster.png',
                        height: 250,
                        width: 600,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Discover Our Food',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Product Cards Section
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children:
                        orientation == Orientation.portrait
                            ? [
                              _buildProductCard(
                                context,
                                'assets/images/Shushi1.jpeg',
                                'Sushi',
                              ),
                              _buildProductCard(
                                context,
                                'assets/images/burger.jpg',
                                'Burger',
                              ),
                            ]
                            : [
                              _buildProductCard(
                                context,
                                'assets/images/burger.jpg',
                                'Burger',
                              ),
                              _buildProductCard(
                                context,
                                'assets/images/Shushi1.jpeg',
                                'Sushi',
                              ),
                              _buildProductCard(
                                context,
                                'assets/images/sushi.jpg',
                                'Sushi 2',
                              ),
                              _buildProductCard(
                                context,
                                'assets/images/pizza.jpg',
                                'Pizza',
                              ),
                            ],
                  ),

                  const SizedBox(height: 20),

                  // Horizontal icon list
                  Center(
                    child: SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(
                                    'assets/images/food.jpg',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Delicious',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.fastfood),
                                ),
                                SizedBox(height: 8),
                                Text('Fresh', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.restaurant),
                                ),
                                SizedBox(height: 8),
                                Text('Taste', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.rice_bowl),
                                ),
                                SizedBox(height: 8),
                                Text('Healthy', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      "Our Restaurant",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'At The Fusion Fork, we serve delicious, freshly prepared dishes using the finest local ingredients. Come experience great food, exceptional service, and a cozy atmosphere perfect for any occasion.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: 'Roboto-regular',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Browse',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Carts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
