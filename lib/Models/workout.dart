class Workout {

  int rounds;
  String stage;
  List<Exercise> sets;

  Workout({this.rounds,this.stage, this.sets});

}


class Exercise {

  String exerciseName;
  String reps;
  String weight;
  int duration;

  Exercise({this.exerciseName,this.reps, this.weight, this.duration});

}