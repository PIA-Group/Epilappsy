import 'package:epilappsy/Authentication/SignInQR.dart';
import 'package:epilappsy/BrainAnswer/ba_api.dart';
import 'package:epilappsy/Pages/NavigationPage.dart';
import 'package:epilappsy/app_localizations.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/curve_background.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password;
  String error = '';

  bool _loading = false;
  final TextEditingController _loginFieldController = TextEditingController();
  final TextEditingController _passFieldController = TextEditingController();
  bool _rememberEmail = true;

  BAApi baApi;
  bool _showPassword = false;

  Future<void> _login() async {
    print(_loginFieldController.text.trim());
    if (!_loading) {
      setState(() {
        _loading = true;
      });
      if (_formKey.currentState.validate()) {
        String _login = _loginFieldController.text.trim();
        String _pass = _passFieldController.text.trim();

        try {
          String loginToken = await BAApi.login(_login, _pass);
          print(loginToken);
          if (_rememberEmail)
            BAApi.rememberUsername(_login);
          else
            BAApi.forgetUsername();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NavigationPage(),
            ),
          );
        } catch (e) {
          String errorText;
          switch (e) {
            case 1:
              errorText = "Sem ligação à internet";
              break;
            case 2:
              errorText = "Demasido tempo sem resposta. Tem internet?";
              break;
            default:
              errorText = "Algo correu mal... Verifique o email e password";
              break;
          }
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorText),
            ),
          );
        }
      }

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    BAApi.getUsername().then((String data) {
      if (data != null && mounted)
        setState(() {
          _loginFieldController.text = data;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: DefaultColors.mainColor,
      body: CustomPaint(
        painter: CurveBackground(),
        child: Form(
          key: _formKey,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              //child: Center(
              child: ListView(
                //physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.02),
                    child: Image.asset(
                      'assets/full_logo.png',
                      height: height * 0.32,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  SizedBox(height: height * 0.15),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: MyTextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      isDense: true,
                      //labelText: 'Email',
                      hintText: 'Email',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    controller: _loginFieldController,
                  ),
                  /* Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("Lembrar email"),
                      Switch(
                        value: _rememberEmail,
                        onChanged: (bool value) {
                          setState(() {
                            _rememberEmail = value;
                          });
                        },
                      ),
                    ],
                  ),
                ), */
                  SizedBox(height: height * 0.02),
                  TextFormField(
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Escreva a sua palavra-passe';
                        }
                        return null;
                      },
                      obscureText: !_showPassword,
                      controller: _passFieldController,
                      style: MyTextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Palavra-passe',
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          MdiIcons.formTextboxPassword,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: _showPassword
                                ? DefaultColors.logoColor
                                : Colors.white,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() => _showPassword = !_showPassword);
                          },
                        ),
                      )),
                  SizedBox(height: height * 0.02),
                  Container(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _login(),
                      child: Text(
                        AppLocalizations.of(context).translate('Sign in'),
                        style:
                            MyTextStyle(color: DefaultColors.textColorOnLight),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignInQR()));
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('Or sign in with a QR code:'),
                                  style: MyTextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: Colors.white,
                                  size: 70,
                                )),
                          ],
                        )),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
