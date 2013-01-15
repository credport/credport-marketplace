class PropertiesController < ApplicationController
  # GET /properties
  # GET /properties.json
  before_filter :authenticate_user!, :only => [:new, :create, :edit]

  def index
    @properties = Property.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @properties }
    end
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
    @property = Property.find(params[:id])
    if current_user
      if current_user.should_review(@property)
        @transaction = current_user.transactions_as_guest.host_not_reviewed.find_by_property_id(@property)
      else
        @transaction = @property.transactions.new if current_user
      end
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @property }
    end
  end

  # GET /properties/new
  # GET /properties/new.json
  def new
    @property = Property.new
    @property.name = Faker::Address.city unless @property.name
    @property.description = Faker::Lorem.paragraphs(3).join("\n\n") if @property.description.empty?
    @property.image = "http://lorempixel.com/600/300/city/" if @property.image.empty?
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @property }
    end
  end

  # GET /properties/1/edit
  def edit
    @property = Property.find(params[:id])
    if @property.user != current_user
      redirect_to property_path(@property)
    end
  end

  # POST /properties
  # POST /properties.json
  def create
    @property = current_user.properties.build(params[:property])

    respond_to do |format|
      if @property.save
        format.html { redirect_to @property, notice: 'Property was successfully created.' }
        format.json { render json: @property, status: :created, location: @property }
      else
        format.html { render action: "new" }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /properties/1
  # PUT /properties/1.json
  def update
    @property = Property.find(params[:id])

    respond_to do |format|
      if @property.update_attributes(params[:property])
        format.html { redirect_to @property, notice: 'Property was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property = Property.find(params[:id])
    @property.destroy

    respond_to do |format|
      format.html { redirect_to properties_url }
      format.json { head :no_content }
    end
  end
end
