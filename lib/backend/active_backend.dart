import '../core/backend/backend.dart';
import 'rest/rest_backend.dart';

/// The backend the app runs against.
///
/// The app talks to the Django REST API exclusively via [RestBackend]. The
/// [Backend] abstraction remains the single seam: another backend would be a new
/// `Backend` implementation swapped in here.
final Backend activeBackend = RestBackend();
