import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cash Toss',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Pacifico', // Setting Pacifico font
      ),
      home: MyHomePage(),
      routes: {
        '/settings': (context) => SettingsPage(), // Route for settings page
        '/add_photo': (context) => AddPhotoPage(), // Route for add photo page
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, String>> _expenses = [];
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this); // Increased length for new tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddExpenseDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Expense Name"),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Add"),
              onPressed: () {
                setState(() {
                  _isLoading = true; // Show loading indicator
                });

                // Simulate adding expense with a delay
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    _expenses.add({
                      "name": nameController.text,
                      "amount": amountController.text,
                    });
                    _isLoading = false; // Hide loading indicator
                  });
                  Navigator.of(context).pop(); // Close the dialog
                  _showAddedExpenseAlert(
                      nameController.text, amountController.text); // Show alert
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddedExpenseAlert(String name, String amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Expense Added"),
          content: Text("Expense '$name' added with amount ₱$amount"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Toss'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.list), text: 'List'),
            Tab(icon: Icon(Icons.pie_chart), text: 'Chart'),
            Tab(
                icon: Icon(Icons.camera_alt),
                text: 'Logo'), // New tab for Add Photo
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildListView(), // Placeholder for List view
                _buildStaggeredGridView(), // Placeholder for Staggered Grid view
                Center(
                    child:
                        _buildAddPhotoView()), // Placeholder for Add Photo view
                Center(
                    child:
                        Text('Settings View')), // Placeholder for Settings view
              ],
            ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              // Show FAB only on List tab
              onPressed: _showAddExpenseDialog, // Show add expense dialog
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            )
          : null,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Expenses: ₱${_calculateTotalExpenses()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.money),
          title: Text(_expenses[index]["name"]!),
          subtitle: Text("₱${_expenses[index]["amount"]!}"),
        );
      },
    );
  }

  Widget _buildStaggeredGridView() {
    List<Color> itemColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: _expenses.length,
      itemBuilder: (BuildContext context, int index) => Container(
        color: itemColors[
            index % itemColors.length], // Use modulo to cycle through colors
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.money, color: Colors.white),
              SizedBox(height: 8),
              Text(
                _expenses[index]["name"]!,
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "₱${_expenses[index]["amount"]!}",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget _buildAddPhotoView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Image.asset('assets/logo1.jpg', height: 200),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(), // Circular Progress Indicator
    );
  }

  String _calculateTotalExpenses() {
    double total = 0.0;
    _expenses.forEach((expense) {
      total += double.parse(expense["amount"]!);
    });
    return total.toStringAsFixed(2);
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildSettingsItem(context, 'Currency', '₱ Philippine Peso'),
            _buildSettingsItem(context, 'Theme', 'Light'),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      onTap: () {
        // Implement action when item is tapped
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on $title')),
        );
      },
    );
  }
}

class AddPhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Image.asset('assets/logo1.jpg', height: 200),
          ],
        ),
      ),
    );
  }
}
