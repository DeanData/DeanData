# SQL-Catch-The-Fish-Game



## Introduction

The project’s goal is to build a script for a computer game named "Catch the Fish".
The database includes the following processes:
•	Registration
•	Login
•	The actual game
•	Score management
•	Technical support
This document describes the system’s architecture and the working assumptions we have created and followed by.
The database includes tables, functions, views, and procedures.


## Tables

This chapter describes all the tables in the project.

Note: Some of the tables we have created include only one column and one row, and their sole purpose is to include a text we wanted to print by running a procedure.


![image](https://user-images.githubusercontent.com/83536999/117184743-bcb29880-ade1-11eb-8080-98bffaa27faf.png)

(Examples for this type of procedures: 1. ‘Login’  2. ‘Open_CatchTheFish’ 


Table 1 – Users
This table contains information of registered users.

![image](https://user-images.githubusercontent.com/83536999/117186943-0e5c2280-ade4-11eb-9266-f2eabf035f95.png)

Main columns explanation:<br/>
• UserID – entered automatically according to the number of players(@identity), the first user starts with 1 followed by the increments of 1 (e.g. 1, 2, 3…). <br/>
• Username, Password, FirstName, LastName, Country, EmailAddress – these columns are mandatory to contain values when a user registers.<br/>
• LoginFailure- indicates the user’s number of failed attempts to login his account, the column gets a default value – 0, and lock the account after 3 failed attempts. <br/>
• LogStatus - column’s default value is “0”<br/>
   o	when LogStatus is “0” it means that the user is logged out<br/>
   o	when LogStatus is “1” it means that the user is logged in<br/>
   o	when Logstatus is “2” it means that the account locked (after 3 consecutive failed login attempts). <br/>
• Columns Country and Gender are mandatory as well – in order to register a user must choose the values listed in the tables: PermittedCountries and GenderListOptions in the database.<br/>

![image](https://user-images.githubusercontent.com/83536999/117185032-12874080-ade2-11eb-9982-b929104e5ff0.png)

Table 2 - PermittedCountries
A static table that contains the list of countries that the is available in.

Table 3 - GenderListOptions
A static table that contains the gender list.

Table 4 – LoginMenu
A static table, with only one column and one row, in order to be a transition path to login to the game. 

Table 5 - MainMenu 
A static table, with only one value, in order to be a transition path to the menu of the game, where the user need to choose whether to login to the game or to register

Table 6 - RegistrationTable
A static table, with only one value, in order to be a transition path to registration.



## Views and functions

Fn_RandomNum - As part of the registration process, we used a function which generates a random digit from 0 to 9. It used when a username picks a username that is already in use by another user. Then it suggests him/her a username that is not in use by adding a random digit.

Vv_getRANDValue - A view has been created to use the function


## ERD

![image](https://user-images.githubusercontent.com/83536999/117185365-6db93300-ade2-11eb-8041-b60db2bbee75.png)

![image](https://user-images.githubusercontent.com/83536999/117185380-727de700-ade2-11eb-8f52-08acf2d476a6.png)



## Stored Procedures

This chapter concentrates on procedures in the database.
Each procedure describes one process that the player can choose as part of the game: Registration, login, game, and technical support.
 
•	First procedure - Registration procedures logic – created with 3 levels of procedures:
o	‘RegPro’ (1-14) procedures – A set of processes that make sure that all the conditions for creating a user have passed successfully.
o	‘RegPro’ 15 procedure – when all the conditions from ‘RegPro’ (1-14) procedures are met, it will insert the user information to the Users table.
o	‘RegistraionProcess’ – high level procedure that calls for all ‘RegPro’ (1-15) procedures.

•	‘RegPro1’: Checks if the username exists. If there is a user with the same username, the procedure will print a suggested username.

•	‘RegPro2-7’ – Password constraints:
Ensures compliance with all required password conditions - The password is longer than 7 characters, with at least one lowercase, one uppercase letter and digit. Will also ensure the password that does not contain the words 'user' or 'password' in it.

•	‘RegPro8-10’: Not null constraints for the first name, last name and address.
•	‘RegPro11’: makes sure that the country entered is from ‘PermittedCountries’ table.
•	‘RegPro12’: Makes sure that the Email address entered includes ‘@’ symbol, which is an indicator for a valid address
•	‘RegPro13’: Makes sure the gender not null and is from the ‘GenderListOptions’ table. 
•	‘RegPro14’: Makes sure the age of the player 18 years old or above.
•	‘RegPro15’: combine all the RegPro1-14 procedure, and allows you to continue the login process with explanation:
•	‘RegistraionProcess’ Procedure: Unifies all ‘RegPro’ processes and arranges in an accessible way to fill in details.

•	Second procedure - ‘LoginProcess’ - combines several of checks for Login:
      o	Checks if the user already registered and the username and password are correct.
      o	Counting the numbers of Log-in failures. In the 3rd failed attempt the procedure is instructed to lock the account.
      o	The procedure verifies that the user is not login and prevents him from double login at the same time.

•	Third procedure – LOGIN:
 made from an aesthetic reason (see explanation in page 2) to connect the user directly to ‘Login menu’ table.
 
 Fourth procedure- ‘CallTechSupport’ procedure:
Allows you to reset your password when the account is blocked. Generates a new and strong password and replaces it with the old password in the a ‘Users’ table.

•	Fifth procedure - ‘Open_CatchTheFish’ procedure:
Made from an aesthetic reason. Prints the start menu for the game. 

Sixth procedure - ‘Start_Game_Alreadi_Yalla_Kvar’:
    o	Execute the game - to start playing the user must choose a fisherman from the list - Avi, Shir or Moshe.
    o	In a fair draw in each round, one of the three fishermen wins:
    o	If the user’s fisherman wins, the user gets 1000 points. 
    o	If the user’s fisherman loses, the user lose 100 points. 

•	Seventh procedure - ‘StartGame’:
The official procedure that checks the compliance with the conditions for starting a game (Username and FisherName are valid) and then calls for a ‘Start_Game_Alreadi_Yalla_Kvar’ procedure.



