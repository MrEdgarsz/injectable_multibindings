// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:multibidings_example/app.dart' as _i846;
import 'package:multibidings_example/notification_service.dart' as _i709;
import 'package:multibidings_example/services/email_service.dart' as _i57;
import 'package:multibidings_example/services/push_service.dart' as _i958;
import 'package:multibidings_example/services/sms_service.dart' as _i149;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i57.EmailService>(() => _i57.EmailService());
    gh.factory<_i958.PushService>(() => _i958.PushService());
    gh.factory<_i149.SMSService>(() => _i149.SMSService());
    gh.factory<_i846.NotificationManager>(() =>
        _i846.NotificationManager(gh<Iterable<_i709.NotificationService>>()));
    return this;
  }
}
