import '../models/consent.dart';

abstract class ConsentRepository {
  Future<Consent?> getConsent(String userId);
  Future<void> saveConsent(Consent consent);
  Stream<Consent?> watchConsent(String userId);
}
