class Property < ActiveRecord::Base
  attr_accessible :name, :description, :image, :title, :text, :rating

  validates :name, :presence => true
  validates :description, :presence => true
  validates :image, :presence => true
  
  belongs_to :user
  validates_associated :user
  validates :user, :presence => true

  has_many :transactions
  def reviews
    transactions.where("host_text IS NOT NULL")
  end
end
