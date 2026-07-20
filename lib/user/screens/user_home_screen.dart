import 'package:flutter/material.dart';

import '../widgets/home/breaking_news_widget.dart';
import '../widgets/home/featured_markets_slider.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/live_markets_widget.dart';
import '../widgets/home/popular_markets_widget.dart';
import '../widgets/home/result_popup.dart';
import '../widgets/home/today_tips_widget.dart';
import '../widgets/home/upcoming_results_widget.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: SafeArea(
        child: Stack(
          children: [

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  /// Header
                  HomeHeader(),

                  SizedBox(height: 18),

                  /// Breaking News
                  BreakingNewsWidget(),

                  SizedBox(height: 20),

                  /// Featured Markets Slider
                  FeaturedMarketsSlider(),

                  SizedBox(height: 24),


                  /// Today's Tips
                  TodayTipsWidget(),

                  SizedBox(height: 24),
 PopularMarketsWidget(),
                   SizedBox(height: 24),

                  /// Live Markets
                  LiveMarketsWidget(),

                  SizedBox(height: 24),

                  /// Upcoming Results
                  UpcomingResultsWidget(),

                  SizedBox(height: 24),

                  /// Popular Markets
                 

                  

                  /// Recently Viewed
              

                  /// Next Results
                  

                ],
              ),
            ),

            /// Popup Overlay
            ResultPopup(),

          ],
        ),
      ),
    );
  }
}