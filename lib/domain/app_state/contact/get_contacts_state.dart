import 'package:fluffychat/app_state/failure.dart';
import 'package:fluffychat/app_state/initial.dart';
import 'package:fluffychat/app_state/lazy_load_success.dart';
import 'package:fluffychat/app_state/success.dart';
import 'package:fluffychat/domain/model/contact/contact.dart';

class GetContactsInitial extends Initial {
  const GetContactsInitial() : super();

  @override
  List<Object?> get props => [];
}

class GetContactsLoading extends Success {
  const GetContactsLoading() : super();

  @override
  List<Object?> get props => [];
}

class GetContactsSuccess extends LazyLoadSuccess<Contact> {
  final String keyword;

  const GetContactsSuccess({
    required super.data,
    required super.offset,
    required super.isEnd,
    required this.keyword,
  });

  @override
  List<Object?> get props => [data, offset, isEnd, keyword];

  GetContactsSuccess addMore(GetContactsSuccess other) {
    return GetContactsSuccess(
      data: data + other.data,
      offset: other.offset,
      isEnd: other.isEnd,
      keyword: other.keyword,
    );
  }
}

class GetContactsFailure extends Failure {
  final String keyword;
  final dynamic exception;

  const GetContactsFailure({
    required this.keyword,
    required this.exception,
  });

  @override
  List<Object?> get props => [keyword, exception];
}
