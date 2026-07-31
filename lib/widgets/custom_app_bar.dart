import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';
//عنصر يمتلك حجما و ارتفاعا معيارا ممتاز 
// لان فصلنا اذا استدعيناه لح يحط خط احمر لهيك لازم نحط هي 
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface.withOpacity(0.9),
      //الاب بار بدون ظل 
      elevation: 0,
      //تغير لون او ظل الاب بار 
      scrolledUnderElevation: 0,
      titleSpacing: 20.0,
      leading: IconButton(
        icon: Stack(
          children: [
            const Icon(Icons.notifications_none_outlined, color: AppColors.brandGray, size: 28),
            Positioned(
              top: 3,
              left: 3,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 1),
                ),
              ),
            ),
          ],
        ),
        onPressed: () {},
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text('أهلاً بك،', style: TextStyle(color: AppColors.brandGray, fontSize: 12)),
                  Text('سارة', style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
                  image: const DecorationImage(
                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuB__G5KDglUpRN4_x-t5IP9Bc2pc9BgC44lZ4K8jS0vowMM3eA7kTca4AEjUEskFZyfKSycXpO5eUxc5cgFcVwN1C4Av95Uu0ibCMulBbHnEPgKiLem8uO94fWPOatobrMhfOaQqYk-gZTcHa4xBw5BSEsvEXJXOUkPAcxEU0DGhtsB3WvQ6TEnxhksL97wTFnjtgSUZHN4mRiuuNhhobthO6ksaAv3hkMKcEmbwXMfirnwftjm9Gw8HQODhlJvmiogWon5jIOLiTo'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
//
  @override
  //فلهيك كتبنا هاد مشان تحديد الارتفاع  
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}