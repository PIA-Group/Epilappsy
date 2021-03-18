import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:epilappsy/Pages/Modules/ConnectedDevices.dart';

//for the dictionaries
import '../app_localizations.dart';

List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
  const StaggeredTile.count(2, 2),
  const StaggeredTile.count(2, 1),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(1, 1),
];

class ModulesPage extends StatefulWidget {
  final Widget child;

  ModulesPage({Key key, this.child}) : super(key: key);

  @override
  _ModulesPageState createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: StaggeredGridView.count(
              crossAxisCount: 4,
              staggeredTiles: _staggeredTiles,
              children: <Widget>[
                _ModuleTile(
                    Colors.green,
                    Icons.devices_other_rounded,
                    AppLocalizations.of(context).translate('Connected Devices'),
                    ConnectedDevicesPage()),
                _ModuleTile(
                    Colors.green,
                    Icons.local_hospital,
                    AppLocalizations.of(context).translate('Medication'),
                    ConnectedDevicesPage()),
                _ModuleTile(
                    Colors.green,
                    Icons.bedtime,
                    AppLocalizations.of(context).translate('Sleep'),
                    ConnectedDevicesPage()),
                _ModuleTile(
                    Colors.green,
                    Icons.food_bank_rounded,
                    AppLocalizations.of(context).translate('Food'),
                    ConnectedDevicesPage()),
              ],
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              padding: const EdgeInsets.all(4.0),
            )));
  }
}

class _ModuleTile extends StatelessWidget {
  _ModuleTile(this.backgroundColor, this.iconData, this.title, this.page);

  final Color backgroundColor;
  final IconData iconData;
  final String title;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return new Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: backgroundColor,
      child: new InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                iconData,
                color: Colors.white,
              ),
              Text(
                title,
                style: TextStyle(color: Colors.white),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
