import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_rev/layout/cubit/cubit.dart';
import 'package:todo_rev/layout/cubit/states.dart';
import 'package:todo_rev/shared/components/components.dart';

class HomeLayoutScreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>TodoAppCubit()..createDatabase(),
      child: BlocConsumer<TodoAppCubit,TodoAppStates>(
        listener: (context,state)
        {
          if(state is TodoAppInsertIntoDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context,state)
        {
          TodoAppCubit cubit = TodoAppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                  cubit.titles[cubit.currentIndex]
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! TodoAppLoadingDatabaseState,
              builder: (context)=> cubit.screens[cubit.currentIndex],
              fallback: (context)=> Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index)
              {
                cubit.changeBottomNavIndex(index);
              },
              items: cubit.items,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown)
                {
                  if(formKey.currentState.validate())
                  {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text
                    );
                  }
                  cubit.changeBottomSheet(isShown: false, fabIcon: Icons.edit);
                  titleController.clear();
                  timeController.clear();
                  dateController.clear();
                }
                else {
                  scaffoldKey.currentState.showBottomSheet((context)=> Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                                controller: titleController,
                                inputType: TextInputType.text,
                                labelText: 'Task Title..',
                                prefixIcon: Icons.title_outlined,
                                validation: (String value)
                                {
                                  if(value.isEmpty)
                                  {
                                    return 'title musn\'t be empty';
                                  }
                                  return null;
                                }
                            ),

                            SizedBox(
                              height: 10.0,
                            ),

                            defaultFormField(
                                controller: timeController,
                                inputType: TextInputType.datetime,
                                labelText: 'Task Time..',
                                prefixIcon: Icons.timelapse_outlined,
                                readOnly: true,
                                onTap: ()
                                {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now()
                                  ).then((value)
                                  {
                                    timeController.text=value.format(context).toString();
                                  }
                                  );
                                },
                                validation: (String value)
                                {
                                  if(value.isEmpty)
                                  {
                                    return 'time musn\'t be empty';
                                  }
                                  return null;
                                }
                            ),

                            SizedBox(
                              height: 10.0,
                            ),

                            defaultFormField(
                                controller: dateController,
                                inputType: TextInputType.datetime,
                                labelText: 'Task Date..',
                                prefixIcon: Icons.calendar_month,
                                readOnly: true,
                                onTap: ()
                                {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2023-12-18')
                                  ).then((value)
                                  {
                                    dateController.text = DateFormat.yMMMd().format(value);
                                  }
                                  );
                                },
                                validation: (String value)
                                {
                                  if(value.isEmpty)
                                  {
                                    return 'date musn\'t be empty';
                                  }
                                  return null;
                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                    elevation: 30.0
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheet(
                        isShown: false,
                        fabIcon: Icons.edit
                    );
                  }
                  );
                  
                  cubit.changeBottomSheet(
                      isShown: true,
                      fabIcon: Icons.add
                  );
                }
              },

              child: Icon(
                  cubit.floatingIcon
              ),

            ),
          );
        },
      ),
    );
  }
}
