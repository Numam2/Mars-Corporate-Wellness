
class Goals{

  final String description;
  final double initialValue;
  final double targetValue;
  final double currentValue;
  final String stage;
  final String unit;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String goalType;
  final List<Milestones> milestones;

  Goals({
    this.description,
    this.initialValue, 
    this.targetValue, 
    this.currentValue, 
    this.stage, 
    this.unit, 
    this.dateFrom, 
    this.dateTo, 
    this.goalType,
    this.milestones,
  });

}

class Milestones {
  final String description;
  bool complete;

  Milestones({this.description, this.complete});
}