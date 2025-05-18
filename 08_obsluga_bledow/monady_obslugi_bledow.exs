# Monady obsługi błędów w Elixir

IO.puts("=== Monady obsługi błędów w Elixir ===\n")

# Monady obsługi błędów to wzorce projektowe pomagające w obsłudze
# błędów w sposób funkcyjny, bez konieczności zagnieżdżonych konstrukcji if/case.

# ------ Koncept: Result Monad ------
IO.puts("--- Koncept: Result Monad ---")

# Wzorzec Result Monad (lub Either Monad) używa dwóch wariantów:
# - {:ok, value} dla operacji zakończonych powodzeniem
# - {:error, reason} dla operacji zakończonych niepowodzeniem

defmodule Result do
  # Success case - zwraca {:ok, value}
  def ok(value), do: {:ok, value}

  # Error case - zwraca {:error, reason}
  def error(reason), do: {:error, reason}

  # Map - transformuje wartość wewnątrz {:ok, _}, ignoruje {:error, _}
  def map({:ok, value}, func), do: {:ok, func.(value)}
  def map({:error, _} = error, _func), do: error

  # Bind (flatMap) - podobny do map, ale func już zwraca {:ok, _} lub {:error, _}
  def bind({:ok, value}, func), do: func.(value)
  def bind({:error, _} = error, _func), do: error

  # Obsługa błędów - transformuje error w inny result
  def recover({:ok, _} = ok, _func), do: ok
  def recover({:error, reason}, func), do: func.(reason)

  # Run - uruchamia funkcję tylko jeśli result to {:ok, _}, zwraca oryginalny result
  def run({:ok, value} = ok, func) do
    func.(value)
    ok
  end
  def run({:error, _} = error, _func), do: error

  # Unwrap - zwraca wartość lub domyślną wartość
  def unwrap({:ok, value}, _default), do: value
  def unwrap({:error, _}, default), do: default

  # Unwrap! - zwraca wartość lub rzuca wyjątek
  def unwrap!({:ok, value}), do: value
  def unwrap!({:error, reason}), do: raise "Failed to unwrap Result: #{inspect(reason)}"
end

# Przykłady użycia
wynik_ok = Result.ok(42)
wynik_error = Result.error("Coś poszło nie tak")

# Transformacje
wynik_podwojony = Result.map(wynik_ok, fn x -> x * 2 end)
wynik_error_transformacja = Result.map(wynik_error, fn x -> x * 2 end)

IO.puts("Oryginalny wynik: #{inspect(wynik_ok)}")
IO.puts("Podwojony wynik: #{inspect(wynik_podwojony)}")
IO.puts("Próba transformacji błędu: #{inspect(wynik_error_transformacja)}")

# Łańcuchowanie operacji
wynik_zlozony =
  Result.ok(10)
  |> Result.map(fn x -> x + 5 end)
  |> Result.bind(fn x ->
    if x > 10, do: Result.ok(x * 3), else: Result.error("Za mała wartość")
  end)

IO.puts("Złożony wynik: #{inspect(wynik_zlozony)}")

# ------ Przykładowa implementacja monady Maybe ------
IO.puts("\n--- Implementacja monady Maybe ---")

defmodule Maybe do
  # Just - zawiera wartość
  def just(value), do: {:just, value}

  # Nothing - reprezentuje brak wartości
  def nothing, do: :nothing

  # Map - transformuje wartość wewnątrz {:just, _}, ignoruje :nothing
  def map({:just, value}, func), do: {:just, func.(value)}
  def map(:nothing, _func), do: :nothing

  # Bind - podobny do map, ale func już zwraca {:just, _} lub :nothing
  def bind({:just, value}, func), do: func.(value)
  def bind(:nothing, _func), do: :nothing

  # Unwrap - zwraca wartość lub domyślną wartość
  def unwrap({:just, value}, _default), do: value
  def unwrap(:nothing, default), do: default

  # Funkcja pomocnicza do konwersji nil na Maybe
  def from_nullable(nil), do: nothing()
  def from_nullable(value), do: just(value)
end

# Przykładowa funkcja używająca monady Maybe
defmodule MaybeExample do
  import Maybe

  def get_user_data(users, user_id) do
    from_nullable(users[user_id])
  end

  def get_email(user) do
    bind(from_nullable(user), fn u -> from_nullable(u[:email]) end)
  end

  def get_domain(email) do
    bind(from_nullable(email), fn e ->
      case String.split(e, "@") do
        [_, domain] -> just(domain)
        _ -> nothing()
      end
    end)
  end

  # Łańcuch operacji używający Maybe
  def get_email_domain(users, user_id) do
    get_user_data(users, user_id)
    |> bind(fn user -> get_email(user) end)
    |> bind(fn email -> get_domain(email) end)
  end
end

# Przykład użycia
users = %{
  1 => %{name: "Jan", email: "jan@example.com"},
  2 => %{name: "Anna", email: "anna@test.pl"},
  3 => %{name: "Piotr"}
}

domain1 = MaybeExample.get_email_domain(users, 1)
domain2 = MaybeExample.get_email_domain(users, 3)  # Brak email
domain3 = MaybeExample.get_email_domain(users, 4)  # Brak użytkownika

IO.puts("Domain for user 1: #{inspect(domain1)}")
IO.puts("Domain for user 3: #{inspect(domain2)}")
IO.puts("Domain for user 4: #{inspect(domain3)}")

# Unwrap przykładów
IO.puts("Domain for user 1 (unwrapped): #{Maybe.unwrap(domain1, "No domain")}")
IO.puts("Domain for user 3 (unwrapped): #{Maybe.unwrap(domain2, "No domain")}")

# ------ Praktyczne zastosowania ------
IO.puts("\n--- Praktyczne zastosowania ---")

# Implementacja uproszczonej biblioteki Ok do obsługi błędów
defmodule Ok do
  # Operator bind (>>=) dla sekwencji operacji
  def success(value), do: {:ok, value}
  def failure(error), do: {:error, error}

  def bind_result({:ok, value}, func), do: func.(value)
  def bind_result({:error, _} = error, _func), do: error

  def map_result({:ok, value}, func), do: {:ok, func.(value)}
  def map_result({:error, _} = error, _func), do: error

  # Makro do składania operacji - podobne do konstrukcji with,
  # ale bardziej w stylu monad
  defmacro bind(expr, func) do
    quote do
      Ok.bind_result(unquote(expr), unquote(func))
    end
  end

  defmacro map(expr, func) do
    quote do
      Ok.map_result(unquote(expr), unquote(func))
    end
  end

  # Składanie wielu operacji
  defmacro do_ok(do: block) do
    # Konwertujemy AST bloku kodu do formy bind
    expand_ok_block(block)
  end

  defp expand_ok_block({:__block__, _, exprs}) do
    # Przekształca sekwencję wyrażeń w zagnieżdżone bind
    Enum.reduce(exprs, nil, fn
      expr, nil ->
        expr  # Pierwsze wyrażenie

      {:=, meta, [{name, _, ctx}, expr]}, acc when is_atom(name) and is_atom(ctx) ->
        # Przypisanie: x = expr
        quote do
          bind(unquote(acc), fn result ->
            unquote(Macro.var(name, ctx)) = result
            unquote(expr)
          end)
        end

      expr, acc ->
        # Pozostałe wyrażenia
        quote do
          bind(unquote(acc), fn _ -> unquote(expr) end)
        end
    end)
  end
  defp expand_ok_block(expr), do: expr
end

defmodule OkExample do
  import Ok

  def dzielenie(a, b) do
    if b == 0, do: failure("Dzielenie przez zero"), else: success(a / b)
  end

  def dodaj_liczby(a, b) do
    if is_number(a) and is_number(b) do
      success(a + b)
    else
      failure("Oba argumenty muszą być liczbami")
    end
  end

  # Przykład użycia z operatorem bind
  def operacje_arytmetyczne1(a, b, c) do
    bind(dzielenie(a, b), fn wynik_dzielenia ->
      bind(dodaj_liczby(wynik_dzielenia, c), fn wynik_dodawania ->
        success(wynik_dodawania)
      end)
    end)
  end

  # Przykład użycia z makrem do_ok
  def operacje_arytmetyczne2(a, b, c) do
    do_ok do
      wynik_dzielenia = dzielenie(a, b)
      wynik_dodawania = dodaj_liczby(wynik_dzielenia, c)
      success(wynik_dodawania)
    end
  end
end

# Przykład użycia
IO.puts("Operacja 1 (poprawna): #{inspect(OkExample.operacje_arytmetyczne1(10, 2, 3))}")
IO.puts("Operacja 1 (błąd): #{inspect(OkExample.operacje_arytmetyczne1(10, 0, 3))}")

IO.puts("Operacja 2 (poprawna): #{inspect(OkExample.operacje_arytmetyczne2(10, 2, 3))}")
IO.puts("Operacja 2 (błąd): #{inspect(OkExample.operacje_arytmetyczne2(10, 0, 3))}")

# ------ Porównanie z konstrukcją with ------
IO.puts("\n--- Porównanie z konstrukcją with ---")

defmodule WithVsMonad do
  import Ok

  # Funkcje pomocnicze
  def pobierz_uzytkownika(id) when id > 0, do: {:ok, %{id: id, name: "User #{id}"}}
  def pobierz_uzytkownika(_), do: {:error, "Nieprawidłowy identyfikator użytkownika"}

  def pobierz_zamowienia(user) do
    if user.id <= 100 do
      {:ok, [%{id: 1, produkt: "Książka"}, %{id: 2, produkt: "Długopis"}]}
    else
      {:error, "Brak zamówień"}
    end
  end

  def oblicz_koszt(zamowienia) do
    {:ok, length(zamowienia) * 10}
  end

  # Implementacja z konstrukcją with
  def pobierz_koszt_with(user_id) do
    with {:ok, user} <- pobierz_uzytkownika(user_id),
         {:ok, zamowienia} <- pobierz_zamowienia(user),
         {:ok, koszt} <- oblicz_koszt(zamowienia) do
      {:ok, %{user: user, koszt: koszt}}
    end
  end

  # Implementacja z monadą Ok
  def pobierz_koszt_monad(user_id) do
    do_ok do
      user = pobierz_uzytkownika(user_id)
      zamowienia = pobierz_zamowienia(user)
      koszt = oblicz_koszt(zamowienia)
      success(%{user: user, koszt: koszt})
    end
  end
end

IO.puts("With (poprawne): #{inspect(WithVsMonad.pobierz_koszt_with(42))}")
IO.puts("With (błąd): #{inspect(WithVsMonad.pobierz_koszt_with(-1))}")

IO.puts("Monada (poprawne): #{inspect(WithVsMonad.pobierz_koszt_monad(42))}")
IO.puts("Monada (błąd): #{inspect(WithVsMonad.pobierz_koszt_monad(-1))}")

# ------ Biblioteki monadyczne w ekosystemie Elixir ------
IO.puts("\n--- Biblioteki monadyczne w ekosystemie Elixir ---")

IO.puts("""
1. OK - Elegancka biblioteka do obsługi błędów
   https://github.com/CrowdHailer/OK

2. Monad - Podstawowa implementacja monad w Elixir
   https://github.com/rmies/monad

3. Witchcraft - Biblioteka inspirowana Haskell'em
   https://github.com/expede/witchcraft

4. Algae - Implementacja typów algebraicznych
   https://github.com/witchcrafters/algae
""")

# ------ Zalety i wady monad obsługi błędów ------
IO.puts("\n--- Zalety i wady monad obsługi błędów ---")

IO.puts("""
Zalety:
1. Lepsze komponowanie operacji - możliwość łańcuchowania operacji bez zagnieżdżania
2. Bardziej deklaratywny kod - skupienie się na przepływie danych
3. Eliminacja częstych przypadków brzegowych - `nil` checks, error handling
4. Jednolity interfejs dla obsługi błędów

Wady:
1. Wyższa abstrakcja - trudniejsza dla początkujących
2. Konieczność konsekwentnego stosowania w całym kodzie
3. W Elixir brak statycznego typowania - monady są bardziej naturalne w językach z silnym typowaniem
4. Overhead w kodzie - więcej funkcji pomocniczych, makr
""")

IO.puts("\nTo podsumowuje monady obsługi błędów w Elixir!")
