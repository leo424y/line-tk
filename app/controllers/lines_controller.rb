class LinesController < ApplicationController
  require 'custom'

  before_action :set_line, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def autocomplete
    params[:q] = {"url_or_note_cont": params[:q]}
    @q = Line.ransack(params[:q])
    @search_result = @q.result.order(updated_at: :desc).pluck(:note, :url)
    render layout: false
  end

  def lihi
    params[:q] = {"note_cont": params[:lihi]}
    @q = Line.ransack(params[:q]).result.order(Arel.sql('RANDOM()')).first
    if @q
      redirect_to "#{@q.url}#:~:text=#{@q.note}"
    else
      redirect_to :root, notice: 'No result. How about check other hilies'
    end
  end
  # GET /lines
  def index
    if params[:i]
      @hili = hilify(params[:i])
      params[:q] = {"url_or_note_cont": @hili[:note]}
    end

    if params[:q] && params[:q][:url_or_note_cont].present?
      @hili = hilify(params[:q][:url_or_note_cont])
      params[:q] = {"url_or_note_cont": @hili[:note]} if @hili
    end

    @q = Line.ransack(params[:q])
    @lines = @q.result(distinct: true).order(updated_at: :desc)

    @lines = @lines.first(42)
    respond_to do |format|
      format.html
      format.json { json_response(@lines)}
    end
  end

  # GET /lines/1
  def show
    respond_to do |format|
      format.html
      format.json { json_response(@line) }
    end
  end

  # GET /lines/new
  def new
    @line = Line.new
  end

  # GET /lines/1/edit
  def edit
  end

  # POST /lines
  def create
    @line = Line.new(line_params)
    @line.url = CGI.unescape(params[:line][:url])
    @line.note = CGI.unescape(params[:line][:note])

    if @line.save
      redirect_to @line, notice: 'Line was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lines/1
  def update
    if @line.update(line_params)
      redirect_to @line, notice: 'Line was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lines/1
  def destroy
    @line.destroy
    redirect_to lines_url, notice: 'Line was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line
      @line = Line.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def line_params
      params.require(:line).permit(:note, :url)
    end

    private

    def hilify hili
      if hili.match?(/https:\/\//) && hili.split('https://')[0].present?
        url = hili.split('https://')[1]
        note = hili.split('https://')[0]
        record = {url: url, note: note, full_url: "https://hili.link/#{note}"}
        Line.create(url: "https://#{record[:url]}", note: record[:note])
        record
      end
    end
end
