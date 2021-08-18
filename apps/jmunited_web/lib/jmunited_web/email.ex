defmodule JmunitedWeb.Email do
  use Bamboo.Phoenix, view: JmunitedWeb.EmailView

  def welcome_email(email, link) do
    new_email(
      to: email,
      from: "ilias.achahbar@student.ucll.be",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>\n
      Please confirm your account by clicking or copy pasting this link: <a href=\"#{JmunitedWeb.Endpoint.url()}/confirm/#{link}\">#{JmunitedWeb.Endpoint.url()}/confirm/#{link}</a>",
      text_body: "Thanks for joining!"
    )
  end

  def order_confirmation(email, products, totalPrice) do
    new_email()
    |> from("ilias.achahbar@student.ucll.be")
    |> to(email)
    |> subject("Order confirmation")
    |> assign(:products, products)
    |> assign(:totalPrice, totalPrice)
    |> render("confirmation_email.html")
  end

  def retour_confirmation(email, products, totalPrice) do
    new_email()
    |> from("ilias.achahbar@student.ucll.be")
    |> to(email)
    |> subject("Retour confirmation")
    |> assign(:products, products)
    |> assign(:totalPrice, totalPrice)
    |> render("confirmation_email.html")
  end

end
