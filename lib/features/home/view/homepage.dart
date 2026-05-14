import 'package:flutter/material.dart';
import 'package:portfolio/features/home/model/home_model.dart';
import 'package:portfolio/shared/components/app_avatar.dart';
import 'package:portfolio/shared/components/appsearch_bar.dart';
import 'package:portfolio/shared/components/divider.dart';
import 'package:portfolio/shared/components/text_button.dart';
import 'package:portfolio/shared/style/style.dart';
import 'package:portfolio/shared/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  final HomeModel homeModel = HomeModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(homeModel.headerdata.imageUrl),
              radius: 20,
            ),
            SizedBox(width: 16),
            Text(homeModel.headerdata.name, style: AppStyle.headline1),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(homeModel.headerdata.icon)),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: AppDivider(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSearchBar(
                controller: searchController,
                hinttext: homeModel.searchdata[0]['hinttext'] as String,
                prefixicon: Icon(
                  homeModel.searchdata[0]['icon'] as IconData,
                  size: 24,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeModel.filters.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Text(
                        homeModel.filters[index],
                        style: AppStyle.label,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 460,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: AppColors.cardColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(homeModel.info.title, style: AppStyle.headline1),
                      SizedBox(height: 10),
                      Text(
                        homeModel.info.description,
                        style: AppStyle.headline3,
                      ),
                      SizedBox(height: 10),
                      AppTextButton(
                        text: homeModel.info.button,
                        onPressed: () {},
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: AppAvatar(
                          imageUrl: homeModel.info.image,
                          radius: 120, // ← adjust size as needed
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("My Core Competencies", style: AppStyle.headline3),
              SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeModel.mycore.length,
                  itemBuilder: (context, index) {
                    final item = homeModel.mycore[index];
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item['image'] as String,
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(height: 4),
                          Text(item['name'] as String, style: AppStyle.label),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Text("Featured Project", style: AppStyle.headline3),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: homeModel.project.length,
                    itemBuilder: (context, index) {
                      final item = homeModel.project[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ── Image ───────────────────────────────
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item['image'] as String,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),

                            // ── Text ────────────────────────────────
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] as String,
                                    style: AppStyle.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    item['description'] as String,
                                    style: AppStyle.bodyMedium,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
