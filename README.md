# Rails API Example

## Up and running in development

    $ bin/setup

    $ rails s

## Endpoints

* `GET /v1/publishers/:publisher_id/shops`
* `POST /v1/shops/:shop_id/book_sales`

[publisher #1 shops endpoint](http://localhost:3000/publishers/1/shops)

or [publisher #2 shops endpoint](http://localhost:3000/publishers/2/shops)

publisher without shops [publisher #3 shops endpoint](http://localhost:3000/publishers/3/shops)

make a POST request with HTTP client to [shop book sell endpoint](http://localhost:3000/shops/1/book_sells) with JSON body `{ book_id: 1, quantity: 2 }`.

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

## Enhancement

* `shop_stock_changes` database constraint `quantity != 0`
