import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String team1Name;
  final String team1LogoPath;
  final String team2Name;
  final String team2LogoPath;
  final DateTime matchDateTime;

  const MatchCard({
    Key? key,
    required this.team1Name,
    required this.team1LogoPath,
    required this.team2Name,
    required this.team2LogoPath,
    required this.matchDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the DateTime object
    final formattedDate =
        '${matchDateTime.day} ${matchDateTime.month.toString().padLeft(2, '0')}';
    final formattedTime =
        '${matchDateTime.hour.toString().padLeft(2, '0')}:${matchDateTime.minute.toString().padLeft(2, '0')} ${matchDateTime.hour >= 12 ? 'PM' : 'AM'}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/container_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Image.asset(team1LogoPath, height: 70),
              const SizedBox(height: 8),
              Text(
                team1Name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$formattedDate\n$formattedTime',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          Column(
            children: [
              Image.asset(team2LogoPath, height: 70),
              const SizedBox(height: 8),
              Text(
                team2Name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
