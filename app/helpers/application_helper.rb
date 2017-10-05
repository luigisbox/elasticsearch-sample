module ApplicationHelper
  def hor(hit, field)
    hit["highlight"][field] ? hit["highlight"][field][0] : hit["_source"][field] 
  end
end
