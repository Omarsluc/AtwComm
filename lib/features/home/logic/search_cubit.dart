import 'dart:developer';

import 'package:atw_comm/core/Api/api_sevice_two.dart';
import 'package:atw_comm/features/home/logic/search_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Api/default_model.dart';

class SearchCubit extends Cubit<SearchStates> {

  SearchCubit(): super(SearchInitialState());

  SearchCubit get(context) => BlocProvider.of(context);

  final TextEditingController searchController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  String? sessionID;
  String? botResponse;



  //******************************************************************************************************** */

  Future<void> sendToModel(context) async {
    try {
      emit(SearchLoadingState());
      final apiService = ApiServiceTwo();

        final response = await apiService.sendMessage(
          message: searchController.text,
          sessionId: sessionID ?? '',
        );

        print('Response: ${response['response']}');
        print('Session ID: ${response['session_id']}');
        botResponse = response['response'];
        sessionID = response['session_id'];

      // String resData = response.data;
      // botResponse = resData['response'];
      // sessionID = resData['session_id'];

      searchController.clear();
      emit(SearchSuccessState());
    } catch (e){
      log(e.toString());
      emit(SearchErrorState());

    }

  }


  //******************************************************************************************************** */

  void changeTextFormFieldBasedOnVoiceUser({required String voiceUser}) {
    emit(SearchLoadingState());
    searchController.text = voiceUser;
    emit(SearchSuccessState());
  }

}