import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/temple_image_selector.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:provider/provider.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/add_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/temple_input_widget.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class AddTempleScreen extends StatefulWidget {
  const AddTempleScreen({super.key});

  @override
  State<AddTempleScreen> createState() => _AddTempleScreenState();
}

class _AddTempleScreenState extends State<AddTempleScreen> {
  late AddTempleViewmodel templeViewmodel;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    templeViewmodel = Provider.of<AddTempleViewmodel>(context);

    return 
    
    Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaCreateAppBar(),
      ),
      body:Stack(children: [
         Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              
              SizedBox(height: screenHeight * 0.02),
              CommonTextField(
                hintText: StringConstant.templeName,
                labelText: StringConstant.templeName,
                isFromPassword: false,
                controller: templeViewmodel.templeName,
              ),
              SizedBox(height: 10),
              CommonTextField(
                hintText: StringConstant.addresss,
                labelText: StringConstant.addresss,
                isFromPassword: false,
                controller: templeViewmodel.address,
              ),
              SizedBox(height: 10),
              CommonTextField(
                hintText: StringConstant.cityy,
                labelText: StringConstant.cityy,
                isFromPassword: false,
                controller: templeViewmodel.city,
              ),
              SizedBox(height: 10),
              CommonTextField(
                hintText: StringConstant.statee,
                labelText: StringConstant.statee,
                isFromPassword: false,
                controller: templeViewmodel.state,
              ),
              SizedBox(height: 10),
              CommonTextField(
                hintText: StringConstant.pincode,
                labelText: StringConstant.pincode,
                isFromPassword: false,
                controller: templeViewmodel.pincode,
              ),
              SizedBox(height: 10),
              CommonTextField(
                hintText: StringConstant.architecturee,
                labelText: StringConstant.architecturee,
                isFromPassword: false,
                controller: templeViewmodel.architecture,
              ),
              SizedBox(height: 10),
              CommonTextField(
                hintText: StringConstant.email,
                labelText: StringConstant.email,
                isFromPassword: false,
                controller: templeViewmodel.email,
              ),
              SizedBox(height: 10),
              CommonTextField(
                hintText: StringConstant.phone,
                labelText: StringConstant.phone,
                isFromPassword: false,
                controller: templeViewmodel.phone,
                isFromPhone: true,
              ),
              SizedBox(height: 10),
              Padding(padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 0),child: 
              TempleInputWidget()),
              SizedBox(height: 10),
              TempleImagePickerWidget(),
              SizedBox(height: 10),
              CommonTextField(
                hintText: StringConstant.description,
                labelText: StringConstant.description,
                isFromPassword: false,
                controller: templeViewmodel.description,
                isFromDescription: true,
              ),
              SizedBox(height: 10),
              addTempleButton(),
              SizedBox(height: 10),

            ],
          ),
        ),
      ),
      if(templeViewmodel.isLoading)
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
      
      ,
    );
  }

  Widget nammaDaivaCreateAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(ImageStrings.backbutton),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(
          StringConstant.addTemple,
          style: AppTextStyles.appBarTitleStyle,
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }
   Widget addTempleButton() {
  return Consumer<AddTempleViewmodel>(
    builder: (context, templeViewmodel, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: templeViewmodel.validateAddTemple()
                ? () async {
                  templeViewmodel.isLoading=true;
                  await templeViewmodel.presignedUrl();
                  if(templeViewmodel.templeAdded==true){
                    Navigator.pushNamed(context, StringsRoute.templeScreen);
                    setState(() {
                    templeViewmodel.templeAdded=false;
                    });
                    Fluttertoast.showToast(msg: templeViewmodel.message??"");
                    templeViewmodel.message="";
                    templeViewmodel.dispose();
                  }
                  }
                : null, 
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              StringConstant.addTemple,
              style: AppTextStyles.buttonTextStyle,
            ),
          ),
        ),
      );
    },
  );
}

}
