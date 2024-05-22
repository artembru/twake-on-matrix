// Mocks generated by Mockito 5.4.4 from annotations
// in fluffychat/test/domain/contacts/contacts_manager_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i5;
import 'package:fluffychat/app_state/failure.dart' as _i6;
import 'package:fluffychat/app_state/success.dart' as _i7;
import 'package:fluffychat/domain/repository/contact_repository.dart' as _i2;
import 'package:fluffychat/domain/usecase/contacts/get_tom_contacts_interactor.dart'
    as _i3;
import 'package:fluffychat/domain/usecase/contacts/phonebook_contact_interactor.dart'
    as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeContactRepository_0 extends _i1.SmartFake
    implements _i2.ContactRepository {
  _FakeContactRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetTomContactsInteractor].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTomContactsInteractor extends _i1.Mock
    implements _i3.GetTomContactsInteractor {
  MockGetTomContactsInteractor() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ContactRepository get contactRepository => (super.noSuchMethod(
        Invocation.getter(#contactRepository),
        returnValue: _FakeContactRepository_0(
          this,
          Invocation.getter(#contactRepository),
        ),
      ) as _i2.ContactRepository);

  @override
  _i4.Stream<_i5.Either<_i6.Failure, _i7.Success>> execute(
          {required int? limit}) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [],
          {#limit: limit},
        ),
        returnValue: _i4.Stream<_i5.Either<_i6.Failure, _i7.Success>>.empty(),
      ) as _i4.Stream<_i5.Either<_i6.Failure, _i7.Success>>);
}

/// A class which mocks [PhonebookContactInteractor].
///
/// See the documentation for Mockito's code generation for more information.
class MockPhonebookContactInteractor extends _i1.Mock
    implements _i8.PhonebookContactInteractor {
  MockPhonebookContactInteractor() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i5.Either<_i6.Failure, _i7.Success>> execute(
          {int? lookupChunkSize = 50}) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [],
          {#lookupChunkSize: lookupChunkSize},
        ),
        returnValue: _i4.Stream<_i5.Either<_i6.Failure, _i7.Success>>.empty(),
      ) as _i4.Stream<_i5.Either<_i6.Failure, _i7.Success>>);
}
