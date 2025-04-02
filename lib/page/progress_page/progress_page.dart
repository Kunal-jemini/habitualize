import 'package:flutter/material.dart';
import 'widgets/summary_card.dart';
import 'widgets/habits_tab.dart';
import 'widgets/charts_tab.dart';
import 'widgets/insights_tab.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Main scroll controller
  late ScrollController _scrollController;

  // Track if we should show the scroll-to-top button
  bool _showScrollTopButton = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    // Initialize scroll controller
    _scrollController = ScrollController();

    // Add scroll listener to track position for scroll-to-top button
    _scrollController.addListener(() {
      setState(() {
        _showScrollTopButton = _scrollController.offset > 300;
      });
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll to top method
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // App Bar
                    _buildAppBarWidget(),

                    // Summary Cards
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildSummaryCards(),
                    ),

                    // Tab Bar
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.grey,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.green.shade600,
                              width: 3,
                            ),
                          ),
                        ),
                        tabs: const [
                          Tab(text: 'Habits'),
                          Tab(text: 'Charts'),
                          Tab(text: 'Insights'),
                        ],
                      ),
                    ),

                    // Tab Content
                    SizedBox(
                      height: 800, // Adjust this height based on your content
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: HabitsTab(),
                            ),
                          ),
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: ChartsTab(),
                            ),
                          ),
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: InsightsTab(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Scroll-to-top floating action button
              if (_showScrollTopButton)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: AnimatedOpacity(
                    opacity: _showScrollTopButton ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.green.shade600,
                      onPressed: _scrollToTop,
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarWidget() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.shade300,
            Colors.green.shade700,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -50,
            right: -20,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Title
          Positioned(
            bottom: 16,
            left: 16,
            child: const Text(
              'Your Progress',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Daily Streak',
                  value: '12 days',
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                  backgroundColor: Colors.orange.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: 'Completed',
                  value: '85%',
                  icon: Icons.task_alt,
                  color: Colors.green,
                  backgroundColor: Colors.green.withOpacity(0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Total Habits',
                  value: '24',
                  icon: Icons.format_list_bulleted,
                  color: Colors.blue,
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: 'Mood Average',
                  value: 'Good',
                  icon: Icons.sentiment_satisfied_alt,
                  color: Colors.purple,
                  backgroundColor: Colors.purple.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
