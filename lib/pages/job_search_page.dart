import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/job_search_controller.dart';
import '../widgets/job_card.dart';

class JobSearchPage extends StatelessWidget {
  const JobSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final JobSearchController controller = Get.put(JobSearchController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(controller),
      body: Column(
        children: [
          _buildResultHeader(controller), // 정렬 드롭다운 포함
          _buildKeywordSection(controller),
          Expanded(
            child: _buildJobList(controller),
          ),
        ],
      ),
    );
  }

  // 상단 헤더 (AppBar)
  PreferredSizeWidget _buildAppBar(JobSearchController controller) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: '알바',
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
          ),
          onChanged: (value) => controller.searchJobs(value),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.tune, color: Colors.black),
          onPressed: () => _showFilterModal(controller),
        ),
      ],
    );
  }

  // 검색 결과 헤더 (정렬 드롭다운 포함)
  Widget _buildResultHeader(JobSearchController controller) {
    return Obx(() => Container(
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Text(
                '총 ${controller.filteredJobPostings.length}건의 알바',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              DropdownButton<String>(
                value: controller.sortOption.value,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                underline: SizedBox(), // 밑줄 제거
                onChanged: (value) {
                  if (value != null) {
                    controller.sortJobs(value);
                  }
                },
                items: controller.sortOptions
                    .map((option) => DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 14,
                              color: controller.sortOption.value == option
                                  ? Colors.blue[600]
                                  : Colors.black87,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              IconButton(
                icon: Icon(Icons.map, color: Colors.grey[600]),
                onPressed: () {
                  Get.snackbar('알림', '지도 뷰는 추후 구현 예정입니다.');
                },
              ),
            ],
          ),
        ));
  }

  // 키워드 섹션
  Widget _buildKeywordSection(JobSearchController controller) {
    return Obx(() => Container(
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Spacer(),
                  if (controller.selectedKeywords.isNotEmpty)
                    GestureDetector(
                      onTap: () => controller.clearKeywords(),
                      child: Text(
                        '초기화',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.availableKeywords
                    .map((keyword) => GestureDetector(
                          onTap: () => controller.toggleKeyword(keyword),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: controller.selectedKeywords
                                      .contains(keyword)
                                  ? Colors.blue[600]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: controller.selectedKeywords
                                      .contains(keyword)
                                  ? null
                                  : Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              keyword,
                              style: TextStyle(
                                fontSize: 12,
                                color: controller.selectedKeywords
                                        .contains(keyword)
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: controller.selectedKeywords
                                        .contains(keyword)
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ));
  }

  // 알바 목록
  Widget _buildJobList(JobSearchController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.blue[600],
          ),
        );
      }

      if (controller.filteredJobPostings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                '검색 결과가 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '다른 검색어로 시도해보세요',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.filteredJobPostings.length,
        itemBuilder: (context, index) {
          final job = controller.filteredJobPostings[index];
          return JobCard(
            job: job,
            onBookmarkTap: () => controller.toggleBookmark(job.id),
            onTap: () {
              Get.snackbar('알림', '${job.companyName} 상세 페이지로 이동');
            },
          );
        },
      );
    });
  }

  // 필터 모달
  void _showFilterModal(JobSearchController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '필터',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('완료'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              '지역',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['전체', '강남구', '마포구', '서대문구', '송파구', '중구']
                  .map((location) => Obx(() => FilterChip(
                        label: Text(location),
                        selected:
                            controller.selectedLocation.value == location,
                        onSelected: (selected) {
                          controller.selectedLocation.value = location;
                          controller.applyFilters();
                        },
                      )))
                  .toList(),
            ),
            SizedBox(height: 20),
            Text(
              '업종',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['전체', '카페', '편의점', '마트', '패스트푸드', '화장품', '베이커리']
                  .map((jobType) => Obx(() => FilterChip(
                        label: Text(jobType),
                        selected: controller.selectedJobType.value == jobType,
                        onSelected: (selected) {
                          controller.selectedJobType.value = jobType;
                          controller.applyFilters();
                        },
                      )))
                  .toList(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
