import 'package:flutter/material.dart';

void main() {
  runApp(const KiliKiliApp());
}

class KiliKiliApp extends StatelessWidget {
  const KiliKiliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KiliKili',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const KiliKiliShell(),
    );
  }
}

class KiliKiliShell extends StatefulWidget {
  const KiliKiliShell({super.key});

  @override
  State<KiliKiliShell> createState() => _KiliKiliShellState();
}

class _KiliKiliShellState extends State<KiliKiliShell> {
  int index = 0;

  final pages = const [
    HomePage(),
    SearchPage(),
    CreatePage(),
    ReelsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.add_box_outlined), selectedIcon: Icon(Icons.add_box), label: 'Create'),
          NavigationDestination(icon: Icon(Icons.video_library_outlined), selectedIcon: Icon(Icons.video_library), label: 'Reels'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ---------------- HOME ----------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('KiliKili', style: TextStyle(fontWeight: FontWeight.w800)),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage())),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 105,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                scrollDirection: Axis.horizontal,
                children: const [
                  StoryAvatar(name: 'Your Story', own: true),
                  StoryAvatar(name: 'Priya'),
                  StoryAvatar(name: 'Rahul'),
                  StoryAvatar(name: 'Neha'),
                  StoryAvatar(name: 'Tapan'),
                  StoryAvatar(name: 'Rinku'),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: FeedPost(
            username: '@tapanmajhi',
            location: 'Koraput, Odisha',
            caption: 'Beautiful Odisha ❤️ #Odisha #Koraput',
            image: 'https://images.unsplash.com/photo-1500534623283-312aade485b7?w=900',
          )),
          const SliverToBoxAdapter(child: FeedPost(
            username: '@kilikili_creator',
            location: 'India',
            caption: 'Create. Share. Discover. Earn. 🐦',
            image: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=900',
          )),
          const SliverToBoxAdapter(child: FeedPost(
            username: '@odia_music',
            location: 'Odisha',
            caption: 'New music coming soon 🎵',
            image: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=900',
          )),
        ],
      ),
    );
  }
}

class StoryAvatar extends StatelessWidget {
  final String name;
  final bool own;
  const StoryAvatar({super.key, required this.name, this.own = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.pink, Colors.orange, Colors.indigo]),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              child: own ? const Icon(Icons.add, size: 28) : Text(name.substring(0, 1)),
            ),
          ),
          const SizedBox(height: 5),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class FeedPost extends StatefulWidget {
  final String username, location, caption, image;
  const FeedPost({super.key, required this.username, required this.location, required this.caption, required this.image});

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  bool liked = false;
  bool saved = false;
  int likes = 1240;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(widget.location),
            trailing: const Icon(Icons.more_horiz),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              widget.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade200,
                child: const Center(child: Icon(Icons.image_not_supported, size: 50)),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  liked = !liked;
                  likes += liked ? 1 : -1;
                }),
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.red : null),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.comment_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send_outlined)),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => saved = !saved),
                icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
            child: Text('$likes likes', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
            child: Text(widget.caption),
          ),
        ],
      ),
    );
  }
}

// ---------------- SEARCH ----------------

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search people, reels, hashtags, products',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
              ),
            ),
          ),
          const ListTile(title: Text('Trending'), subtitle: Text('#Odisha   #Koraput   #Dhemsa   #KiliKili')),
          const Expanded(
            child: Center(child: Text('Search results will appear here')),
          ),
        ],
      ),
    );
  }
}

// ---------------- CREATE ----------------

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Create', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          CreateTile(icon: Icons.photo, title: 'Photo Post', onTap: () {}),
          CreateTile(icon: Icons.videocam, title: 'Video Post', onTap: () {}),
          CreateTile(icon: Icons.video_library, title: 'Reel', onTap: () {}),
          CreateTile(icon: Icons.auto_stories, title: 'Story', onTap: () {}),
          CreateTile(icon: Icons.shopping_bag, title: 'Product Listing', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopPage()));
          }),
        ],
      ),
    );
  }
}

class CreateTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const CreateTile({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

// ---------------- REELS ----------------

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (_, i) => Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            [
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=900',
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=900',
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=900',
              'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=900',
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=900',
            ][i],
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(
                  child: Text(
                    '@kilikili_creator\nBeautiful moment ❤️ #KiliKili #Reels',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Column(
                  children: [
                    _ReelAction(icon: Icons.favorite, text: '12K'),
                    _ReelAction(icon: Icons.comment, text: '342'),
                    _ReelAction(icon: Icons.send, text: 'Share'),
                    _ReelAction(icon: Icons.bookmark, text: 'Save'),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ReelAction extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ReelAction({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(children: [
        Icon(icon, color: Colors.white, size: 30),
        Text(text, style: const TextStyle(color: Colors.white)),
      ]),
    );
  }
}

// ---------------- PROFILE ----------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 45, child: Icon(Icons.person, size: 45)),
              const SizedBox(width: 22),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stat(value: '245', label: 'Posts'),
                    Stat(value: '1.2K', label: 'Followers'),
                    Stat(value: '428', label: 'Following'),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 14),
          const Text('Tapan Majhi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Text('@tapanmajhi'),
          const Text('Create • Share • Discover • Earn 🐦\nOdisha | Creator'),
          const SizedBox(height: 15),
          FilledButton(onPressed: () {}, child: const Text('Edit Profile')),
          const SizedBox(height: 10),
          ProfileMenu(icon: Icons.analytics, title: 'Creator Studio', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatorStudioPage()));
          }),
          ProfileMenu(icon: Icons.shopping_bag, title: 'KiliKili Shop', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopPage()));
          }),
          ProfileMenu(icon: Icons.account_balance_wallet, title: 'Wallet & Payout', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PayoutPage()));
          }),
          ProfileMenu(icon: Icons.settings, title: 'Settings', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
          }),
        ],
      ),
    );
  }
}

class Stat extends StatelessWidget {
  final String value, label;
  const Stat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    Text(label, style: const TextStyle(color: Colors.grey)),
  ]);
}

class ProfileMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const ProfileMenu({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

// ---------------- SHOP ----------------

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      ['T-Shirt', '\$12.99', 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500'],
      ['Backpack', '\$24.99', 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500'],
      ['Sneakers', '\$49.99', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500'],
      ['Smart Watch', '\$59.99', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500'],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('KiliKili Shop')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: .72, crossAxisSpacing: 10, mainAxisSpacing: 10,
        ),
        itemBuilder: (_, i) => Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Image.network(products[i][2], fit: BoxFit.cover, width: double.infinity)),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                child: Text(products[i][0], style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(products[i][1]),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Add to Cart'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- CREATOR STUDIO ----------------

class CreatorStudioPage extends StatelessWidget {
  const CreatorStudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creator Studio')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Creator Dashboard', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          const SizedBox(height: 15),
          const Row(children: [
            Expanded(child: MetricCard(title: 'Followers', value: '1,245')),
            SizedBox(width: 10),
            Expanded(child: MetricCard(title: 'Views', value: '245K')),
          ]),
          const SizedBox(height: 10),
          const Row(children: [
            Expanded(child: MetricCard(title: 'Likes', value: '18.5K')),
            SizedBox(width: 10),
            Expanded(child: MetricCard(title: 'Watch Time', value: '12,500 min')),
          ]),
          const SizedBox(height: 15),
          Card(
            child: ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Estimated Earnings'),
              subtitle: const Text('\$24.50 USD'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayoutPage())),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.verified, color: Colors.green),
              title: Text('Monetization'),
              subtitle: Text('Active'),
            ),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () {},
            child: const Text('View Monetization Requirements'),
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title, value;
  const MetricCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
      ]),
    ),
  );
}

// ---------------- PAYOUT ----------------

class PayoutPage extends StatelessWidget {
  const PayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet & Payout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: const [
                Text('Available Balance', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 5),
                Text('\$32.50 USD', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          const ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Bank Account'),
            subtitle: Text('Minimum payout: \$25'),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
          const ListTile(
            leading: Icon(Icons.payment),
            title: Text('PayPal'),
            subtitle: Text('Minimum payout: \$100'),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
          const SizedBox(height: 15),
          FilledButton(
            onPressed: () => _showPayoutDialog(context),
            child: const Text('Request Payout'),
          ),
          const SizedBox(height: 20),
          const Text('Payout History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const ListTile(title: Text('\$30.00'), subtitle: Text('Processing'), trailing: Text('Today')),
          const ListTile(title: Text('\$45.00'), subtitle: Text('Paid'), trailing: Text('06 Sep')),
          const ListTile(title: Text('\$25.00'), subtitle: Text('Paid'), trailing: Text('18 Aug')),
        ],
      ),
    );
  }

  static void _showPayoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payout Verification'),
        content: const Text(
          'Before a real payout can be requested, KiliKili will verify identity, tax information and the selected payment account.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

// ---------------- CHAT ----------------

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final names = ['Priya', 'Rahul', 'Family Group', 'Friends Group', 'Neha', 'Tapan'];
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (_, i) => ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(names[i]),
          subtitle: Text(i.isEven ? 'Typing...' : 'See you soon!'),
          trailing: const Text('2m'),
          onTap: () {},
        ),
      ),
    );
  }
}

// ---------------- NOTIFICATIONS ----------------

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      'Tapan liked your post ❤️',
      'Rahul started following you 👤',
      'Priya commented on your Reel 💬',
      'You received a new message 💌',
      'Your product was purchased 🛍️',
      'Your payout is processing 💰',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (_, i) => ListTile(
          leading: CircleAvatar(child: Icon(i == 5 ? Icons.payments : Icons.notifications)),
          title: Text(notifications[i]),
          subtitle: const Text('Recently'),
        ),
      ),
    );
  }
}

// ---------------- SETTINGS ----------------

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      [Icons.person, 'Account'],
      [Icons.lock_outline, 'Privacy'],
      [Icons.security, 'Security'],
      [Icons.notifications, 'Notifications'],
      [Icons.language, 'Language'],
      [Icons.block, 'Blocked Accounts'],
      [Icons.monetization_on, 'Monetization'],
      [Icons.analytics, 'Analytics'],
      [Icons.help_outline, 'Help & Support'],
      [Icons.description, 'Terms & Privacy'],
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: items.map((item) => ListTile(
          leading: Icon(item[0] as IconData),
          title: Text(item[1] as String),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        )).toList(),
      ),
    );
  }
}
