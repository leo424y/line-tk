class LinksController < ApplicationController
  extend Limiter::Mixin
  limit_method :index, rate: 120

  require 'custom'
  require 'line/bot'  # gem 'link-bot-api'


  before_action :set_link, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
    end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          msg = event.message['text']
          keyword = msg.split('http')[0] || '🦫hili'

          reply_text = if msg.match?(/http/) && keyword.present?
            hili_link = "https://hili.link?i=#{CGI.escape(msg)}"
            uri = URI(hili_link)

            Net::HTTP.get_response(uri)

            "https://hili.link/#{keyword}"
          else
            "https://hili.link/#{event.message['text']}"
          end

          image_uri = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=#{CGI.escape(reply_text)}&format=jpg"

          message = {
            type: 'text',
            text: reply_text
          }

          message2 = {
            type: 'image',
            originalContentUrl: image_uri,
            previewImageUrl: image_uri,
          }
          client.reply_message(event['replyToken'], [message, message2])
        end
      end
    end

    "OK"
  end

  def autocomplete
    params[:q] = {"url_or_note_cont": params[:q]}
    @q = Link.ransack(params[:q])
    @search_result = @q.result.order(updated_at: :desc).pluck(:note, :url)
    render layout: false
  end

  def lihi
    params[:q] = {"note_cont": params[:lihi]}
    @q = Link.ransack(params[:q]).result.order(Arel.sql('RANDOM()')).first
    if @q
      redirect_to "#{@q.url}#:~:text=#{@q.note}"
    else
      redirect_to :root, notice: 'No result. How about check other hilies'
    end
  end
  # GET /links
  def index
    if params[:q] && params[:q][:url_or_note_cont].present?
      @hili = hilify(params[:q][:url_or_note_cont])
      params[:q] = {"url_or_note_cont": @hili[:note]} if @hili
    end

    if params[:i]
      @hili = hilify(params[:i])
      params[:q] = {"url_or_note_cont": @hili[:note]}
    end

    @q = Link.ransack(params[:q])
    @links = @q.result(distinct: true).order(updated_at: :desc)

    @links = @links.first(42)
    respond_to do |format|
      format.html
      format.json { json_response(@links)}
    end
  end

  # GET /links/1
  def show
    respond_to do |format|
      format.html
      format.json { json_response(@link) }
    end
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  def create
    @link = Link.new(link_params)
    @link.url = CGI.unescape(params[:link][:url])
    @link.note = CGI.unescape(params[:link][:note])

    if @link.save
      redirect_to @link, notice: 'Link was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /links/1
  def update
    if @link.update(link_params)
      redirect_to @link, notice: 'Link was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /links/1
  def destroy
    @link.destroy
    redirect_to links_url, notice: 'Link was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def link_params
      params.require(:link).permit(:note, :url)
    end

    private

    def hilify hili
      if hili.match?(/http/)
        if hili.match?('#:~:text=')
          url = CGI.unescape(hili.split('#:~:text=')[0])
          note = CGI.unescape(hili.split('#:~:text=')[1])
          record = {url: url, note: note, full_url: "https://#{request.host}/#{note}"}
          Link.create(url: "#{record[:url]}", note: record[:note])
        elsif hili.split('http')[0].present?
          url = hili.split('http')[1]
          note = hili.split('http')[0]
          record = {url: url, note: note, full_url: "https://#{request.host}/#{note}"}
          Link.create(url: "http#{record[:url]}", note: record[:note])
        end
        record
      end
    end
end
