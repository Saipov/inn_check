defmodule InnCheck.Utils.InnValidator do
  @moduledoc """
    Проверка валидности ИНН
    TODO: нужно будет отрефакторить, захардкодил поля
  """
  import Ecto.Changeset

  @weight_factor_10 [2, 4, 10, 3, 5, 9, 4, 6, 8, 0]
  @weight_factor_12 [3, 7, 2, 4, 10, 3, 5, 9, 4, 6, 8, 0]

  def validate_inn(changeset) do
    inn =
      get_field(changeset, :number)
      |> string_to_list!
      |> inn_check

    if inn do
      put_change(changeset, :is_valid, true)
    else
      changeset
    end
  end

  def inn_check(value) when length(value) == 10 do
    calc_checksum = value |> get_checksum(@weight_factor_10) |> control_number
    check_digit = value |> Enum.drop(9) |> hd

    if check_digit == calc_checksum do
      true
    else
      false
    end
  end

  def inn_check(value) when length(value) == 12 do
    one = value |> Enum.drop(-1) |> get_checksum(@weight_factor_12)
    two = value |> get_checksum(tl(@weight_factor_12)) |> control_number
    number_ten = value |> Enum.drop(10) |> hd
    number_eleven = value |> Enum.drop(11) |> hd

    if one == number_ten and two == number_eleven do
      true
    else
      false
    end
  end

  def inn_check(_value), do: false

  defp control_number(checksum), do: checksum |> rem(11) |> rem(10)

  defp string_to_list!(nil), do: false

  defp string_to_list!(string),
    do:
      string
      |> String.replace(~r/[^\d]/, "")
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

  defp get_checksum(value, weight) do
    list = Enum.zip(value, weight) |> Enum.map(fn {x, y} -> x * y end)
    Enum.sum(list)
  end
end
