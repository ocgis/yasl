class SelectionsController < ApplicationController
  before_action :set_selection, only: [:update]
  before_action :set_list, only: [:new]

  def new
    @selection = Selection.new()

    selected_item_ids = @list.selections.collect { |selection| selection.item_id }

    now = Time.now
    
    items = Item.where.not(id: selected_item_ids)
    top_items = items.where("buycounter > 1").select { |a| sortindex(now, a) <= 3 }.sort { |b,a| sortindex(now, a)  <=> sortindex(now, b) }
    middle_items = items.where("buycounter = 1").sort { |b,a| a.first_bought_at <=> b.first_bought_at }
    bottom_items = items.where("buycounter = 0").sort { |b,a| a.created_at <=> b.created_at }
    unpopular_items = items.where("buycounter > 1").select { |a| sortindex(now, a) > 3 }.sort { |b,a| sortindex(now, a)  <=> sortindex(now, b) }
    @items = top_items + middle_items +  bottom_items + unpopular_items
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

  def gcreate
    create
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

    def sortindex(now, a)
      return (now - a.updated_at) / ((a.updated_at - a.first_bought_at) / (a.buycounter - 1))
    end
end
