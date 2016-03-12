#hackathon mode ON

API_KEY = "AIzaSyBrkSGKz1S4TLlGBQKgTOFb1A_DmKgJI7U"

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  def status_door
    render json: {status: Event.last.status}
  end

  def toggle_status
    if Event.last.status == 'opened'
      'closed'
    else
      'opened'
    end
  end

  def register_token
    token = event_params["token"]
    token = AndroidToken.last || AndroidToken.create()
    token.update_attribute(:value, token)
  end

  # POST /events
  # POST /events.json
  # same as create
  def toggle_door
    @event = Event.new(event_params)
    @event.status = toggle_status

    if token = AndroidToken.first.try(:value)
      gcm = GCM.new(API_KEY)
      registration_ids = [token]
      options = {data: {status: @event.status}}
      gcm.send(registration_ids, options)
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:status, :requester, :token)
    end
end
