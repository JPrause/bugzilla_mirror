class ReportTablesController < ApplicationController
  # GET /report_tables
  # GET /report_tables.json
  def index
    @report_tables = ReportTable.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @report_tables }
    end
  end

  # GET /report_tables/1
  # GET /report_tables/1.json
  def show
    @report_table = ReportTable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report_table }
    end
  end

  # GET /report_tables/new
  # GET /report_tables/new.json
  def new
    @report_table = ReportTable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report_table }
    end
  end

  # GET /report_tables/1/edit
  def edit
    @report_table = ReportTable.find(params[:id])
  end

  # POST /report_tables
  # POST /report_tables.json
  def create
    @report_table = ReportTable.new(params[:report_table])

    respond_to do |format|
      if @report_table.save
        format.html { redirect_to @report_table, notice: 'Report table was successfully created.' }
        format.json { render json: @report_table, status: :created, location: @report_table }
      else
        format.html { render action: "new" }
        format.json { render json: @report_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /report_tables/1
  # PUT /report_tables/1.json
  def update
    @report_table = ReportTable.find(params[:id])

    respond_to do |format|
      if @report_table.update_attributes(params[:report_table])
        format.html { redirect_to @report_table, notice: 'Report table was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @report_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /report_tables/1
  # DELETE /report_tables/1.json
  def destroy
    @report_table = ReportTable.find(params[:id])
    @report_table.destroy

    respond_to do |format|
      format.html { redirect_to report_tables_url }
      format.json { head :no_content }
    end
  end

  # RUN  /bz_queries/1
  # RUN  /bz_queries/1.json
  def run
    @report_table = ReportTable.find(params[:id])
    @report_table_result = @report_table.run( @report_table )

    respond_to do |format|
      format.html
      format.json { head :no_content }
    end
  end

  # GET /report_tables/1/edit
  def edit
    @report_table = ReportTable.find(params[:id])
  end

end
