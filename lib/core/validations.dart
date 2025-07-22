import '../handlers/translation_handler.dart';

mixin Validations {
  String isValidEmail(String email) {
    // Check if empty
    if (email.trim().isEmpty) {
      return "البريد الإلكتروني مطلوب";
    }

    // Basic email pattern
    final basicEmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!basicEmailRegex.hasMatch(email)) {
      return "صيغة البريد الإلكتروني غير صحيحة";
    }

    // Check Mansoura University student domain
    const mansouraDomain = "@std.mans.edu.eg";
    if (!email.toLowerCase().endsWith(mansouraDomain)) {
      return "يجب أن يكون البريد الإلكتروني للطالب على النطاق $mansouraDomain";
    }

    // No errors
    return "";
  }

  String isValidPassword(String password) {
    if (password.isEmpty) {
      return "Password is required";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }
    // Check for password complexity
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must contain at least one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password must contain at least one lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must contain at least one number";
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Password must contain at least one special character";
    }
    return "";
  }

  String isValidPhone(String phone) {
    if (phone.isEmpty) {
      return "Phone number is required";
    }
    // Remove any non-digit characters for validation
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.length < 10 || cleanPhone.length > 15) {
      return "Please enter a valid phone number (10-15 digits)";
    }
    return "";
  }

  String isValidConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return "Please confirm your password";
    }
    if (confirmPassword != password) {
      return "Passwords do not match";
    }
    return "";
  }

  String isValidCode(String code) {
    if (code.isEmpty) {
      return "Verification code is required";
    }
    if (code.length != 6) {
      return "Verification code must be 6 digits";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(code)) {
      return "Verification code must contain only numbers";
    }
    return "";
  }

  String isValidName(String name) {
    if (name.isEmpty) {
      return "Full name is required";
    }
    if (name.length < 3) {
      return "Full name must be at least 3 characters long";
    }
    // Check for valid characters in name
    if (!RegExp(r'^[a-zA-Z\s\-\.]+$').hasMatch(name)) {
      return "Name can only contain letters, spaces, hyphens, and periods";
    }
    return "";
  }

  String isValidFirstName(String name) {
    if (name.isEmpty) {
      return "First name is required";
    }
    if (name.length < 2) {
      return "First name must be at least 2 characters long";
    }
    if (!RegExp(r'^[a-zA-Z\s\-\.]+$').hasMatch(name)) {
      return "First name can only contain letters, spaces, hyphens, and periods";
    }
    return "";
  }

  String isValidLastName(String name) {
    if (name.isEmpty) {
      return "Last name is required";
    }
    if (name.length < 2) {
      return "Last name must be at least 2 characters long";
    }
    if (!RegExp(r'^[a-zA-Z\s\-\.]+$').hasMatch(name)) {
      return "Last name can only contain letters, spaces, hyphens, and periods";
    }
    return "";
  }

  String isValidCivilNumber(String civilNumber) {
    if (civilNumber.isEmpty) {
      return "Civil ID number is required";
    }
    // Remove any non-digit characters
    final cleanNumber = civilNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanNumber.length != 10) {
      return "Civil ID number must be exactly 10 digits";
    }
    // Check if all characters are numbers
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      return "Civil ID number must contain only digits";
    }
    return "";
  }

  String isValidAge(String age) {
    if (age.isEmpty) {
      return "Age is required";
    }
    if (int.tryParse(age) == null) {
      return "Age must be a valid number";
      }
    if (int.parse(age) < 0) {
      return "Age cannot be negative";
    }
    return "";
  }
}
