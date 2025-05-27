
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
    import 'package:meta/meta.dart';
    import 'package:http/http.dart'as http;

    import '../../../Resources/Model.dart';

    part 'main_screen_state.dart';

    class MainScreenCubit extends Cubit<MainScreenState> {
      MainScreenCubit() : super(MainScreenInitial()){
        getImage();
      }

      int navigationPage = 1;
      int selectedCategoryIndex = 0;
      List <Map<String,dynamic>> imageData=[];
      int currentPage = 1;
      final scrollController = ScrollController();
      bool  isPaginationListener = false;
      bool _scrollListenerAdded = false;
      bool get isScrollListenerAdded => _scrollListenerAdded;

      void changePage(int pageNumber){
        navigationPage = pageNumber;
        emit(ScreenChanged());
      }



      void selectCategory(int index) {
        selectedCategoryIndex = index;
        emit(CategoryChanged());  // create this state in your main_screen_state.dart
      }



      Future<void> getImage({loadMore = false}) async{
        if (loadMore) currentPage++;

        String url = "https://api.pexels.com/v1/curated?page=$currentPage&per_page=20";
        String apiKey ="Y3pK9XNPGPLYvEe5Xk05RYoKkE3gFiNlnVe48JHz4jW0MNqNC9RQXTrg";

        final response = await http.get(Uri.parse(url),
        headers: {
          "Authorization" :apiKey
        });

        if(response.statusCode==200){
          print("success");
          final data =imageModelFromJson(response.body);
          final newData =data.photos.map((photo){
            return{
              "ID" :photo.id,
              "url" :photo.src.original,
            };
          }).toList();
          if(loadMore){
            final existingIds = imageData.map((e) => e["ID"]).toSet();
            final filteredNewData =
            newData.where((element) => !existingIds.contains(element["ID"])).toList();

            imageData.addAll(filteredNewData);
          }else{
            imageData =newData;
          }

          emit(ImageLoaded());
        }else{
          print("error");
        }
      }

  void setupScrollListener() {

    if (_scrollListenerAdded) return; // guard: add listener only once
    _scrollListenerAdded = true;

          scrollController.addListener(() {
            if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 300) {
              if (!isPaginationListener) {
                isPaginationListener = true;
                getImage(loadMore: true).then((_) {
                  isPaginationListener = false;
                });
              }
            }
          });
        }




      }
