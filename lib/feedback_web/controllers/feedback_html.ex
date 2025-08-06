defmodule FeedbackWeb.FeedbackHTML do
  use FeedbackWeb, :html

  import Phoenix.HTML.Form

  embed_templates "feedback_html/*"
end
