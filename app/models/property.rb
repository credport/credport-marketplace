class Property < ActiveRecord::Base
  attr_accessible :name, :description, :image

  validates :name, :presence => true
  validates :description, :presence => true
  validates :image, :presence => true
  
  belongs_to :user
end
