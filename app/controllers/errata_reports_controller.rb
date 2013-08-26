class ErrataReportsController < ApplicationController
  # GET /errata_reports
  # GET /errata_reports.json
  def index
    @errata_reports = ErrataReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @errata_reports }
    end
  end

  # GET /errata_reports/1
  # GET /errata_reports/1.json
  def show
    @errata_report = ErrataReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @errata_report }
    end
  end

  # GET /errata_reports/new
  # GET /errata_reports/new.json
  def new
    @errata_report = ErrataReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @errata_report }
    end
  end

  # GET /errata_reports/1/edit
  def edit
    @errata_report = ErrataReport.find(params[:id])
  end

  # POST /errata_reports
  # POST /errata_reports.json
  def create
    @errata_report = ErrataReport.new(params[:errata_report])

    respond_to do |format|
      if @errata_report.save
        format.html { redirect_to @errata_report, notice: 'Errata report was successfully created.' }
        format.json { render json: @errata_report, status: :created, location: @errata_report }
      else
        format.html { render action: "new" }
        format.json { render json: @errata_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /errata_reports/1
  # PUT /errata_reports/1.json
  def update
    @errata_report = ErrataReport.find(params[:id])

    respond_to do |format|
      if @errata_report.update_attributes(params[:errata_report])
        format.html { redirect_to @errata_report, notice: 'Errata report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @errata_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /errata_reports/1
  # DELETE /errata_reports/1.json
  def destroy
    @errata_report = ErrataReport.find(params[:id])
    @errata_report.destroy

    respond_to do |format|
      format.html { redirect_to errata_reports_url }
      format.json { head :no_content }
    end
  end

  # RUN  /errata_reports/1
  # RUN  /errata_reports/1.json
  def run
    @errata_report = ErrataReport.find(params[:id])
    @errata_report_result = @errata_report.run

    respond_to do |format|
      format.html
      format.json { head :no_content }
    end
  end

end
