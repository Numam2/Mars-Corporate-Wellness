import 'package:bloc/bloc.dart';

enum ChallengeEvent {reload}

class ChallengeBloc extends Bloc<ChallengeEvent,String>{
  @override
  // TODO: implement initialState
  String get initialState => 'Today';

  @override
  Stream<String> mapEventToState(ChallengeEvent event) async*{
    // TODO: implement mapEventToState
    switch(event){
      case ChallengeEvent.reload:
        yield state;
      break;
    }
    
  }



}