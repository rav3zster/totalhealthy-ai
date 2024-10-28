// import 'package:vittavridhi/app/modules/all_groups/views/all_groups_view.dart';

class APIEndpoints {
  static const baseURL = _development;
  static const _development =
      "https://2tice5smragy4oxgo3qvcy52q40qzwed.lambda-url.us-east-1.on.aws/";
  static const auth = _Auth();

  static const group = _Group();

  static const logs = _Logs();

  static const link = _Link();

  static const table = _Table();

  static const employee = _Employee();

  static const profile = _Profile();

  static const customer = _Customer();

  static const createData = _CreateData();
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
}

class _Employee {
  const _Employee();
  String get getClosingSift =>
      "${APIEndpoints.baseURL}api/all-assigned-employees";
  String get createEmployee => "${APIEndpoints.baseURL}api/employees";
  String get employeeStatus =>
      "${APIEndpoints.baseURL}api/update_employees_status/";
  String get designnation => "${APIEndpoints.baseURL}api/designations";
  // String get assignNozzel => "${APIEndpoints.baseURL}api/assign-nozzel";
  String get updateEmployeeStatus =>
      "${APIEndpoints.baseURL}api/update-employee-assi-status";
}

class _Profile {
  const _Profile();

  String get userProfile => "${APIEndpoints.baseURL}api/profile";
  String get getprofile => "${APIEndpoints.baseURL}api/profile";
}

class _Auth {
  const _Auth();
  String get signup =>
      "https://uxtaxcxe54qbnsse3mffqq2i6i0vbnqd.lambda-url.us-east-1.on.aws/registration";
  String get login => "${APIEndpoints.baseURL}login";
}

class _Group {
  const _Group();
  String get groupMember => "${APIEndpoints.baseURL}groups_with_members";
  String get userGroup => "${APIEndpoints.baseURL}users";
  String get pooledRequests => "${APIEndpoints.baseURL}pooled_requests";
  String get createGroup => "${APIEndpoints.baseURL}groups";
}

class _Link {
  const _Link();
  String get terms => "http://uden.tech/terms-and-conditions";
  String get privacy => "http://uden.tech/privacy-policy";
}

class _Customer {
  const _Customer();

  String get vehicle => "${APIEndpoints.baseURL}api/vehicles";
  String get vehicleGet => "${APIEndpoints.baseURL}api/vehicles?customerId=";
  String get company => "${APIEndpoints.baseURL}api/customers";
  String get customerAssignwithID =>
      "${APIEndpoints.baseURL}api/customers_assign_shit/";
  String get openday => "${APIEndpoints.baseURL}api/open-days";
}

class _Logs {
  const _Logs();
  String get errorLogs => "${APIEndpoints.baseURL}error_logs/";
}
