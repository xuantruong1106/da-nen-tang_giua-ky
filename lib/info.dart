import 'package:flutter/material.dart';
import 'sign_in.dart';
import './connect_db.dart';

class Info extends StatefulWidget {
  final String? username;
  final bool isLoggedIn;

  Info({super.key, required this.username, required this.isLoggedIn});

  final db = DatabaseConnection();

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<Info> {
  late List<Map<String, dynamic>> dataGetInfoStudent = [];
  late List<Map<String, dynamic>> dataGetClassAndCourse = [];
  late List<Map<String, dynamic>> dataGetProvince = [];
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    isLoggedIn = widget.isLoggedIn;
    checkLoginStatus();
  }

  void checkLoginStatus() {
    if (!isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } else {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    try {
      await widget.db.connect();
      final result = await widget.db.executeQuery('SELECT * FROM info_student');
      setState(() {
        dataGetInfoStudent = result.map((row) => {
          'id': row[0],
          'fullname': row[1],
          'date_of_birth': row[2].toString().substring(0, 10).split('-').reversed.join('-'),
          'home_town': row[3],
          'class_name': row[4],
          'course': row[5],
        }).toList();
        dataGetInfoStudent.sort((a, b) => a['id'].compareTo(b['id']));
      });
    } catch (e) {
      // ignore: avoid_print
      print('error fetchData: $e');
    } finally {
      await widget.db.connection?.close();
      // ignore: avoid_print
      print('Connection closed for fetchData');
    }
  }

  Future<void> addStudentInfo(String fullName, String dateOfBirth, String hometown, String className, String course) async {
    try {
      await widget.db.connect();
      await widget.db.executeQuery(
        'SELECT addStudentInfo(@fullName, @dateOfBirth, @hometown, @className, @course);',
        substitutionValues: {
          'fullName': fullName,
          'dateOfBirth': dateOfBirth,
          'hometown': hometown,
          'className': className,
          'course': course,
        },
      );
      setState(() {
        dataGetInfoStudent.add({
          'id': DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
          'fullname': fullName,
          'date_of_birth': dateOfBirth,
          'home_town': hometown,
          'class_name': className,
          'course': course,
        });
      });
    } catch (e) {
      // ignore: avoid_print
      print('error addStudentInfo: $e');
    } finally {
      await widget.db.connection?.close();
    }
  }

  Future<void> getClassAndCourse() async {
    try {
      await widget.db.connect();
      final result = await widget.db.executeQuery('SELECT * FROM get_classes_and_courses();');
      setState(() {
        dataGetClassAndCourse = result.map((row) => {
          'class_name': row[0],
          'course_name': row[1],
        }).toList();
      });
      await widget.db.connection?.close();
    } catch (e) {
      // ignore: avoid_print
      print('error getClassAndCourse: $e');
    } finally {
      // ignore: avoid_print
      print('Connection closed for getClassAndCourse');
    }
  }

  Future<void> getProvince() async {
    try {
      await widget.db.connect();
      final result = await widget.db.executeQuery('SELECT province_name FROM province');
      setState(() {
        dataGetProvince = result.map((row) => {
          'province_name': row[0],
        }).toList();
      });
      await widget.db.connection?.close();
    } catch (e) {
      // ignore: avoid_print
      print('error getProvince: $e');
    } finally {
      // ignore: avoid_print
      print('Connection closed for getProvince');
    }
  }

  void showAddStudentDialog() async {
    await getClassAndCourse();
    await getProvince();
    final fullNameController = TextEditingController();
    final dateOfBirthController = TextEditingController();
    final hometownController = TextEditingController();
    final classNameController = TextEditingController();
    final courseController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Student Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: dateOfBirthController,
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                      dateOfBirthController.text = formattedDate;
                    }
                  },
                ),
                // TextField(
                //   controller: hometownController,
                //   decoration: const InputDecoration(labelText: 'Hometown'),
                // ),
                DropdownButtonFormField<String>(
                  value: hometownController.text.isEmpty ? null : hometownController.text,
                  decoration: const InputDecoration(labelText: 'Hometown'),
                  items: dataGetProvince.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['province_name'],
                      child: Text(item['province_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    hometownController.text = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: classNameController.text.isEmpty ? null : classNameController.text,
                  decoration: const InputDecoration(labelText: 'Class Name'),
                  items: dataGetClassAndCourse.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['class_name'],
                      child: Text(item['class_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    classNameController.text = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: courseController.text.isEmpty ? null : courseController.text,
                  decoration: const InputDecoration(labelText: 'Course'),
                  items: dataGetClassAndCourse.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['course_name'],
                      child: Text(item['course_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    courseController.text = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                addStudentInfo(
                  fullNameController.text,
                  dateOfBirthController.text,
                  hometownController.text,
                  classNameController.text,
                  courseController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> editInfoStudent(int id, String fullName, String dateOfBirth, String hometown, String className, String course) async {
    try {
      await widget.db.connect();
      await widget.db.executeQuery(
        'UPDATE info_student SET full_name = @fullName, date_of_birth = @dateOfBirth, hometown = @hometown, class_name = @className, course = @course WHERE id = @id;',
        substitutionValues: {
          'id': id,
          'fullName': fullName,
          'dateOfBirth': dateOfBirth,
          'hometown': hometown,
          'className': className,
          'course': course,
        },
      );
      await widget.db.connection?.close();
      fetchData();
    } catch (e) {
      // ignore: avoid_print
      print('error editInfoStudent: $e');
    } finally {
      // ignore: avoid_print
      print('Connection closed for getInfoUser');
    }
  }

  void showEditStudentDialog(Map<String, dynamic> student) async {
    await getClassAndCourse();
    await getProvince();
    final fullNameController = TextEditingController(text: student['fullname']);
    final dateOfBirthController = TextEditingController(text: student['date_of_birth']);
    final hometownController = TextEditingController(text: student['home_town']);
    final classNameController = TextEditingController(text: student['class_name']);
    final courseController = TextEditingController(text: student['course']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Student Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: dateOfBirthController,
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(student['date_of_birth']),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                      dateOfBirthController.text = formattedDate;
                    }
                  },
                ),
                // TextField(
                //   controller: hometownController,
                //   decoration: const InputDecoration(labelText: 'Hometown'),
                // ),
                DropdownButtonFormField<String>(
                  value: hometownController.text.isEmpty ? null : hometownController.text,
                  decoration: const InputDecoration(labelText: 'Hometown'),
                  items: dataGetProvince.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['province_name'],
                      child: Text(item['province_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    hometownController.text = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: classNameController.text.isEmpty ? null : classNameController.text,
                  decoration: const InputDecoration(labelText: 'Class Name'),
                  items: dataGetClassAndCourse.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['class_name'],
                      child: Text(item['class_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    classNameController.text = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: courseController.text.isEmpty ? null : courseController.text,
                  decoration: const InputDecoration(labelText: 'Course'),
                  items: dataGetClassAndCourse.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['course_name'],
                      child: Text(item['course_name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    courseController.text = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                editInfoStudent(
                  student['id'],
                  fullNameController.text,
                  dateOfBirthController.text,
                  hometownController.text,
                  classNameController.text,
                  courseController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteStudentInfo(int id) async {
    try {
      await widget.db.connect();
      await widget.db.executeQuery('DELETE FROM info_student WHERE id = @id;', substitutionValues: {'id': id});
      await widget.db.connection?.close();
      fetchData();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    } finally {
      // ignore: avoid_print
      print('Connection closed for deleteStudentInfo');
    }
  }

  void showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteStudentInfo(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future refreshData() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Student Information - ${widget.username}'),
        ),
        body: dataGetInfoStudent.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: refreshData,
                          color: Colors.blue,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: showAddStudentDialog,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataGetInfoStudent.length,
                      itemBuilder: (context, index) {
                        final student = dataGetInfoStudent[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: Text('Student name: ${student['fullname']}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ID: ${student['id']}'),
                                    Text('Date of Birth: ${student['date_of_birth']}'),
                                    Text('Home Town: ${student['home_town']}'),
                                    Text('Class Name: ${student['class_name']}'),
                                    Text('Course: ${student['course']}'),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('EDIT'),
                                    onPressed: () {
                                      showEditStudentDialog(student);
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    child: const Text('DELETE'),
                                    onPressed: () {
                                      showDeleteDialog(student['id']);
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}