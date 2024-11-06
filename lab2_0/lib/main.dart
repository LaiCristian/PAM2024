import 'package:flutter/material.dart';

void main() {
  runApp(AppWrapper());
}

class AppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Font',
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController carouselController = PageController();
  int activePageIndex = 0;

  @override
  void initState() {
    super.initState();
    carouselController.addListener(() {
      setState(() {
        activePageIndex = carouselController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              HeaderSection(),
              const SizedBox(height: 16),
              Image.asset(
                'assets/main_img2.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              SearchComponent(),
              const SizedBox(height: 16),
              SectionLabel(label: "Nearest Barbershop"),
              BarberList(
                barberData: [
                  BarberInfo(name: 'Alana Barbershop - Haircut massage & Spa', location: 'Banguntapan (5 km)', rating: 4.5, imagePath: 'assets/barb_1.png'),
                  BarberInfo(name: 'Hercha Barbershop - Haircut & Styling', location: 'Jalan Kaliurang (8 km)', rating: 5.0, imagePath: 'assets/barb_2.png'),
                  BarberInfo(name: 'Barberking - Haircut styling & massage', location: 'Jogja Expo Centre (12 km)', rating: 4.5, imagePath: 'assets/barb_3.png'),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: ActionButton(),
              ),
              const SizedBox(height: 16),
              SectionLabel(label: "Most Recommended"),
              BarberList(
                barberData: [
                  BarberInfo(name: 'Masterpiece Barbershop', location: 'Jogja Expo Centre (2 km)', rating: 5.0, imagePath: 'assets/barb_4.png', isRecommended: true),
                ],
              ),
              const SizedBox(height: 16),
              CarouselWidget(
                controller: carouselController,
                pageIndex: activePageIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF363062), width: 2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "See All",
            style: TextStyle(
              color: Color(0xFF363062),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_circle_right_outlined, color: Color(0xFF363062)),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF363062)),
            SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Yogyakarta', style: TextStyle(color: Colors.grey)),
                Text(
                  'Joe Samanta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
              ],
            ),
          ],
        ),
        CircleAvatar(
          radius: 23,
          backgroundImage: AssetImage('assets/prof_img.png'),
        ),
      ],
    );
  }
}

class SearchComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(color: Color(0xFF8683A1), fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search barber's, haircut service...",
              hintStyle: TextStyle(color: Color(0xFF8683A1), fontSize: 14),
              fillColor: Color(0xFFEBF0F5),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFC8D5E1)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Color(0xFF363062),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, size: 20),
            color: Colors.white,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String label;

  const SectionLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
      ],
    );
  }
}

class BarberInfo {
  final String name;
  final String location;
  final double rating;
  final String imagePath;
  final bool isRecommended;

  BarberInfo({
    required this.name,
    required this.location,
    required this.rating,
    required this.imagePath,
    this.isRecommended = false,
  });
}

class BarberList extends StatelessWidget {
  final List<BarberInfo> barberData;

  const BarberList({Key? key, required this.barberData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: barberData.map((barber) => BarberProfile(barber: barber)).toList(),
    );
  }
}

class BarberProfile extends StatelessWidget {
  final BarberInfo barber;

  const BarberProfile({Key? key, required this.barber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: barber.isRecommended
          ? buildRecommendedProfile()
          : buildStandardProfile(),
    );
  }

  Widget buildRecommendedProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.asset(
            barber.imagePath,
            width: double.infinity,
            height: 240,
            fit: BoxFit.cover,
          ),
        ),
        buildCardDetails(),
      ],
    );
  }

  Widget buildStandardProfile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            barber.imagePath,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: buildCardDetails()),
      ],
    );
  }

  Widget buildCardDetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(barber.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF8683A1), size: 14),
              Text(barber.location, style: const TextStyle(fontSize: 12, color: Color(0xFF8683A1))),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                index < barber.rating.round() ? Icons.star : Icons.star_border,
                color: Color(0xFFFEC107),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselWidget extends StatelessWidget {
  final PageController controller;
  final int pageIndex;

  const CarouselWidget({
    Key? key,
    required this.controller,
    required this.pageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: List.generate(5, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: pageIndex == index ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: pageIndex == index ? const Color(0xFF363062) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: SizedBox(
            height: 400,
            child: PageView.builder(
              controller: controller,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      child: BarberProfile(
                        barber: BarberInfo(
                          name: 'Varcity Barbershop',
                          location: 'Condongcatur (10 km)',
                          rating: 4.5,
                          imagePath: 'assets/barb_5.png',
                        ),
                      ),
                    ),
                    Expanded(
                      child: BarberProfile(
                        barber: BarberInfo(
                          name: 'Twinsky Monkey Barber',
                          location: 'Jl Taman Siswa (8 km)',
                          rating: 5.0,
                          imagePath: 'assets/barb_6.png',
                        ),
                      ),
                    ),
                    Expanded(
                      child: BarberProfile(
                        barber: BarberInfo(
                          name: 'Barberman',
                          location: 'J-Walk Centre (17 km)',
                          rating: 4.5,
                          imagePath: 'assets/barb_7.png',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
