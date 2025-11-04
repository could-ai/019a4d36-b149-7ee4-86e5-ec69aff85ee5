import 'package:flutter/material.dart';

void main() {
  runApp(const OrderRegistrationApp());
}

class OrderRegistrationApp extends StatelessWidget {
  const OrderRegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Registration App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const OrderRegistrationScreen(),
    );
  }
}

class Order {
  final String customerName;
  final String itemName;
  final int quantity;
  final double price;

  Order({
    required this.customerName,
    required this.itemName,
    required this.quantity,
    required this.price,
  });

  double get total => quantity * price;
}

class OrderRegistrationScreen extends StatefulWidget {
  const OrderRegistrationScreen({super.key});

  @override
  State<OrderRegistrationScreen> createState() => _OrderRegistrationScreenState();
}

class _OrderRegistrationScreenState extends State<OrderRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final List<Order> _orders = [];

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _orders.add(Order(
          customerName: _customerNameController.text,
          itemName: _itemNameController.text,
          quantity: int.parse(_quantityController.text),
          price: double.parse(_priceController.text),
        ));
        _customerNameController.clear();
        _itemNameController.clear();
        _quantityController.clear();
        _priceController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order registered successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Registration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(labelText: 'Customer Name'),
                    validator: (value) => value!.isEmpty ? 'Please enter customer name' : null,
                  ),
                  TextFormField(
                    controller: _itemNameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                    validator: (value) => value!.isEmpty ? 'Please enter item name' : null,
                  ),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter quantity';
                      final num = int.tryParse(value);
                      return num == null || num <= 0 ? 'Please enter a valid quantity' : null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price per Item'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter price';
                      final num = double.tryParse(value);
                      return num == null || num <= 0 ? 'Please enter a valid price' : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitOrder,
                    child: const Text('Register Order'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _orders.isEmpty
                  ? const Center(child: Text('No orders registered yet.'))
                  : ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        return Card(
                          child: ListTile(
                            title: Text('${order.customerName} - ${order.itemName}'),
                            subtitle: Text('Qty: ${order.quantity}, Price: $${order.price.toStringAsFixed(2)}, Total: $${order.total.toStringAsFixed(2)}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _itemNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}