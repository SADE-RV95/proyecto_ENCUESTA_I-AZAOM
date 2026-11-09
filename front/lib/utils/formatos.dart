const _meses = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

List<int>? _partes(String raw) {
  try {
    final p = raw.split(' ').first.split('-');
    final y = int.parse(p[0]);
    final m = int.parse(p[1]);
    final d = int.parse(p[2]);
    if (m < 1 || m > 12) return null;
    return [y, m, d];
  } catch (_) {
    return null;
  }
}

/// "2026-10-08" -> "8 oct"
String fechaCorta(String raw) {
  final f = _partes(raw);
  return f == null ? raw : '${f[2]} ${_meses[f[1] - 1]}';
}

/// "2026-09-28 10:30:00" -> "28 sep 2026"
String fechaLarga(String raw) {
  final f = _partes(raw);
  return f == null ? raw : '${f[2]} ${_meses[f[1] - 1]} ${f[0]}';
}

/// "Mariana López" -> "ML"
String iniciales(String nombre) {
  final partes =
      nombre.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
  if (partes.isEmpty) return '?';
  if (partes.length == 1) {
    final p = partes.first;
    return (p.length >= 2 ? p.substring(0, 2) : p).toUpperCase();
  }
  return (partes[0][0] + partes[1][0]).toUpperCase();
}
