CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE IF NOT EXISTS "publishers" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS "books" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar NOT NULL, "publisher_id" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_d7ae2b039e"
FOREIGN KEY ("publisher_id")
  REFERENCES "publishers" ("id")
);
CREATE INDEX "index_books_on_publisher_id" ON "books" ("publisher_id");
CREATE TABLE IF NOT EXISTS "shops" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE IF NOT EXISTS "shop_stock_changes" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "shop_id" integer NOT NULL, "book_id" integer NOT NULL, "quantity" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_c36a1ca401"
FOREIGN KEY ("shop_id")
  REFERENCES "shops" ("id")
, CONSTRAINT "fk_rails_3ef06178ff"
FOREIGN KEY ("book_id")
  REFERENCES "books" ("id")
);
CREATE INDEX "index_shop_stock_changes_on_shop_id" ON "shop_stock_changes" ("shop_id");
CREATE INDEX "index_shop_stock_changes_on_book_id" ON "shop_stock_changes" ("book_id");
CREATE VIEW books_in_stocks as

  select books.id,
    books.title,
    books.publisher_id,
    stocks.shop_id,
    sum(stocks.quantity) as copies_in_stock
  from books
    inner join shop_stock_changes as stocks on stocks.book_id = books.id
  group by books.id, shop_id
    having copies_in_stock > 0;
CREATE VIEW publisher_shops as
  select shops.id,
    shops.name,
    books.publisher_id,
    abs(sum(case
              when stocks.quantity < 0 then stocks.quantity
              else 0
            end)) as books_sold_count
  from shops
    inner join shop_stock_changes as stocks on stocks.shop_id = shops.id
    inner join books on stocks.book_id = books.id
  group by shops.id, books.publisher_id;
INSERT INTO "schema_migrations" (version) VALUES
('20180718074259'),
('20180718074339'),
('20180718074417'),
('20180718074504'),
('20180719024053'),
('20180719060421');


