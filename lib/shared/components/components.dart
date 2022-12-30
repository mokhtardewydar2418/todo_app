
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_rev/layout/cubit/cubit.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType inputType,
  @required String labelText,
  @required IconData prefixIcon,
  bool readOnly = false,
  IconData suffixIcon,
  Function onChange,
  Function onSubmit,
  Function onTap,
  @required Function validation,
  bool obscureText = false,
  Function suffixFunction,

}) =>
    TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon !=null
            ? IconButton(
            onPressed: suffixFunction,
            icon: Icon(suffixIcon))
            : null,
      ),
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      readOnly: readOnly,
      validator: validation,
    );


Widget buildTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 35.0,
          backgroundColor: Colors.black12,
          child: Text(
            '${model['time']}',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                    fontSize: 18.0
                ),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        IconButton(
            onPressed: ()
            {
              TodoAppCubit.get(context).updateDatabase(
                  status: 'done',
                  id: model['id']
              );
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
              size: 35.0,
            )
        ),
        SizedBox(
          width: 10.0,
        ),
        IconButton(
            onPressed: ()
            {
              TodoAppCubit.get(context).updateDatabase(
                  status: 'archived',
                  id: model['id']
              );
            },
            icon: Icon(
              Icons.archive_outlined,
              size: 35.0,
            )
        ),
      ],
    ),
  ),
  onDismissed: (direction)
  {
    TodoAppCubit.get(context).deleteData(id: model['id']);
  },
);

Widget tasksBuild({@required List<Map> tasks})=> ConditionalBuilder(
  condition: tasks.length>0,
  builder: (context)=>ListView.separated(
        itemBuilder: (context,index)=> buildTaskItem(tasks[index],context),
        separatorBuilder: (context,index)=>seperator(),
        itemCount: tasks.length
    ),
  fallback: (context)=>Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet , Please Add Some Tasks',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      )
  ),
);

Widget seperator() => Container(
  padding: EdgeInsetsDirectional.only(start: 20.0),
  color: Colors.grey,
  width: double.infinity,
  height: 1.0,
);