import 'dart:math';

class Statistics {
  static const _pi = pi;

  static double gamma(double z) {
    const p = [
      0.99999999999980993,
      676.5203681218851,
      -1259.1392167224028,
      771.32342877765313,
      -176.61502916214059,
      12.507343278686905,
      -0.13857109526572012,
      9.9843695780195716e-6,
      1.5056327351493116e-7,
    ];
    if (z < 0.5) return _pi / (sin(_pi * z) * gamma(1 - z));
    z -= 1;
    var x = p[0];
    for (var i = 1; i < 9; i++) {
      x += p[i] / (z + i);
    }
    final t = z + 7.5;
    return sqrt(2 * _pi) * pow(t, z + 0.5) * exp(-t) * x;
  }

  static double logGamma(double x) => log(gamma(x));

  static double erf(double x) {
    const a = [0.254829592, -0.284496736, 1.421413741, -1.453152027, 1.061405429];
    const p = 0.3275911;
    final sign = x < 0 ? -1 : 1;
    final ax = x.abs();
    final t = 1 / (1 + p * ax);
    double y = 1;
    for (int i = 0; i < a.length; i++) {
      y -= a[i] * pow(t, i + 1);
    }
    return sign * (1 - y * exp(-ax * ax));
  }

  static double normalCdf(double x) => 0.5 * (1 + erf(x / sqrt(2)));

  static double normalPdf(double x) => exp(-0.5 * x * x) / sqrt(2 * _pi);

  static double fPdf(double f, double d1, double d2) {
    if (f <= 0) return 0;
    final lnum = logGamma((d1 + d2) / 2) + (d1 / 2) * log(d1 / d2) + (d1 / 2 - 1) * log(f);
    final lden = logGamma(d1 / 2) + logGamma(d2 / 2) + ((d1 + d2) / 2) * log(1 + d1 * f / d2);
    return exp(lnum - lden);
  }

  static double chiSquarePdf(double x, double k) {
    if (x <= 0) return 0;
    final lval = (k / 2 - 1) * log(x) - x / 2 - (k / 2) * log(2) - logGamma(k / 2);
    return exp(lval);
  }

  static double regularizedIncompleteGamma(double a, double x) {
    if (x <= 0) return 0.0;
    return _gammaSeries(a, x);
  }

  static double _gammaSeries(double a, double x) {
    var sum = 1.0 / a;
    var del = sum;
    var ap = a;
    for (var n = 1; n < 200; n++) {
      ap += 1;
      del *= x / ap;
      sum += del;
      if (del.abs() < sum.abs() * 3e-7) break;
    }
    return sum * exp(-x + a * log(x) - logGamma(a));
  }

  static double regularizedIncompleteBeta(double x, double a, double b) {
    if (x <= 0) return 0.0;
    if (x >= 1) return 1.0;
    final lbeta = logGamma(a) + logGamma(b) - logGamma(a + b);
    final front = exp(log(x) * a + log(1 - x) * b - lbeta) / a;
    return front * _betaCf(x, a, b);
  }

  static double _betaCf(double x, double a, double b) {
    const maxIter = 200;
    const eps = 3e-7;
    final qab = a + b;
    final qap = a + 1;
    final qam = a - 1;
    var c = 1.0;
    var d = 1.0 - qab * x / qap;
    if (d.abs() < 1e-30) d = 1e-30;
    d = 1.0 / d;
    var h = d;
    for (var m = 1; m <= maxIter; m++) {
      final m2 = 2 * m;
      var aa = m * (b - m) * x / ((qam + m2) * (a + m2));
      d = 1.0 + aa * d;
      if (d.abs() < 1e-30) d = 1e-30;
      c = 1.0 + aa / c;
      if (c.abs() < 1e-30) c = 1e-30;
      d = 1.0 / d;
      h *= d * c;
      aa = -(a + m) * (qab + m) * x / ((a + m2) * (qap + m2));
      d = 1.0 + aa * d;
      if (d.abs() < 1e-30) d = 1e-30;
      c = 1.0 + aa / c;
      if (c.abs() < 1e-30) c = 1e-30;
      d = 1.0 / d;
      final del = d * c;
      h *= del;
      if ((del - 1.0).abs() < eps) break;
    }
    return h;
  }

  static double fCdf(double f, double d1, double d2) {
    if (f <= 0) return 0;
    final x = (d1 * f) / (d1 * f + d2);
    return regularizedIncompleteBeta(x, d1 / 2, d2 / 2);
  }

  static double chiSquareCdf(double x, double k) {
    if (x <= 0) return 0;
    return regularizedIncompleteGamma(k / 2, x / 2);
  }

  static double weibullReliability(double t, double m, double eta) {
    if (t <= 0) return 1.0;
    return exp(-pow(t / eta, m));
  }

  static double weibullHazard(double t, double m, double eta) {
    if (t <= 0) return 0.0;
    return (m / eta) * pow(t / eta, m - 1);
  }

  static double weibullMTTF(double m, double eta) => eta * gamma(1 + 1 / m);

  static double binomialCdf(int n, int c, double p) {
    double sum = 0;
    double term = pow(1 - p, n).toDouble();
    for (int k = 0; k <= c; k++) {
      sum += term * _comb(n, k);
      if (k < c) term *= p / (1 - p);
    }
    return sum;
  }

  static double _comb(int n, int k) {
    if (k > n) return 0;
    if (k == 0 || k == n) return 1;
    double result = 1;
    for (int i = 0; i < k; i++) {
      result *= (n - i) / (i + 1);
    }
    return result;
  }
}
