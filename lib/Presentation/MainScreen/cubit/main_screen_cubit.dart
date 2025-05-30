
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
        List <Map<String,dynamic>> SearchimageData=[];
        int currentPage = 1;
        final scrollController = ScrollController();
        bool isPaginationLoading = false;
        bool _scrollListenerAdded = false;
        bool get isScrollListenerAdded => _scrollListenerAdded;
        final searchController =TextEditingController();
        bool searched = false;


        void changePage(int pageNumber){
          navigationPage = pageNumber;
          emit(ScreenChanged());
        }



        void selectCategory(int index) {
          selectedCategoryIndex = index;
          emit(CategoryChanged());  // create this state in your main_screen_state.dart
        }



        Future<void> getImage({loadMore = false}) async{
          if (loadMore){
            if(isPaginationLoading)return;
            isPaginationLoading =true;
            emit(ImageLoading());
            currentPage++;
          }

          String url = "https://api.pexels.com/v1/curated?page=$currentPage&per_page=20";
          String apiKey ="Y3pK9XNPGPLYvEe5Xk05RYoKkE3gFiNlnVe48JHz4jW0MNqNC9RQXTrg";

          final response = await http.get(Uri.parse(url),
          headers: {
            "Authorization" :apiKey
          });

          if(response.statusCode==200){
            final data =imageModelFromJson(response.body);
            final newData =data.photos.map((photo){
              return{
                "ID" :photo.id,
                "url" :photo.src.original,
              };
            }).toList();
            if(loadMore){

              imageData.addAll(newData);
            }else{
              imageData =newData;
            }
            isPaginationLoading=false;
            emit(ImageLoaded());
          }else{
            isPaginationLoading =false;
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

          void getSearchImage({loadMore = false})async{
            searched = true;
            if (loadMore){
              if(isPaginationLoading)return;
              isPaginationLoading =true;
              emit(ImageLoading());
              currentPage++;
            }

            final String query = searchController.text;
            String url = "https://api.pexels.com/v1/search?query=$query&page=1&per_page=20";
            String apiKey ="Y3pK9XNPGPLYvEe5Xk05RYoKkE3gFiNlnVe48JHz4jW0MNqNC9RQXTrg";

            final response = await http.get(Uri.parse(url),
                headers: {
                  "Authorization" :apiKey
                });

            if(response.statusCode==200){
              final Searchdata =imageModelFromJson(response.body);
              final newSearchData =Searchdata.photos.map((photo){
                return{
                  "ID" :photo.id,
                  "url" :photo.src.original,
                };
              }).toList();
              if(loadMore){

                SearchimageData.addAll(newSearchData);
              }else{
                SearchimageData =newSearchData;
              }
              isPaginationLoading=false;
              emit(ImageLoaded());
            }else{
              isPaginationLoading=false;
            }
          }

        }
