// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class Plan {
  String title;
  List<String> tasks = [];

  void addTask(newTask) {
    tasks.add(newTask);
  }

  void updateTitle(newTitle) {
    title = newTitle;
  }

  Plan({required this.title});
}

class PlanProvider extends ChangeNotifier {
  List<Plan> _plans = [];
  List<Plan> get plans => _plans;

  void addPlan(Plan newPlan) {
    _plans.add(newPlan);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PlanProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        primaryColor: Colors.white,
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.grey,
            fontFamily: 'Lato-Black',
            fontSize: 40,
          ),
        ),
      ),
      home: MyHomePage(),
      routes: {
        '/build': (context) => const BuildPage(),
        '/launch': (context) => const LaunchPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Gym\nFlow',
                  style: TextStyle(
                    fontSize: 90,
                    fontFamily: 'Marmelad',
                  )),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/build');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    fixedSize: const Size(200.0, 50.0)),
                child: const Text(' NEW ',
                    style: TextStyle(fontFamily: 'Lato', fontSize: 20)),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/launch');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    fixedSize: const Size(200.0, 50.0)),
                child: const Text(
                  'LAUNCH',
                  style: TextStyle(fontFamily: 'Lato', fontSize: 20),
                ),
              ),
            ]),
      ),
    );
  }
}

class BuildPage extends StatefulWidget {
  const BuildPage({super.key});

  @override
  State<BuildPage> createState() => _BuildPageState();
}

class _BuildPageState extends State<BuildPage> {
  final TextEditingController _planTitleController = TextEditingController();

  @override
  void dispose() {
    _planTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //appBar: AppBar(title: Text(''), backgroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Give your\nplan a\nname',
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w300,
                )),
            const SizedBox(height: 30),
            Container(
              width: 250,
              child: TextField(
                controller: _planTitleController,
                cursorColor: Colors.black,
                cursorWidth: 1.0,
                decoration: const InputDecoration(
                    hintText: 'e.g Leg Day, Wednesday...',
                    hintStyle: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w200,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                style: const TextStyle(
                  fontSize: 40,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                String planTitle = _planTitleController.text;
                Plan myPlan = Plan(title: planTitle);
                // ignore: avoid_print
                print('Added new plan: ${myPlan.title}');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTaskPage(plan: myPlan)));
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              color: Colors.black,
              highlightColor: Colors.grey,
              splashColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class AddTaskPage extends StatefulWidget {
  Plan plan;
  AddTaskPage({required this.plan});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  void _addPlan(BuildContext context, Plan plan) {
    Provider.of<PlanProvider>(context, listen: false).addPlan(plan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          const SizedBox(height: 100),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                widget.plan.title,
                style: const TextStyle(
                  fontSize: 40,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  const Text(
                    'Exercises',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        Plan updatedPlan = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewTaskPage(plan: widget.plan)));
                        if (updatedPlan != null) {
                          setState(() {
                            widget.plan = updatedPlan;
                          });
                        }
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
            ),
          ),
          Container(
            height: 400,
            child: ListView.builder(
              itemCount: widget.plan.tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                  widget.plan.tasks[index],
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 25,
                    fontWeight: FontWeight.w200,
                  ),
                ));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                Provider.of<PlanProvider>(context, listen: false)
                    .addPlan(widget.plan);
                Navigator.pushReplacementNamed(
                    context, '/'); // Navigate back to the homepage
                //Navigator.pushAndRemoveUntil(
                //  context,
                //  MaterialPageRoute(builder: (context) => MyHomePage()),
                //  (route) => false,
                //);
              },
              icon: const Icon(Icons.check),
              color: Colors.black,
              highlightColor: Colors.grey,
              splashColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class NewTaskPage extends StatefulWidget {
  final Plan plan;
  const NewTaskPage({Key? key, required this.plan}) : super(key: key);

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final TextEditingController _taskNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 250,
              child: TextField(
                controller: _taskNameController,
                cursorColor: Colors.black,
                cursorWidth: 1.0,
                decoration: const InputDecoration(
                    hintText: 'e.g Squats, Rest, Lat Machine',
                    hintStyle: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w200,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                style: const TextStyle(
                  fontSize: 40,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.fitness_center_rounded),
                Text('test')
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[Icon(Icons.repeat_rounded), Text('test')],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[Icon(Icons.timer_rounded), Text('test')],
            ),
            ElevatedButton(
                onPressed: () {
                  String newTask = _taskNameController.text;
                  widget.plan.addTask(newTask);

                  print('Added a task: $newTask');
                  Navigator.pop(context, widget.plan);
                  // add newTask to the previously instantiated plan
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}

class LaunchPage extends StatefulWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Launch'), backgroundColor: Colors.grey),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              child: ListView.builder(
                itemCount: planProvider.plans.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskPage(
                                plan: planProvider.plans[index], taskIndex: 0),
                          ));
                    },
                    child: ListTile(
                        title: Text(
                      planProvider.plans[index].title,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 25,
                        fontWeight: FontWeight.w200,
                      ),
                    )),
                  );
                },
              ),
            ),
            Text('Total plans: ${planProvider.plans.length}'),
          ],
        ),
      ),
    );
  }
}

class TaskPage extends StatelessWidget {
  final Plan plan;
  final int taskIndex;

  TaskPage({required this.plan, required this.taskIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text('Task ${taskIndex + 1}'),
      //),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              plan.tasks[taskIndex],
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 60,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  if (taskIndex < plan.tasks.length - 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskPage(
                                plan: plan, taskIndex: taskIndex + 1)));
                  } else {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
                icon: Icon(Icons.arrow_forward_rounded))
          ],
        ),
      ),
    );
  }
}
