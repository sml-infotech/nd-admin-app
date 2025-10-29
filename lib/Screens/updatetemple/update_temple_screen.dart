import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammadaiva_dashboard/Common/common_textfields.dart';
import 'package:nammadaiva_dashboard/Screens/addtemple/temple_input_widget.dart';
import 'package:nammadaiva_dashboard/Screens/updatetemple/update_temple_viewmodel.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';
import 'package:nammadaiva_dashboard/arguments/temple_details_arguments.dart';
import 'package:provider/provider.dart';

class TempleUpdateScreen extends StatefulWidget {
  final TempleDetailsArguments arguments;
  const TempleUpdateScreen({super.key, required this.arguments});

  @override
  State<TempleUpdateScreen> createState() => _TempleUpdateScreenState();
}

class _TempleUpdateScreenState extends State<TempleUpdateScreen> {
  late UpdateTempleViewmodel viewModel;
  bool _isDataLoaded = false; // ensure data sets only once

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataLoaded) {
      viewModel = Provider.of<UpdateTempleViewmodel>(context, listen: false);
      _setInitialData();
      _isDataLoaded = true;
    }
  }

  void _setInitialData() {
    viewModel.templeName.text = widget.arguments.name ?? '';
    viewModel.templeLocation.text = widget.arguments.address ?? '';
    viewModel.templeDescription.text = widget.arguments.description ?? '';
    viewModel.templePhoneNumber.text = widget.arguments.phoneNumber ?? '';
    viewModel.templeEmail.text = widget.arguments.email ?? '';
    viewModel.templeArchitecture.text = widget.arguments.architecture ?? '';
    viewModel.templeDeities.text = widget.arguments.deities.join(', ');
    viewModel.templeCity.text = widget.arguments.city??"";
    viewModel.templeState.text = widget.arguments.state??"";
    viewModel.templePincode.text = widget.arguments.pincode??"";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    viewModel = Provider.of<UpdateTempleViewmodel>(context);

    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaDetailAppBar(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageWidget(),
                          const SizedBox(height: 16),
                          titleTextWidget(StringConstant.templeName),
                          const SizedBox(height: 8),
                          CommonTextField(
                            hintText: "",
                            labelText: "",
                            isFromPassword: false,
                            controller: viewModel.templeName,
                          ),
                          titleTextWidget(StringConstant.templelocation),
                          const SizedBox(height: 8),
                          CommonTextField(
                            hintText: "",
                            labelText: "",
                            isFromPassword: false,
                            controller: viewModel.templeLocation,
                          ),
                          titleTextWidget(StringConstant.cityy),
                          const SizedBox(height: 8),
                          CommonTextField(
                            hintText: "",
                            labelText: "",
                            isFromPassword: false,
                            controller: viewModel.templeCity,
                          ),
                          titleTextWidget(StringConstant.statee),
                          const SizedBox(height: 8),
                          CommonTextField(
                            hintText: "",
                            labelText: "",
                            isFromPassword: false,
                            controller: viewModel.templeState,
                          ),
                          titleTextWidget(StringConstant.pincode),
                          const SizedBox(height: 8),
                          CommonTextField(
                            hintText: "",
                            labelText: "",
                            isFromPassword: false,
                            controller: viewModel.templePincode,
                          ),
                          titleTextWidget(StringConstant.templedescription),
                          const SizedBox(height: 8),
                          CommonTextField(
                            hintText: "",
                            labelText: "",
                            isFromPassword: false,
                            controller: viewModel.templeDescription,
                          ),
                          titleTextWidget(StringConstant.templephonenumber),
                          const SizedBox(height: 8),
                          CommonTextField(
                            hintText: "",
                            labelText: "",
                            isFromPassword: false,
                            isFromPhone: true,
                            controller: viewModel.templePhoneNumber,
                          ),
                          titleTextWidget(StringConstant.templeemail),
                          const SizedBox(height: 8),
                          CommonTextField(
                            hintText: "",
                            labelText: "",
                            isFromPassword: false,
                            controller: viewModel.templeEmail,
                          ),
                          titleTextWidget(StringConstant.deitiestemple),
                          const SizedBox(height: 8),
                           CommonTextField(
                            hintText: "",
                            labelText: "",
                            isFromPassword: false,
                            controller: viewModel.templeDeities,
                          ),
                          titleTextWidget(StringConstant.templearchitecture),
                          const SizedBox(height: 8),
                          CommonTextField(
                            hintText: "",
                            labelText: "",
                            isFromPassword: false,
                            controller: viewModel.templeArchitecture,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
           if (viewModel.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorConstant.buttonColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget nammaDaivaDetailAppBar() {
    return Center(
      child: Row(
        children: [
          IconButton(
            icon: Image.asset(ImageStrings.backbutton),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Text(StringConstant.templeDetail,
              style: AppTextStyles.appBarTitleStyle),
          const Spacer(),
          GestureDetector(
            onTap: () 
            async {
         if(viewModel.validateUpdateTemple()){
          await viewModel.updateTemple(widget.arguments.templeId);
          Fluttertoast.showToast(msg: viewModel.message);
        if(viewModel.templeUpdated){
         Navigator.popUntil(context, (route) {
                      print(route.settings.name); 
                      return route.settings.name == StringsRoute.templeScreen;
                    });
              }


}else{
  Fluttertoast.showToast(msg: viewModel.message);
}
            },
            child: Text(StringConstant.save,
                style: AppTextStyles.appBarTitleStyle),
          ),
        ],
      ),
    );
  }

  Widget imageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        "https://picsum.photos/id/1016/800/400",
        fit: BoxFit.fill,
        width: double.infinity,
      ),
    );
  }

  Widget titleTextWidget(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        title,
        style: AppTextStyles.editTempleTitleStyle,
      ),
    );
  }
}
