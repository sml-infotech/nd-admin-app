import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/expandable_text.dart';
import 'package:nammadaiva_dashboard/Screens/puja_list/toggle_button.dart';
import 'package:nammadaiva_dashboard/Utills/constant.dart';
import 'package:nammadaiva_dashboard/Utills/image_strings.dart';
import 'package:nammadaiva_dashboard/Utills/styles.dart';

class PujaList extends StatefulWidget {
  const PujaList({super.key});

  @override
  State<PujaList> createState() => _PujaListState();
}

class _PujaListState extends State<PujaList> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorConstant.buttonColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: screenHeight - kToolbarHeight,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),

                      child: Column(children: [listCard()]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: ColorConstant.buttonColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: Image.asset(ImageStrings.backbutton),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(StringConstant.addPuja, style: AppTextStyles.appBarTitleStyle),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget listCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  pujatitleName(),
                  Spacer(),
                  SmallToggleSwitch(
                    onChanged: (bool value) {
                      print(value);
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                  editButton(),
                ],
              ),

              isActiveTextWidget(isActive),
              deitiesName(),
              descriptionWidget(),
              SizedBox(height: 8),
              fromAndToWidget(fromDate: '10/02/2002', toDate: '12/05/2004'),
              SizedBox(height: 8),
              feesAndMaxDevotees(fee: '500.00', maxDevotee: '20'),
              SizedBox(height: 8),
              availableDaysText(),
              SizedBox(height: 8),
              availableDays(activeDays: ['Mon', 'Wed', 'Fri']),
              SizedBox(height: 8),
              availableTimeSlotsTitle(),
              SizedBox(height: 8),
              availableTimeSlots(
                activeTimes: [
                  '9:00 AM',
                  '10:30 AM',
                  '6:00 PM',
                  '9:00 AM',
                  '10:30 AM',
                  '6:00 PM',
                ],
              ),
              SizedBox(height: 6),
              viewImageWidget(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget pujatitleName() {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(12, 8, 0, 0),
      child: SizedBox(
        width: 200,
        child: Text(
          "Kanni Poojaaagggggggvcvbddfgdfgdfgdfgdfgdgdfgdfgdfgfbdgdfgg",
          maxLines: 2,
          style: AppTextStyles.welcomeStyle,
        ),
      ),
    );
  }

  Widget editButton() {
    return IconButton(onPressed: () {}, icon: Icon(Icons.edit));
  }

  Widget deitiesName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Deities : ",
              style: AppTextStyles.templeNameDetailsStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "murugan, maariamman, saamy",
              style: AppTextStyles.templeNameDetailsStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget descriptionWidget() {
    const fullText =
        "murugan, maariamman,dfgdfgdfgg dfgdfgdfgdfgdfgdfgdfgfgdfgdfgdfg vkjnkjghkj kjdffgln lkndfgkklndbibdfkgbvsdjkfgjkdsfgjsdfjgsdfgbjhdfsgjhbsdfjh xdffgjhdsb gjhdfsgjhdffbgjhdfsbgvjdfbgjhdsbhjbdsgjbsdjlg bvsdfgjbkdffjg dsfbgjhdsfbgjhsdbhjbsdjgdfgfgm ldflkndfklndffnkdfgkl kldjsnffgkjsdfg ;ladsfglkjnsdfg klnsdbgk dfgfdgfdgfdgfgdfgdfgsaamfgdfgdfg";

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 13, 0),
      child: ExpandableText(
        label: "Description : ",
        text: fullText,
        maxLines: 2,
        style: AppTextStyles.templeNameDetailsStyle,
      ),
    );
  }

  Widget fromAndToWidget({required String fromDate, required String toDate}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "From: ",
                  style: AppTextStyles.templeNameDetailsStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: fromDate,
                  style: AppTextStyles.templeNameDetailsStyle,
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "To: ",
                  style: AppTextStyles.templeNameDetailsStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: toDate,
                  style: AppTextStyles.templeNameDetailsStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget isActiveTextWidget(bool isActive) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: Text(
        isActive ? "Active" : "Inactive",
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
          fontFamily: font,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget feesAndMaxDevotees({required String fee, required String maxDevotee}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Fee: ",
                  style: AppTextStyles.templeNameDetailsStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "₹$fee",
                  style: AppTextStyles.templeNameDetailsStyle,
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Max Devotees: ",
                  style: AppTextStyles.templeNameDetailsStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: maxDevotee,
                  style: AppTextStyles.templeNameDetailsStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget availableDays({
    required List<String> activeDays, // e.g. ['Mon', 'Wed', 'Fri']
  }) {
    final allDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: allDays.map((day) {
        final isActive = activeDays.contains(day);

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isActive ? ColorConstant.buttonColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(0),

            border: Border.all(
              color: isActive
                  ? ColorConstant.buttonColor
                  : Colors.grey.shade400,
              width: 1,
            ),
          ),
          child: Text(
            day.substring(0, 3),
            style: TextStyle(
              fontSize: 11,
              fontFamily: font,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget availableDaysText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 0, 0),
      child: Text(
        "Available Days :",
        style: AppTextStyles.templeNameDetailsStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget availableTimeSlotsTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 0, 0),
      child: Text(
        "Available Time Slots :",
        style: AppTextStyles.templeNameDetailsStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget viewImageWidget() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 0, 0),
        child: Text(
          "View Images",
          style: AppTextStyles.templeNameDetailsStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstant.buttonColor,
          ),
        ),
      ),
    );
  }

  Widget availableTimeSlots({required List<String> activeTimes}) {
    if (activeTimes.isEmpty) {
      return Center(
        child: Text(
          "No available time slots",
          style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: font),
        ),
      );
    }

    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(12, 0, 0, 0),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
        children: activeTimes.map((time) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            decoration: BoxDecoration(
              color: ColorConstant.buttonColor,
              borderRadius: BorderRadius.circular(0),

              border: Border.all(color: ColorConstant.buttonColor, width: 1),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 11,
                fontFamily: font,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
