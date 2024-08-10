import 'package:flutter/material.dart';

// CommonSettingsPage widget
class CommonSettingsPage extends StatelessWidget {
  final String shopName;
  final String bannerImage;

  CommonSettingsPage({
    required this.shopName,
    required this.bannerImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          Image.network(bannerImage),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              shopName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          // Add more settings options here
        ],
      ),
    );
  }
}

// Callback function to navigate to CommonSettingsPage
void onSettingsIconClicked(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CommonSettingsPage(
        shopName: 'My Shop',
        bannerImage: 'https://example.com/shop_banner.jpg',
      ),
    ),
  );
}
