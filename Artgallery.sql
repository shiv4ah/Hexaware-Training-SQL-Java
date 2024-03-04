create database Gallery;
use Gallery;
create table Artists(ArtistID int primary key, Name varchar(255) not null,Biography text, Nationality varchar(100));

create table Categories(CategoryID int primary key,Name varchar(100) not null);

CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));
 
 CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);
 
 CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));
 
 INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');
 
 INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\'s powerful anti-war mural.', 'guernica.jpg');

INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);
 
 select * from Categories;
 select * from Artists;
 select * from Artworks;
 select * from Exhibitions;
 select * from ExhibitionArtWorks;
 
SELECT Artists.Name AS Artist_Name, COUNT(Artworks.ArtworkID) AS Num_Artworks
FROM Artists
LEFT JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
ORDER BY Num_Artworks DESC;

SELECT Artworks.Title
FROM Artworks
INNER JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Artists.Nationality IN ('Spanish', 'Dutch')
ORDER BY Artworks.Year ASC;

use Gallery;

SELECT Artworks.Title AS Artwork_Title, Artists.Name AS Artist_Name, Categories.Name AS Category_Name
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';

SELECT Artists.Name AS Artist_Name, COUNT(*) AS Artwork_Count
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(*) > 2;

SELECT Artworks.Title
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
WHERE Exhibitions.Title = 'Modern Art Masterpieces'
AND Artworks.ArtworkID IN (
    SELECT ArtworkID
    FROM ExhibitionArtworks
    JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
    WHERE Exhibitions.Title = 'Renaissance Art'
);

SELECT Categories.Name AS Category_Name, COUNT(*) AS Artwork_Count
FROM Artworks
JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
GROUP BY Categories.Name;

SELECT Artists.Name AS Artist_Name, COUNT(*) AS Artwork_Count
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID
HAVING COUNT(*) > 3;

SELECT Artworks.Title AS Artwork_Title, Artists.Name AS Artist_Name
FROM Artworks
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Artists.Nationality = 'Spanish';

SELECT Exhibitions.Title AS Exhibition_Title
FROM Exhibitions
JOIN ExhibitionArtworks ON Exhibitions.ExhibitionID = ExhibitionArtworks.ExhibitionID
JOIN Artworks ON ExhibitionArtworks.ArtworkID = Artworks.ArtworkID
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Artists.Name IN ('Vincent van Gogh', 'Leonardo da Vinci')
GROUP BY Exhibitions.Title
HAVING COUNT(DISTINCT Artists.Name) = 2;

SELECT Artworks.*
FROM Artworks
LEFT JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
WHERE ExhibitionArtworks.ArtworkID IS NULL;

SELECT Artists.ArtistID, Artists.Name AS Artist_Name
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
JOIN (
    SELECT DISTINCT ArtistID
    FROM Artworks
) AS ArtworksByArtist ON Artists.ArtistID = ArtworksByArtist.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
HAVING COUNT(DISTINCT Artworks.CategoryID) = (
    SELECT COUNT(*) 
    FROM Categories
);

SELECT Categories.Name AS Category_Name, COUNT(Artworks.ArtworkID) AS Artwork_Count
FROM Categories
LEFT JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name;

SELECT Artists.ArtistID, Artists.Name AS Artist_Name, COUNT(Artworks.ArtworkID) AS Artwork_Count
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;

SELECT Categories.Name AS Category_Name, AVG(Artworks.Year) AS Average_Year
FROM Categories
JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name
HAVING COUNT(Artworks.ArtworkID) > 1;

SELECT Artworks.Title AS Artwork_Title
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';

SELECT Categories.Name AS Category_Name, AVG(Artworks.Year) AS Category_Average_Year
FROM Categories
JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name
HAVING AVG(Artworks.Year) > (
    SELECT AVG(Year) 
    FROM Artworks
);

SELECT Title
FROM Artworks
WHERE ArtworkID NOT IN (
    SELECT ArtworkID
    FROM ExhibitionArtworks
);
USE gallery;
SELECT DISTINCT Artists.Name AS Artist_Name
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE Categories.Name = (
    SELECT Categories.Name
    FROM Artworks
    JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
    WHERE Artworks.Title = 'Mona Lisa'
);

SELECT Artists.Name AS Artist_Name, COUNT(Artworks.ArtworkID) AS Artwork_Count
FROM Artists
LEFT JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name;

