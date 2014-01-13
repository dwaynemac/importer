class ImportsController < UserApplicationController
  before_action :set_import, only: [:show, :edit, :update, :destroy, :rollback]

  # GET /imports
  # GET /imports.json
  def index
    @imports = current_user.current_account.imports.load # .load is .all on rails 4
  end

  # GET /imports/1
  # GET /imports/1.json
  def show
    @import.realtime_status
  end

  # GET /imports/new
  def new
    @import = current_user.current_account.imports.build
  end

  # GET /imports/1/edit
  def edit
  end

  # POST /imports
  # POST /imports.json
  def create
    @import = current_user.current_account.imports.build
    respond_to do |format|
      if @import.save
        format.html { redirect_to edit_import_path(@import), notice: 'Import was successfully created.' }
        format.json { render action: 'edit', status: :created, location: @import }
      else
        format.html { render action: 'new' }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /imports/1
  # PATCH/PUT /imports/1.json
  def update
    respond_to do |format|
      if @import.update(import_params)
        format.html { redirect_to @import, notice: 'Import was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imports/1
  # DELETE /imports/1.json
  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url }
      format.json { head :no_content }
    end
  end

  # DELETE /imports/1/rollback
  def rollback
    raise "waiting for modules to implement rollback"
    if @import.can_rollback? and @import.rollback
      respond_to do |format|
        format.html { redirect_to imports_url }
      end
    else
      respond_to do |format|
        format.html { redirect_to imports_url, error: 'couldnt rollback' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      params[:import].permit(:import_file)
    end
end
