String? emailValidator(String? value) {
  return RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value!)
      ? null
      : "Correo electrónico no válido.";
}

String? emptyValidator(String? value) {
  return (value == null || value.isEmpty) ? "Este campo es obligatorio." : null;
}

String? passwordValidator(String? value) {
  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  return (value == null || value.isEmpty)
      ? "Este campo es obligatorio."
      : (!regex.hasMatch(value))
          ? 'La contraseña debe tener al menos 8 caracteres e incluir al menos una mayúscula, una minúscula y un número'
          : null;
}

String? confirmValueValidator(String? value, String? reference) {
  return (value == null || value.isEmpty)
      ? "Este campo es obligatorio."
      : (value != reference)
          ? "Las contraseñas no coinciden."
          : null;
}

String? phoneValidator(String? value) {
  return (value == null || value.isEmpty)
      ? "Este campo es obligatorio."
      : (value.length != 10)
          ? "Los números de teléfono tienen 10 dígitos."
          : null;
}

String? confirmValidator(String? value, String reference) {
  return (value == null || value.isEmpty)
      ? 'Este campo es obligatorio.'
      : (value != reference)
          ? 'Las contraseñas no coinciden'
          : null;
}
