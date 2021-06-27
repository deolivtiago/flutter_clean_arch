import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';

import './login_presenter.dart';
import './components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingStream.listen((isLoading) {
            isLoading ? showLoading(context) : hideLoading(context);
          });

          widget.presenter.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context, error);
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Provider<LoginPresenter>(
                    create: (_) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          SizedBox(height: 8.0),
                          PasswordInput(),
                          SizedBox(height: 32.0),
                          LoginButton(),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.person),
                            label: Text('Criar Conta'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
