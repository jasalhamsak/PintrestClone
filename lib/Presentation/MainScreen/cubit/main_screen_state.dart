part of 'main_screen_cubit.dart';

@immutable
sealed class MainScreenState {}

final class MainScreenInitial extends MainScreenState {}
final class ScreenChanged extends MainScreenState {}
final class ImageLoading extends MainScreenState {}
final class ImageLoaded extends MainScreenState {}
class CategoryChanged extends MainScreenState {}
