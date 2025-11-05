import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_firebase_app/providers/cart_provider.dart';
import 'package:todo_firebase_app/screens/cart_screen.dart';
import 'package:todo_firebase_app/screens/product_detail_screen.dart';
import 'package:todo_firebase_app/widgets/product_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;

  static const Color primaryColor = Colors.purpleAccent;
  static const Color accentColor = Colors.pinkAccent;
  static const Color backgroundColor = Color(0xFFF5F5F5);

  late List<ProductSection> _sections;

  @override
  void initState() {
    super.initState();
    _sections = [
      ProductSection(
        collectionName: 'Unisex Fragrances',
        demoProducts: [
          {
            'name': 'CK One',
            'price': 85.00,
            'description': 'Fresh and clean fragrance for everyone.',
            'imageUrl': 'https://example.com/ck_one.jpg',
          },
          {
            'name': 'Tom Ford Black Orchid',
            'price': 120.00,
            'description': 'Rich, dark, and luxurious scent for men and women.',
            'imageUrl': 'https://example.com/black_orchid.jpg',
          },
          {
            'name': 'Jo Malone Wood Sage & Sea Salt',
            'price': 95.00,
            'description': 'Earthy and refreshing unisex fragrance.',
            'imageUrl': 'https://example.com/jo_malone_unisex.jpg',
          },
        ],
        searchQuery: _searchQuery,
      ),
      ProductSection(
        collectionName: 'Men’s Colognes',
        demoProducts: [
          {
            'name': 'Dior Sauvage',
            'price': 150.00,
            'description': 'Fresh and spicy scent for men.',
            'imageUrl': 'https://example.com/dior_sauvage.jpg',
          },
          {
            'name': 'Bleu de Chanel',
            'price': 145.00,
            'description': 'Woody aromatic fragrance for men.',
            'imageUrl': 'https://example.com/bleu_de_chanel.jpg',
          },
          {
            'name': 'Acqua di Gio',
            'price': 130.00,
            'description': 'Classic fresh aquatic cologne.',
            'imageUrl': 'https://example.com/acqua_di_gio.jpg',
          },
        ],
        searchQuery: _searchQuery,
      ),
      ProductSection(
        collectionName: 'Women’s Perfumes',
        demoProducts: [
          {
            'name': 'Chanel No.5',
            'price': 120.00,
            'description': 'Classic floral fragrance for women.',
            'imageUrl': 'https://example.com/chanel_no5.jpg',
          },
          {
            'name': 'Yves Saint Laurent Libre',
            'price': 130.00,
            'description': 'Modern, bold scent for women.',
            'imageUrl': 'https://example.com/ysl_libre.jpg',
          },
          {
            'name': 'Lancome La Vie Est Belle',
            'price': 110.00,
            'description': 'Sweet floral scent with a warm base.',
            'imageUrl': 'https://example.com/lancome.jpg',
          },
        ],
        searchQuery: _searchQuery,
      ),
    ];
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully")),
      );
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _sections
            .map((section) => ProductSection(
          collectionName: section.collectionName,
          demoProducts: section.demoProducts,
          searchQuery: _searchQuery,
        ))
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox),
            label: 'Unisex',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.male),
            label: 'Men’s Colognes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.female),
            label: 'Women’s Perfumes',
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Perfume & Fragrance Store',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search perfumes or fragrances...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      actions: [
        Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Badge(
              label: Text(cart.itemCount.toString()),
              isLabelVisible: cart.itemCount > 0,
              child: IconButton(
                icon: const Icon(Icons.shopping_basket),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _logout,
        ),
      ],
    );
  }
}

class ProductSection extends StatefulWidget {
  final String collectionName;
  final List<Map<String, dynamic>> demoProducts;
  final String searchQuery;

  const ProductSection({
    required this.collectionName,
    required this.demoProducts,
    required this.searchQuery,
    super.key,
  });

  @override
  State<ProductSection> createState() => _ProductSectionState();
}

class _ProductSectionState extends State<ProductSection> {
  late final CollectionReference _productsCollection;

  @override
  void initState() {
    super.initState();
    _productsCollection =
        FirebaseFirestore.instance.collection(widget.collectionName);
  }

  List<Map<String, dynamic>> _filterProducts(List<Map<String, dynamic>> products) {
    if (widget.searchQuery.isEmpty) return products;
    return products
        .where((product) =>
        product['name'].toString().toLowerCase().contains(widget.searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: _productsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading();
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load products. Please try again.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final products = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
            final filteredProducts = _filterProducts(products);
            return _buildProductGrid(filteredProducts, isFirestore: true);
          }

          final filteredDemo = _filterProducts(widget.demoProducts);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Demo Products (No data available)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: _buildProductGrid(filteredDemo, isFirestore: false)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(List<Map<String, dynamic>> products,
      {required bool isFirestore}) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products found matching your search.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          productData: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  productData: product,
                  productId: isFirestore
                      ? '${widget.collectionName}_${index}'
                      : 'demo_${widget.collectionName}_${index + 1}',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
