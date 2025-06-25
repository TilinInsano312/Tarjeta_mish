class AppConfig {

  static const String appName = "MyApp";
  static const String appVersion = "1.0.0";
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  static const String apiAuthEndpoint = '/auth';
  static const String accountEndpoint = '/account';
  static const String transactionEndpoint = '/transaction';
  static const String cardEndpoint = '/card';
  static const String contactEndpoint = '/contact';
  static const String userEndpoint = '/user';
  static const Duration timeoutDuration = Duration(seconds: 10);


}