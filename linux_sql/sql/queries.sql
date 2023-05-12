#DDL Statements

CREATE table members
(memid integer not null,
surname varchar(200) not null,
firstname varchar(200) not null,
address varchar(300) not null,
zipcode int not null,
telephone varchar(20) not null,
recommendedby int,
joindate timestamp not null,
constraint mem_pk primary key (memid),
constraint mem_fk foreign key (recommendedby) references members(memid));

CREATE table facilities
(facid int,
name varchar(100),
membercost integer,
guestcost integer,
initialoutlay integer,
monthlymaintenance integer,
constraint fac_pk primary key(facid));


CREATE table bookings
(facid int,
memid int,
starttime timestamp,
slots int,
constraint book_pk primary key(facid),
constraint book_fk1 foreign key(memid) references members(memid),
constraint book_fk2 foreign key(memid) references facilities(facid));

Question
The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:

facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

Solution:
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) VALUES (9,'spa',20,30,100000,800);


Question
Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:

Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

Solution:
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) VALUES ((select max(facid) from cd.facilities)+1,'spa',20,30,100000,800);

Question
We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.

Solution:
UPDATE cd.facilities SET initialoutlay=10000 WHERE facid =1;

Question
We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.

Solution:
UPDATE cd.facilities SET guestcost= guestcost+(guestcost*0.1), membercost= membercost+(membercost*0.1) WHERE facid=1;

Question
As part of a clearout of our database, we want to delete all bookings from the cd.bookings table. How can we accomplish this?

solution:
DELETE FROM cd.bookings;

Question
We want to remove member 37, who has never made a booking, from our database. How can we achieve that?
Solution:
DELETE FROM cd.members WHERE memid=37;


Question
How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.
solution:
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost < monthlymaintenance*0.02 AND membercost>0;

Question
How can you produce a list of all facilities with the word 'Tennis' in their name?
solution:
SELECT * FROM cd.facilities
WHERE name like '%Tennis%';


Question
How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.
Solution:
SELECT * FROM cd.facilities
WHERE facid IN(1,5);

Question
How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.
solution:
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate>='2012-09-01 00:00:00';

Question
You, for some reason, want a combined list of all surnames and all facility names. Yes, this is a contrived example :-). Produce that list!
solution:
SELECT Surname FROM cd.members
UNION
SELECT name FROM cd.facilities;

Question
How can you produce a list of the start times for bookings by members named 'David Farrell'?
solution:
SELECT starttime FROM cd.bookings AS B JOIN cd.members AS M
on B.memid=M.memid
WHERE M.firstname='David'
AND M.surname='Farrell';

Question
How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
solution:
SELECT B.starttime as start, F.name as name
FROM cd.bookings B JOIN cd.facilities F
on B.facid=F.facid
WHERE F.name like 'Tennis Court%' and
(B.starttime>='2012-09-21' and B.starttime<'2012-09-22')
ORDER BY B.starttime;

Question
How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).
solution:
SELECT A.firstname as memfname, A.surname as memsname, B.firstname as recfname, B.surname as recsname
FROM cd.members A LEFT OUTER JOIN cd.members B
ON A.recommendedby = B.memid
ORDER BY A.surname, A.firstname;

Question
How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
Solution:
SELECT DISTINCT B.firstname as firstname, B.surname as surname
FROM cd.members A inner JOIN cd.members B
ON A.recommendedby = B.memid
ORDER BY surname, firstname;

Question
How can you output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.
Solution:
SELECT DISTINCT A.firstname||' '||surname as members, (select B.firstname|| ' '||B.surname as recommende from cd.members B where B.memid=A.recommendedby) FROM cd.members A
ORDER BY members;

Question
Produce a count of the number of recommendations each member has made. Order by member ID.
Solution:
SELECT recommendedby, COUNT(memid) FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;

Question
Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id.
Solution:
SELECT facid, sum(slots) as TotalSlots FROM cd.bookings
GROUP BY facid
ORDER BY facid;

Question
Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.
Solution:
SELECT facid, sum(slots) as TotalSlots FROM cd.bookings
WHERE starttime>='2012-09-01' and starttime <'2012-10-01'
GROUP BY facid
ORDER BY TotalSlots;

Question
Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.
Solution:
SELECT facid, extract(month from starttime) as month, sum(slots) as TotalSlots FROM cd.bookings
WHERE extract(year from starttime) =2012
GROUP BY facid, month
ORDER BY facid, month;

Question
Find the total number of members (including guests) who have made at least one booking.
Solution:
SELECT count(distinct memid) FROM cd.bookings
WHERE facid>=1;

Question
Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.
solution:
SELECT M.surname, M.firstname, M.memid, min(B.starttime)
FROM cd.bookings B join cd.members M
ON B.memid=M.memid
WHERE B.starttime>='2012-09-01'
group by M.firstname, M.surname, M.memid
ORDER BY m.memid;

Question
Produce a list of member names, with each row containing the total member count. Order by join date, and include guest members.
solution:
SELECT count(*) over(),firstname, surname
FROM cd.members
order by joindate;

Question
Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.
solution:
select row_number() over(order by joindate), firstname, surname from cd.members order by joindate

Question
Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.
solution:
select facid, total from (
	select facid, sum(slots) total, rank() over (order by sum(slots) desc) rank
        	from cd.bookings
		group by facid
	) as ranked
	where rank = 1


Question
Output the names of all members, formatted as 'Surname, Firstname'
solution:
Select (surname || ', ' || firstname) as name from cd.members;


Question
You've noticed that the club's member table has telephone numbers with very inconsistent formatting. You'd like to find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.
solution:
select memid, telephone
from cd.members
where telephone like '(%)%';

Question
You'd like to produce a count of how many members you have whose surname starts with each letter of the alphabet. Sort by the letter, and don't worry about printing out a letter if the count is 0.
solution:
SELECT substr(surname,1,1) as letter, count(*)
from cd.members
group by letter
order by letter;


