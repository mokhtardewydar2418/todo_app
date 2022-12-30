import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_rev/layout/cubit/cubit.dart';
import 'package:todo_rev/layout/cubit/states.dart';
import 'package:todo_rev/shared/components/components.dart';

class TasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit,TodoAppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var tasks = TodoAppCubit.get(context).newTasks;
        return tasksBuild(tasks: tasks);
      },
    );
  }
}
