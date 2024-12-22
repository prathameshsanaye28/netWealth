import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaxCalculator extends StatefulWidget {
  const TaxCalculator({Key? key}) : super(key: key);

  @override
  _TaxCalculatorState createState() => _TaxCalculatorState();
}

class _TaxCalculatorState extends State<TaxCalculator> {
  int currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController businessIncomeController =
      TextEditingController();
  final TextEditingController investmentIncomeController =
      TextEditingController();
  final TextEditingController mortgageInterestController =
      TextEditingController();
  final TextEditingController studentLoanInterestController =
      TextEditingController();
  final TextEditingController charitableDonationsController =
      TextEditingController();
  final TextEditingController retirementController = TextEditingController();
  final TextEditingController healthInsuranceController =
      TextEditingController();

  // Tax calculation results
  TaxCalculationResult? calculationResult;
  String paymentStatus = '';

  @override
  void dispose() {
    // Clean up controllers
    salaryController.dispose();
    businessIncomeController.dispose();
    investmentIncomeController.dispose();
    mortgageInterestController.dispose();
    studentLoanInterestController.dispose();
    charitableDonationsController.dispose();
    retirementController.dispose();
    healthInsuranceController.dispose();
    super.dispose();
  }

  // Calculate tax based on inputs
  void calculateTax() {
    double totalIncome = (double.tryParse(salaryController.text) ?? 0) +
        (double.tryParse(businessIncomeController.text) ?? 0) +
        (double.tryParse(investmentIncomeController.text) ?? 0);

    double totalDeductions =
        (double.tryParse(mortgageInterestController.text) ?? 0) +
            (double.tryParse(studentLoanInterestController.text) ?? 0) +
            (double.tryParse(charitableDonationsController.text) ?? 0) +
            (double.tryParse(retirementController.text) ?? 0) +
            (double.tryParse(healthInsuranceController.text) ?? 0);

    double taxableIncome =
        (totalIncome - totalDeductions).clamp(0, double.infinity);

    // Mock progressive tax calculation
    double taxOwed;
    if (taxableIncome <= 10000) {
      taxOwed = taxableIncome * 0.10;
    } else if (taxableIncome <= 40000) {
      taxOwed = 1000 + (taxableIncome - 10000) * 0.12;
    } else if (taxableIncome <= 85000) {
      taxOwed = 4600 + (taxableIncome - 40000) * 0.22;
    } else {
      taxOwed = 14500 + (taxableIncome - 85000) * 0.24;
    }

    double effectiveRate = (taxOwed / totalIncome * 100);

    calculationResult = TaxCalculationResult(
      totalIncome: totalIncome,
      totalDeductions: totalDeductions,
      taxableIncome: taxableIncome,
      taxOwed: taxOwed,
      effectiveRate: effectiveRate,
    );
  }

  // Process mock payment
  void processPayment() {
    setState(() {
      paymentStatus = 'processing';
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        paymentStatus = 'completed';
      });
    });
  }

  Widget buildIncomeStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Your Income',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          buildCurrencyTextField(
            controller: salaryController,
            label: 'Annual Salary',
          ),
          const SizedBox(height: 16),
          buildCurrencyTextField(
            controller: businessIncomeController,
            label: 'Business Income',
          ),
          const SizedBox(height: 16),
          buildCurrencyTextField(
            controller: investmentIncomeController,
            label: 'Investment Income',
          ),
        ],
      ),
    );
  }

  Widget buildDeductionsStep() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Your Deductions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          buildCurrencyTextField(
            controller: mortgageInterestController,
            label: 'Mortgage Interest',
          ),
          const SizedBox(height: 16),
          buildCurrencyTextField(
            controller: studentLoanInterestController,
            label: 'Student Loan Interest',
          ),
          const SizedBox(height: 16),
          buildCurrencyTextField(
            controller: charitableDonationsController,
            label: 'Charitable Donations',
          ),
          const SizedBox(height: 16),
          buildCurrencyTextField(
            controller: retirementController,
            label: '401(k) Contributions',
          ),
          const SizedBox(height: 16),
          buildCurrencyTextField(
            controller: healthInsuranceController,
            label: 'Health Insurance Premiums',
          ),
        ],
      ),
    );
  }

  Widget buildCalculationStep() {
    if (calculationResult == null) {
      return const Center(
        child: Text('Please complete previous steps to view calculation'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tax Calculation Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Income Breakdown',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                buildSummaryRow('Total Income', calculationResult!.totalIncome),
                buildSummaryRow(
                    'Total Deductions', calculationResult!.totalDeductions),
                buildSummaryRow(
                    'Taxable Income', calculationResult!.taxableIncome),
                const Divider(),
                Text('Tax Summary',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                buildSummaryRow(
                  'Tax Owed',
                  calculationResult!.taxOwed,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildSummaryRow(
                  'Effective Tax Rate',
                  calculationResult!.effectiveRate,
                  isPercentage: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPaymentStep() {
    if (calculationResult == null) {
      return const Center(
        child: Text('Please complete previous steps to proceed with payment'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Make Payment',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Total Amount Due',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${calculationResult!.taxOwed.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                if (paymentStatus.isEmpty)
                  ElevatedButton(
                    onPressed: processPayment,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Process Payment'),
                  )
                else if (paymentStatus == 'processing')
                  const Center(child: CircularProgressIndicator())
                else
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Payment Completed!',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCurrencyTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: '\$ ',
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
    );
  }

  Widget buildSummaryRow(String label, double value,
      {TextStyle? style, bool isPercentage = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            isPercentage
                ? '${value.toStringAsFixed(1)}%'
                : '\$${value.toStringAsFixed(2)}',
            style: style,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Calculator'),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < 3) {
            if (currentStep == 1) {
              calculateTax();
            }
            setState(() {
              currentStep++;
            });
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep--;
            });
          }
        },
        steps: [
          Step(
            title: const Text('Income'),
            content: buildIncomeStep(),
            isActive: currentStep >= 0,
          ),
          Step(
            title: const Text('Deductions'),
            content: buildDeductionsStep(),
            isActive: currentStep >= 1,
          ),
          Step(
            title: const Text('Calculation'),
            content: buildCalculationStep(),
            isActive: currentStep >= 2,
          ),
          Step(
            title: const Text('Payment'),
            content: buildPaymentStep(),
            isActive: currentStep >= 3,
          ),
        ],
      ),
    );
  }
}

// Model class for tax calculation results
class TaxCalculationResult {
  final double totalIncome;
  final double totalDeductions;
  final double taxableIncome;
  final double taxOwed;
  final double effectiveRate;

  TaxCalculationResult({
    required this.totalIncome,
    required this.totalDeductions,
    required this.taxableIncome,
    required this.taxOwed,
    required this.effectiveRate,
  });
}