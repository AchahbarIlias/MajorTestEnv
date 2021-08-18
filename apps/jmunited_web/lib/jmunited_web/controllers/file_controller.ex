defmodule JmunitedWeb.FileController do
    use JmunitedWeb, :controller
  
    alias Jmunited.ProductContext
    alias Jmunited.ProductContext.Product
    alias CSV


    def csv(conn, %{"file" => file}) do
        file.path
        |> File.stream!()
        |> CSV.decode
        |> Enum.each(fn(p) -> 
          case p do 
            {:ok, product} -> 
              ProductContext.create_product(%{:name => Enum.at(product, 0), :description => Enum.at(product, 1), :size => Enum.at(product, 3), :color => Enum.at(product, 4), :price => Enum.at(product, 5)})
          end
         end)
    
        conn
        |> put_flash(:info, "Products succesfully added")
        |> redirect(to: Routes.product_path(conn, :index))
          
      end
end