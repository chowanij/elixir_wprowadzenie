# Generator struktury katalogów z pliku JSON
# Ten skrypt tworzy drzewo katalogów i plików na podstawie struktury zdefiniowanej w pliku JSON

defmodule DrzewoKatalogow do
  @moduledoc """
  Moduł do generowania drzewa katalogów na podstawie pliku JSON.
  """

  @doc """
  Główna funkcja do generowania struktury katalogów.
  Przyjmuje ścieżkę do pliku JSON i opcjonalną ścieżkę bazową.
  """
  def generuj_z_pliku(json_path, base_path \\ "wygenerowany_projekt") do
    IO.puts("Generowanie struktury katalogów z pliku: #{json_path}")
    IO.puts("Katalog bazowy: #{base_path}")

    # Odczytaj zawartość pliku JSON
    case File.read(json_path) do
      {:ok, json_content} ->
        # Parsuj JSON
        case Jason.decode(json_content) do
          {:ok, struktura} ->
            # Tworzenie katalogu bazowego, jeśli nie istnieje
            if File.exists?(base_path) do
              IO.puts("\nUwaga: Katalog #{base_path} już istnieje. Czy chcesz kontynuować i nadpisać pliki? (t/n)")
              odpowiedz = IO.gets("") |> String.trim() |> String.downcase()

              case odpowiedz do
                "t" ->
                  IO.puts("Kontynuowanie - istniejące pliki mogą zostać nadpisane...")
                  # Generowanie struktury
                  generuj_strukture(struktura, base_path)
                  IO.puts("\nStruktura katalogów została wygenerowana w: #{Path.expand(base_path)}")
                _ ->
                  IO.puts("Anulowano operację.")
              end
            else
              # Tworzenie katalogu bazowego i generowanie struktury
              File.mkdir_p!(base_path)
              generuj_strukture(struktura, base_path)
              IO.puts("\nStruktura katalogów została wygenerowana w: #{Path.expand(base_path)}")
            end

          {:error, reason} ->
            IO.puts("Błąd podczas parsowania JSON: #{inspect(reason)}")
        end

      {:error, reason} ->
        IO.puts("Nie można odczytać pliku JSON: #{inspect(reason)}")
    end
  end

  @doc """
  Generuje strukturę katalogów i plików.
  """
  def generuj_strukture(wezel, sciezka) do
    pelna_sciezka = Path.join(sciezka, wezel["name"])

    case wezel["type"] do
      "directory" ->
        # Tworzenie katalogu
        IO.puts("Tworzenie katalogu: #{pelna_sciezka}")
        File.mkdir_p!(pelna_sciezka)

        # Rekurencyjne generowanie dla dzieci
        if Map.has_key?(wezel, "children") do
          Enum.each(wezel["children"], fn dziecko ->
            generuj_strukture(dziecko, pelna_sciezka)
          end)
        end

      "file" ->
        # Tworzenie pliku
        IO.puts("Tworzenie pliku: #{pelna_sciezka}")
        File.write!(pelna_sciezka, wezel["content"] || "")

      _ ->
        IO.puts("Nieznany typ węzła: #{wezel["type"]}")
    end
  end

  @doc """
  Wyświetla wygenerowaną strukturę katalogów.
  """
  def wyswietl_strukture(sciezka, wciecie \\ 0) do
    sciezka_abs = Path.expand(sciezka)
    nazwa = Path.basename(sciezka_abs)

    # Wyświetlanie bieżącego elementu
    IO.puts(String.duplicate("  ", wciecie) <> "|-- " <> nazwa)

    # Sprawdzenie czy to katalog
    if File.dir?(sciezka_abs) do
      # Listowanie zawartości katalogu
      case File.ls(sciezka_abs) do
        {:ok, elementy} ->
          # Sortujemy elementy: najpierw katalogi, potem pliki
          posortowane = Enum.sort_by(elementy, fn elem ->
            if File.dir?(Path.join(sciezka_abs, elem)), do: "0" <> elem, else: "1" <> elem
          end)

          # Rekurencyjne wyświetlanie dla każdego elementu
          Enum.each(posortowane, fn element ->
            wyswietl_strukture(Path.join(sciezka_abs, element), wciecie + 1)
          end)

        {:error, reason} ->
          IO.puts(String.duplicate("  ", wciecie + 1) <> "Błąd: #{reason}")
      end
    end
  end
end

# Sprawdzenie, czy Jason jest zainstalowany, jeśli nie - wyświetl instrukcje instalacji
try do
  Code.ensure_loaded?(Jason)
rescue
  _ ->
    IO.puts("""
    Błąd: Brak biblioteki Jason do parsowania JSON.

    Aby zainstalować, utwórz plik mix.exs z treścią:

    defmodule JsonParser.MixProject do
      use Mix.Project

      def project do
        [
          app: :json_parser,
          version: "0.1.0",
          elixir: "~> 1.12",
          deps: deps()
        ]
      end

      def application do
        [
          extra_applications: [:logger]
        ]
      end

      defp deps do
        [
          {:jason, "~> 1.2"}
        ]
      end
    end

    Następnie wykonaj:
    $ mix deps.get

    I uruchom ten skrypt ponownie z:
    $ elixir -r jason generator_struktury.exs
    """)
    System.halt(1)
end

# Sprawdzenie czy podano argumenty wiersza poleceń
sciezka_json = if length(System.argv()) > 0 do
  System.argv() |> List.first()
else
  # Domyślna ścieżka
  "struktura.json"
end

katalog_docelowy = if length(System.argv()) > 1 do
  System.argv() |> Enum.at(1)
else
  "wygenerowany_projekt"
end

# Sprawdzenie czy plik JSON istnieje
if !File.exists?(sciezka_json) do
  # Sprawdź czy istnieje w katalogu bieżącym
  sciezka_lokalna = Path.join(File.cwd!(), sciezka_json)
  if File.exists?(sciezka_lokalna) do
    sciezka_json = sciezka_lokalna
  else
    IO.puts("Błąd: Plik JSON nie istnieje: #{sciezka_json}")
    IO.puts("Upewnij się, że plik istnieje i podaj poprawną ścieżkę.")
    System.halt(1)
  end
end

# Generowanie struktury
DrzewoKatalogow.generuj_z_pliku(sciezka_json, katalog_docelowy)

# Wyświetl wygenerowaną strukturę
IO.puts("\nWygenerowana struktura katalogów:")
DrzewoKatalogow.wyswietl_strukture(katalog_docelowy)

IO.puts("\nAby użyć skryptu z własnymi parametrami:")
IO.puts("elixir -r jason generator_struktury.exs sciezka_do_json.json katalog_docelowy")
