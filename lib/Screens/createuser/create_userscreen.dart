
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/create_user_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/createuser/role_drop_down.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:provider/provider.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
 late CreateUserViewmodel viewModel;
  @override
  Widget build(BuildContext context) {
     viewModel = Provider.of<CreateUserViewmodel>(context);
      final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
    appBar: AppBar(
        backgroundColor:  ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaCreateAppBar(),
      ),
      body: Column(
        children: [  
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: 
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children:  [
                
                 CommonTextField(
              hintText: StringConstant.enterUserName,
              labelText: StringConstant.userName,
              isFromPassword: false,
              controller:  viewModel.nameController,
            ),


            const SizedBox(height: 20,),
             CommonTextField(
              hintText: StringConstant.email,
              labelText: StringConstant.email,
              isFromPassword: false,
              controller:  viewModel.emailController,
            ),
            const SizedBox(height: 20,),
               CommonTextField(
              hintText: StringConstant.password,
              labelText: StringConstant.password,
              isFromPassword: true,
              controller:  viewModel.passwordController,
            ),

            const SizedBox(height: 20,),

            CommonDropdownField(
           hintText:StringConstant.selectedRole ,
           labelText:StringConstant.role ,
           items:StringConstant.roles ,
           selectedValue:StringConstant.temple ,
           onChanged: (value) {
          print("Selected: $value");
  } ,
)
           ])))))

      ],)
    );
  }


  Widget nammaDaivaCreateAppBar(){
  return Center(child: 
  Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    IconButton(
    icon: Image.asset(ImageStrings.backbutton),
    onPressed: () {
    Navigator.pop(context);
    },
    ),
    Spacer(),
    Text(StringConstant.createAcc,style:AppTextStyles.appBarTitleStyle ,),
    Spacer(),
    SizedBox(width: 48,),
    
  ],));
  
  
   
  }
}