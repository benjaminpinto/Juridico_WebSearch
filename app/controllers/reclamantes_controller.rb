class ReclamantesController < ApplicationController
  # GET /reclamantes
  # GET /reclamantes.xml
  def index
    @reclamantes = Reclamante.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reclamantes }
    end
  end
  
  # GET /reclamantes/1
  # GET /reclamantes/1.xml
  def show
    @reclamante = Reclamante.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reclamante }
    end
  end

  # GET /reclamantes/new
  # GET /reclamantes/new.xml
  def new
    @reclamante = Reclamante.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reclamante }
    end
  end

  # GET /reclamantes/1/edit
  def edit
    @reclamante = Reclamante.find(params[:id])
  end

  # POST /reclamantes
  # POST /reclamantes.xml
  def create
    @reclamante = Reclamante.new(params[:reclamante])

    respond_to do |format|
      if @reclamante.save
        flash[:notice] = 'Reclamante was successfully created.'
        format.html { redirect_to(@reclamante) }
        format.xml  { render :xml => @reclamante, :status => :created, :location => @reclamante }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reclamante.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reclamantes/1
  # PUT /reclamantes/1.xml
  def update
    @reclamante = Reclamante.find(params[:id])

    respond_to do |format|
      if @reclamante.update_attributes(params[:reclamante])
        flash[:notice] = 'Reclamante was successfully updated.'
        format.html { redirect_to(@reclamante) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reclamante.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reclamantes/1
  # DELETE /reclamantes/1.xml
  def destroy
    @reclamante = Reclamante.find(params[:id])
    @reclamante.destroy

    respond_to do |format|
      format.html { redirect_to(reclamantes_url) }
      format.xml  { head :ok }
    end
  end

  def search
    @query = params[:nome].to_s.upcase
    @reclamante = Reclamante.find(:all, :conditions => ["Nome_Reclamante like ?", "#{@query}%"  ])
  end

end
