class Selection < ActiveRecord::Base
  belongs_to :list
  belongs_to :item

  def self.sortera(selections)
    checked = []
    unchecked = []
    selections.each do |selection|
      if selection.status == 'checked'
        checked.append(selection)
      else
        unchecked.append(selection)
      end
    end
    return unchecked + checked
  end

end
