import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: AppBar(
        backgroundColor:  ColorConstant.buttonColor,
        elevation: 0,
        title: nammaDaivaAppBar(),
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
                    welcomeText(),
                    SizedBox(height: 15),
                    templeNameText(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        contaierWidgets(ImageStrings.templeImage, StringConstant.templeDetailText,(){
                          Navigator.pushNamed(context, StringsRoute.templeDetail);
                        }),
                        contaierWidgets(ImageStrings.sevaimg,StringConstant.sevaText,(){
                        Navigator.pushNamed(context, StringsRoute.userDetails);

                        }),
                      ],
                    ),
                                        SizedBox(height: 20),
                   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        contaierWidgets(ImageStrings.onlineseva,StringConstant.onlineSeva,(){}),
                        contaierWidgets(ImageStrings.donation,StringConstant.donationText,(){}),
                      ],
                    ),
                                                            SizedBox(height: 20),

                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        contaierWidgets(ImageStrings.ritual,StringConstant.ritualText,(){}),
                        contaierWidgets(ImageStrings.audit,StringConstant.audittext,(){}),
                      ],
                    ),
                                                            SizedBox(height: 20),

                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        contaierWidgets(ImageStrings.transaction,StringConstant.transactionText,(){}),
                        contaierWidgets(ImageStrings.wowtracker,StringConstant.wowtracker,(){
                                    Navigator.pushNamed(context, StringsRoute.createUser);

                        }),
                      ],

                    ),
                    SizedBox(height: 25),

                  ],
                ),
              ),
            ),
          ),)
        ],
      ),
    );
  }

  

  Widget nammaDaivaAppBar(){
  return Center(child: 
  Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Spacer(),
    Text(StringConstant.nammaDaivaSmall,style:AppTextStyles.appBarTitleStyle ,),
    Spacer(),
    IconButton(
          icon: Image.asset(ImageStrings.logout),
          onPressed: () {
          },
        )
  ],));
  }

  Widget welcomeText() {
    return Text(
      StringConstant.welcomeBack,
      style: AppTextStyles.welcomeStyle,
    );
  }

  Widget templeNameText() {
    return Text(
      "Arulmigu Arunachaleswarar Temple",
      style: AppTextStyles.templeNameStyle,
    );
  }

  Widget contaierWidgets(
    String image, String title,Function ()? onTap
  ){
    return GestureDetector(
      onTap: onTap,
      child:
    
    Container(
      height: 156,
      width: 170,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Column(children: [
        SizedBox(height: 10),
        Image.asset(image,height: 60,width: 60,),
        SizedBox(height: 10),
        Padding(padding: EdgeInsetsGeometry.fromLTRB(14, 0, 14, 0),child:         Text(title,style:AppTextStyles. templeNameStyle,textAlign: TextAlign.center,)
     ) ],)),
    ));
  }
}
