import 'package:permission_handler/permission_handler.dart';

Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
  Map<Permission, PermissionStatus> statuses = {};

  // 请求所有权限
  for (var permission in Permission.values) {
    var status = await permission.request();
    statuses[permission] = status;
  }

  return statuses;
}

Future<bool> checkAllPermissionsGranted() async {
  // 请求所有权限并获取状态
  var statuses = await requestAllPermissions();

  // 检查所有权限状态
  bool allGranted = statuses.values.every((status) => status.isGranted);

  return allGranted;
}
