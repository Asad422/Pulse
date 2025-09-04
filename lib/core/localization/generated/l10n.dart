// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Pulse`
  String get appTitle {
    return Intl.message(
      'Pulse',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get splashGreeting {
    return Intl.message(
      'Welcome!',
      name: 'splashGreeting',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homeTitle {
    return Intl.message(
      'Home',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  /// `We the People`
  String get onbHeader {
    return Intl.message(
      'We the People',
      name: 'onbHeader',
      desc: '',
      args: [],
    );
  }

  /// `Rate politicians and their policies\nHolding power to account`
  String get onbSubtitle {
    return Intl.message(
      'Rate politicians and their policies\nHolding power to account',
      name: 'onbSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Vote on policies that affect you`
  String get onbSectionTitle {
    return Intl.message(
      'Vote on policies that affect you',
      name: 'onbSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Express your support or opposition on legislation that matters to your community.`
  String get onbSectionBody {
    return Intl.message(
      'Express your support or opposition on legislation that matters to your community.',
      name: 'onbSectionBody',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get onbCtaGetStarted {
    return Intl.message(
      'Get Started',
      name: 'onbCtaGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Continue as Guest`
  String get onbCtaContinueGuest {
    return Intl.message(
      'Continue as Guest',
      name: 'onbCtaContinueGuest',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, you agree to our `
  String get onbTermsPrefix {
    return Intl.message(
      'By continuing, you agree to our ',
      name: 'onbTermsPrefix',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get onbTermsTerms {
    return Intl.message(
      'Terms of Service',
      name: 'onbTermsTerms',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get onbTermsAnd {
    return Intl.message(
      ' and ',
      name: 'onbTermsAnd',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get onbTermsPrivacy {
    return Intl.message(
      'Privacy Policy',
      name: 'onbTermsPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `legalPolicySafetyTitle`
  String get legalPolicySafetyTitle {
    return Intl.message(
      'legalPolicySafetyTitle',
      name: 'legalPolicySafetyTitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
