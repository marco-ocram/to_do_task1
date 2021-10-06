import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_task1/constants.dart';

import '../task.dart';
import '../task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //-----Initialized variables for the screen-----------------------------------
  TextEditingController _taskController = TextEditingController();
  List<Task> listOfTasks = [];
  List<Task> listOfCurrentTasks = [];
  DateTime date;
  double width;
  double height;

  getList() {
    for (Task task in listOfTasks) {
      if (task.dateTime == date) listOfCurrentTasks.add(task);
    }
  }

  //-----SHOW DATE PICKER DIALOG------------------------------------------------
  _datePicker() async {
    await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2001),
            lastDate: DateTime(2022))
        .then((value) {
      try {
        date = value;
      } catch (e) {
        date = DateTime.now();
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    date = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      backgroundColor: Colors.white,

      //-----------------------
      appBar: AppBar(
        title: Text(
          'TO DO',
        ),
        leading: IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            onPressed: () => _datePicker()),
        backgroundColor: Colors.blueAccent,
      ),
      //-----------------------

      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: Text(
          "Add",
          style: TextStyle(color: Colors.white),
        ),
      ),
      //------------------------------------------------------------------------

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 4, vertical: height * 2),
            child: Column(
              children: [
                Text(
                  formatDate(date),
                  style: TextStyle(color: Colors.blue, fontSize: height * 3),
                ),
                listOfWidgets(),
              ],
            )),
      ),
    );
  }

  Column listOfWidgets() {
    getList();
    return Column(
      children: List.generate(
          listOfTasks.length,
          (index) => InkWell(
              onTap: () {
                setState(() {
                  listOfTasks[index].isComplete =
                      !listOfTasks[index].isComplete;
                });
              },
              child: taskWidget(listOfTasks[index], height, width))),
    );
  }

  void addTask() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                formatDate(date),
                style:
                    TextStyle(color: Colors.blueAccent, fontSize: height * 3),
              ),
              content: CupertinoTextField(
                maxLines: 2,
                controller: _taskController,
                cursorColor: Colors.black,
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text("Add task"),
                  onPressed: () {
                    Task currentTask = Task(_taskController.text, false, date);
                    setState(() {
                      print(listOfTasks);
                      listOfTasks.add(currentTask);
                      _taskController.clear();
                      getList();
                    });

                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
