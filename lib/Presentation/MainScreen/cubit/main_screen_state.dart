part of 'main_screen_cubit.dart';

@immutable
sealed class MainScreenState {}

final class MainScreenInitial extends MainScreenState {}
final class ScreenChanged extends MainScreenState {}
final class ImageLoading extends MainScreenState {}
final class ImageLoaded extends MainScreenState {}
class CategoryChanged extends MainScreenState {}
class SearchViewChanged extends MainScreenState {}
class IsSearched extends MainScreenState {}
class IsWantToSearch extends MainScreenState {}
class IsImageClicked extends MainScreenState {}
class ImageDownloading extends MainScreenState {}
class ImageDownloaded extends MainScreenState {
  final String imagePath;
  ImageDownloaded(this.imagePath);
}
class ImageDownloadError extends MainScreenState {
  final String error;
  ImageDownloadError(this.error);
}
