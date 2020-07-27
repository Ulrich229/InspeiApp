import 'package:flutter/material.dart';
import 'package:inspeiapp/providers/students.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/login_exception.dart';
import '../providers/lessons.dart';
import '../models/lesson.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/classroom-2787754_1280.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueGrey.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'My Journey',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: MediaQuery.of(context).size.height / 42,
                          fontFamily: 'Pcb',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'classe': '',
    'nom': '',
    'prenom': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<double> _opacity;
  Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _opacity = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller));
    _slide = Tween<Offset>(
            begin: Offset(
              0,
              -1.5,
            ),
            end: Offset(0, 0))
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller));
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            scrollable: true,
            elevation: 0.7,
            title: Text(
              '⛔ Connexion impossible',
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      print('Invalid');
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
      print("I'm true");
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        print("Start Loging in");
        try {
          final b = await Provider.of<Students>(context, listen: false)
              .fetchAndSetStudent(_authData['email']);
        } on LoginException catch (e) {
          throw e;
        } catch (e) {
          throw e;
        }
        try {
          final a = await Provider.of<Auth>(context, listen: false)
              .login(_authData['email'], _authData['password']);
          print("Loged in");
        } on LoginException catch (e) {
          print('Auth Login Exception');
          throw e;
        } catch (e) {
          print('Auth Exception');
          throw e;
        }
        /* }); */
      } else {
        final List<Lesson> lessons =
            Provider.of<Lessons>(context, listen: false)
                .lessons(_authData["classe"]);
        // Sign user up
        print("Start Singning up");
        try {
          final a = await Provider.of<Auth>(context, listen: false)
              .signup(_authData['email'], _authData['password']);
        } on LoginException catch (e) {
          print('Auth Login Exception');
          throw e;
        } catch (e) {
          print('Auth Exception');
          throw e;
        }
        try {
          final b =
              await Provider.of<Students>(context, listen: false).addStudent(
            _authData['nom'],
            _authData['prenom'],
            _authData['classe'],
            lessons,
            _authData['email'],
          );
        } on LoginException catch (e) {
          throw e;
        } catch (e) {
          throw e;
        }
        print("Signing up");
      }
    } on LoginException catch (error) {
      var errorMessage = 'Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage =
            'L\'adresse email que vous avez entré a déja été utilisée pour créer un compte';
      }
      if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'L\'adresse email que vous avez entré est invalide';
      }
      if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage =
            'Votre mot de passe est trop faible.\nIl serait très facile de le craquer\nVeuillez donc le changer pour plus de sécurité';
      }
      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage =
            "Aucun compte avec cette adresse email n'existe.\nVérifiez que l'adresse que vous avez entré est correcte.\nSi vous n'avez pas encore de compte créez-en un en cliquant sur 'Plutôt s'inscrire'";
      }
      if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = "Le mot de passe que vous avez entré n'est pas correct";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      print(error);
      var errorMessage =
          "Une erreur est survenue.\nVérifiez que vous avez bien accès à internet et rééssayez";
      /* "Vérifiez que:\n- Vous avez accès à internet\n- Vous avez entré une addresse email valide\n- Votre addresse email correspond à celle que vous avez utilisé lors de votre inscription(Mode Connexion uniquement)\n- Le mot de passe que vous avez entré est correct\n- L'addresse email que vous avez entré n'a pas encore été utilisée pour créer un compte";
      */
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
    print(_authMode);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 425 : 260,
          maxHeight: _authMode == AuthMode.Signup ? 700 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 30 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 82 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacity,
                    child: SlideTransition(
                      position: _slide,
                      child: Column(children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          constraints: BoxConstraints(
                            minHeight: _authMode == AuthMode.Signup ? 30 : 0,
                            maxHeight: _authMode == AuthMode.Signup ? 82 : 0,
                          ),
                          child: FadeTransition(
                            opacity: _opacity,
                            child: SlideTransition(
                              position: _slide,
                              child: Column(children: [
                                TextFormField(
                                  enabled: _authMode == AuthMode.Signup,
                                  decoration: InputDecoration(labelText: 'Nom'),
                                  onSaved: (value) {
                                    _authData['nom'] = value;
                                  },
                                  validator: _authMode == AuthMode.Signup
                                      ? (value) {
                                          if (value.isEmpty ||
                                              value.length < 3) {
                                            return 'Entrez un nom valide';
                                          }
                                        }
                                      : null,
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 30 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 82 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacity,
                    child: SlideTransition(
                      position: _slide,
                      child: Column(children: [
                        TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: InputDecoration(labelText: 'Prénom'),
                          onSaved: (value) {
                            _authData['prenom'] = value;
                          },
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value.isEmpty || value.length < 3) {
                                    return 'Entrez un prénom valide';
                                  } else if (value.contains(' ')) {
                                    return 'Veuillez entrer un seul prénom';
                                  }
                                }
                              : null,
                        ),
                      ]),
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Email invalide...';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Mot de passe trop court';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 30 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 82 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacity,
                    child: SlideTransition(
                      position: _slide,
                      child: Column(children: [
                        TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: InputDecoration(
                              labelText: 'Confirmer Mot de passe'),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Mots de passes incompatibles!';
                                  }
                                }
                              : null,
                        ),
                      ]),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 82 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacity,
                    child: SlideTransition(
                      position: _slide,
                      child: Column(children: [
                        TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: InputDecoration(labelText: 'Classe'),
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != 'CP1' && value != 'CP2') {
                                    return 'Entrez CP1 ou CP2';
                                  }
                                }
                              : null,
                          onSaved: (value) {
                            _authData['classe'] = value;
                          },
                        ),
                      ]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text(_authMode == AuthMode.Login
                            ? 'SE CONNECTER'
                            : "S'INSCRIRE"),
                        onPressed: _submit,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                      ),
                FlatButton(
                  child: Text(
                    'PLUTÔT ${_authMode == AuthMode.Login ? "S'INSCRIRE" : 'SE CONNECTER'}',
                    textAlign: TextAlign.center,
                  ),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
