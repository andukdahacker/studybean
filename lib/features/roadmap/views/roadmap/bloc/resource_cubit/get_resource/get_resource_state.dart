part of 'get_resource_cubit.dart';

sealed class GetResourceState extends Equatable {}

class GetResourceInitial extends GetResourceState {
  @override
  List<Object?> get props => [];
}

class GetResourceLoading extends GetResourceState {
  @override
  List<Object?> get props => [];
}

class GetResourceSuccess extends GetResourceState {
  final ActionResource actionResource;

  GetResourceSuccess(this.actionResource);

  @override
  List<Object?> get props => [actionResource];
}

class GetResourceFailed extends GetResourceState {
  final Object error;

  GetResourceFailed(this.error);

  @override
  List<Object?> get props => [error];
}