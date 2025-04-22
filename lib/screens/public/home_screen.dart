import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:mi_app/widgets/appdrawer.dart'; 

class PublicHomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> images = [
    'assets/images/slide1.jpeg',
    'assets/images/slide2.jpeg',
    'assets/images/slide3.jpeg',
  ];

  final List<String> titles = const [
    'Prevención de Incendios',
    'Primeros Auxilios',
    'Preparación para Desastres',
  ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Defensa Civil'),
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: Swiper(
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildSlide(images[index], titles[index]);
              },
              autoplay: true,
              pagination: const SwiperPagination(),
              control: const SwiperControl(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(String image, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
