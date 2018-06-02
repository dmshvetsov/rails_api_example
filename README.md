# Rails API Example

## Business Domain

```
Publisher
---------
id
timestamps
```

```
Book
----
id
title
publisher_id – Publisher foreign key
timestamps
```

```
Shop
----
id
name
[books_sold_count – cache column, can be implemented for better performance]
timestamps
```

```
Shop::Receipt (shop agregates receipts)
-------------
id
shop_id
book_id
copies_count
datetime
timestamps
```

```
Shop::Sale (shop agregates sales)
----------
id
shop_id
book_id
datetime
timestamps
```

## Endpoints

* `GET /v1/publishers/:id/shops`
* `POST /v1/shops/:id/sale`
