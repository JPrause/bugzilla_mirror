class BzQueriesController < ApplicationController
  # GET /bz_queries
  # GET /bz_queries.json
  def index
    @bz_queries = BzQuery.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bz_queries }
    end
  end

  # GET /bz_queries/1
  # GET /bz_queries/1.json
  def show
    @bz_query = BzQuery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bz_query }
    end
  end

  # GET /bz_queries/new
  # GET /bz_queries/new.json
  def new
    @bz_query = BzQuery.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bz_query }
    end
  end

  # GET /bz_queries/1/edit
  def edit
    @bz_query = BzQuery.find(params[:id])
  end

  # POST /bz_queries
  # POST /bz_queries.json
  def create
    @bz_query = BzQuery.new(params[:bz_query])

    respond_to do |format|
      if @bz_query.save
        format.html { redirect_to @bz_query, notice: 'BzQuery was successfully created.' }
        format.json { render json: @bz_query, status: :created, location: @bz_query }
      else
        format.html { render action: "new" }
        format.json { render json: @bz_query.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bz_queries/1
  # PUT /bz_queries/1.json
  def update
    @bz_query = BzQuery.find(params[:id])

    respond_to do |format|
      if @bz_query.update_attributes(params[:bz_query])
        format.html { redirect_to @bz_query, notice: 'BzQuery was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bz_query.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bz_queries/1
  # DELETE /bz_queries/1.json
  def destroy
    @bz_query = BzQuery.find(params[:id])
    @bz_query.destroy

    respond_to do |format|
      format.html { redirect_to bz_queries_url }
      format.json { head :no_content }
    end
  end

  # RUN  /bz_queries/1
  # RUN  /bz_queries/1.json
  def run
    @bz_query = BzQuery.find(params[:id])
    @bz_query_result = @bz_query.run( @bz_query )

    respond_to do |format|
      format.html
      format.json { head :no_content }
    end
  end

  # GET /bz_queries/1/edit
  def edit
    @bz_query = BzQuery.find(params[:id])
  end

end
