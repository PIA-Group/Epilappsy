import 'package:casia/BrainAnswer/ba_api.dart';
import 'package:casia/Models/seizure.dart';
import 'package:casia/Pages/AddSeizure/AddSeizurePage.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:casia/main.dart';

class NewSeizureTransitionPage extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  bool flag = true;

  Seizure seizure;
  bool switchPage = false;
  ValueNotifier<String> duration;
  NewSeizureTransitionPage({this.duration});

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return FutureBuilder(
      future: BAApi.getStudiesList(BAApi.loginToken),
      builder: (BuildContext context, snapshot) {
        if ((ConnectionState.active != null && !snapshot.hasData)) {
          return Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator())));
        } else if (!switchPage) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(AppLocalizations.of(context)
                                      .translate('was it one of your usual seizures').inCaps + '?',
                textAlign: TextAlign.center,
                style: MyTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DefaultColors.textColorOnDark)),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, position) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    child: position < snapshot.data.length
                        ? Text(
                            snapshot.data[position]['title'],
                            style: MyTextStyle(),
                          )
                        : Text(
                            AppLocalizations.of(context)
                                      .translate('no').inCaps + '! ' + AppLocalizations.of(context)
                                      .translate('new seizure type').inCaps,
                            style: MyTextStyle(),
                          ),
                    onPressed: () async {
                      //TODO: NEW SEIZURE TYPE
                      print('snapshot: ${snapshot.data[position]}');
                      Navigator.of(context).pop();
                      pushDynamicScreen(
                        context,
                        screen: NewSeizureTransitionPage2(
                            duration: duration, study: snapshot.data[position]),
                        withNavBar: false,
                      );

                      /* await BAApi.getJsonForm(
                              BAApi.loginToken, snapshot.data[position])
                          .then((form) {
                        seizure = Seizure.fromFieldData(form);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BAAddSeizurePage(
                                    duration: duration,
                                    seizure: seizure,
                                    formFields: form,
                                    seizureName: snapshot.data[position]
                                        ['title'])));
                      }); */
                    },
                  ),
                );
              },
              itemCount: snapshot.data.length + 1,
            ),
          ]);
        } else {
          return Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator())));
        }
      },
    );
  }
}

class NewSeizureTransitionPage2 extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  bool flag = true;

  dynamic study;
  Seizure seizure;
  ValueNotifier<String> duration;
  NewSeizureTransitionPage2({this.duration, this.study});

  Future<void> switchPage(BuildContext context) async {
    await BAApi.getJsonForm(BAApi.loginToken, study).then((form) {
      seizure = Seizure.fromFieldData(form);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BAAddSeizurePage(
                  duration: duration,
                  seizure: seizure,
                  formFields: form,
                  seizureName: study['title'])));
    });
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    switchPage(context);
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
            child: SizedBox(
                width: 50, height: 50, child: CircularProgressIndicator())));
  }
}
