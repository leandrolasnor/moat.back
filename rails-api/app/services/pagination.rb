# frozen_string_literal: true

class Pagination
  def initialize(items, current_page, per_page, serializer, current_user = nil, scope: nil)
    @per_page = (per_page || 10).to_i
    @current_page = (current_page || 1).to_i
    @items_count = items.count(:id)
    @pages_count = (@items_count / @per_page.to_f).ceil
    @serializer = serializer
    @current_user = current_user
    @items = items
    @scope = scope
  end

  def page_items
    @page_items ||= ActiveModel::Serializer::CollectionSerializer.new(
      @items.limit(@per_page).offset(@current_page * @per_page),
      current_user: @current_user,
      serializer: @serializer,
      scope: @scope
    )
  end

  def header_params
    { 'Pages-Count' => @pages_count, 'Per-Page' => @per_page, 'Current-Page' => @current_page, 'Items-Count' => @items_count }
  end

  def to_json
    page_items.to_json
  end
end
