class MyValidators {
  static String? displayNameValidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Morate da unesete podatke';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Korisnicko ime mora da ima izmedju 3 i 20 karaktera';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Morate da unesete email';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return 'Morate da unesete validan email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Morate da unesete lozinku';
    }
    if (value.length < 6) {
      return 'Lozinka mora da ima najmanje 6 karaktera';
    }
    return null;
  }

  static String? uploadProdTexts({String? value, String? toBeReturnedString}) {
    if (value == null || value.isEmpty) {
      return toBeReturnedString;
    }
    return null;
  }
}
