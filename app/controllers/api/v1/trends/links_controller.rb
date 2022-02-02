# frozen_string_literal: true

class Api::V1::Trends::LinksController < Api::BaseController
  before_action :set_links

  def index
    render json: @links, each_serializer: REST::Trends::LinkSerializer
  end

  private

  def set_links
    @links = begin
      if Setting.trends
        links_from_trends
      else
        []
      end
    end
  end

  def links_from_trends
    scope = Trends.links.query.allowed

    scope.in_locale(current_user.preferred_content_locale) if user_signed_in?

    scope.limit(limit_param(10))
  end
end
