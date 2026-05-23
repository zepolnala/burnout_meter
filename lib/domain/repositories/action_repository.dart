import '../models/action.dart';

abstract class ActionRepository {
  Future<void> sendAction(ActionInstance action);
  Future<void> updateActionStatus(String actionId, String status);
  Future<List<ActionInstance>> getActionsForUser(String userId);
  Future<List<ActionInstance>> getActionsSentByUser(String senderUserId);
  Stream<List<ActionInstance>> watchActionsForUser(String userId);
}
