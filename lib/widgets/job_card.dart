import 'package:flutter/material.dart';
import '../models/job_posting.dart';

class JobCard extends StatelessWidget {
  final JobPosting job;
  final VoidCallback onBookmarkTap;
  final VoidCallback onTap;

  const JobCard({
    Key? key,
    required this.job,
    required this.onBookmarkTap,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 12),
            _buildJobInfo(),
            SizedBox(height: 12),
            _buildTags(),
            SizedBox(height: 12),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // 카드 헤더 (회사명, 즐겨찾기)
  Widget _buildHeader() {
    return Row(
      children: [
        // 회사 로고 (임시로 아이콘 사용)
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.business,
            color: Colors.blue[600],
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.companyName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 2),
                  Text(
                    job.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onBookmarkTap,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Icon(
              job.isBookmarked ? Icons.favorite : Icons.favorite_border,
              color: job.isBookmarked ? Colors.red[400] : Colors.grey[400],
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  // 알바 정보 (급여, 근무시간)
  Widget _buildJobInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 급여 정보
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monetization_on,
                    size: 14,
                    color: Colors.orange[600],
                  ),
                  SizedBox(width: 4),
                  Text(
                    job.salary,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        // 근무시간
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: Colors.grey[600],
            ),
            SizedBox(width: 6),
            Text(
              job.workHours,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 태그 (업종, 혜택)
  Widget _buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 업종 태그
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                job.jobType,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        // 혜택 태그들
        if (job.benefits.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: job.benefits.take(3).map((benefit) => Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Text(
                benefit,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green[700],
                ),
              ),
            )).toList(),
          ),
      ],
    );
  }

  // 카드 푸터 (등록일, 액션 버튼)
  Widget _buildFooter() {
    return Row(
      children: [
        // 등록일
        Icon(
          Icons.schedule,
          size: 14,
          color: Colors.grey[500],
        ),
        SizedBox(width: 4),
        Text(
          _formatDate(job.postedDate),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        Spacer(),
        // 지원하기 버튼
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '지원하기',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // 날짜 포맷 함수
  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}분 전';
      }
      return '${difference.inHours}시간 전';
    } else if (difference.inDays == 1) {
      return '1일 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
