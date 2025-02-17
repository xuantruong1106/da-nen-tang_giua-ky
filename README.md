# giuaky
- technology uesd: 
  + framework: flutter
  + database: postgresql
    
- steps run app
  + create database from file sql-backup\giuaky-postgresql.sql
  + open cmd run code: flutter run ( if run on windows: use host of database is 'localhost', if run on emulator: use host of database is '10.0.2.2')
 

-----------Project Implementation Steps----------------
- The 'main' file runs, initializes the router in 'router.dart', and navigates to the '/sign_in' route for login.  
- After a successful login, it navigates to the '/main' route.  
- The '/main' route includes the following functionalities:  
  - fetchData(): Retrieve the list of students  
  - addStudentInfo(): Add a student  
  - getCourses(): Retrieve the list of courses  
  - getClasses(): Retrieve the list of classes based on the selected course  
  - getProvince(): Retrieve the list of provinces  
  - editInfoStudent(): Edit student information  
  - deleteStudentInfo(): Delete a student  
  - refreshData(): Refresh the data
 
- author: Nguyễn Xuân Trường
