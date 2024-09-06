import 'package:studybean/common/db/local_db.dart';
import 'package:studybean/features/roadmap/models/create_local_action_resource_input.dart';
import 'package:studybean/features/roadmap/models/create_local_roadmap_input.dart';
import 'package:studybean/features/roadmap/models/create_milestone_input.dart';
import 'package:studybean/features/roadmap/models/edit_local_action_resource_input.dart';
import 'package:studybean/features/roadmap/models/edit_local_milestone_input.dart';
import 'package:studybean/features/roadmap/models/generate_milestone_with_ai_response.dart';
import 'package:uuid/uuid.dart';

import '../models/create_local_action_input.dart';
import '../models/edit_local_action_input.dart';
import '../models/roadmap.dart';
import '../models/subject.dart';

class RoadmapLocalRepository {
  final LocalDB _db;

  RoadmapLocalRepository(this._db);

  Future<Roadmap> createRoadmap(CreateLocalRoadmapInput input) async {
    final roadmapId = const Uuid().v4();
    final subjectId = const Uuid().v4();

    await _db.instance.rawInsert('INSERT INTO subjects(id, name) VALUES(?, ?)',
        [subjectId, input.subject]);
    await _db.instance.rawInsert(
        'INSERT INTO roadmaps(id, subjectId, goal, createdAt, updatedAt) VALUES(?, ?, ?, ?, ?)',
        [
          roadmapId,
          subjectId,
          input.goal,
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String(),
        ]);

    final result = await _db.instance.rawQuery(
      'SELECT r.*, s.name as subjectName FROM roadmaps r INNER JOIN subjects s ON s.id = r.subjectId WHERE r.id = ?',
      [roadmapId],
    );

    final roadmap = Roadmap.fromJson(result.first);
    final roadmapWithSubject = roadmap.copyWith(
      subject: Subject(
          id: result.first['subjectId'] as String,
          name: result.first['subjectName'] as String),
    );

    return roadmapWithSubject;
  }

  Future<Roadmap> createRoadmapWithAi(GenerateMilestoneWithAiResponse input,
      CreateLocalRoadmapInput localRoadmapInput) async {
    final roadmapId = const Uuid().v4();
    final subjectId = const Uuid().v4();

    await _db.instance.rawInsert('INSERT INTO subjects(id, name) VALUES(?, ?)',
        [subjectId, localRoadmapInput.subject]);

    await _db.instance.rawInsert(
        'INSERT INTO roadmaps(id, subjectId, goal, createdAt, updatedAt) VALUES(?, ?, ?, ?, ?)',
        [
          roadmapId,
          subjectId,
          localRoadmapInput.goal,
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String(),
        ]);

    final milestones = input.milestones.map((milestone) async {
      final milestoneId = const Uuid().v4();

      await _db.instance.rawInsert(
        'INSERT INTO milestones(id, roadmapId, name, position) VALUES(?, ?, ?, ?)',
        [
          milestoneId,
          roadmapId,
          milestone.name,
          milestone.index,
        ],
      );

      final actions = milestone.actions.map((action) async {
        final actionId = const Uuid().v4();
        await _db.instance.rawInsert(
          'INSERT INTO actions(id, milestoneId, name, description, duration, durationUnit, createdAt, updatedAt) VALUES(?, ?, ?, ?, ?, ?, ?, ?)',
          [
            actionId,
            milestoneId,
            action.name,
            action.description,
            action.duration,
            action.durationUnit.value,
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
          ],
        );

        final resources = action.resource.map((resource) async {
          final resourceId = const Uuid().v4();
          await _db.instance.rawInsert(
            'INSERT INTO resources(id, actionId, title, description, url) VALUES(?, ?, ?, ?, ?)',
            [
              resourceId,
              actionId,
              resource.title,
              resource.description,
              resource.url,
            ],
          );
        }).toList();

        await Future.wait(resources);
      }).toList();

      await Future.wait(actions);
    }).toList();

    await Future.wait(milestones);

    final roadmap = getRoadmapWithId(roadmapId);

    return roadmap;
  }

  Future<List<Roadmap>> getRoadmaps() async {
    final result = await _db.instance.rawQuery(
      'SELECT r.*, s.name as subjectName FROM roadmaps r INNER JOIN subjects s ON s.id = r.subjectId',
    );

    final roadmapWithMilestones = await Future.wait(result.map((e) async {
      final milestones = await _db.instance.rawQuery(
        'SELECT m.* FROM milestones m WHERE m.roadmapId = ? ORDER BY position ASC',
        [e['id'] as String],
      );

      final roadmap = Roadmap.fromJson(e);
      final roadmapWithSubject = roadmap.copyWith(
        subject: Subject(
          id: e['subjectId'] as String,
          name: e['subjectName'] as String,
        ),
      );

      return roadmapWithSubject.copyWith(
        milestones: milestones
            .map((milestone) => Milestone.fromJson(milestone))
            .toList(),
      );
    }));

    return roadmapWithMilestones;
  }

  Future<Roadmap> getRoadmapWithId(String id) async {
    final result = await _db.instance.rawQuery(
      'SELECT r.*, s.name as subjectName FROM roadmaps r LEFT JOIN subjects s ON r.subjectId = s.id WHERE r.id = ?',
      [id],
    );

    final milestones = await _db.instance.rawQuery(
      'SELECT m.* FROM milestones m WHERE m.roadmapId = ? ORDER BY position ASC',
      [id],
    );

    final milestoneActions = await Future.wait(milestones.map((e) async {
      final actions = await _db.instance.rawQuery(
          'SELECT * FROM actions a WHERE a.milestoneId = ?',
          [e['id'] as String]);

      final milestone = Milestone.fromJson(e);

      final milestoneWithActions = milestone.copyWith(
          actions: actions
              .map((actionJson) => MilestoneAction.fromJson(actionJson))
              .toList());

      return milestoneWithActions;
    }));

    final roadmap = Roadmap.fromJson(result.first);
    final roadmapWithSubject = roadmap.copyWith(
      subject: Subject(
          id: result.first['subjectId'] as String,
          name: result.first['subjectName'] as String),
      milestones: milestoneActions,
    );
    return roadmapWithSubject;
  }

  Future<void> deleteAllRoadmap() async {
    await _db.instance.rawDelete('DELETE FROM actions');
    await _db.instance.rawDelete('DELETE FROM milestones');
    await _db.instance.rawDelete('DELETE FROM subjects');
    await _db.instance.rawDelete('DELETE FROM roadmaps');
  }

  Future<void> deleteRoadmap(String id) async {
    await _db.instance.rawDelete('DELETE FROM roadmaps WHERE id = ?', [id]);
  }

  Future<Milestone> createMilestone(CreateMilestoneInput input) async {
    final id = const Uuid().v4();
    await _db.instance.rawInsert(
        'INSERT INTO milestones(id, name, roadmapId, position) VALUES(?, ?, ?, ?)',
        [
          id,
          input.name,
          input.roadmapId,
          input.index,
        ]);

    final result = await _db.instance.rawQuery(
      'SELECT * FROM milestones WHERE id = ?',
      [id],
    );
    return Milestone.fromJson(result.first);
  }

  Future<Milestone> getMilestoneWithId(String id) async {
    final result = await _db.instance.rawQuery(
      'SELECT * FROM milestones WHERE id = ?',
      [id],
    );
    final milestone = Milestone.fromJson(result.first);

    final milestoneActions = await _db.instance.rawQuery(
      'SELECT * FROM actions WHERE milestoneId = ?',
      [id],
    );

    return milestone.copyWith(
      actions: milestoneActions
          .map((actionJson) => MilestoneAction.fromJson(actionJson))
          .toList(),
    );
  }

  Future<Milestone> updateMilestone(EditLocalMilestoneInput input) async {
    await _db.instance.rawUpdate(
      'UPDATE milestones SET name = ? WHERE id = ?',
      [input.name, input.milestoneId],
    );
    return await getMilestoneWithId(input.milestoneId);
  }

  Future<void> deleteMilestone(String id) async {
    await _db.instance.rawDelete('DELETE FROM milestones WHERE id = ?', [id]);
  }

  Future<MilestoneAction> createAction(CreateLocalActionInput input) async {
    final id = const Uuid().v4();
    await _db.instance.rawInsert(
        'INSERT INTO actions(id, name, milestoneId, description, duration, durationUnit, isCompleted, createdAt, updatedAt) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          id,
          input.name,
          input.milestoneId,
          input.description,
          input.duration,
          input.durationUnit.value,
          0,
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String(),
        ]);

    final result = await _db.instance.rawQuery(
      'SELECT * FROM actions WHERE id = ?',
      [id],
    );

    return MilestoneAction.fromJson(result.first);
  }

  Future<ActionResource> createActionResource(
      CreateLocalActionResourceInput input) async {
    final id = const Uuid().v4();
    await _db.instance.rawInsert(
        'INSERT INTO resources(id, title, url, description, actionId) VALUES(?, ?, ?, ?, ?)',
        [
          id,
          input.title,
          input.url,
          input.description,
          input.actionId,
        ]);

    final result = await _db.instance.rawQuery(
      'SELECT * FROM resources WHERE id = ?',
      [id],
    );

    return ActionResource.fromJson(result.first);
  }

  Future<ActionResource> editActionResource(
      EditLocalActionResourceInput input) async {
    await _db.instance.rawUpdate(
      'UPDATE resources SET title = ?, url = ?, description = ? WHERE id = ?',
      [
        input.title,
        input.url,
        input.description,
        input.id,
      ],
    );

    final result = await _db.instance.rawQuery(
      'SELECT * FROM resources WHERE id = ?',
      [input.id],
    );

    return ActionResource.fromJson(result.first);
  }

  Future<void> deleteActionResource(String id) async {
    await _db.instance.rawDelete('DELETE FROM resources WHERE id = ?', [id]);
  }

  Future<MilestoneAction> updateActionComplete(
      String id, bool isCompleted) async {
    await _db.instance.rawUpdate(
      'UPDATE actions SET isCompleted = ? WHERE id = ?',
      [isCompleted ? 1 : 0, id],
    );

    final result = await getActionWithId(id);

    return result;
  }

  Future<MilestoneAction> getActionWithId(String id) async {
    final result = await _db.instance.rawQuery(
      'SELECT * FROM actions WHERE id = ?',
      [id],
    );

    final resources = await _db.instance.rawQuery(
      'SELECT * FROM resources WHERE actionId = ?',
      [id],
    );

    final action = MilestoneAction.fromJson(result.first);

    final actionWithResources = action.copyWith(
      resource: resources.map((e) => ActionResource.fromJson(e)).toList(),
    );

    return actionWithResources;
  }

  Future<MilestoneAction> editAction(EditLocalActionInput input) async {
    await _db.instance.rawUpdate(
      'UPDATE actions SET name = ?, description = ?, duration = ?, durationUnit = ? WHERE id = ?',
      [
        input.name,
        input.description,
        input.duration,
        input.durationUnit?.value,
        input.id,
      ],
    );

    final result = await _db.instance.rawQuery(
      'SELECT * FROM actions WHERE id = ?',
      [input.id],
    );

    return MilestoneAction.fromJson(result.first);
  }

  Future<void> deleteAction(String id) async {
    await _db.instance.rawDelete('DELETE FROM actions WHERE id = ?', [id]);
  }
}
