class Transaction < ActiveRecord::Base
  attr_accessible :guest_rating, :guest_text, :host_rating, :host_text
  attr_protected :property, :booker, :bookee

  belongs_to :booker, :class_name => 'User', :foreign_key => :booker_id
  belongs_to :bookee, :class_name => 'User', :foreign_key => :bookee_id
  belongs_to :property

  validates_associated :bookee
  validates_associated :booker
  validates_associated :property

  validates :bookee, :presence => true
  validates :booker, :presence => true
  validates :property, :presence => true

  validate :cant_book_your_own, :valid_review
   
  def cant_book_your_own
    errors.add(:booker, "can't book his own property") if bookee == booker
  end

  def valid_review
    if guest_text
      errors.add(:guest_rating, "is not present") unless guest_rating
    end
    if host_text
      errors.add(:host_rating, "is not present") unless host_rating
    end
  end

  scope :guest_not_reviewed, where(["guest_text IS NULL"])
  scope :guest_reviewed, where(["guest_text IS NOT NULL"])
  scope :host_not_reviewed, where(["host_text IS NULL"])
  scope :host_reviewed, where(["host_text IS NOT NULL"])

  scope :booked_by_user, lambda { |user| where(:booker_id => user) }

  def push_to_credport
    # currently only push reviews, not raw transactions
    consumer = OAuth2::Client.new(Rails.configuration.credport_key, Rails.configuration.credport_secret, :site => ENV['CREDPORT_BASE_URL'] || "https://www.credport.org")
    
    if host_text && bookee.credport_token
      host_review = {
        :from => booker.credport_representation,
        :to => bookee.credport_representation,
        :connection => {
          :context_name => Rails.configuration.credport_review_context_name,
          :properties => {
            :text => host_text,
            :rating => host_rating,
            :id => id
          }
          
        }
      }
      access_token = OAuth2::AccessToken.new(consumer, bookee.credport_token)
      post_host_review = access_token.post "/api/v1/reviews", {:body => host_review.to_json, :headers => {'Content-Type' => 'application/json'}}
    end

    if guest_text && booker.credport_token
      guest_review = {
        :from => bookee.credport_representation,
        :to => booker.credport_representation,
        :connection => {
          :context_name => Rails.configuration.credport_review_context_name,
          :properties => {
            :text => guest_text,
            :rating => guest_rating,
            :id => id
          }
        }
      }
      access_token = OAuth2::AccessToken.new(consumer, booker.credport_token)
      post_guest_review = access_token.post "/api/v1/reviews", {:body => guest_review.to_json, :headers => {'Content-Type' => 'application/json'}}
    end
    
  end
end
