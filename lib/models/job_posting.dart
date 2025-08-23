class JobPosting {
  final String id;
  final String companyName;
  final String location;
  final String salary;
  final String workHours;
  final String jobType;
  final String description;
  final DateTime postedDate;
  final bool isBookmarked;
  final String companyLogo;
  final String address;
  final String contactNumber;
  final List<String> benefits;
  final Map<String, dynamic> requirements;

  JobPosting({
    required this.id,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.workHours,
    required this.jobType,
    required this.description,
    required this.postedDate,
    this.isBookmarked = false,
    required this.companyLogo,
    required this.address,
    required this.contactNumber,
    required this.benefits,
    required this.requirements,
  });

  factory JobPosting.fromJson(Map<String, dynamic> json) {
    return JobPosting(
      id: json['id'],
      companyName: json['companyName'],
      location: json['location'],
      salary: json['salary'],
      workHours: json['workHours'],
      jobType: json['jobType'],
      description: json['description'],
      postedDate: DateTime.parse(json['postedDate']),
      isBookmarked: json['isBookmarked'] ?? false,
      companyLogo: json['companyLogo'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      benefits: List<String>.from(json['benefits']),
      requirements: Map<String, dynamic>.from(json['requirements']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'location': location,
      'salary': salary,
      'workHours': workHours,
      'jobType': jobType,
      'description': description,
      'postedDate': postedDate.toIso8601String(),
      'isBookmarked': isBookmarked,
      'companyLogo': companyLogo,
      'address': address,
      'contactNumber': contactNumber,
      'benefits': benefits,
      'requirements': requirements,
    };
  }
}
