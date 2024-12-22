import 'package:flutter/material.dart';
import 'dart:math' as math;

// Mock data models
class StockPrice {
  final DateTime time;
  final double open, high, low, close;

  StockPrice({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

class Transaction {
  final String type;
  final double price;
  final int shares;
  final DateTime timestamp;

  Transaction({
    required this.type,
    required this.price,
    required this.shares,
    required this.timestamp,
  });
}

class StockTradingDemo extends StatefulWidget {
  @override
  _StockTradingDemoState createState() => _StockTradingDemoState();
}

class _StockTradingDemoState extends State<StockTradingDemo> {
  // Mock data
  final String stockSymbol = "TECH";
  double currentPrice = 150.0;
  double accountBalance = 10000.0;
  int sharesOwned = 0;
  List<Transaction> transactions = [];
  List<StockPrice> priceHistory = [];
  String orderStatus = "";

  // Order form controls
  final TextEditingController sharesController = TextEditingController();
  String orderType = "Buy";

  @override
  void initState() {
    super.initState();
    // Generate mock price history
    generateMockPriceHistory();
  }

  void generateMockPriceHistory() {
    double basePrice = 150.0;
    final random = math.Random();
    DateTime now = DateTime.now();

    for (int i = 30; i >= 0; i--) {
      double volatility = random.nextDouble() * 5;
      double open = basePrice + (random.nextDouble() - 0.5) * volatility;
      double close = basePrice + (random.nextDouble() - 0.5) * volatility;
      double high = math.max(open, close) + random.nextDouble() * 2;
      double low = math.min(open, close) - random.nextDouble() * 2;

      priceHistory.add(StockPrice(
        time: now.subtract(Duration(days: i)),
        open: open,
        high: high,
        low: low,
        close: close,
      ));

      basePrice = close;
    }
    currentPrice = basePrice;
  }

  void executeOrder() {
    int shares = int.tryParse(sharesController.text) ?? 0;
    if (shares <= 0) {
      setState(() {
        orderStatus = "Invalid number of shares";
      });
      return;
    }

    double totalCost = shares * currentPrice;

    if (orderType == "Buy") {
      if (totalCost > accountBalance) {
        setState(() {
          orderStatus = "Insufficient funds";
        });
        return;
      }

      // Simulate order processing
      setState(() {
        orderStatus = "Processing buy order...";
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          accountBalance -= totalCost;
          sharesOwned += shares;
          transactions.add(Transaction(
            type: "Buy",
            price: currentPrice,
            shares: shares,
            timestamp: DateTime.now(),
          ));
          orderStatus = "Buy order completed";
          sharesController.clear();
        });
      });
    } else {
      if (shares > sharesOwned) {
        setState(() {
          orderStatus = "Insufficient shares";
        });
        return;
      }

      // Simulate order processing
      setState(() {
        orderStatus = "Processing sell order...";
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          accountBalance += totalCost;
          sharesOwned -= shares;
          transactions.add(Transaction(
            type: "Sell",
            price: currentPrice,
            shares: shares,
            timestamp: DateTime.now(),
          ));
          orderStatus = "Sell order completed";
          sharesController.clear();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Trading Demo'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Overview
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account Overview',
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 8),
                    Text('Balance: \$${accountBalance.toStringAsFixed(2)}'),
                    Text('Shares Owned: $sharesOwned'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Stock Info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$stockSymbol Stock',
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 8),
                    Text('Current Price: \$${currentPrice.toStringAsFixed(2)}'),

                    // Mock Candlestick Chart
                    Container(
                      height: 200,
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: CandlestickPainter(priceHistory),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Order Form
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Place Order',
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 16),

                    // Order Type Toggle
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment(value: 'Buy', label: Text('Buy')),
                        ButtonSegment(value: 'Sell', label: Text('Sell')),
                      ],
                      selected: {orderType},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          orderType = newSelection.first;
                        });
                      },
                    ),

                    SizedBox(height: 16),

                    // Shares Input
                    TextField(
                      controller: sharesController,
                      decoration: InputDecoration(
                        labelText: 'Number of Shares',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: 16),

                    // Order Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: executeOrder,
                        child: Text('Place ${orderType} Order'),
                      ),
                    ),

                    if (orderStatus.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          orderStatus,
                          style: TextStyle(
                            color: orderStatus.contains('completed')
                                ? Colors.green
                                : orderStatus.contains('Processing')
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Transaction History
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transaction History',
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 8),
                    ...transactions.reversed.map(
                      (transaction) => ListTile(
                        title: Text(
                            '${transaction.type} ${transaction.shares} shares'),
                        subtitle: Text(
                            'at \$${transaction.price.toStringAsFixed(2)} per share'),
                        trailing: Text(
                          transaction.timestamp.toString().split('.')[0],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for candlestick chart
class CandlestickPainter extends CustomPainter {
  final List<StockPrice> priceHistory;

  CandlestickPainter(this.priceHistory);

  @override
  void paint(Canvas canvas, Size size) {
    if (priceHistory.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double maxPrice =
        priceHistory.fold(0.0, (max, price) => math.max(max, price.high));
    double minPrice = priceHistory.fold(
        double.infinity, (min, price) => math.min(min, price.low));

    double priceRange = maxPrice - minPrice;
    double candleWidth = size.width / priceHistory.length;

    for (int i = 0; i < priceHistory.length; i++) {
      StockPrice price = priceHistory[i];
      double x = i * candleWidth + candleWidth / 2;

      // Calculate y coordinates
      double highY = size.height * (1 - (price.high - minPrice) / priceRange);
      double lowY = size.height * (1 - (price.low - minPrice) / priceRange);
      double openY = size.height * (1 - (price.open - minPrice) / priceRange);
      double closeY = size.height * (1 - (price.close - minPrice) / priceRange);

      // Draw price range line
      paint.color = Colors.grey;
      canvas.drawLine(
        Offset(x, highY),
        Offset(x, lowY),
        paint,
      );

      // Draw candle body
      paint.style = PaintingStyle.fill;
      paint.color = price.close > price.open ? Colors.green : Colors.red;
      canvas.drawRect(
        Rect.fromPoints(
          Offset(x - candleWidth / 4, openY),
          Offset(x + candleWidth / 4, closeY),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}