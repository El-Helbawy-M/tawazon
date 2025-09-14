import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FigmaUIScreen extends StatelessWidget {
  const FigmaUIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header with status bar and navigation
          _buildHeader(),
          
          // Main content
          Expanded(
            child: Column(
              children: [
                // Weather widget
                _buildWeatherWidget(),
                
                // Tournament schedule list
                Expanded(
                  child: _buildTournamentSchedule(),
                ),
              ],
            ),
          ),
          
          // Bottom tab navigation
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // iOS Status Bar
              Container(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '9:41',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.signal_cellular_4_bar, size: 17, color: Colors.black),
                        const SizedBox(width: 5),
                        Icon(Icons.wifi, size: 17, color: Colors.black),
                        const SizedBox(width: 5),
                        Container(
                          width: 24,
                          height: 12,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Navigation Bar
              Container(
                height: 56,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF161616),
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Color(0xFF161616),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.more_horiz,
                        color: Color(0xFF161616),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEEF6DA),
            Color(0xFFDDECB5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF546A1B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Today',
                      style: TextStyle(
                        fontFamily: 'Futura PT',
                        fontSize: 14,
                        color: Color(0xFF546A1B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '36°',
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 32,
                    color: Color(0xFF546A1B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                center: Alignment(-0.7, -0.76),
                radius: 0.8,
                colors: [
                  Color(0xFFFFE475),
                  Color(0xFFFFB029),
                  Color(0xFFFF9000),
                ],
                stops: [0.19, 0.53, 0.78],
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5.25,
                  left: 5.25,
                  child: Container(
                    width: 13.5,
                    height: 13.5,
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFFFE475),
                          Color(0xFFFFB029),
                          Color(0xFFFF9000),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 0.75,
                  left: 0.75,
                  child: Container(
                    width: 22.5,
                    height: 22.5,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFE475),
                          Color(0xFFFFBF29),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentSchedule() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agenda',
            style: TextStyle(
              fontFamily: 'Futura PT',
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: Color(0xFF161616),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildScheduleItem(
                  time: '08:00',
                  player1: 'Magnus Carlsen',
                  player2: 'Fabiano Caruana',
                  flagAsset: 'assets/images/flag_no.svg',
                  avatar1: 'assets/images/avatar_1.png',
                  avatar2: 'assets/images/avatar_2.png',
                ),
                _buildScheduleItem(
                  time: '10:00',
                  player1: 'Hikaru Nakamura',
                  player2: 'Ding Liren',
                  flagAsset: 'assets/images/flag_no.svg',
                  avatar1: 'assets/images/avatar_3.png',
                  avatar2: 'assets/images/avatar_4.png',
                ),
                _buildScheduleItem(
                  time: '12:00',
                  player1: 'Ian Nepomniachtchi',
                  player2: 'Alireza Firouzja',
                  flagAsset: 'assets/images/flag_no.svg',
                  avatar1: 'assets/images/avatar_5.png',
                  avatar2: 'assets/images/avatar_1.png',
                ),
                _buildScheduleItem(
                  time: '14:00',
                  player1: 'Wesley So',
                  player2: 'Maxime Vachier-Lagrave',
                  flagAsset: 'assets/images/flag_no.svg',
                  avatar1: 'assets/images/avatar_2.png',
                  avatar2: 'assets/images/avatar_3.png',
                ),
                _buildScheduleItem(
                  time: '16:00',
                  player1: 'Levon Aronian',
                  player2: 'Anish Giri',
                  flagAsset: 'assets/images/flag_no.svg',
                  avatar1: 'assets/images/avatar_4.png',
                  avatar2: 'assets/images/avatar_5.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required String time,
    required String player1,
    required String player2,
    required String flagAsset,
    required String avatar1,
    required String avatar2,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8E8E8),
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          // Time
          SizedBox(
            width: 60,
            child: Text(
              time,
              style: const TextStyle(
                fontFamily: 'Futura PT',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF384250),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Player info
          Expanded(
            child: Row(
              children: [
                // Avatar 1
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBBBBBB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 9),
                
                // Flag
                Container(
                  width: 16,
                  height: 11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 16,
                        height: 11,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD80027),
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 5.5,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E52B2),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 9),
                
                // Player names
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player1,
                        style: const TextStyle(
                          fontFamily: 'Futura PT',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF161616),
                        ),
                      ),
                      Text(
                        player2,
                        style: const TextStyle(
                          fontFamily: 'Futura PT',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF161616),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Avatar 2
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBBBBBB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, 'Home', true),
              _buildNavItem(Icons.calendar_today, 'Schedule', false),
              _buildNavItem(Icons.add_circle_outline, '', false),
              _buildNavItem(Icons.notifications_outlined, 'Alerts', false),
              _buildNavItem(Icons.person_outline, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: isSelected
              ? BoxDecoration(
                  color: const Color(0xFF9DA4AE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                )
              : null,
          child: Icon(
            icon,
            size: 24,
            color: isSelected ? const Color(0xFF161616) : const Color(0xFF9DA4AE),
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Futura PT',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isSelected ? const Color(0xFF161616) : const Color(0xFF9DA4AE),
            ),
          ),
        ],
      ],
    );
  }
}