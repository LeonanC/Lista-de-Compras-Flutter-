import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lista_compras_app/src/pages/home.dart';
import 'package:lista_compras_app/src/pages/preco.dart';
import 'package:lista_compras_app/src/pages/profile.dart';

abstract class BaseStyles{

  static double get borderRadius => 25.0;
  static double get borderWidth => 2.0;
  static double get listFieldHorizontal => 25.0;
  static double get listFieldVertical => 8.0;
  static double get animationOffset => 2.0;
  static EdgeInsets get listPadding {
    return EdgeInsets.symmetric(horizontal: listFieldHorizontal, vertical: listFieldVertical);
  }
  static List<BoxShadow> get boxShadow {
    return [
      BoxShadow(
        color: AppColors.darkgray.withOpacity(.5),
        offset: Offset(1.0, 2.0),
        blurRadius: 2.0,
      ),
    ];
  }

  static List<BoxShadow> get boxShadowPressed {
    return [
      BoxShadow(
        color: AppColors.darkgray.withOpacity(.5),
        offset: Offset(1.0, 1.0),
        blurRadius: 1.0,
      ),
    ];
  }

   static Widget iconPrefix(IconData icon){
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Icon(
        icon,
        size: 35.0,
        color: AppColors.lightblue,
      ),
    );
  }
}

abstract class AppAlerts {

  static Future<void> showErrorDialog(BuildContext context, String errorMessage) async {

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          title: Text('Error', style: TextStyles.subtitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorMessage, style: TextStyles.body),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay', style: TextStyles.body),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
    );

  }
}

class AppButton extends StatefulWidget {
  final String buttonText;
  final ButtonType buttonType;
  final void Function() onPressed;

  AppButton({
    @required this.buttonText,
    this.buttonType,
    this.onPressed,
  });
  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    TextStyle fontStyle;
    Color buttonColor;

    switch(widget.buttonType){
      case ButtonType.Straw:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.straw;
      break;
      case ButtonType.LightBlue:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightblue;
      break;
      case ButtonType.DarkBlue:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.darkblue;
      break;
      case ButtonType.Disabled:
        fontStyle = TextStyles.buttonTextDark;
        buttonColor = AppColors.lightgray;
      break;
      case ButtonType.DarkGrey:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.darkgray;
      break;
      default:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightblue;
        break;
    }

    return AnimatedContainer(
      padding: EdgeInsets.only(
        top: (pressed) ? BaseStyles.listFieldVertical + BaseStyles.animationOffset :  BaseStyles.listFieldVertical,
        bottom: (pressed) ? BaseStyles.listFieldVertical - BaseStyles.animationOffset :  BaseStyles.listFieldVertical,
        left: BaseStyles.listFieldHorizontal,
        right: BaseStyles.listFieldHorizontal
      ),
      child: GestureDetector(
        child: Container(
          height: ButtonStyles.buttonHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
            boxShadow: pressed ? BaseStyles.boxShadowPressed : BaseStyles.boxShadow
          ), 
          child: Center(child: Text(widget.buttonText, style: fontStyle)),
        ),
        onTapDown: (details){
          setState(() {
            if (widget.buttonType != ButtonType.Disabled) pressed = !pressed;
          });
        },
        onTapUp: (details){
          setState(() {
            if (widget.buttonType != ButtonType.Disabled) pressed = !pressed;
          });
        },
        onTap: () {
          if (widget.buttonType != ButtonType.Disabled){
            widget.onPressed();
          }
        },
      ),
      duration: Duration(milliseconds: 20),
    );
    
  }
}

enum ButtonType { LightBlue, Straw, Disabled, DarkGrey, DarkBlue }

abstract class TextStyles {

  static TextStyle get title {
    return GoogleFonts.poppins(textStyle: TextStyle(color: AppColors.darkblue, fontWeight: FontWeight.bold, fontSize: 40.0));
  }

  static TextStyle get subtitle {
    return GoogleFonts.economica(textStyle: TextStyle(color: AppColors.straw, fontWeight: FontWeight.bold, fontSize: 30.0));
  }

  static TextStyle get navTitle {
    return GoogleFonts.poppins(textStyle: TextStyle(color: AppColors.darkblue, fontWeight: FontWeight.bold));
  }

  static TextStyle get navTitleMaterial {
    return GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }

  static TextStyle get body {
    return GoogleFonts.roboto(textStyle: TextStyle(color: AppColors.darkgray, fontSize: 16.0));
  }

  static TextStyle get bodyLightBlue {
    return GoogleFonts.roboto(textStyle: TextStyle(color: AppColors.lightblue, fontSize: 16.0));
  }

  static TextStyle get bodyRed {
    return GoogleFonts.roboto(textStyle: TextStyle(color: AppColors.red, fontSize: 16.0));
  }

  static TextStyle get link {
    return GoogleFonts.roboto(textStyle: TextStyle(color: AppColors.straw, fontSize: 16.0, fontWeight: FontWeight.bold));
  }

  static TextStyle get suggestion{
    return GoogleFonts.roboto(textStyle: TextStyle(color: AppColors.lightgray, fontSize: 14.0));
  }

  static TextStyle get error {
    return GoogleFonts.roboto(textStyle: TextStyle(color: AppColors.red, fontSize: 12.0));
  }

  static TextStyle get buttonTextLight {
    return GoogleFonts.roboto(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold);
  }

  static TextStyle get buttonTextDark {
    return GoogleFonts.roboto(color: AppColors.darkgray, fontSize: 16.0, fontWeight: FontWeight.bold);
  }


}

abstract class AppColors {
  static Color get darkgray => const Color(0xFF4e5b60);
  static Color get lightgray => const Color(0xFFc8d6ef);
  static Color get darkblue => const Color(0xFF263a44);
  static Color get lightblue => const Color(0xFF48a1af);
  static Color get straw => const Color(0xFFe2a84b);
  static Color get red => const Color(0xFFee5253);
  static Color get green => const Color(0xFF3b7d02);
  static Color get facebook => const Color(0xFF3b5998);
  static Color get google => const Color(0xFF4285f4);
}

abstract class ButtonStyles{

  static double get buttonHeight => 50.0;

}

class CustomListTile extends StatelessWidget {

  final IconData icon;
  final String text;
  
  CustomListTile({this.icon, this.text});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.blue),
          SizedBox(width: 15.0),
          Text(text, style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SpinKitFadingCircle(
        color: Colors.black,
        size: 30,
      ),
    );
  }
}

abstract class AppNavbar {

  static CupertinoSliverNavigationBar cupertinoNavBar ({String title, @required BuildContext context}) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(title, style: TextStyles.navTitle),
      backgroundColor: Colors.transparent,
      border: null,
      leading: GestureDetector(child: Icon(CupertinoIcons.back, color: AppColors.straw), onTap: () => Navigator.of(context).pop(),),
    );
  }

  static SliverAppBar materialNavBar({@required String title, bool pinned, TabBar tabBar}){
    return SliverAppBar(
      title: Text(title, style: TextStyles.navTitleMaterial),
      backgroundColor: AppColors.darkblue,
      centerTitle: true,
      bottom: tabBar,
      floating: true,
      pinned: (pinned == null ) ? true : pinned,
      snap: true,
    );
  }
}

abstract class AppSliverScaffold {
  static Scaffold materialSliverScaffold({String navTitle, Widget pageBody, BuildContext context}){
    return Scaffold(
      body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
              return <Widget>[
                AppNavbar.materialNavBar(title: navTitle, pinned: false),
              ];
            },
            body: pageBody,
          )
    );
  }
}

class SmallButton extends StatefulWidget {

  final String name;
  final void Function() onChanged;
  
  SmallButton({this.name, this.onChanged});

  @override
  _SmallButtonState createState() => _SmallButtonState();
}

class _SmallButtonState extends State<SmallButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27.0,
      width: 70.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: (){
          widget.onChanged;
          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EditProfilePage()));
        },
        child: Center(child: Text(widget.name, style: TextStyle(color: Colors.blue, fontSize: 16.0)))),
    );
  }
}

class AppSocialButton extends StatelessWidget {
  final SocialType socialType;

  AppSocialButton({@required this.socialType});

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    Color iconColor;
    IconData icon;

    switch(socialType){
      case SocialType.Facebook:
        iconColor = Colors.white;
        buttonColor = AppColors.facebook;
        icon = FontAwesomeIcons.facebook;
      break;
       case SocialType.Google:
        iconColor = Colors.white;
        buttonColor = AppColors.google;
        icon = FontAwesomeIcons.google;
      break;
      default:
        iconColor = Colors.white;
        buttonColor = AppColors.facebook;
        icon = FontAwesomeIcons.facebook;
        break;
    }


    return Padding(
      padding: BaseStyles.listPadding,
      child: Container(
        height: ButtonStyles.buttonHeight,
        width: ButtonStyles.buttonHeight,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
          boxShadow: BaseStyles.boxShadow
        ), 
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}

enum SocialType { Facebook, Google }

abstract class TabBarStyles {

  static Color get unselectedLabelColor => AppColors.lightgray;
  static Color get labelColor => AppColors.straw;
  static Color get indicatorColor => AppColors.straw;

}

class AppTextField extends StatefulWidget {
  final String hintText;
  final IconData materialIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onChanged;
  final String errorText;
  final String initialText;

  AppTextField({
    @required this.hintText,
    @required this.materialIcon,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.errorText,
    this.initialText,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {

  FocusNode _node;
  bool displayCupertinoErrorBorder;
  TextEditingController _controller;

  @override
  void initState() {
    _node = FocusNode();    
    _controller = TextEditingController();
    if(widget.initialText != null) _controller.text = widget.initialText;
    _node.addListener(_handleFocusChange);
    displayCupertinoErrorBorder = false;
    super.initState();
  }

  void _handleFocusChange(){
    if (_node.hasFocus == false && widget.errorText != null){
      displayCupertinoErrorBorder = true;
    }else{
      displayCupertinoErrorBorder = false;
    }

    widget.onChanged(_controller.text);
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: TextFieldStyles.textBoxHorizontal, vertical: TextFieldStyles.textBoxVertical),
        child: TextField(
          keyboardType: widget.textInputType,
          cursorColor: TextFieldStyles.cursorColor,
          style: TextFieldStyles.text,
          textAlign: TextFieldStyles.textAlign,
          decoration: TextFieldStyles.materialDecoration(widget.hintText, widget.materialIcon, widget.errorText),
          obscureText: widget.obscureText,
          onChanged: widget.onChanged,
          controller: _controller,
        ),
      );
  }
}

abstract class TextFieldStyles{
  static double get textBoxHorizontal => BaseStyles.listFieldHorizontal;
  static double get textBoxVertical => BaseStyles.listFieldVertical;
  static TextStyle get text => TextStyles.body;
  static TextStyle get placeholder => TextStyles.suggestion;
  static Color get cursorColor => AppColors.darkblue;
  static Widget iconPrefix(IconData icon) => BaseStyles.iconPrefix(icon);

  static TextAlign get textAlign => TextAlign.center;

  static BoxDecoration get cupertinoDecoration {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.straw, 
        width: BaseStyles.borderWidth,
      ),
      borderRadius: BorderRadius.circular(BaseStyles.borderRadius));
  }

  static BoxDecoration get cupertinoErrorDecoration {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.red, 
        width: BaseStyles.borderWidth,
      ),
      borderRadius: BorderRadius.circular(BaseStyles.borderRadius));
  }

  static InputDecoration materialDecoration(String hintText, IconData icon, String errorText) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(8.0),
      hintText: hintText,
      hintStyle: TextFieldStyles.placeholder,
      border: InputBorder.none,
      errorText: errorText,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.straw, width: BaseStyles.borderWidth),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.straw, width: BaseStyles.borderWidth),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.straw, width: BaseStyles.borderWidth),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.red, width: BaseStyles.borderWidth),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      prefixIcon: iconPrefix(icon),
    );
  }
}

abstract class VendorScaffold {

  static CupertinoTabScaffold get cupertinoTabScaffold {
    return CupertinoTabScaffold(
      tabBar: _cupertinoTabBar, 
      tabBuilder: (context, index) {
        return _pageSelection(index);
      },    
    );
  }

  static get _cupertinoTabBar {
    return CupertinoTabBar(
      backgroundColor: AppColors.darkblue,
      items: <BottomNavigationBarItem> [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.create), title: Text('Products')),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.shopping_cart), title: Text('Orders')),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), title: Text('Profile')),
      ],
    );
  }

  static Widget _pageSelection(int index){
    if(index == 0){
      return HomePage();
    }

    if(index == 1){
      return PrecoPage();
    }

    return ProfilePage();
  }
}

class Style{

  static Color primary([double opacity = 1]) => Colors.red[700].withOpacity(opacity);
  static Color primaryDark([double opacity = 1]) => Color(0xff9a0007).withOpacity(opacity);
  static Color primaryLight([double opacity = 1]) => Color(0xffff6659).withOpacity(opacity);

  static Color secondary([double opacity = 1]) => Colors.teal[700].withOpacity(opacity);
  static Color secondaryDark([double opacity = 1]) => Color(0xff004c40).withOpacity(opacity);
  static Color secondaryLight([double opacity = 1]) => Color(0xff48a999).withOpacity(opacity);

  static Color light([double opacity = 1]) => Color.fromRGBO(242, 234, 228, opacity);
  static Color dark([double opacity = 1]) => Color.fromRGBO(51, 51, 51, opacity);

  static Color danger([double opacity = 1]) => Color.fromRGBO(217, 74, 74, opacity);
  static Color success([double opacity = 1]) => Color.fromRGBO(5, 100, 50, opacity);
  static Color info([double opacity = 1]) => Color.fromRGBO(100, 150, 255, opacity);
  static Color warning([double opacity = 1]) => Color.fromRGBO(166, 134, 0, opacity);
}

Widget blueButton({BuildContext context, String label, buttonWidth}){
  return Container(
    height: 56.0,
    width: buttonWidth != null ? buttonWidth : MediaQuery.of(context).size.width - 48,
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23.0),
        gradient: LinearGradient(
          colors: [
            Color(0xFFFB415B),
            Color(0xFFEE5623),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft
        ),
      ),
    child: Center(child: Text(label, style: TextStyle(color: Colors.white, fontSize: 16))),
  );
}


Widget appBar(BuildContext context){
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 22),
      children: <TextSpan>[
        TextSpan(text: 'Lista ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
        TextSpan(text: ' De ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
        TextSpan(text: ' Compras', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
      ],
    ),
  );
}

const kSpacingUnit = 10;

const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);

final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.7),
  fontWeight: FontWeight.w600,
);

final kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
  fontWeight: FontWeight.w100,
);

final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  fontWeight: FontWeight.w400,
  color: kDarkPrimaryColor,
);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: kLightSecondaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kLightSecondaryColor,
        displayColor: kLightSecondaryColor,
      ),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  backgroundColor: kLightSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: kDarkSecondaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kDarkSecondaryColor,
        displayColor: kDarkSecondaryColor,
      ),
);

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    Key key,
    this.icon,
    this.text,
    this.hasNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kSpacingUnit.w * 5.5,
      margin: EdgeInsets.symmetric(
        horizontal: kSpacingUnit.w * 4,
      ).copyWith(
        bottom: kSpacingUnit.w * 2,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kSpacingUnit.w * 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            this.icon,
            size: kSpacingUnit.w * 2.5,
          ),
          SizedBox(width: kSpacingUnit.w * 1.5),
          Text(
            this.text,
            style: kTitleTextStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          if (this.hasNavigation)
            Icon(
              LineAwesomeIcons.angle_right,
              size: kSpacingUnit.w * 2.5,
            ),
        ],
      ),
    );
  }
}