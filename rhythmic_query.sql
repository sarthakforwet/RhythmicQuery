use rhythmic_query;

show tables;

# what genres of music are most popular?
# For this purpose, we need to lookup for three tables, genre, track and invoiceline.
select g.GenreId, g.Name, sum(i.Quantity) quantities_sold from
genre g
join
track t
on g.GenreId = t.GenreId
join
invoiceline i
on
t.TrackId = i.TrackId
group by
g.GenreId
order by
sum(i.Quantity)
desc
limit 5;

# The above query extracts top three Genre which are most popular by the number of their quantities sold. 
# In this, we see Rock having the most number of copies sold.

# which artist are popular by week, month, year?
# Tables used artist, album, track. invoiceline

select a.Name, sum(i.Quantity) quantities_sold, Month(inv.InvoiceDate) `month` from
artist a
join
album ab
on 
a.ArtistId = ab.ArtistId
join
track t
on 
ab.AlbumId = t.AlbumId
join
invoiceline i
on
t.TrackId = i.TrackId
join
invoice inv
on
i.InvoiceId = inv.InvoiceId
group by
a.ArtistId, Month(inv.InvoiceDate)
order by 
sum(i.Quantity)
desc
limit 5;

# By week
select a.Name, sum(i.Quantity) quantities_sold, Week(inv.InvoiceDate) as `week` from
artist a
join
album ab
on 
a.ArtistId = ab.ArtistId
join
track t
on 
ab.AlbumId = t.AlbumId
join
invoiceline i
on
t.TrackId = i.TrackId
join
invoice inv
on
i.InvoiceId = inv.InvoiceId
group by
a.ArtistId, Week(inv.InvoiceDate)
order by 
sum(i.Quantity)
desc
limit 5;

# By Year
select a.Name, sum(i.Quantity) quantities_sold, Year(inv.InvoiceDate) as `year` from
artist a
join
album ab
on 
a.ArtistId = ab.ArtistId
join
track t
on 
ab.AlbumId = t.AlbumId
join
invoiceline i
on
t.TrackId = i.TrackId
join
invoice inv
on
i.InvoiceId = inv.InvoiceId
group by
a.ArtistId, Year(inv.InvoiceDate)
order by 
sum(i.Quantity)
desc
limit 5;


# What can you tell me about the customers that are spending the most on [genre], [artist], etc?
WITH GenreSpending AS (
    SELECT 
        g.GenreId,
        g.Name AS Genre,
        c.CustomerId,
        concat(c.FirstName, ' ', c.LastName) AS CustomerName,
        SUM(il.UnitPrice * il.Quantity) AS TotalSpending
    FROM 
        Customer c
    JOIN 
        Invoice i ON c.CustomerId = i.CustomerId
    JOIN 
        InvoiceLine il ON i.InvoiceId = il.InvoiceId
    JOIN 
        Track t ON t.TrackId = il.TrackId
    JOIN 
        Genre g ON g.GenreId = t.GenreId
    GROUP BY 
        g.GenreId, c.CustomerId
),
RankedSpending AS (
    SELECT 
        GenreId,
        Genre,
        CustomerId,
        CustomerName,
        TotalSpending,
        RANK() OVER (PARTITION BY GenreId ORDER BY TotalSpending DESC) AS SpendingRank
    FROM 
        GenreSpending
)
SELECT 
    Genre,
    CustomerName AS TopSpender,
    TotalSpending
FROM 
    RankedSpending
WHERE 
    SpendingRank = 1;

-- 13.Track changes in sales by genre using the genre, track, and invoiceline tables to identify trends.
-- Tableau Question
-- select * from 
-- Genre g
-- Join
-- track t
-- on 
-- t.GenreId = g.GenreId
-- join invoiceline it
-- on
-- it.TrackId = t.TrackId;


-- 14 How effective are different media types in generating sales?
select m.name, sum(it.UnitPrice * it.Quantity) TotalSales from track t
join 
mediatype m
on 
t.MediaTypeId = m.MediaTypeId
join
invoiceline it
on
t.TrackId = it.TrackId
group by
m.MediaTypeId
order by
TotalSales
desc;
# MPEG audio file is the mostly used media type which has maximum sale equal to 1956.24 units.


-- 16.What is the average customer purchase size and frequency?


-- 17.Use data from the customer and invoice tables to calculate average invoice totals and purchase frequency per customer.
select concat(c.FirstName, ' ', c.LastName) Customer, sum(i.Total) invoice_total, count(*) purchase_frequency
from Customer c
Join Invoice i
on 
c.CustomerId = i.CustomerId
group by
c.CustomerId;
# Dummy data and thus is uniform for each customer

-- 18.Which playlists are most popular among users?


-- 19.Analyze data from the playlist and playlisttrack tables to determine which playlists have the most tracks or engagement.

-- 20.How does customer location influence purchasing behavior?

-- 21.Investigate how factors like country, city, or state (from the customer table) correlate with purchasing patterns.

-- 22.What is the impact of employee support on customer satisfaction?

-- 23.Explore any correlations between customer spending and their assigned support representative using data from the customer and employee tables.