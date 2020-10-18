class Product < ApplicationRecord
  validates :title, presence: true
  validates :body_html, presence: true
end

