import 'package:epilappsy/Authentication/SignInQR.dart';
import 'package:epilappsy/BrainAnswer/ba_api.dart';
import 'package:epilappsy/Pages/NavigationPage.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import '../app_localizations.dart';

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
              errorText = "Algo correu mal...";
              break;
          }
          print(e);
          /* _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(errorText),
            ), 
          );*/
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
    return Scaffold(
      backgroundColor: Color.fromRGBO(71, 98, 123, 1),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Center(
              child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Container(
                  alignment: Alignment.topCenter,
                  height: 100,
                  child: RichText(
                    text: TextSpan(style: TextStyle(fontSize: 40), children: [
                      TextSpan(
                          text: 'Health',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      TextSpan(
                          text: 'Check',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color.fromRGBO(219, 213, 110, 1))),
                    ]),
                  ),
                ),
              ),
              Container(
                height: 20,
                child: Text(error,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    )),
              ),
              //SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Escreva o seu email ou telemóvel';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  labelText: 'Email/Telemóvel',
                ),
                controller: _loginFieldController,
              ),

              Padding(
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
              ),
              SizedBox(height: 20),
              TextFormField(
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Escreva a sua palavra-passe';
                    }
                    return null;
                  },
                  obscureText: !_showPassword,
                  controller: _passFieldController,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Palavra-passe',
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: _showPassword ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  )),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _login();

                  /* context
                      .read<AuthenticationService>()
                      .signIn(
                        email: email,
                        password: password,
                        thiscontext: context,
                      )
                      .then((value) {
                    error = value;
                    setState(() {});
                  }); */
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    height: 50,
                    width: MediaQuery.of(context).size.width - 48,
                    alignment: Alignment.center,
                    child: Text(
                        AppLocalizations.of(context).translate('Sign in'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))),
              ),
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.topLeft,
                  child: FlatButton(
                      child: Center(
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInQR()));
                      }))
            ],
          )),
        ),
      ),
    );
  }
}
