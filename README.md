# Examination System

This project is a SQL database to be built for an autmated system that allow online exams to be taken. The system includes stored procedures that allow for selecting, inserting, updating, and deleting data in any table.

## Features

Database has:
- An Entity Relationship Diagram (ERD) 
- Backup
- A database dictionary (Documentation)
- Stored procedures for:
  - Exam generation
  - Exam answers
  - Exam correction



The system also includes the following reports to help the staff:
All These Reports were implemented using Stored Procedures 
- Report that returns the students information according to Department (Using no parameter)
- Report that takes the student ID and returns the grades of the student in all courses
![Screenshot (431)](https://user-images.githubusercontent.com/83030549/221994815-ec7b24e6-ee1b-4f96-9a26-1522e68b3dfd.png)

- Report that takes the instructor ID and returns the name of the courses that he teaches and the number of student per course
- Report that takes course ID and returns its topics
- Report that takes exam number and returns the questions in it and choices (freeform report)
- Report that takes exam number and the student ID then returns the questions in this exam with the student answers


## Tools
- [AZURE SQL Database](https://azure.microsoft.com/en-us/products/azure-sql/database)
- [MSSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16)
- [dForge](https://azure.microsoft.com/en-us/products/azure-sql/database)
- [Report Builder](https://www.microsoft.com/en-us/download/details.aspx?id=53613)
- [SQL DOC](https://www.red-gate.com/products/sql-development/sql-doc/)

## Getting Started

To use this system, you will need to:

1. Install the SQL Server Management Studio
2. Connect to the server 
3. Use the stored procedures to SELECT, INSERT, UPDATE, DELETE
4. Use the stored procedures to generate exams, answers, and corrections
5. Use the reports to retrieve information on students, instructors, courses, topics, and exams

## Code Overview


## Screenshots

  
## Authors
- [Ahmed Abdelnaser](https://github.com/ahmedabdelnaser70)
- [Ammar Elghandour](https://github.com/amarGhandour)
- [Aya Kamel](https://github.com/aya5258)
- [Sohaila Elhakim](https://github.com/sohailaalhakim)
- [Walid Essam](https://github.com/WalidEssam)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
