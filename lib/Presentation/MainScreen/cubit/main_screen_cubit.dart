import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';



import '../../../Resources/Model.dart';

part 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(MainScreenInitial()) {
    getImage();
  }

  int navigationPage = 1;
  int selectedCategoryIndex = 0;
  List<Map<String, dynamic>> imageData = [];
  List<Map<String, dynamic>> SearchimageData = [];
  int currentPage = 1;
  final scrollController = ScrollController();
  bool isPaginationLoading = false;
  bool _scrollListenerAdded = false;
  bool get isScrollListenerAdded => _scrollListenerAdded;
  final searchController = TextEditingController();
  bool searched = false;
  bool wantToSearch = false;
  int currentSearchViewIndex = 1;
  bool imageClicked = false;
  int imageCount = 0;


  void changePage(int pageNumber) {
    navigationPage = pageNumber;
    emit(ScreenChanged());
  }

  void selectCategory(int index) {
    selectedCategoryIndex = index;
    emit(CategoryChanged()); // create this state in your main_screen_state.dart
  }

  Future<void> getImage({loadMore = false}) async {
    if (loadMore) {
      if (isPaginationLoading) return;
      isPaginationLoading = true;
      emit(ImageLoading());
      currentPage++;
    }

    String url =
        "https://api.pexels.com/v1/curated?page=$currentPage&per_page=20";
    String apiKey = "Y3pK9XNPGPLYvEe5Xk05RYoKkE3gFiNlnVe48JHz4jW0MNqNC9RQXTrg";

    final response =
        await http.get(Uri.parse(url), headers: {"Authorization": apiKey});

    if (response.statusCode == 200) {
      final data = imageModelFromJson(response.body);
      final newData = data.photos.map((photo) {
        return {
          "ID": photo.id,
          "url": photo.src.original,
          "alt" :photo.alt
        };
      }).toList();
      if (loadMore) {
        imageData.addAll(newData);
      } else {
        imageData = newData;
      }
      isPaginationLoading = false;
      emit(ImageLoaded());
    } else {
      isPaginationLoading = false;
    }
  }

    void setupScrollListener() {
      if (_scrollListenerAdded) return; // guard: add listener only once
      _scrollListenerAdded = true;

      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          if (!isPaginationLoading) {
            getImage(loadMore: true);
          }
        }
      });
    }

  void getSearchImage({loadMore = false}) async {
    searched = true;
    if (loadMore) {
      if (isPaginationLoading) return;
      isPaginationLoading = true;
      emit(ImageLoading());
      currentPage++;
    }

    final String query = searchController.text;
    String url =
        "https://api.pexels.com/v1/search?query=$query&page=1&per_page=20";
    String apiKey = "Y3pK9XNPGPLYvEe5Xk05RYoKkE3gFiNlnVe48JHz4jW0MNqNC9RQXTrg";

    final response =
        await http.get(Uri.parse(url), headers: {"Authorization": apiKey});

    if (response.statusCode == 200) {
      final Searchdata = imageModelFromJson(response.body);
      final newSearchData = Searchdata.photos.map((photo) {
        return {
          "ID": photo.id,
          "url": photo.src.original,
        };
      }).toList();
      if (loadMore) {
        SearchimageData.addAll(newSearchData);
      } else {
        SearchimageData = newSearchData;
      }
      isPaginationLoading = false;
      emit(ImageLoaded());
    } else {
      isPaginationLoading = false;
    }
  }

  void changeSearchViewIndex(int index) {
    currentSearchViewIndex = index;
    emit(SearchViewChanged());
  }

  void changeSearchedState(isSearched) {
    searched = isSearched;
    emit(IsSearched());
  }
  void changeSearchQuery(query) {
    searchController.text = query;
    emit(IsSearched());
  }

  void isWantToSearch(isWantToSearch) {
    wantToSearch = isWantToSearch;
    emit(IsWantToSearch());
  }

  String url="";
  String alt="";
  void isImageClicked(isImageClicked,getUrl,getAlt) {
    imageClicked = isImageClicked;
     url = getUrl;
     alt = getAlt;
    emit(IsImageClicked());
  }



  Future<void> downloadImage(String url) async {
    emit(ImageDownloading());
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var dir = await getApplicationDocumentsDirectory();

        // Increment count for filename
        imageCount++;

        // Detect extension from content-type header
        String? contentType = response.headers['content-type'];
        String extension = 'jpg'; // fallback
        if (contentType != null) {
          if (contentType.contains('png')) {
            extension = 'png';
          } else if (contentType.contains('jpeg') || contentType.contains('jpg')) {
            extension = 'jpg';
          } else if (contentType.contains('gif')) {
            extension = 'gif';
          }
        } else {
          // fallback: try get extension from url
          final uri = Uri.parse(url);
          final path = uri.path;
          if (path.contains('.')) {
            extension = path.split('.').last;
          }
        }

        String fileName = 'downloaded_image_$imageCount.$extension';
        File file = File('${dir.path}/$fileName');

        await file.writeAsBytes(response.bodyBytes);

        emit(ImageDownloaded(file.path));
      } else {
        emit(ImageDownloadError('Failed to download image. Status: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ImageDownloadError('Error: $e'));
    }
  }
}
