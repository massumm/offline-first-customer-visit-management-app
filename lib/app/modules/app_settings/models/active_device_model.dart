enum DeviceTypeEnum { mobile, laptop }

enum OsTypeEnum {
  android,
  ios,
  macOs,
  windows;

  String get os {
    const osNames = {
      OsTypeEnum.android: 'Android',
      OsTypeEnum.ios: 'iOS App',
      OsTypeEnum.macOs: 'MacOS',
      OsTypeEnum.windows: 'Windows',
    };
    return osNames[this] ?? 'Unknown';
  }
}

enum SessionStatusEnum {
  active,
  inactive,
  notUsedRecently;

  String get status {
    const statusNames = {
      SessionStatusEnum.active: 'Active',
      SessionStatusEnum.inactive: 'Inactive',
      SessionStatusEnum.notUsedRecently: 'Not used recently',
    };
    return statusNames[this] ?? 'Unknown';
  }
}

class ActiveDevice {
  final String deviceName;
  final DeviceTypeEnum deviceType;
  final OsTypeEnum osType;
  final SessionStatusEnum sessionStatus;
  final DateTime lastActive;

  ActiveDevice({
    required this.deviceName,
    required this.deviceType,
    required this.osType,
    required this.sessionStatus,
    required this.lastActive,
  });
}
