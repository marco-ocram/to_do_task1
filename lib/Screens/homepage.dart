import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_task1/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    date = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //--HEIGHT AND WIDTH MODULE OF DEVICE--------------------------------------
    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'TO DO',
        ),
        centerTitle: true,
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
        onPressed: () {
          addTask(-1);
        },
        child: Text(
          "Add",
          style: TextStyle(color: Colors.white),
        ),
      ),
      //------------------------------------------------------------------------

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                formatDate(date),
                style: TextStyle(color: Colors.blue, fontSize: height * 3),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.hasError ||
                      snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else {
                    listOfTasks = getListOfTasks(snapshot.data, date);
                    if (listOfTasks.length == 0)
                      return Center(
                        child: Text("No tasks added"),
                      );
                    else
                      return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 4, vertical: height * 2),
                          child: listOfTaskWidgets());
                  }
                }),
          ],
        ),
      ),
    );
  }

  //----LIST OF ALL TASKS-------------------------------------------------------
  Column listOfTaskWidgets() {
    return Column(
      children: List.generate(
          listOfTasks.length,
          (index) => InkWell(
              //edit and delete
              onLongPress: () => onLongPress(index),
              //check if complete
              onTap: () {
                listOfTasks[index].isComplete = !listOfTasks[index].isComplete;
                completeTaskToDatabase(listOfTasks[index]);
              },
              child: taskWidget(listOfTasks[index], height, width))),
    );
  }

  //-----EDITING AND DELETING THE TASK------------------------------------------
  void onLongPress(index) => showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          actions: [
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  addTask(index);
                },
                child: Icon(
                  Icons.edit,
                  size: height * 3,
                )),
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  deleteTaskToDatabase(listOfTasks[index]);
                },
                child: Icon(
                  Icons.delete,
                  size: height * 3,
                ))
          ],
        );
      });

  //-----ADDING THE TASK--------------------------------------------------------
  void addTask(int index) async {
    print("UID");
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
                    // onPressed: index == -1
                    //     ? addNewTask()
                    //     : editTask(listOfTasks[index])
                    onPressed: () {
                      Task task = Task(
                          task: _taskController.text,
                          isComplete: false,
                          timestamp: Timestamp.fromDate(date));
                      print("REACHED");
                      index == -1
                          ? addNewTask(task)
                          : editTask(listOfTasks[index], _taskController.text);
                      _taskController.clear();
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  addNewTask(Task task) {
    print("REACHED");
    print("ADDING");
    _taskController.clear();
    // Navigator.pop(context);
    addTaskToDatabase(task);
  }

  editTask(Task task, String text) {
    print("TASK UPDATING $text");
    task.task = text;
    print(task.task);
    print(task.taskuid);
    print("EDITING");
    editTasktoDatabase(task);
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
        print(date);
      } catch (e) {
        date = DateTime.now();
      }
      setState(() {});
    });
  }
}
