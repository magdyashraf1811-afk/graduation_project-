import 'package:athaar_app/utils/app_colors.dart';
import 'package:athaar_app/utils/app_image.dart';
import 'package:material_ui/material_ui.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return SliverAppBar(

      floating: true,
      snap: true,
      pinned: true,
      backgroundColor: Colors.black,
      toolbarHeight: 90,
      automaticallyImplyLeading: false,

      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: height*0.01,
        children: [
          Row(
            children: [
              Image.asset(AppImage.logoAthar,width: 100,height: 100,),
              const Spacer(),

              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.person_3_outlined,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
