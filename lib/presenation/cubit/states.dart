abstract class TaskState{}
class TaskCubitInitialState extends TaskState{}


class CriticalChange extends TaskState{}


class AppLoadingState extends TaskState{}
class AppNoDataTasks extends TaskState{}
class AppDataBaseTasks extends TaskState{}
class AppErrorTasks extends TaskState{}

class AppLoadingInsertDataBaseState extends TaskState{}
class AppInsertDateBaseDone extends TaskState{}
class InsertDateBaseError extends TaskState{}

class AppDeleteDataBase extends TaskState{}

class CompleteTasksState extends TaskState{}
class CompleteErrorState extends TaskState{}
class criticalTasksState extends TaskState{}
class criticalErrorState extends TaskState{}

class UpdateDatabaseLoading extends TaskState{}
class UpdateDatabaseDone extends TaskState{}
class UpdateDatabaseError extends TaskState{}

class ScheduleDataBase extends TaskState{}

class TaskColorChanged extends TaskState{}

class AppSelectTask extends TaskState{}
