module SelectionsHelper

  def selection_sortindex(now, a)
    return (now - a.updated_at) / ((a.updated_at - a.first_bought_at) / (a.buycounter - 1))
  end

  def selection_name(item)
    item_name = item.name
    if @flags.debug
      if item.buycounter > 1
        now = Time.now
        sortindex = selection_sortindex(now, item)
        item_name << " sortindex: #{sortindex}"
        avg = (item.updated_at - item.first_bought_at) / (item.buycounter - 1)
        item_name << " avg: #{avg}"
        since = now - item.updated_at
        item_name << " since: #{since}"
      end
    end
    return item_name
  end
end
