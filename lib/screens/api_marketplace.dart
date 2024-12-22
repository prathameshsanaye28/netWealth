// // lib/models/api_product.dart
// import 'package:flutter/material.dart';
// import 'package:netwealth_vjti/models/professional.dart' as ModelUser;

// class ApiProduct {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final String documentationUrl;
//   final List<String> features;

//   ApiProduct({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.documentationUrl,
//     required this.features,
//   });
// }

// // lib/services/payment_service.dart
// class PaymentService {
//   Future<bool> processPayment({
//     required String cardNumber,
//     required String expiryDate,
//     required String cvv,
//     required double amount,
//   }) async {
//     // Simulate payment processing delay
//     await Future.delayed(Duration(seconds: 2));
    
//     // Simple validation
//     if (cardNumber.length != 16) return false;
//     if (cvv.length != 3) return false;
    
//     // For demo purposes, consider payment successful if card number ends with '1234'
//     return cardNumber.endsWith('1234');
//   }
// }



// class MarketplaceScreen extends StatelessWidget {
//   final List<ApiProduct> apis = [
//     ApiProduct(
//       id: '1',
//       name: 'Payment Processing API',
//       description: 'Complete payment processing solution with fraud detection',
//       price: 99.99,
//       documentationUrl: 'https://api.example.com/docs/payment',
//       features: ['Real-time processing', 'Fraud detection', 'Multiple currencies'],
//     ),
//     ApiProduct(
//       id: '2',
//       name: 'KYC Verification API',
//       description: 'Verify customer identity with advanced KYC checks',
//       price: 149.99,
//       documentationUrl: 'https://api.example.com/docs/kyc',
//       features: ['ID verification', 'Face matching', 'Document validation'],
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('API Marketplace'),
//       ),
//       body: ListView.builder(
//         itemCount: apis.length,
//         itemBuilder: (context, index) {
//           final api = apis[index];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: ListTile(
//               title: Text(api.name),
//               subtitle: Text(api.description),
//               trailing: ElevatedButton(
//                 child: Text('\$${api.price.toString()}'),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PaymentScreen(product: api),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // lib/screens/payment_screen.dart
// class PaymentScreen extends StatefulWidget {
//   final ApiProduct product;

//   PaymentScreen({required this.product});

//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _cardNumberController = TextEditingController();
//   final _expiryDateController = TextEditingController();
//   final _cvvController = TextEditingController();
//   bool _isProcessing = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Purchase ${widget.product.name}',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _cardNumberController,
//                 decoration: InputDecoration(
//                   labelText: 'Card Number',
//                   hintText: '1234 5678 9012 3456',
//                 ),
//                 validator: (value) {
//                   if (value?.length != 16) {
//                     return 'Please enter a valid 16-digit card number';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _expiryDateController,
//                       decoration: InputDecoration(
//                         labelText: 'Expiry Date',
//                         hintText: 'MM/YY',
//                       ),
//                       validator: (value) {
//                         if (value?.isEmpty ?? true) {
//                           return 'Required';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: TextFormField(
//                       controller: _cvvController,
//                       decoration: InputDecoration(
//                         labelText: 'CVV',
//                         hintText: '123',
//                       ),
//                       validator: (value) {
//                         if (value?.length != 3) {
//                           return 'Invalid CVV';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               if (_isProcessing)
//                 Center(child: CircularProgressIndicator())
//               else
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     child: Text('Pay \$${widget.product.price}'),
//                     onPressed: () async {
//                       if (_formKey.currentState?.validate() ?? false) {
//                         setState(() => _isProcessing = true);
                        
//                         final paymentService = PaymentService();
//                         final success = await paymentService.processPayment(
//                           cardNumber: _cardNumberController.text,
//                           expiryDate: _expiryDateController.text,
//                           cvv: _cvvController.text,
//                           amount: widget.product.price,
//                         );
                        
//                         setState(() => _isProcessing = false);
                        
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               success
//                                   ? 'Payment successful!'
//                                   : 'Payment failed. Please try again.',
//                             ),
//                             backgroundColor: success ? Colors.green : Colors.red,
//                           ),
//                         );
                        
//                         if (success) {
//                           Navigator.pop(context);
//                         }
//                       }
//                     },
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// lib/main.dart
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/models/professional.dart' as ModelUser;
import 'package:netwealth_vjti/resources/firestore_methods.dart';
import 'package:netwealth_vjti/resources/user_provider.dart';
import 'package:provider/provider.dart';


// lib/models/api_model.dart
class ApiProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> features;
  String? purchasedByUserId;
  DateTime? purchaseDate;

  ApiProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
    this.purchasedByUserId,
    this.purchaseDate,
  });
}



// lib/providers/api_provider.dart
// class ApiProvider with ChangeNotifier {
//   final List<ApiProduct> _apis = [
//     ApiProduct(
//       id: '1',
//       name: 'Payment Processing API',
//       description: 'Complete payment processing solution with fraud detection',
//       price: 99.99,
//       features: ['Real-time processing', 'Fraud detection', 'Multiple currencies'],
//     ),
//     ApiProduct(
//       id: '2',
//       name: 'KYC Verification API',
//       description: 'Verify customer identity with advanced KYC checks',
//       price: 149.99,
//       features: ['ID verification', 'Face matching', 'Document validation'],
//     ),
//     ApiProduct(
//       id: '3',
//       name: 'Transaction Analytics API',
//       description: 'Advanced analytics and reporting for financial transactions',
//       price: 199.99,
//       features: ['Real-time analytics', 'Custom reports', 'Data visualization'],
//     ),
//   ];

//   final List<ApiProduct> _purchasedApis = [];

//   List<ApiProduct> get availableApis => _apis;
//   List<ApiProduct> getPurchasedApis(String userId) => 
//       _purchasedApis.where((api) => api.purchasedByUserId == userId).toList();

//   Future<void> purchaseApi(ApiProduct api, String userId) async {
//     final purchasedApi = ApiProduct(
//       id: api.id,
//       name: api.name,
//       description: api.description,
//       price: api.price,
//       features: api.features,
//       purchasedByUserId: userId,
//       purchaseDate: DateTime.now(),
//     );
//     _purchasedApis.add(purchasedApi);
//     notifyListeners();
//   }
// }
class ApiProvider with ChangeNotifier {
  final FireStoreMethods _firebaseService = FireStoreMethods();

  List<ApiProduct> _apis = [];
  List<ApiProduct> _purchasedApis = [];

  List<ApiProduct> get availableApis => _apis;

  // Fetch APIs from Firebase
  Future<void> fetchApis() async {
    try {
      _apis = await _firebaseService.fetchApis();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch APIs: $e');
    }
  }

  // Get purchased APIs for a specific user
  List<ApiProduct> getPurchasedApis(String userId) {
    return _apis.where((api) => api.purchasedByUserId?.contains(userId) ?? false).toList();
  }

  // Purchase an API
  Future<void> purchaseApi(ApiProduct api, String userId) async {
    await _firebaseService.purchaseApi(api, userId);

    // Optionally add to the local list if you need to display it
    _purchasedApis.add(ApiProduct(
      id: api.id,
      name: api.name,
      description: api.description,
      price: api.price,
      features: api.features,
      purchasedByUserId: userId,
      purchaseDate: DateTime.now(),
    ));

    // Refresh the list after purchase
    await fetchApis();
    notifyListeners();
  }
}

// lib/screens/marketplace_screen.dart
class MarketplaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApiProvider(),
      child: MarketplaceContent(),
    );
  }
}

// class MarketplaceContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;
//     final apiProvider = Provider.of<ApiProvider>(context);
//     final apis = apiProvider.availableApis;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('API Marketplace'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.shopping_bag),
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 builder: (context) => PurchasedApisSheet(),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: apis.length,
//         itemBuilder: (context, index) {
//           final api = apis[index];
//           return ApiCard(api: api);
//         },
//       ),
//     );
//   }
// }

// class MarketplaceContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;
//     final apiProvider = Provider.of<ApiProvider>(context);

//     // Fetch APIs from Firebase
//     if (apiProvider.availableApis.isEmpty) {
//       apiProvider.fetchApis();
//     }

//     final apis = apiProvider.availableApis;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('API Marketplace'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.shopping_bag),
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 builder: (context) => PurchasedApisSheet(),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: apis.length,
//         itemBuilder: (context, index) {
//           final api = apis[index];
//           return ApiCard(api: api);
//         },
//       ),
//     );
//   }
// }
class MarketplaceContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;
    final apiProvider = Provider.of<ApiProvider>(context);

    // Fetch APIs from Firebase if they're not already loaded
    if (apiProvider.availableApis.isEmpty) {
      apiProvider.fetchApis();
    }

    final apis = apiProvider.availableApis;

    return Scaffold(
      appBar: AppBar(
        title: Text('API Marketplace'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_bag),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => PurchasedApisSheet(),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: apis.length,
        itemBuilder: (context, index) {
          final api = apis[index];
          return ApiCard(api: api);
        },
      ),
    );
  }
}

// lib/widgets/api_card.dart
class ApiCard extends StatelessWidget {
  final ApiProduct api;

  const ApiCard({Key? key, required this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          api.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '\$${api.price.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.blue),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(api.description),
                SizedBox(height: 12),
                Text(
                  'Features:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...api.features.map((feature) => Padding(
                  padding: EdgeInsets.only(top: 4, left: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.green),
                      SizedBox(width: 8),
                      Text(feature),
                    ],
                  ),
                )),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: user != null
                        ? () => _handlePurchase(context, user)
                        : null,
                    child: Text('Purchase API'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handlePurchase(BuildContext context, ModelUser.Professional user) async {
    // Open the card payment screen
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardPaymentScreen(
          api: api,
          userId: user.id ?? '',
        ),
      ),
    );
  }
}
// class ApiCard extends StatelessWidget {
//   final ApiProduct api;

//   const ApiCard({Key? key, required this.api}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;

//     return Card(
//       margin: EdgeInsets.only(bottom: 16),
//       child: ExpansionTile(
//         title: Text(
//           api.name,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           '\$${api.price.toStringAsFixed(2)}',
//           style: TextStyle(color: Colors.blue),
//         ),
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(api.description),
//                 SizedBox(height: 12),
//                 Text(
//                   'Features:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 ...api.features.map((feature) => Padding(
//                   padding: EdgeInsets.only(top: 4, left: 8),
//                   child: Row(
//                     children: [
//                       Icon(Icons.check_circle, size: 16, color: Colors.green),
//                       SizedBox(width: 8),
//                       Text(feature),
//                     ],
//                   ),
//                 )),
//                 SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: user != null
//                         ? () => _handlePurchase(context, user)
//                         : null,
//                     child: Text('Purchase API'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handlePurchase(BuildContext context, ModelUser.Professional user) async {
//     // Open the dummy payment gateway screen
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DummyPaymentGatewayScreen(
//           api: api,
//           userId: user.id ?? '',
//         ),
//       ),
//     );
//   }
// }
// class ApiCard extends StatelessWidget {
//   final ApiProduct api;

//   const ApiCard({Key? key, required this.api}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;

//     return Card(
//       margin: EdgeInsets.only(bottom: 16),
//       child: ExpansionTile(
//         title: Text(
//           api.name,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           '\$${api.price.toStringAsFixed(2)}',
//           style: TextStyle(color: Colors.blue),
//         ),
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(api.description),
//                 SizedBox(height: 12),
//                 Text(
//                   'Features:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 ...api.features.map((feature) => Padding(
//                   padding: EdgeInsets.only(top: 4, left: 8),
//                   child: Row(
//                     children: [
//                       Icon(Icons.check_circle, size: 16, color: Colors.green),
//                       SizedBox(width: 8),
//                       Text(feature),
//                     ],
//                   ),
//                 )),
//                 SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: user != null
//                         ? () => _handlePurchase(context, user)
//                         : null,
//                     child: Text('Purchase API'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // void _handlePurchase(BuildContext context, ModelUser.Professional user) async {
//   //   final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    
//   //   // Show confirmation dialog
//   //   final confirmed = await showDialog<bool>(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: Text('Confirm Purchase'),
//   //       content: Text('Would you like to purchase ${api.name} for \$${api.price.toStringAsFixed(2)}?'),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context, false),
//   //           child: Text('Cancel'),
//   //         ),
//   //         ElevatedButton(
//   //           onPressed: () => Navigator.pop(context, true),
//   //           child: Text('Purchase'),
//   //         ),
//   //       ],
//   //     ),
//   //   );

//   //   if (confirmed == true) {
//   //     await apiProvider.purchaseApi(api, user!.id??'');
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('API purchased successfully!')),
//   //     );
//   //   }
//   // }
//   void _handlePurchase(BuildContext context, ModelUser.Professional user) async {
//   final apiProvider = Provider.of<ApiProvider>(context, listen: false);
  
//   // Show confirmation dialog
//   final confirmed = await showDialog<bool>(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Confirm Purchase'),
//       content: Text('Would you like to purchase ${api.name} for \$${api.price.toStringAsFixed(2)}?'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context, false),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () => Navigator.pop(context, true),
//           child: Text('Purchase'),
//         ),
//       ],
//     ),
//   );

//   if (confirmed == true) {
//     await apiProvider.purchaseApi(api, user.id ?? '');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('API purchased successfully!')),
//     );
//   }
// }
// }

// lib/widgets/purchased_apis_sheet.dart
// class PurchasedApisSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;
//     if (user == null) return SizedBox();

//     final purchasedApis = Provider.of<ApiProvider>(context).getPurchasedApis(user!.id??'');

//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'Your Purchased APIs',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               Spacer(),
//               IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           if (purchasedApis.isEmpty)
//             Center(child: Text('No purchased APIs yet'))
//           else
//             Expanded(
//               child: ListView.builder(
//                 itemCount: purchasedApis.length,
//                 itemBuilder: (context, index) {
//                   final api = purchasedApis[index];
//                   return Card(
//                     margin: EdgeInsets.only(bottom: 8),
//                     child: ListTile(
//                       title: Text(api.name),
//                       subtitle: Text(
//                         'Purchased on: ${api.purchaseDate?.toString().split(' ')[0] ?? 'N/A'}',
//                       ),
//                       trailing: Text(
//                         '\$${api.price.toStringAsFixed(2)}',
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
// class PurchasedApisSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;
//     if (user == null) return SizedBox();

//     final purchasedApis = Provider.of<ApiProvider>(context).getPurchasedApis(user.id ?? '');

//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'Your Purchased APIs',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               Spacer(),
//               IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           if (purchasedApis.isEmpty)
//             Center(child: Text('No purchased APIs yet'))
//           else
//             Expanded(
//               child: ListView.builder(
//                 itemCount: purchasedApis.length,
//                 itemBuilder: (context, index) {
//                   final api = purchasedApis[index];
//                   return Card(
//                     margin: EdgeInsets.only(bottom: 8),
//                     child: ListTile(
//                       title: Text(api.name),
//                       subtitle: Text(
//                         'Purchased on: ${api.purchaseDate?.toString().split(' ')[0] ?? 'N/A'}',
//                       ),
//                       trailing: Text(
//                         '\$${api.price.toStringAsFixed(2)}',
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

class PurchasedApisSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) return SizedBox();

    final apiProvider = Provider.of<ApiProvider>(context);

    // Filter APIs to show only those purchased by the current user
    final purchasedApis = apiProvider.getPurchasedApis(user.id ?? '');

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Your Purchased APIs',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (purchasedApis.isEmpty)
            Center(child: Text('No purchased APIs yet'))
          else
            Expanded(
              child: ListView.builder(
                itemCount: purchasedApis.length,
                itemBuilder: (context, index) {
                  final api = purchasedApis[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(api.name),
                      subtitle: Text(
                        'Purchased on: ${api.purchaseDate?.toString().split(' ')[0] ?? 'N/A'}',
                      ),
                      trailing: Text(
                        '\$${api.price.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}




class CardPaymentScreen extends StatefulWidget {
  final ApiProduct api;
  final String userId;

  CardPaymentScreen({required this.api, required this.userId});

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cardholderNameController = TextEditingController();

  String _paymentStatus = '';
  bool _isPaymentProcessed = false;

  // Function to simulate card payment validation
  void _processPayment() {
    setState(() {
      _isPaymentProcessed = true;
    });

    // Check if the card number ends with '1234'
    if (_cardNumberController.text.endsWith('1234')) {
      setState(() {
        _paymentStatus = 'Payment Successful';
      });

      // Simulate the purchase and update the API provider
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);
      apiProvider.purchaseApi(widget.api, widget.userId);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('API purchased successfully!')),
      );
    } else {
      setState(() {
        _paymentStatus = 'Payment Failed';
      });

      // Show a failure message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed. Card details are incorrect.')),
      );
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cvvController.dispose();
    _expiryDateController.dispose();
    _cardholderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Card Details for Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isPaymentProcessed)
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Card Number Input
                    TextFormField(
                      controller: _cardNumberController,
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a card number';
                        }
                        if (value.length != 16) {
                          return 'Card number must be 16 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // CVV Input
                    TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CVV';
                        }
                        if (value.length != 3) {
                          return 'CVV must be 3 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Expiry Date Input
                    TextFormField(
                      controller: _expiryDateController,
                      decoration: InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expiry date';
                        }
                        if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
                          return 'Invalid expiry date format (MM/YY)';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Cardholder Name Input
                    TextFormField(
                      controller: _cardholderNameController,
                      decoration: InputDecoration(
                        labelText: 'Cardholder Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter cardholder name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _processPayment();
                          }
                        },
                        child: Text('Pay \$${widget.api.price.toStringAsFixed(2)}'),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isPaymentProcessed)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _paymentStatus,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _paymentStatus == 'Payment Successful'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Go back to the previous screen
                      Navigator.pop(context);
                    },
                    child: Text('Back to Marketplace'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
