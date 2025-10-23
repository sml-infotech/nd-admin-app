import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/forgot/forgot_otpdialog.dart';
import 'package:nammadaiva_dashboard/Screens/forgot/forgot_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/otp/otp_screen.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart'; 
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/arguments/otp_arguments.dart';
import 'package:provider/provider.dart'; 

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotViewmodel viewmodel ;
  @override
  Widget build(BuildContext context) {
    viewmodel = Provider.of<ForgotViewmodel>(context);
        final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: _buildAppBar(),
      ),
      body: Stack(children: [
SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: screenHeight - kToolbarHeight),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                forgotImage(),
                const SizedBox(height: 30),
                const SizedBox(height: 12),
                forgotSubText(),
                const SizedBox(height: 18),
                CommonTextField(hintText: StringConstant.email, labelText: StringConstant.enterUserName, isFromPassword: false, controller: viewmodel.emailController),
                const SizedBox(height: 25),
                resetButton(viewmodel,context),
                 SizedBox(height: 40),
              
              ],
            ),
          ),
        ),
      ),
 if(viewmodel.isLoading)
                Positioned.fill(
                child: Container(
                 color: Colors.black.withOpacity(0.4),
                child: Center(
                 child: CircularProgressIndicator(
              color: ColorConstant.buttonColor,
            ),
          ),
        ),
      )

      ],)
      
      
      
    );
  }


 Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(StringConstant.forgotPassword1, style: AppTextStyles.appBarTitleStyle),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }
  Widget forgotImage() {
    return Image.asset(
      ImageStrings.loginImage,
      height: 70,
      width: 70,
      fit: BoxFit.contain,
    );
  }


  Widget forgotSubText() {
    return Text(
    StringConstant.fogotSubtext  ,
      style: AppTextStyles.otpSubHeadingStyle.copyWith(
        fontSize: 16,
        color: Colors.black54,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

   
}
void _showOtpDialog(BuildContext context, ForgotViewmodel viewmodel) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return  OtpDialog(email:viewmodel.emailController.text, password: '',);
           
          
        
  
    },
  );
}
Widget resetButton(ForgotViewmodel viewmodel,BuildContext context) {
  final isButtonEnabled = viewmodel.validateEmail();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isButtonEnabled
            ? () async {
           await  viewmodel.  forgotPasswordApi();
             Fluttertoast.showToast(
                  msg: viewmodel.message,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM,
                  toastLength: Toast.LENGTH_SHORT,
                );
             if(viewmodel.code==200){
                _showOtpDialog(context, viewmodel);
                viewmodel.code=0;
               }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isButtonEnabled ? ColorConstant.buttonColor : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child:  Text(
                StringConstant.verify,
                style: AppTextStyles.buttonTextStyle,
              ),
      ),
    ),
  );
}