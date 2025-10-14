enum Server { dev, stage, prod }

var environment = Server.stage;
String baseUrlString() {
  switch (environment) {
    case Server.dev:
      return "";
    case Server.stage:
      return "https://w83sadhrvk.execute-api.ap-southeast-2.amazonaws.com/Prod/api/v1/";
    case Server.prod:
      return "";
  }
}

class UrlConstant {
  UrlConstant._();
  static String loginUrl = "${baseUrlString()}login-dashboard-user";
 
}
