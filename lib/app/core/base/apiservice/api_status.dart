class APIStatus {
  static success(value) => value >= 200 && value <= 300 ? true : false;
  static error(value) => value >= 400 && value <= 500 ? true : false;
  static serverError(value) => value >= 500 && value < 600 ? true : false;
}
