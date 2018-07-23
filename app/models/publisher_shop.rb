class PublisherShop < ApplicationRecord
  def self.primary_key
    :id
  end

  has_many :books_in_stocks, foreign_key: :shop_id

  # order by books sold desc
  scope :most_sold, lambda { |cond = {}|
    where(cond).order('books_sold_count DESC, name ASC').uniq
  }
end
