exit unless Rails.env.development?

# Truncate data

[
  Shop::StockChange,
  Shop,
  Book,
  Publisher
].map(&:delete_all)

# Create data

publisher1 = Publisher.create!(id: 1)
publisher2 = Publisher.create!(id: 2)
Publisher.create!(id: 3)

book1, book2, book3, book4 = Book.create!([
  { publisher: publisher1, title: 'SQL cookbook' },
  { publisher: publisher1, title: 'Code: The Hidden Language of Computer Hardware and Software' },
  { publisher: publisher1, title: 'HTML and CSS: Design and Build Websites' },
  { publisher: publisher2, title: 'Clean code' }
])

amazon = Shop.create!(name: 'Amazon')
ozon = Shop.create!(name: 'Ozon')

Shop::StockChange.create!([
  { shop: amazon, book: book1, quantity: 2105 },
  { shop: amazon, book: book2, quantity: 1350 },
  { shop: amazon, book: book3, quantity: 4200 },
  { shop: amazon, book: book4, quantity: 800 },
  { shop: ozon, book: book4, quantity: 400 }
])
