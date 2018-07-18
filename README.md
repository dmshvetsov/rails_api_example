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
Shop::StockChange
-------------
id
shop_id – Shop foreign key
book_id – Book foreign key
quantity
timestamps
```

## Endpoints

* `GET /v1/publishers/:id/shops`
* `POST /v1/shops/:id/stock_changes`
