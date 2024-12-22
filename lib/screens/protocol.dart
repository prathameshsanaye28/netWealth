import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Hotel {
  final String name;

  Hotel({
    required this.name,
  });
}

class APIMarket extends StatefulWidget {
  const APIMarket({Key? key}) : super(key: key);

  @override
  _APIMarketState createState() => _APIMarketState();
}

class _APIMarketState extends State<APIMarket> {
  List<Hotel> hotels = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  Future<void> fetchHotels() async {
    try {
      final url = Uri.parse(
          'https://nordigen.medium.com/list-of-all-banking-apis-updated-3bb6029a0033');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      dom.Document html = dom.Document.html(response.body);

      final titles = html
          .querySelectorAll('[id="78c8"] > strong')
          .map((element) => element.innerHtml.trim())
          .toList();

      print('Titles found: ${titles.length}');

      List<Hotel> fetchedHotels =
          titles.map((title) => Hotel(name: title)).toList();

      setState(() {
        hotels = fetchedHotels;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching APIs: $e');
      setState(() {
        errorMessage = 'Error fetching APIs. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial API MarketPlace'),
        backgroundColor: Color.fromRGBO(224, 226, 248, 1),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(224, 226, 248, 1),
              Color.fromRGBO(200, 202, 240, 1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hotels.isEmpty
                      ? Center(child: Text('No APIs found'))
                      : HotelList(hotels: hotels),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelList extends StatelessWidget {
  final List<Hotel> hotels;

  const HotelList({Key? key, required this.hotels}) : super(key: key);

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(
        'https://nordigen.medium.com/list-of-all-banking-apis-updated-3bb6029a0033');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: _launchURL,
                          child: Text(
                            hotel.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}