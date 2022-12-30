
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_rev/layout/cubit/states.dart';
import 'package:todo_rev/modules/archived_screen/archived_screen.dart';
import 'package:todo_rev/modules/done_screen/done_screen.dart';
import 'package:todo_rev/modules/tasks_screen/tasks_screen.dart';

class TodoAppCubit extends Cubit<TodoAppStates>
{
  TodoAppCubit() : super(TodoAppInitialState());

  static TodoAppCubit get(context) =>BlocProvider.of(context);

  int currentIndex=0;

  void changeBottomNavIndex(int index)
  {
    currentIndex = index;
    emit(TodoAppChangeBottomNavIndexState());
  }

  List<Widget> screens =
  [
    TasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  List<String> titles =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  List<BottomNavigationBarItem> items =
  [
    BottomNavigationBarItem(
      icon: Icon(Icons.menu),
      label: 'Tasks',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.task_alt_outlined),
      label: 'Done',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.archive),
      label: 'Archived',
    ),
  ];

  bool isBottomSheetShown = false;
  IconData floatingIcon = Icons.edit;

  void changeBottomSheet({
    @required bool isShown,
    @required IconData fabIcon,
})
  {
    isBottomSheetShown = isShown;
    floatingIcon = fabIcon;
    emit(TodoAppChangeBottomSheetState());
  }

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase()
  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,version)
      {
        print('Database Created');

          database.execute('CREATE TABLE todo (id INTEGER PRIMARY KEY ,title TEXT , time TEXT , date TEXT , status TEXT)').then((value)
        {
          print('Table Created');
        }
        ).catchError((error)
        {
          print('Error While Creating table : ${error.toString()}');
        }
        );
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('Database Opened');
      }
    ).then((value)
    {
      database = value ;
      emit(TodoAppCreateDatabaseState());
    }
    );
  }

   void insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
}) async
  {
    await database.transaction((txn)
    {
       txn.rawInsert('INSERT INTO Todo(title , time , date , status) VALUES("$title" , "$time" , "$date" , "new")');
    }
    ).then((value)
    {
      print('$value Inserted successfully');

      emit(TodoAppInsertIntoDatabaseState());

      getDataFromDatabase(database);
      return null;
    }
    );
  }

  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(TodoAppLoadingDatabaseState());

    database.rawQuery('SELECT * FROM todo').then((value)
    {
      value.forEach((element)
      {
        if(element['status']=='new')
        {
          newTasks.add(element);
        }
        else if(element['status']=='done')
        {
          doneTasks.add(element);
        }
        else
        {
          archivedTasks.add(element);
        }
      }
      );
      emit(TodoAppGetDataFromDatabaseState());
    }
    );


  }

  void updateDatabase({
    @required String status,
    @required int id
})
  {
    database.rawUpdate(
        'UPDATE todo SET status = ? WHERE id = ?',
        ['$status',id]).then((value)
    {
      getDataFromDatabase(database);
      emit(TodoAppUpdateDatabaseState());
    }
    );
  }

  void deleteData({
    @required int id
})
  {
    database.rawDelete(
        'DELETE FROM todo WHERE id = ?',
        [id]
    ).then((value)
    {
      getDataFromDatabase(database);

      emit(TodoAppDeleteDatabaseState());
    }
    );
  }

}