// import 'package:vittavridhi/app/modules/all_groups/views/all_groups_view.dart';

class APIEndpoints {
  static const baseURL = _development;
  static const _development =
      "https://2tice5smragy4oxgo3qvcy52q40qzwed.lambda-url.us-east-1.on.aws/";
  static const auth = _Auth();

  static const group = _Group();

  static const logs = _Logs();

  static const table = _Table();

  static const profile = _Profile();

  static const meals = _Meals();

  static const createData = _CreateData();
  static const notification = _Notification();
}

class _Table {
  const _Table();
  String get apiProductSearch => "${APIEndpoints.baseURL}api/products";
  String get deleteUpdateNozzle => "${APIEndpoints.baseURL}api/nozzle";
  String get tank => "${APIEndpoints.baseURL}api/tanks";
  String get reports => "${APIEndpoints.baseURL}api/reports";
  String get getflow => "${APIEndpoints.baseURL}api/get_completed_flow";

  String get assignNozzelsClose =>
      "${APIEndpoints.baseURL}api/allassignedNozzelles/";

  String get dispensing => "${APIEndpoints.baseURL}api/dispensing_units";

  String get cngdispensing => "${APIEndpoints.baseURL}api/cng/dispensing_units";

  String get customerAssign =>
      "${APIEndpoints.baseURL}api/customers_assign_shit/1";

  String get assignedNozzelles =>
      "${APIEndpoints.baseURL}api/assignedNozzelles";
}

class _CreateData {
  const _CreateData();
  // String get assignTank => "${APIEndpoints.baseURL}api/assign-tank/";
  String get createGroup => "${APIEndpoints.baseURL}groups";
  String get createMeal => "${APIEndpoints.baseURL}meals";
  String get mealHistory => "${APIEndpoints.baseURL}meals/history";
  String searchUserByemail(String email) =>
      "${APIEndpoints.baseURL}user-details?email=$email";
  String searchUserByPhone(String phone) =>
      "${APIEndpoints.baseURL}user-details?phone_number=$phone";
  String get generateDiet => "${APIEndpoints.baseURL}generate-diet-plan";
  String get copyMeals => "${APIEndpoints.baseURL}meals/copy";
}

class _Profile {
  const _Profile();

  String get userProfile => "${APIEndpoints.baseURL}api/profile";
}

class _Notification {
  const _Notification();

  String get getNotification => "${APIEndpoints.baseURL}notifications";
  String postNotification(id, action) =>
      "${APIEndpoints.baseURL}notifications/$id/respond?action=$action";
}

class _Auth {
  const _Auth();
  String get signup => "${APIEndpoints.baseURL}registration";
  String get login => "${APIEndpoints.baseURL}login";
}

class _Group {
  const _Group();
  String get groupMember => "${APIEndpoints.baseURL}groups_with_members";
  String get userGroup => "${APIEndpoints.baseURL}users";
  String get pooledRequests => "${APIEndpoints.baseURL}pooled_requests";
  String get createGroup => "${APIEndpoints.baseURL}admin/groups";
  String get addGroup => "${APIEndpoints.baseURL}groups";

  String addGroupMember(groupId, userId) =>
      "${APIEndpoints.baseURL}groups/$groupId/send-request/$userId";
}

class _Meals {
  const _Meals();

  String getadmindMeals(id, role) =>
      "${APIEndpoints.baseURL}$role/meals?groupId=$id";
  String getuserdHistory(
    id,
  ) =>
      "${APIEndpoints.baseURL}user/meals_history_meals?groupId=$id";
  String getadmindHistory(userId, groupId) =>
      "${APIEndpoints.baseURL}admin/meals_history_meals?groupId=$groupId&userId=$userId";
}

class _Logs {
  const _Logs();
  String get errorLogs => "${APIEndpoints.baseURL}error_logs/";
}
