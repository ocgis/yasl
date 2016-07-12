class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy, :delete_checked, :forget_checked]

  # GET /lists
  # GET /lists.json
  def index
    @lists = List.all
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_checked
    checked = @list.selections.select { |selection| selection.status == 'checked' }
    checked.each do |c|
      if c.item.buycounter == 0
        c.item.first_bought_at = Time.now
      end
      c.item.buycounter = c.item.buycounter + 1
      c.item.save
      c.destroy
    end

    set_list
    respond_to do |format|
      format.js { render "replace_html", :locals => { :objects => Selection.sortera(@list.selections), :replaceElem => "selections" } }
    end
  end

  def forget_checked
    checked = @list.selections.select { |selection| selection.status == 'checked' }
    checked.each do |c|
      c.destroy
    end

    set_list
    respond_to do |format|
      format.js { render "replace_html", :locals => { :objects => Selection.sortera(@list.selections), :replaceElem => "selections" } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name)
    end
end
