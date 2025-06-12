import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final isAvailable = await auth.canCheckBiometrics;
    final hasHardware = await auth.isDeviceSupported();
    if (!isAvailable || !hasHardware) return false;

    try {
      return await auth.authenticate(
        localizedReason: '',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      return false;
    }
  }
}
