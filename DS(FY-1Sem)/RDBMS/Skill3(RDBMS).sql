-- Skill - 3(RDBMS) --

create database prepartion;
use  prepartion;
    
create table player1(p_id int primary key, p_name varchar(25), age int, Game_name varchar(100), address varchar(200), country varchar(255));
select * from player1;

create table match1(m_id int primary key, m_title varchar(100), m_startdate Date, m_enddate Date, location varchar(255));
select * from match1;


create table player_matches(p_id int, m_id int, primary key(p_id, m_id), foreign key(p_id) references player1(p_id), foreign key(m_id) references match1(m_id));

insert into player1(p_id, p_name, age, Game_name, address, country) values
(1, 'Virat Kolhi' ,34,'Cricket','Pune','India'),
(2, 'Maria Garcia', 28, 'Tennis', '456 Maple Ave, Barcelona', 'Spain'),
(3, 'Liu Wei', 22, 'Badminton', '789 Pine St, Beijing', 'China'),
(4, 'Aarav Patel', 27, 'Cricket', '101 Cedar Rd, Mumbai', 'India'),
(5, 'Emily Clark', 24, 'Swimming', '234 Oak Dr, Sydney', 'Australia'),
(6, 'Ahmed Hassan', 30, 'Boxing', '567 Birch Ln, Cairo', 'Egypt'),
(7, 'Sophia Rossi', 23, 'Basketball', '890 Walnut Ave, Rome', 'Italy'),
(8, 'Lucas Fernandez', 26, 'Rugby', '321 Chestnut Blvd, Buenos Aires', 'Argentina'),
(9, 'Yuki Sato', 29, 'Judo', '654 Spruce St, Tokyo', 'Japan'),
(10, 'Chloe Dupont', 21, 'Cycling', '987 Willow Way, Paris', 'France');

select * from player1;

insert into match1(m_id, m_title, m_startdate, m_enddate, location) values
(1, 'IPL','2024-03-29','2024-05-29','Mumbai'),
(2, 'Wimbledon Final', '2024-07-14', '2024-07-14', 'London, UK'),
(3, 'Cricket World Cup Final', '2023-11-19', '2023-11-19', 'Ahmedabad, India'),
(4, 'NBA Finals Game 7', '2024-06-20', '2024-06-20', 'Los Angeles, USA'),
(5, 'Olympic 100m Final', '2024-08-03', '2024-08-03', 'Paris, France'),
(6, 'Super Bowl LVIII', '2024-02-11', '2024-02-11', 'Las Vegas, USA'),
(7, 'Rugby World Cup Final', '2023-10-28', '2023-10-28', 'Paris, France'),
(8, 'UFC 300', '2024-03-02', '2024-03-02', 'Las Vegas, USA'),
(9, 'FIFA World Cup Final', '2022-12-18', '2022-12-18', 'Lusail, Qatar'),
(10, 'Tour de France Final Stage', '2024-07-28', '2024-07-28', 'Paris, France');

select * from match1;

insert into player_matches(P_id,m_id) values
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(1,2),(3,1),(5,4),(7,2);

select * from player_matches;

-- 1) List Countrywise name of the Player ---
select country, p_name from player1 order by country, p_name;

-- 2) Given start date and end date of particular match find the number of the days for which the match is played --

select m_id, m_title, m_startdate, m_enddate, datediff(m_enddate,m_startdate) as duration_in_days from match1;

-- 3) Find out the player name who played match title as IPL --

SELECT p.p_name 
FROM player1 p 
JOIN player_matches pm ON p.p_id = pm.p_id 
JOIN match1 m ON pm.m_id = m.m_id 
WHERE m.m_title LIKE 'IPL%';

-- 4) List the matches which are being played in the same location today--

SELECT * 
FROM match1 m1, match1 m2 
WHERE m1.location = m2.location 
  AND m1.m_id != m2.m_id 
  AND m1.m_startdate = m2.m_startdate;


-- 5) Count how many players are playing for INDIA -- 

select count(*) as number_of_players from player1 where country = 'India';

-- 6)  Find the number of player who have not played single match -- 

SELECT p.p_name 
FROM player1 p 
LEFT OUTER JOIN player_matches pm ON p.p_id = pm.p_id 
WHERE pm.p_id IS NULL;

-- 7) Find the number of matches played in the last two year--

SELECT COUNT(*) AS number_of_matches 
FROM match1 
WHERE m_startdate >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- 8)  list all the players names except India;

select p_name from player1 where country != 'India';

-- 9) Add constraint for age of players it must be above 18 and 35 --

SET SQL_SAFE_UPDATES = 0;

alter table player1 add constraint age_check check (age between 18 and 35);

-- 10) Store Information about family members of players in player table(use JSON) information can be 
-- no_of_members,name, age, contact_no (retrive family members information of any one playes)--

Alter table player1 add column family_members JSON;

INSERT INTO player1 (p_id, p_name, age, Game_name, address, country, family_members) 
VALUES (
    102, 
    'Virat Kohli', 
    34, 
    'Cricket', 
    'Delhi', 
    'India', 
    '{"no_of_members": 3, "members": [
        {"name": "Anushka", "age": 34, "contact_no": 1234567890},
        {"name": "Vamika", "age": 2, "contact_no": 9876543210}
    ]}'
);

select * from player1;

select p_name, family_members from player1 where p_id = 102;










