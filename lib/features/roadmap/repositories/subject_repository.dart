import 'package:http_interceptor/http/http_methods.dart';
import 'package:studybean/common/api/api_client.dart';
import 'package:studybean/common/models/page_info.dart';
import 'package:studybean/features/roadmap/models/get_many_subject_response.dart';

import '../models/get_many_subject_input.dart';
import '../models/subject.dart';

class SubjectRepository {
  final APIClient _client;

  SubjectRepository(this._client);

  Future<GetManySubjectResponse> getSubjects(GetManySubjectInput input) async {
    final response =
        await _client.call(HttpMethod.GET, path: '/subjects/list', query: {
      'name': input.name,
      'take': input.take.toString(),
      'cursor': input.cursor,
    });

    final List<dynamic> subjects = response.data?['nodes'] ?? [];
    final pageInfo = response.data?['pageInfo'];

    return GetManySubjectResponse(
      nodes: subjects.map((e) => Subject.fromJson(e)).toList(),
      pageInfo: PageInfo.fromJson(pageInfo),
    );
  }

  Future<Subject> createSubject(String name) async {
    final response = await _client
        .call(HttpMethod.POST, path: '/subjects', body: {'name': name});
    final subjectJson = response.data;
    if (subjectJson == null) throw Exception('Failed to create subject');
    return Subject.fromJson(subjectJson['subject']);
  }
}
