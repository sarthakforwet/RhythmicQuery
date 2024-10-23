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


# What can you tell me about the our customers that are spending the most on [genre], [artist], etc?

