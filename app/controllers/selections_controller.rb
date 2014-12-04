class SelectionsController < ApplicationController
  before_action :set_selection, only: [:update]
  before_action :set_list, only: [:new]

  def new
    @selection = Selection.new()
  end

  # POST /selections
  # POST /selections.json
  def create
    p = selection_params
    item_name = p.require(:item_id)
    list = List.find(p.require(:list_id))
    items = Item.where(name: p.require(:item_id))
    if items.length == 1
      item = items[0]
    elsif items.length == 0
      item = Item.create(name: item_name)
    else
      raise StandardError, "Wrong number of matching items: #{items}"
    end
      
    p[:item_id] = item.id
    @selection = Selection.new(p)

    respond_to do |format|
      if @selection.save
        format.html { redirect_to list }
        format.json { render :show, status: :created, location: @selection }
      else
        format.html { render :new }
        format.json { render json: @selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /selections/1
  # PATCH/PUT /selections/1.json
  def update
    respond_to do |format|
      if @selection.update(selection_params)
        list = List.find(selection_params.require(:list_id))
        format.js { render "replace_html", :locals => { :objects => Selection.sortera(list.selections), :replaceElem => "selections" } }
        format.html { redirect_to @selection.list, notice: 'selection was successfully updated.' }
        format.json { render :show, status: :ok, location: @selection }
      else
        format.html { render :edit }
        format.json { render json: @selection.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_selection
      @selection = Selection.find(params[:id])
    end

    def set_list
      @list = List.find(params.require(:list_id))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def selection_params
      params.require(:selection).permit(:status, :list_id, :item_id)
    end
end
