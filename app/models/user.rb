class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :credport_uid
  # attr_accessible :title, :body

  has_many :properties, :dependent => :destroy
  has_many :transactions_as_host, :foreign_key => 'bookee_id', :dependent => :destroy, :class_name => 'Transaction'
  has_many :transactions_as_guest, :foreign_key => 'booker_id', :dependent => :destroy, :class_name => 'Transaction'

  def should_review(property)
    transactions_as_guest.host_not_reviewed.where(:property_id => property).exists?
  end

  def reviews
    transactions_as_guest.guest_reviewed + transactions_as_host.host_reviewed
  end

  def credport_representation
    {
      :uid => id,
      :url => Rails.application.routes.url_helpers.user_url(self, :host => Rails.configuration.credport_url_host),
      :image => 'http://lorempixel.com/200/200/animals/',
      :name => name,
      :context_name => Rails.configuration.credport_identity_context_name,
      :subtitle => "#{name} on Marketplace X"}
  end
end
