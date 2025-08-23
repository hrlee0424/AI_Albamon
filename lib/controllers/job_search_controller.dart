import 'package:get/get.dart';
import '../models/job_posting.dart';
import '../data/dummy_data.dart';

class JobSearchController extends GetxController {
  // 검색 관련 상태
  var searchKeyword = '알바'.obs;
  var isLoading = false.obs;
  var jobPostings = <JobPosting>[].obs;
  var filteredJobPostings = <JobPosting>[].obs;
  
  // 정렬 관련 상태
  var sortOption = '최신순'.obs;
  var sortOptions = ['최신순', '급여순', '거리순', '인기순'].obs;
  
  // 필터 관련 상태
  var selectedLocation = '전체'.obs;
  var selectedJobType = '전체'.obs;
  var minSalary = 0.obs;
  var maxSalary = 20000.obs;
  
  // 키워드 필터 관련 상태
  var selectedKeywords = <String>[].obs;
  var availableKeywords = [
    '초보가능',
    '친구와 함께',
    '점심제공',
    '야간근무',
    '재택근무',
    '브랜드',
  ].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadJobPostings();
  }
  
  // 더미 데이터 로드
  void loadJobPostings() {
    isLoading.value = true;
    
    // 실제 앱에서는 API 호출
    Future.delayed(Duration(milliseconds: 500), () {
      jobPostings.value = DummyData.getJobPostings();
      filteredJobPostings.value = jobPostings;
      isLoading.value = false;
    });
  }
  
  // 검색 기능
  void searchJobs(String keyword) {
    searchKeyword.value = keyword;
    applyFilters();
  }
  
  // 정렬 기능
  void sortJobs(String option) {
    sortOption.value = option;
    
    switch (option) {
      case '최신순':
        filteredJobPostings.sort((a, b) => b.postedDate.compareTo(a.postedDate));
        break;
      case '급여순':
        filteredJobPostings.sort((a, b) => _extractSalary(b.salary).compareTo(_extractSalary(a.salary)));
        break;
      case '거리순':
        // 실제 앱에서는 GPS 위치 기반 정렬
        filteredJobPostings.shuffle();
        break;
      case '인기순':
        // 실제 앱에서는 조회수/지원수 기반 정렬
        filteredJobPostings.shuffle();
        break;
    }
    filteredJobPostings.refresh();
  }
  
  // 키워드 토글
  void toggleKeyword(String keyword) {
    if (selectedKeywords.contains(keyword)) {
      selectedKeywords.remove(keyword);
    } else {
      selectedKeywords.add(keyword);
    }
    applyFilters();
  }
  
  // 키워드 초기화
  void clearKeywords() {
    selectedKeywords.clear();
    applyFilters();
  }
  
  // 필터 적용
  void applyFilters() {
    var filtered = jobPostings.where((job) {
      bool matchesKeyword = job.companyName.contains(searchKeyword.value) ||
                           job.jobType.contains(searchKeyword.value) ||
                           job.description.contains(searchKeyword.value);
      
      bool matchesLocation = selectedLocation.value == '전체' ||
                            job.location.contains(selectedLocation.value);
      
      bool matchesJobType = selectedJobType.value == '전체' ||
                           job.jobType == selectedJobType.value;
      
      int salary = _extractSalary(job.salary);
      bool matchesSalary = salary >= minSalary.value && salary <= maxSalary.value;
      
      // 키워드 필터링
      bool matchesKeywords = selectedKeywords.isEmpty || 
                            selectedKeywords.any((keyword) => _matchesKeyword(job, keyword));
      
      return matchesKeyword && matchesLocation && matchesJobType && matchesSalary && matchesKeywords;
    }).toList();
    
    filteredJobPostings.value = filtered;
    sortJobs(sortOption.value);
  }
  
  // 키워드 매칭 로직
  bool _matchesKeyword(JobPosting job, String keyword) {
    switch (keyword) {
      case '초보가능':
        return job.requirements['experience'] == '신입가능';
      case '친구와 함께':
        return job.description.contains('친구') || job.description.contains('함께');
      case '점심제공':
        return job.benefits.contains('식대지원') || job.benefits.contains('점심제공');
      case '야간근무':
        return job.workHours.contains('야간') || job.workHours.contains('22:00') || job.workHours.contains('23:00');
      case '재택근무':
        return job.workHours.contains('재택') || job.description.contains('재택');
      case '브랜드':
        return job.companyName.contains('스타벅스') || 
               job.companyName.contains('맥도날드') || 
               job.companyName.contains('올리브영') ||
               job.companyName.contains('투썸') ||
               job.companyName.contains('배스킨');
      default:
        return false;
    }
  }
  
  // 급여에서 숫자 추출 (예: "시급 12,000원" -> 12000)
  int _extractSalary(String salaryText) {
    RegExp regExp = RegExp(r'[\d,]+');
    String? match = regExp.firstMatch(salaryText)?.group(0);
    if (match != null) {
      return int.tryParse(match.replaceAll(',', '')) ?? 0;
    }
    return 0;
  }
  
  // 즐겨찾기 토글
  void toggleBookmark(String jobId) {
    int index = filteredJobPostings.indexWhere((job) => job.id == jobId);
    if (index != -1) {
      // JobPosting이 final 필드들을 가지고 있으므로 새 객체를 생성
      JobPosting oldJob = filteredJobPostings[index];
      JobPosting newJob = JobPosting(
        id: oldJob.id,
        companyName: oldJob.companyName,
        location: oldJob.location,
        salary: oldJob.salary,
        workHours: oldJob.workHours,
        jobType: oldJob.jobType,
        description: oldJob.description,
        postedDate: oldJob.postedDate,
        isBookmarked: !oldJob.isBookmarked,
        companyLogo: oldJob.companyLogo,
        address: oldJob.address,
        contactNumber: oldJob.contactNumber,
        benefits: oldJob.benefits,
        requirements: oldJob.requirements,
      );
      filteredJobPostings[index] = newJob;
      
      // 원본 데이터도 업데이트
      int originalIndex = jobPostings.indexWhere((job) => job.id == jobId);
      if (originalIndex != -1) {
        jobPostings[originalIndex] = newJob;
      }
    }
  }
}
