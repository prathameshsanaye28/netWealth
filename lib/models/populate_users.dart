import 'package:cloud_firestore/cloud_firestore.dart';

void populateFintechJobs() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  final List<Map<String, dynamic>> fintechJobs = [
    {
      'title': 'Senior Flutter Developer - Payment Systems',
      'company': 'PayTech Solutions',
      'jurisdiction': 'United States',
      'yearsExperienceRequired': 5,
      'requiredTechnicalSkills': [
        'Flutter', 'Dart', 'REST APIs', 'Payment Gateway Integration',
        'State Management', 'CI/CD', 'Unit Testing'
      ],
      'requiredRegulatoryExpertise': [
        'PCI DSS', 'PSD2', 'GDPR'
      ],
      'requiredFinancialStandards': [
        'ISO 20022', 'ISO 8583'
      ],
      'industryFocus': ['Digital Payments', 'Mobile Banking'],
      'description': 'Leading the development of our next-generation mobile payment platform using Flutter.',
      'postedDate': DateTime.now().toIso8601String(),
    },
    {
      'title': 'Mobile Developer - Digital Banking',
      'company': 'NeoBank Financial',
      'jurisdiction': 'United Kingdom',
      'yearsExperienceRequired': 3,
      'requiredTechnicalSkills': [
        'Flutter', 'Firebase', 'REST APIs', 'Bloc Pattern',
        'Biometric Authentication', 'SQLite'
      ],
      'requiredRegulatoryExpertise': [
        'FCA Regulations', 'Open Banking Standards'
      ],
      'requiredFinancialStandards': [
        'SWIFT', 'SEPA'
      ],
      'industryFocus': ['Digital Banking', 'Personal Finance'],
      'description': 'Join our team building the future of digital banking with innovative mobile solutions.',
      'postedDate': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    },
    {
      'title': 'Flutter Developer - Investment Platform',
      'company': 'WealthTech Innovations',
      'jurisdiction': 'Singapore',
      'yearsExperienceRequired': 4,
      'requiredTechnicalSkills': [
        'Flutter', 'WebSocket', 'Real-time Data Handling',
        'Charts and Graphics', 'State Management'
      ],
      'requiredRegulatoryExpertise': [
        'MAS Guidelines', 'Securities Regulations'
      ],
      'requiredFinancialStandards': [
        'FIX Protocol', 'Market Data Standards'
      ],
      'industryFocus': ['Investment Management', 'Trading Platforms'],
      'description': 'Develop sophisticated investment platform features for retail and institutional clients.',
      'postedDate': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
    },
    {
      'title': 'Senior Mobile Engineer - Cryptocurrency',
      'company': 'CryptoFin Technologies',
      'jurisdiction': 'European Union',
      'yearsExperienceRequired': 5,
      'requiredTechnicalSkills': [
        'Flutter', 'Blockchain Integration', 'Cryptography',
        'Secure Storage', 'Web3'
      ],
      'requiredRegulatoryExpertise': [
        'AMLD5', 'Cryptocurrency Regulations'
      ],
      'requiredFinancialStandards': [
        'ERC-20', 'Blockchain Standards'
      ],
      'industryFocus': ['Cryptocurrency', 'Blockchain'],
      'description': 'Build secure and scalable cryptocurrency wallet and trading applications.',
      'postedDate': DateTime.now().subtract(Duration(days: 4)).toIso8601String(),
    },
    {
      'title': 'Flutter Developer - InsurTech',
      'company': 'InsureDigital',
      'jurisdiction': 'Australia',
      'yearsExperienceRequired': 3,
      'requiredTechnicalSkills': [
        'Flutter', 'ML Integration', 'Camera APIs',
        'PDF Generation', 'State Management'
      ],
      'requiredRegulatoryExpertise': [
        'APRA Regulations', 'Insurance Laws'
      ],
      'requiredFinancialStandards': [
        'ACORD Standards', 'Insurance Data Standards'
      ],
      'industryFocus': ['Insurance', 'Risk Management'],
      'description': 'Develop innovative mobile solutions for insurance claim processing and policy management.',
      'postedDate': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
    },
    {
      'title': 'Mobile App Developer - Lending Platform',
      'company': 'LendTech Solutions',
      'jurisdiction': 'Canada',
      'yearsExperienceRequired': 4,
      'requiredTechnicalSkills': [
        'Flutter', 'REST APIs', 'OCR Integration',
        'Document Processing', 'Firebase'
      ],
      'requiredRegulatoryExpertise': [
        'FINTRAC Regulations', 'Lending Laws'
      ],
      'requiredFinancialStandards': [
        'Credit Scoring Standards', 'MISMO Standards'
      ],
      'industryFocus': ['Digital Lending', 'Credit Assessment'],
      'description': 'Create innovative lending solutions for our digital lending platform.',
      'postedDate': DateTime.now().subtract(Duration(days: 6)).toIso8601String(),
    },
    {
      'title': 'Senior Flutter Engineer - RegTech',
      'company': 'ComplianceTech',
      'jurisdiction': 'Hong Kong',
      'yearsExperienceRequired': 5,
      'requiredTechnicalSkills': [
        'Flutter', 'Machine Learning', 'Data Analytics',
        'Document Processing', 'Cloud Services'
      ],
      'requiredRegulatoryExpertise': [
        'HKMA Requirements', 'Financial Regulations'
      ],
      'requiredFinancialStandards': [
        'KYC Standards', 'AML Standards'
      ],
      'industryFocus': ['Regulatory Technology', 'Compliance'],
      'description': 'Build next-generation compliance and regulatory reporting solutions.',
      'postedDate': DateTime.now().subtract(Duration(days: 7)).toIso8601String(),
    },
    {
      'title': 'Flutter Developer - Digital Remittance',
      'company': 'RemitGlobal',
      'jurisdiction': 'United Arab Emirates',
      'yearsExperienceRequired': 3,
      'requiredTechnicalSkills': [
        'Flutter', 'Payment Integration', 'Geolocation',
        'Security Protocols', 'Performance Optimization'
      ],
      'requiredRegulatoryExpertise': [
        'UAE Central Bank Regulations', 'International Remittance Laws'
      ],
      'requiredFinancialStandards': [
        'SWIFT Standards', 'International Payment Standards'
      ],
      'industryFocus': ['Money Transfer', 'Cross-border Payments'],
      'description': 'Develop innovative mobile solutions for international money transfers.',
      'postedDate': DateTime.now().subtract(Duration(days: 8)).toIso8601String(),
    },
    {
      'title': 'Mobile Developer - Wealth Management',
      'company': 'WealthTech Advisors',
      'jurisdiction': 'Switzerland',
      'yearsExperienceRequired': 4,
      'requiredTechnicalSkills': [
        'Flutter', 'Portfolio Management',
        'Financial Charts', 'Data Visualization'
      ],
      'requiredRegulatoryExpertise': [
        'FINMA Regulations', 'Wealth Management Laws'
      ],
      'requiredFinancialStandards': [
        'Portfolio Management Standards', 'Investment Reporting Standards'
      ],
      'industryFocus': ['Wealth Management', 'Financial Advisory'],
      'description': 'Create sophisticated wealth management and portfolio tracking applications.',
      'postedDate': DateTime.now().subtract(Duration(days: 9)).toIso8601String(),
    },
    {
      'title': 'Senior Flutter Engineer - Open Banking',
      'company': 'OpenFin Solutions',
      'jurisdiction': 'Brazil',
      'yearsExperienceRequired': 5,
      'requiredTechnicalSkills': [
        'Flutter', 'API Integration', 'OAuth',
        'Banking APIs', 'Security Protocols'
      ],
      'requiredRegulatoryExpertise': [
        'Open Banking Regulations', 'Central Bank Requirements'
      ],
      'requiredFinancialStandards': [
        'Open Banking Standards', 'API Security Standards'
      ],
      'industryFocus': ['Open Banking', 'Financial Services'],
      'description': 'Lead the development of open banking solutions and API integrations.',
      'postedDate': DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
    },
    {
      'title': 'Flutter Developer - Personal Finance',
      'company': 'FinHealth',
      'jurisdiction': 'India',
      'yearsExperienceRequired': 3,
      'requiredTechnicalSkills': [
        'Flutter', 'Data Analytics',
        'Machine Learning', 'Cloud Services'
      ],
      'requiredRegulatoryExpertise': [
        'RBI Guidelines', 'Financial Advisory Regulations'
      ],
      'requiredFinancialStandards': [
        'Personal Finance Standards', 'Banking Standards'
      ],
      'industryFocus': ['Personal Finance', 'Financial Wellness'],
      'description': 'Build innovative personal finance management and budgeting tools.',
      'postedDate': DateTime.now().subtract(Duration(days: 11)).toIso8601String(),
    },
    {
      'title': 'Mobile Engineer - Trading Platform',
      'company': 'TradeX Financial',
      'jurisdiction': 'Japan',
      'yearsExperienceRequired': 4,
      'requiredTechnicalSkills': [
        'Flutter', 'Real-time Data',
        'WebSocket', 'Technical Analysis'
      ],
      'requiredRegulatoryExpertise': [
        'JFSA Regulations', 'Securities Trading Laws'
      ],
      'requiredFinancialStandards': [
        'Trading Standards', 'Market Data Standards'
      ],
      'industryFocus': ['Trading', 'Investment'],
      'description': 'Develop advanced trading platform features and real-time market data integration.',
      'postedDate': DateTime.now().subtract(Duration(days: 12)).toIso8601String(),
    },
    {
      'title': 'Senior Flutter Developer - Payment Gateway',
      'company': 'PaymentTech Solutions',
      'jurisdiction': 'Germany',
      'yearsExperienceRequired': 5,
      'requiredTechnicalSkills': [
        'Flutter', 'Payment Processing',
        'Security Protocols', 'API Integration'
      ],
      'requiredRegulatoryExpertise': [
        'BaFin Regulations', 'Payment Services Directive'
      ],
      'requiredFinancialStandards': [
        'Payment Card Standards', 'Security Standards'
      ],
      'industryFocus': ['Payment Processing', 'E-commerce'],
      'description': 'Lead the development of secure payment gateway solutions.',
      'postedDate': DateTime.now().subtract(Duration(days: 13)).toIso8601String(),
    },
    {
      'title': 'Flutter Engineer - Robo-Advisory',
      'company': 'RoboWealth',
      'jurisdiction': 'South Korea',
      'yearsExperienceRequired': 4,
      'requiredTechnicalSkills': [
        'Flutter', 'AI Integration',
        'Investment Algorithms', 'Data Analysis'
      ],
      'requiredRegulatoryExpertise': [
        'FSC Regulations', 'Investment Advisory Laws'
      ],
      'requiredFinancialStandards': [
        'Investment Management Standards', 'Algorithm Trading Standards'
      ],
      'industryFocus': ['Robo-Advisory', 'Investment Management'],
      'description': 'Develop automated investment advisory and portfolio management solutions.',
      'postedDate': DateTime.now().subtract(Duration(days: 14)).toIso8601String(),
    },
    {
      'title': 'Mobile Developer - Business Banking',
      'company': 'BusinessFin Solutions',
      'jurisdiction': 'France',
      'yearsExperienceRequired': 3,
      'requiredTechnicalSkills': [
        'Flutter', 'Enterprise Integration',
        'Banking APIs', 'Security'
      ],
      'requiredRegulatoryExpertise': [
        'AMF Regulations', 'Business Banking Laws'
      ],
      'requiredFinancialStandards': [
        'Business Banking Standards', 'Corporate Finance Standards'
      ],
      'industryFocus': ['Business Banking', 'Corporate Finance'],
      'description': 'Create innovative mobile solutions for business banking and corporate clients.',
      'postedDate': DateTime.now().subtract(Duration(days: 15)).toIso8601String(),
    },
  ];

  // Batch write to Firestore
  final WriteBatch batch = firestore.batch();
  
  for (var job in fintechJobs) {
    DocumentReference docRef = firestore.collection('jobs').doc();
    batch.set(docRef, job);
  }

  try {
    await batch.commit();
    print('Successfully added ${fintechJobs.length} fintech jobs to Firestore');
  } catch (e) {
    print('Error adding jobs to Firestore: $e');
  }
}