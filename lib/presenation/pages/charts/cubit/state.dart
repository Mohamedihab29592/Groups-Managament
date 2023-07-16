abstract class ChartStates{}
class ChartInitialState extends ChartStates{}
class ChartLoadingState extends ChartStates{}
class ChartSuccessState extends ChartStates {}
class ChartErrorState extends ChartStates{
  final String error;
  ChartErrorState(this.error);
}