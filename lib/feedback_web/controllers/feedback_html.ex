defmodule FeedbackWeb.FeedbackHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use FeedbackWeb, :html

  embed_templates "feedback_html/*"
end
