import 'package:flutter/material.dart';

class PaymentMethod {
  final String name;
  final double baseFee;
  final double percentageFee;
  final String icon;

  PaymentMethod({
    required this.name,
    required this.baseFee,
    required this.percentageFee,
    required this.icon,
  });
}

class PaymentSimulator extends StatefulWidget {
  @override
  _PaymentSimulatorState createState() => _PaymentSimulatorState();
}

class _PaymentSimulatorState extends State<PaymentSimulator> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0.0;
  PaymentMethod? _selectedMethod;
  String _currentStep = 'amount';
  bool _isProcessing = false;

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      name: 'Credit Card',
      baseFee: 0.30,
      percentageFee: 0.029,
      icon: '💳',
    ),
    PaymentMethod(
      name: 'Bank Transfer',
      baseFee: 0.25,
      percentageFee: 0.015,
      icon: '🏦',
    ),
    PaymentMethod(
      name: 'Digital Wallet',
      baseFee: 0.20,
      percentageFee: 0.02,
      icon: '📱',
    ),
  ];

  double _calculateFees(double amount, PaymentMethod method) {
    return method.baseFee + (amount * method.percentageFee);
  }

  Widget _buildAmountInput() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter Amount',
              prefixText: '\$',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
            onSaved: (value) {
              _amount = double.parse(value!);
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() {
                  _currentStep = 'method';
                });
              }
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelection() {
    return Column(
      children: [
        Text(
          'Select Payment Method',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 16),
        ..._paymentMethods.map((method) {
          final fees = _calculateFees(_amount, method);
          final total = _amount + fees;

          return Card(
            child: ListTile(
              leading: Text(
                method.icon,
                style: TextStyle(fontSize: 24),
              ),
              title: Text(method.name),
              subtitle: Text(
                'Fees: \$${fees.toStringAsFixed(2)} • Total: \$${total.toStringAsFixed(2)}',
              ),
              onTap: () {
                setState(() {
                  _selectedMethod = method;
                  _currentStep = 'confirm';
                });
              },
            ),
          );
        }).toList(),
        SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              _currentStep = 'amount';
            });
          },
          child: Text('Back'),
        ),
      ],
    );
  }

  Widget _buildConfirmation() {
    final fees = _calculateFees(_amount, _selectedMethod!);
    final total = _amount + fees;

    return Column(
      children: [
        Text(
          'Confirm Payment',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 24),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildConfirmationRow(
                    'Amount:', '\$${_amount.toStringAsFixed(2)}'),
                _buildConfirmationRow('Payment Method:',
                    '${_selectedMethod!.icon} ${_selectedMethod!.name}'),
                _buildConfirmationRow('Fees:', '\$${fees.toStringAsFixed(2)}'),
                Divider(),
                _buildConfirmationRow('Total:', '\$${total.toStringAsFixed(2)}',
                    isTotal: true),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
        if (!_isProcessing)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 'method';
                  });
                },
                child: Text('Back'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _simulatePayment,
                child: Text('Confirm Payment'),
              ),
            ],
          )
        else
          CircularProgressIndicator(),
      ],
    );
  }

  Widget _buildConfirmationRow(String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _simulatePayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _currentStep = 'success';
    });
  }

  Widget _buildSuccess() {
    return Column(
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 64,
        ),
        SizedBox(height: 16),
        Text(
          'Payment Simulated Successfully!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _amount = 0.0;
              _selectedMethod = null;
              _currentStep = 'amount';
            });
          },
          child: Text('Start New Payment'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Simulator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              Row(
                children: [
                  _buildStepIndicator('Amount', _currentStep == 'amount'),
                  _buildStepDivider(),
                  _buildStepIndicator('Method', _currentStep == 'method'),
                  _buildStepDivider(),
                  _buildStepIndicator('Confirm', _currentStep == 'confirm'),
                ],
              ),
              SizedBox(height: 32),
              // Current step content
              if (_currentStep == 'amount')
                _buildAmountInput()
              else if (_currentStep == 'method')
                _buildMethodSelection()
              else if (_currentStep == 'confirm')
                _buildConfirmation()
              else if (_currentStep == 'success')
                _buildSuccess(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Theme.of(context).primaryColor : Colors.grey,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider() {
    return Container(
      width: 40,
      height: 1,
      color: Colors.grey,
    );
  }
}