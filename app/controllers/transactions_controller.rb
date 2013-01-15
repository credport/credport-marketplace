class TransactionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @property = Property.find(params[:property_id])
    @transaction = @property.transactions.build
    @transaction.booker = current_user
    @transaction.bookee = @property.user
    if @transaction.save
      redirect_to property_path(@property), :notice => "Property Booked!"
    else
      redirect_to property_path(@property), :noteice => "Property could not be booked!"
    end
  end

  def update
    # we only update a transaction if we leave a corresponding review
    @transaction = Transaction.find(params[:id])
    @transaction.assign_attributes params[:transaction]
    if (@transaction.host_text_changed? or @transaction.guest_text_changed?) and @transaction.save
      @transaction.push_to_credport
      redirect_to property_path(@transaction.property), :notice => "Review submitted"
    else
      redirect_to property_path(@transaction.property), :notice => "Could not submit review!"
    end
  end

end
