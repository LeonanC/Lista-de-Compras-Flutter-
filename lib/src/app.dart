import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_compras_app/src/infra/res/internationalization.gen.dart';
import 'package:lista_compras_app/src/internationalization.dart';
import 'package:lista_compras_app/src/pages/login.dart';
import 'package:lista_compras_app/src/pages/vendor.dart';
import 'package:lista_compras_app/src/routes.dart';
import 'package:lista_compras_app/src/utils/widgets.dart';
export 'package:intl/intl.dart' show DateFormat;
export 'package:intl/intl.dart' show NumberFormat;
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ThemeProvider(
      initTheme: kDarkTheme,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            supportedLocales: Intl.suportedLocales,
            localizationsDelegates: [
              InternationalizationDelegate(
                translationsPath: Intl.stringsPath,
                suportedLocales: Intl.suportedLocales,
                files: Intl.files,
              ),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            
            debugShowCheckedModeBanner: false,
            home: Login(),
            onGenerateRoute: Routes.materialRoutes,
            theme: ThemeProvider.of(context),
          );
        }
      ),
    );    
  }
}

Widget loadingScreen(bool isIOS){
    return (isIOS)
    ? CupertinoPageScaffold(child: Center(child: CupertinoActivityIndicator()))
    : Scaffold(body: Center(child: CircularProgressIndicator()));
  }