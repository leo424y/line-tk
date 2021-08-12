class LinesController < ApplicationController
  require 'custom'

  before_action :set_line, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def autocomplete
    params[:q] = {"url_or_note_cont": params[:q]}
    @q = Line.ransack(params[:q])
    @search_result = @q.result.last(10).pluck(:note, :url)
    render layout: false
  end

  # GET /lines
  def index
    hilify params[:i]
    @q = Line.ransack(params[:q])
    @lines = @q.result(distinct: true)
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

    def hilify url
      if url.match? /https:\/\//
        record = {url: url.split('https://')[1], note: url.split('https://')[0]}
        Line.create(url: "https://#{record[:url]}", note: record[:note])
      end
    end
end
