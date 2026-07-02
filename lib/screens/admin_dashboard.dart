import 'package:flutter/material.dart';

import 'markets_screen.dart';
import 'results_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() =>
      _AdminDashboardState();
}

class _AdminDashboardState
    extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<_DrawerItem> _items = [
    _DrawerItem(
      "Result Management",
      Icons.bar_chart_rounded,
    ),
    _DrawerItem(
      "Markets",
      Icons.storefront_rounded,
    ),
  ];

  final List<Widget> _pages = const [
    ResultsScreen(),
    MarketsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),

      body: SafeArea(
        child: Column(
          children: [

            _buildTopBar(),

            Expanded(
              child: AnimatedSwitcher(
                duration:
                    const Duration(milliseconds: 300),
                switchInCurve:
                    Curves.easeOutCubic,
                switchOutCurve:
                    Curves.easeInCubic,
                child: KeyedSubtree(
                  key: ValueKey(_selectedIndex),
                  child: _pages[_selectedIndex],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [

          Builder(
            builder: (context) {
              return InkWell(
                borderRadius:
                    BorderRadius.circular(14),
                onTap: () {
                  Scaffold.of(context)
                      .openDrawer();
                },
                child: Container(
                  padding:
                      const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(
                        0xffF4F5F8),
                    borderRadius:
                        BorderRadius.circular(
                            14),
                  ),
                  child: const Icon(
                    Icons.menu_rounded,
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 16),

          Expanded(
  child: Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [

      const Text(
        "Matka Admin",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -.5,
        ),
      ),

      const SizedBox(height: 2),

      Row(
        children: [

          Stack(
  children: [

    // Container(
    //   height: 50,
    //   width: 50,
    //   decoration: BoxDecoration(
    //     color: const Color(0xffF4F5F8),
    //     borderRadius:
    //         BorderRadius.circular(16),
    //   ),
    //   child: const Icon(
    //     Icons.notifications_none_rounded,
    //   ),
    // ),

    // Positioned(
    //   right: 8,
    //   top: 8,
    //   child: Container(
    //     height: 10,
    //     width: 10,
    //     decoration: BoxDecoration(
    //       color: Colors.red,
    //       borderRadius:
    //           BorderRadius.circular(20),
    //     ),
    //   ),
    // )

  ],
),
// const SizedBox(width: 12),

// Container(
//   height: 50,
//   width: 50,
//   decoration: BoxDecoration(
//     gradient: const LinearGradient(
//       colors: [
//         Color(0xff6A1B9A),
//         Color(0xff8E24AA),
//       ],
//     ),
//     borderRadius:
//         BorderRadius.circular(18),
//   ),
//   child: const Icon(
//     Icons.person,
//     color: Colors.white,
//   ),
// ),

        //   const SizedBox(width: 6),

        //   Text(
        //     _items[_selectedIndex].title,
        //     style: TextStyle(
        //       color: Colors.grey.shade600,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),

        ],
      ),

    ],
  ),
),

          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: const Color(
                  0xffF4F5F8),
              borderRadius:
                  BorderRadius.circular(
                      14),
            ),
            child: const Icon(
              Icons.notifications_none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: 310,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight:
              Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [

            Container(
              margin:
                  const EdgeInsets.all(18),
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xff6A1B9A),
                    Color(0xff8E24AA),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(
                        22),
              ),
              child: const Row(
                children: [

                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        Colors.white,
                    child: Icon(
                      Icons
                          .admin_panel_settings_rounded,
                      size: 34,
                      color:
                          Color(0xff6A1B9A),
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [

                        Text(
                          "Matka Admin",
                          style: TextStyle(
                            color:
                                Colors.white,
                            fontSize: 22,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Administrator",
                          style: TextStyle(
                            color:
                                Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
  ),
  child: Row(
    children: [

      Text(
        "Dashboard",
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),

      const Spacer(),

      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: const Text(
          "v1.0",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    ],
  ),
),

const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(
                        horizontal: 12),
                itemCount: _items.length,
                itemBuilder:
                    (context, index) {
                  final item =
                      _items[index];

                  final selected =
                      index ==
                          _selectedIndex;

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                            bottom: 8),
                    child: AnimatedContainer(
                      duration:
                          const Duration(
                              milliseconds:
                                  250),
                          decoration: BoxDecoration(
  gradient: selected
      ? const LinearGradient(
          colors: [
            Color(0xff6A1B9A),
            Color(0xff8E24AA),
          ],
        )
      : null,
  color:
      selected ? null : Colors.transparent,
  borderRadius:
      BorderRadius.circular(18),
),
                      child: ListTile(
  shape: RoundedRectangleBorder(
    borderRadius:
        BorderRadius.circular(18),
  ),
  leading: AnimatedContainer(
    duration:
        const Duration(milliseconds: 250),
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      color: selected
          ? Colors.white24
          : Colors.grey.shade100,
      borderRadius:
          BorderRadius.circular(14),
    ),
    child: Icon(
      item.icon,
      color: selected
          ? Colors.white
          : Colors.deepPurple,
    ),
  ),
  title: Text(
    item.title,
    style: TextStyle(
      color: selected
          ? Colors.white
          : Colors.black87,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    ),
  ),
  trailing: selected
      ? const Icon(
          Icons.chevron_right_rounded,
          color: Colors.white,
        )
      : null,
  onTap: () {
    Navigator.pop(context);

    setState(() {
      _selectedIndex = index;
    });
  },
),
                    ),
                  );
                },
              ),
            ),

           Container(
  margin: const EdgeInsets.all(18),
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius:
        BorderRadius.circular(18),
  ),
  child: Row(
    children: [

      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.workspace_premium,
          color: Colors.white,
        ),
      ),

      const SizedBox(width: 14),

      const Expanded(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              "Matka Admin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2),

            Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

          ],
        ),
      ),

    ],
  ),
),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem {
  final String title;
  final IconData icon;

  _DrawerItem(
    this.title,
    this.icon,
  );
}