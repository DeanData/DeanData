










--######################################################################

--            WELCOME TO CATCH THE FISH INSTALLATION PROCESS


--             Instractions: Press 'Ctrl + A' and then 'F5'

--######################################################################

















CREATE DATABASE CatchTheFishDB
go
USE CatchTheFishDB
go

-------- Random number functions-----------------------------------------
--1
create view [dbo].[vv_getRANDValue]
as
select rand() as [value]
GO
------------------------------------------------------------------------
--2
Create function [dbo].[fn_RandomNum](@Lower int, @Upper int)
returns int
as
Begin
DECLARE @Random INT;
if @Upper > @Lower
	SELECT @Random = (1 + @Upper - @Lower) * (SELECT Value FROM vv_getRANDValue) + @Lower
Else
	SELECT @Random = (1 + @Lower - @Upper) * (SELECT Value FROM vv_getRANDValue) + @Upper
return @Random
end
GO
------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
go
create table PermittedCountries
(CountryID int not null primary key,
Country nvarchar(30))
go
insert into PermittedCountries
values 
(1, 'Austria'),
(2, 'Israel'),
(3, 'Peru')
go
create procedure CountryList
as
select Country from PermittedCountries
go
-------------------------------------------------------------------------------------------------------------------------------------------
create table GenderListOptions
(GenderID int not null primary key,
Gender nvarchar(30))
go
insert into GenderListOptions
values 
(1, 'Female'),
(2, 'Male')
go
create procedure GenderList
as
select Gender from GenderListOptions
go
-------------------------------------------------------------------------------------------------------------------------------------------

--- Users table
create TABLE Users
(UserID int identity(1,1) not null,
UserName nvarchar(20) not null,
Password nvarchar(20) not null,
FirstName nvarchar(20) not null,
LastName nvarchar(20) not null,
Address nvarchar(50) ,
Country nvarchar(20),
EmailAddress nvarchar(40) unique not null,
Gender nvarchar(20),
BirthDate date,
Loginfailure int NULL DEFAULT (0),
LogStatus int NULL DEFAULT (0), --when Logsts =1 it means that the user is already Logged in or locked, because more than 3 failure tries.
Points int default(1000),

PRIMARY KEY (UserID)
)

go

insert into users --('UserName', 'Password', 'FirstName', 'LastName', 'Address', 'Country', 'EmailAddress', 'Gender', 'BirthDate','LoginFailure','LogStatus','Points')
values ('TigerKing','Exotic123','Joe','Exotic','Tel Aviv','Israel','je@gmail.com','Male','1963-03-05',default,1,default)
go


-------------------------------------------------------------------------------------------------------------------------------------------
-- USER NAME RegPro1
create procedure RegPro1 (@UserName nvarchar(20))
as
declare
@AddDigit int
set @AddDigit = dbo.fn_RandomNum(0,9)
		if exists
			(SELECT username FROM users WHERE username = @username)
			begin
				set @UserName = @UserName + CAST(@AddDigit AS nvarchar(2))
				print ('- The username you have chosen is already taken. Username suggestion:' + CAST(@username AS nvarchar(50)) )
			end
go

-- PASSWORD - more than 7 characters -RegPro2
create procedure RegPro2 (@Password nvarchar(20))
as
											if len (@password) < 7 print '- The password must contain at least 7 characters.'
go

-- PASSWORD - cannot contain the username in it - RegPro3
create procedure RegPro3 (@Password nvarchar(20),@UserName nvarchar(20))
as						
											 if @password like '%' + @username + '%' print '- The password cannot contain the username in it.'						
go

-- PASSWORD - cannot contain the word Password - RegPro4
create procedure RegPro4 (@Password nvarchar(20))
as
												 if @password like '%password%' print '- Tha password cannot contain the word Password.'
go

-- PASSWORD - -RegPro5 - lowercase letter
create procedure RegPro5 (@Password nvarchar(20))
as
												 if @password not LIKE '%[a-z]%' COLLATE Latin1_General_BIN print '- Tha password must contain a lowercase letter.'
									
												
go

-- PASSWORD - -RegPro6 - CAPITAL LETTER
create procedure RegPro6 (@Password nvarchar(20))
as
												 if @password not LIKE '%[A-Z]%' COLLATE Latin1_General_BIN  print '- Tha password must contain a capital letter.'
											
go

-- PASSWORD - -RegPro7 - digit [0123456789]
create procedure RegPro7 (@Password nvarchar(20))
as
												 if @password not like '%[0-9]%'  print '- Tha password must contain a digit (0-9).'
											
go

-- FIRST NAME - not null -RegPro8
create procedure RegPro8 (@FirstName nvarchar(20))
as
					if @FirstName is null print '- First name required'
go

-- LAST NAME - not null - RegPro9
create procedure RegPro9 (@LastName nvarchar(20))
as
							 if @LastName is null print '- Last name required'
go

-- ADDRESS - not null - RegPro10
create procedure RegPro10 (@Address nvarchar(50))
as
						 if @Address is null print '- Address required'				
go

-- COUNTRY - not null - RegPro11
create procedure RegPro11 (@Country nvarchar(20))
as		
							 if @Country is null print '- Country required'
								else if @Country not in (select country from PermittedCountries) print '- We are sorry, the game is currently unavailable in your country. Choose country from the list '
go 

-- EMAIL - valid email address - RegPro12
create procedure RegPro12 (@EmailAddress nvarchar(40))
as			
						if @EmailAddress not like ('%@%') print '- Email address invalid'
go 

-- GENDER - not null - RegPro13
create procedure RegPro13 (@Gender nvarchar(20))
as
						 if @Gender = null print '- Gender required'
						 else if @Gender not in (select gender from GenderListOptions) print '- Invalid gender '
go

-- BIRTHDATE - must be 18 years old or older - RegPro14
create procedure RegPro14 (@BirthDate datetime)
as
							 if 18 > DATEDiff(yyyy,@BirthDate,getdate()) print '- Must be 18 years old or older :('
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
go

-- All details together - RegPro15
create procedure RegPro15
(
@UserName nvarchar(20),
@Password nvarchar(20),
@FirstName nvarchar(20),
@LastName nvarchar(20),
@Address nvarchar(50),
@Country nvarchar(20),
@EmailAddress nvarchar(40),
@Gender nvarchar(20),
@BirthDate datetime
)
as

declare
@X int

set @X = 0
					-- USER NAME
						if exists
							(SELECT username FROM users WHERE username = @username)
							 set @X = @X + 1								
					-- PASSWORD
						else if len (@password) < 7 set @X = 0	
								else if @password  like '%' + @username + '%' set @X = 0	
									else if @password  like '%password%' set @X = 0
										else if @password not LIKE '%[a-z]%' COLLATE Latin1_General_BIN set @X = 0
											else if @password not LIKE '%[A-Z]%' COLLATE Latin1_General_BIN set @X = 0
												else if @password not like '%[0-9]%' set @X = 0
					-- FIRST NAME
							else if @FirstName is  null set @X = 0
					-- LAST NAME
							else if @LastName is  null set @X = 0
					-- ADDRESS
							else if @Address is  null set @X = 0	
					-- COUNTRY
							else if @Country is  null set @X = 0
								else if @Country not in (select country from PermittedCountries) set @X = 0 
					-- EMAIL							
							else if @EmailAddress not like ('%@%') set @X = 0
					-- GENDER
							else if @Gender not in (select gender from GenderListOptions) set @X = 0 
					-- BIRTHDATE
							else if 18 > DATEDiff(yyyy,@BirthDate,getdate()) set @x = 0
								
								else 
								begin
print '

--Registration complete ! ! !



--INSTRACTIONS:
--1. Copy the text below
--2. Paste the query
--3. Insert your login info
--4. Select all and press F5


--FOR INVALID LOGIN - TRY THIS 3 TIMES IN A ROW

EXECUTE LoginProcess
@UserName = ''OurFirstRealUser'',
@Password = ''WrongPassword'' 



--TO LOGIN AN ALREADY LOGGEDIN USER - TRY THIS

EXECUTE LoginProcess
@UserName = ''TigerKing'',
@Password = ''Exotic123'' 



--FOR A SUCCESSFUL LOGIN - TRY THIS

EXECUTE LoginProcess
@UserName = ''OurFirstRealUser'',
@Password = ''Abc!@2345'' 



'		
insert into users 
values(@UserName,@Password,@FirstName,@LastName,@Address,@Country,@EmailAddress,@Gender,@BirthDate,default,default,default)

end
go
------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------

create procedure RegistrationProcess 
(
@UserName nvarchar(20),
@Password nvarchar(20),
@FirstName nvarchar(20),
@LastName nvarchar(20),
@Address nvarchar(50),
@Country nvarchar(20),
@EmailAddress nvarchar(40),
@Gender nvarchar(20),
@BirthDate datetime
)

as

exec RegPro1 @UserName
exec RegPro2 @Password
exec RegPro3 @Password, @UserName
exec RegPro4 @Password
exec RegPro5 @Password
exec RegPro6 @Password
exec RegPro7 @Password
exec RegPro8 @FirstName
exec RegPro9 @LastName
exec RegPro10 @Address
exec RegPro11 @Country
exec RegPro12 @EmailAddress
exec RegPro13 @Gender
exec RegPro14 @BirthDate
exec RegPro15 @UserName,@Password,@FirstName,@LastName,@Address,@Country,@EmailAddress,@Gender,@BirthDate

--------------------------------------------------------------------------------------------------------------------------------------------------
go
create table RegistrationTable
(RegistrationColumn nvarchar(1000))
go
insert into RegistrationTable
values
(
'
--INSTRACTIONS:
--1. Copy the text below to the query
--2. Insert your information
--3. Select all and press F5


--FOR AN INVALID REGISTRATION - TRY THIS

Exec RegistrationProcess
@UserName     = ''TigerKing'',
@Password     = ''                     '',
@FirstName    = ''                     '',
@LastName     = ''                     '',
@Address      = ''                     '',
@Country      = '' Execute CountryList '',
@EmailAddress = ''abc2gmail.com'',
@Gender       = '' Execute GenderList  '',
@BirthDate    = ''2015-01-01'' 



--FOR A VALID REGISTRATION - TRY THIS

Exec RegistrationProcess
@UserName     = ''OurFirstRealUser'',
@Password     = ''Abc!@2345'',
@FirstName    = ''Israel'',
@LastName     = ''Israeli'',
@Address      = ''Vienna'',
@Country      = ''Austria'',
@EmailAddress = ''isr@ael.co.il'',
@Gender       = ''Female'',
@BirthDate    = ''2000-01-01'' 



')



go
create procedure Registration
as
declare @PrintRegistration nvarchar(1000)

set @PrintRegistration = (select * from RegistrationTable)

print @PrintRegistration




go
--proc Login--------------------------------------------------------------------------------------------------------------------------------------------------
create proc LoginProcess
(
@username nvarchar(20),
@Password nvarchar(20)
)
--when @LogStatus = 0 it means that the user is NOT logged in.
--when @LogStatus = 1 it means that the user already logged in.
--when @LogStatus = 2 it means that the user locked (3 failed login attempts).
as
declare 
@LoginFailure int,
@LogStatus int

set @LoginFailure = (select LoginFailure from users where UserName = @username)
set @LogStatus = (select LogStatus from users where UserName = @username)

if not exists
			(SELECT username FROM users
			WHERE username = @username)
				print ('The username does not exists, please register')

	
		else if @LogStatus = 1 print 'User already logged in'
			else if exists
					(select username, [password] from Users
					where UserName=@username and Password=@Password)
			begin 
				
print 
('
--Login successful ! ! !

--INSTRACTIONS:
--1. Copy the command below 
--2. Paste in the query
--3. Choose fisher name
--4. Select all and run (F5)



--FOR AN UNSUCCESSFUL START - TRY THIS

Execute StartGame
@username = ''WrongUserName'',
@FisherName = ''WrongFisherName''



--FOR A SUCCESSFUL START - TRY THIS

Execute StartGame
@username = ''OurFirstRealUser'',
@FisherName = ''Avi/Moshe/Shir (Choose one name)''



--OR

Select * from ViewScoreList




'
)

update Users  set LogStatus = 1 where username = @username
				set @LoginFailure = 0 

			end
	else if @LoginFailure < 2 
			begin
				
				SET
					@LoginFailure = @LoginFailure + 1
				
print (
'
The username and password do not match ! !

Login attempt: '+ cast(@LoginFailure as nvarchar(10)) +' .
The account will be locked after 3 failed attempts.



















')




update users set Loginfailure = @LoginFailure where username = @username

			end
		else
			begin
print(
'
--User is locked, please contact technical support.


--To contact technical support - Run the command below:


--TRY ME FIRST ! 

Execute CallTechSupport
@UserName = ''WrongUserName'',
@EmailAddress = ''WrongEmailAddress''



--TRY ME SECOND ! !

Execute CallTechSupport
@UserName = ''OurFirstRealUser'',
@EmailAddress = ''isr@ael.co.il''



')
				set @LogStatus = 2
			end
----------------------------------------------------------------------------------------------------------------------------------------------------------
go
create table LoginMenu
(LoginMenu2 nvarchar(1000))
go
insert into LoginMenu
values
('
--INSTRACTIONS:
--1. Copy the text below
--2. Paste into the query
--3. Insert your login info
--4. Select all and press F5

EXECUTE LoginProcess
@UserName = ''YourUserNameHere'',
@Password = ''YourPasswordHere'' 


')


go
create procedure LOGIN
as
declare @PrintLogin nvarchar(1000)

set
@PrintLogin = (select * from LoginMenu)

print
@PrintLogin

------------------------MAIN MENU---------------------------------------------------------------------------------
go
create table MainMenu
([Main Menu] nvarchar(1000))
go
insert into MainMenu
values
('
--INSTRACTIONS:
--1. Copy the command of the desired option
--2. Paste into the query
--3. Select the command and press F5


Execute LOGIN
Execute REGISTRATION


')

go

----------------------------------------------------------------------------

create procedure Open_CatchTheFish
as
declare @PrintMenu nvarchar(1000)
set @PrintMenu = (select * from MainMenu)
print @PrintMenu
GO
------------------------------------------


------------------------------------------
--create proc Play------------------------
create procedure Start_Game_Alreadi_Yalla_Kvar
(
@username NvarChar(30),
@FisherName NvarChar(30)
)
as
declare 
@FishTurn int,
@Fisher2 nvarchar(10),
@Fisher3 nvarchar(10),
@FishStepsPerTurn1 nvarchar(240),
@FishStepsPerTurn2 nvarchar(240),
@FishStepsPerTurn3 nvarchar(240),
@points int,
@X int
declare @FishShape nvarchar(20) = ' ><(())>'


set @points = (select points from users where username = @username)
set @FishStepsPerTurn1 = ''
set @FishStepsPerTurn2 = '' 
set @FishStepsPerTurn3 = '' 
set @FishTurn = 1
set @X = 0
declare @RandWin int = cast(rand()*(3)+1 as int)

if @FisherName = 'Avi'   begin set @FisherName = 'Avi'  set @Fisher2 = 'Moshe'  set  @Fisher3 = 'Shir' set @X = 1 end
else if @FisherName = 'Moshe'  begin set @FisherName = 'Moshe' set @Fisher2 = 'Avi' set @Fisher3 = 'Shir' set @X = 1 end 
else if @FisherName = 'Shir'  begin set @FisherName = 'Shir' set @Fisher2 = 'Moshe' set @Fisher3 = 'Avi' set @X = 1 end 

if @x != 1 print 'Fisher name invalid'
else
while @FishTurn < 11 
	begin
		print ('----------------------------------------------------------------------------------------------------')
		print ( concat (@FisherName , ' : ' , @FishStepsPerTurn1 , @FishShape) )
		print ( concat (@Fisher2 , ' : ' , @FishStepsPerTurn2 , @FishShape) )
		print ( concat (@Fisher3 , ' : '  , @FishStepsPerTurn3 , @FishShape) )
		set @FishStepsPerTurn1 =  ( concat (@FishStepsPerTurn1 , (SUBSTRING('                                        a',1,cast((rand()*(14)-1) as int))) ) )
		set @FishStepsPerTurn2 =  ( concat (@FishStepsPerTurn2 , (SUBSTRING('                                        a',1,cast((rand()*(14)-1) as int))) ) )
		set @FishStepsPerTurn3 =  ( concat (@FishStepsPerTurn3 , (SUBSTRING('                                        a',1,cast((rand()*(14)-1) as int))) ) )
		set @FishTurn = @FishTurn + 1
		while @FishTurn = 11
				if @RandWin = 1
					begin
					
print (
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

'
+
@FisherName + ' Ya king/queen we have a winner!! you earn a $1,000 !!

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
					






					
					
					
					')
					 
					 update users set points = (@points + 1000) where username = @username 
					break
					end
				else
					begin
					  
print 
('
----------------------------------------------------------------------------------------------------

 Too bad! this time you lose, You will have to pay us $100 

----------------------------------------------------------------------------------------------------














')
	
					
				update users set points = (@points - 100) where username = @username 	
					break
					end
	end
------------------------------------------------------------------------------------------------------------------------------------


go




create procedure StartGame
(
@UserName nvarchar(30),
@FisherName nvarchar(30)
)
as
declare
@LogS int

set @LogS = (select LogStatus from Users where UserName = @UserName)

if @FisherName not in ('Avi','Moshe','Shir') print 'Fisher name invalid. Please choose one of the following and try again: Avi / Moshe / Shir '
	else if @LogS != 1 print 'User is not logged in.'
		else if @UserName != (select username from Users where username = @UserName) print 'User name is incorrect'
			else 
				execute Start_Game_Alreadi_Yalla_Kvar 
				@UserName = @UserName, 
				@FisherName = @FisherName


go
----------------------------------------------------------------------------------------------------------------------------------------------
create procedure CallTechSupport
(@UserName nvarchar(30),
@EmailAddress nvarchar(50)
)
as
declare 
@LogReset int,
@NewPassword nvarchar(20),
@Pass uniqueidentifier, 
@Word uniqueidentifier


if not exists (select username, EmailAddress from users where username = @UserName and EmailAddress = @EmailAddress) print 'User name and Email do not match. Try again'
else
begin
set @LogReset = (select LogStatus from Users where USERNAME = @UserName)
set @LogReset = 0
set @Pass = NEWID()  
set @Word = NEWID()  
set @NewPassword = cast((CONVERT(varchar(255), @Pass)) as nvarchar(5)) + lower(cast((CONVERT(varchar(255), @Word)) as nvarchar(5)))
PRINT 
'
We have reset your login attempts to 0 and generated a new password.

Your new password is: ' + @NewPassword + '

Please try to login again.


'

update users set [Password] = @NewPassword where username = @UserName

end



----------------------------------------------------------------------------------------------------------------------------------------------
Go


Create View ViewScoreList
as
select UserName, Points
from Users


Go

