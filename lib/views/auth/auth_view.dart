import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mvvm_architecture/di/injection.dart';
import 'package:mvvm_architecture/viewmodels/auth_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../utils/extensions/extensions.dart';

class AuthView extends ViewModelBuilderWidget<AuthViewModel> {
  @override
  bool get reactive => true;
  @override
  bool get initialiseSpecialViewModelsOnce => true;
  @override
  bool get disposeViewModel => false;
  @override
  Widget builder(BuildContext context, AuthViewModel model, Widget child) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          children: [
            Icon(
              FlutterIcons.fire_mco,
              color: Colors.deepOrange,
              size: 100.0,
            ),
            Text(
              model.isSignUp ? 'SignUp' : 'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .08),
            if (model.hasError)
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  model.modelError.toString(),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.red,
                  ),
                ),
              ),
            if (model.isSignUp == true) ...[
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                key: model.nameKey,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Name Must Not Be Empty';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
            ],
            Text(
              'Email',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              key: model.emailKey,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Email Must Not Be Empty';
                } else if (!value.isEmail) {
                  return 'Enter Valid Email';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'Password',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              key: model.passwordKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: model.togglePassword,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password Must Not Be Empty';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: model.togglePassword
                      ? Icon(
                          Icons.visibility,
                          color: Colors.deepOrange,
                        )
                      : Icon(
                          Icons.visibility_off,
                          color: Colors.deepOrange,
                        ),
                  onPressed: model.toggle,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: model.isSignUp ? model.signUp : model.login,
              child: model.busy("login")
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : Text(model.isSignUp ? 'Sign Up' : 'Login'),
            ),
            if (!model.isSignUp) ...[
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: model.googleSignIn,
                child: model.busy("google")
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(FlutterIcons.google_faw),
                          ),
                          Expanded(
                            child: Text(
                              'Login With Google',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
            const SizedBox(height: 40.0),
            TextButton(
              onPressed: model.toggleSignUp,
              child: Text(model.isSignUp ? 'Already Have an Account ? Log In' : 'Don\'t have an Account ? Create One'),
            )
          ],
        ),
      ),
    );
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => getIt<AuthViewModel>();
}
