import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TodoAppCubit,TodoAppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var tasks = TodoAppCubit.get(context).archivedTasks;
        return tasksBuild(tasks: tasks);
      },
    );
  }
}
