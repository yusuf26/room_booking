import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/login_page.dart';

class SideMenu extends StatefulWidget {
  // SideMenu();
  const SideMenu({Key? key}) : super(key: key);
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  _SideMenuState();

  String email = "";
  String token = "";
  String name = "";
  int? role_id;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        email = pref.getString("email")!;
        token = pref.getString("token")!;
        name = pref.getString("name")!;
        role_id = pref.getInt("role_id")!;
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const PageLogin(),
        ),
        (route) => false,
      );
    }
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("is_login");
      preferences.remove("email");
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const PageLogin(),
      ),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
        "Berhasil logout",
        style: TextStyle(fontSize: 16),
      )),
    );
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 6,
      child: Column(children: [
        UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/profile-user.png'))),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
          leading: const Icon(Icons.home),
          title: const Text(
            'Home',
            style: TextStyle(fontSize: 20),
          ),
        ),
        if (role_id != 3)
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/customer');
            },
            leading: const Icon(Icons.account_box),
            title: const Text(
              'Customer',
              style: TextStyle(fontSize: 20),
            ),
          ),
        if (role_id == 1)
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/user');
            },
            leading: const Icon(Icons.supervisor_account),
            title: const Text(
              'Users',
              style: TextStyle(fontSize: 20),
            ),
          ),
        if (role_id != 3)
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/room');
            },
            leading: const Icon(Icons.storage),
            title: const Text(
              'Room',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/booking');
          },
          leading: const Icon(Icons.sticky_note_2),
          title: const Text(
            'Booking',
            style: TextStyle(fontSize: 20),
          ),
        ),
        if (role_id == 1 || role_id == 3)
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/invoice');
            },
            leading: const Icon(Icons.attach_money),
            title: const Text(
              'Invoice',
              style: TextStyle(fontSize: 20),
            ),
          ),
        SizedBox(height: 30),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.exit_to_app),
                  label: Text('Sign Out'),
                  onPressed: () {
                    logOut();
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
