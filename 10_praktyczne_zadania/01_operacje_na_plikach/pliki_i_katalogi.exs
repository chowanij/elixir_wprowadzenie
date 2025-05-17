# Operacje na plikach i katalogach w Elixir

IO.puts("=== Operacje na plikach i katalogach w Elixir ===\n")

# Utworzenie folderu testowego
test_dir = "test_files"
test_file = Path.join(test_dir, "test.txt")
test_file2 = Path.join(test_dir, "test2.txt")
test_subdir = Path.join(test_dir, "subfolder")

# --------- Operacje na katalogach ---------
IO.puts("--- Operacje na katalogach ---")

# Sprawdzenie czy katalog istnieje i utworzenie go
if !File.exists?(test_dir) do
  IO.puts("Tworzenie katalogu #{test_dir}...")
  :ok = File.mkdir(test_dir)
  IO.puts("Katalog utworzony!")
else
  IO.puts("Katalog #{test_dir} już istnieje")
end

# Uzyskanie aktualnego folderu
current_dir = File.cwd!()
IO.puts("Aktualny katalog: #{current_dir}")

# Sprawdzenie zawartości katalogu
IO.puts("\nListowanie zawartości katalogu:")
case File.ls(test_dir) do
  {:ok, files} ->
    IO.puts("Znaleziono #{length(files)} plików w #{test_dir}:")
    Enum.each(files, fn file -> IO.puts("- #{file}") end)
  {:error, reason} -> IO.puts("Błąd podczas listowania katalogu: #{reason}")
end

# Utworzenie podkatalogu
if !File.exists?(test_subdir) do
  IO.puts("\nTworzenie podkatalogu #{test_subdir}...")
  :ok = File.mkdir_p(test_subdir)  # mkdir_p tworzy również katalogi nadrzędne jeśli nie istnieją
  IO.puts("Podkatalog utworzony!")
end

# --------- Operacje na plikach ---------
IO.puts("\n--- Operacje na plikach ---")

# Zapisywanie do pliku
IO.puts("Zapisywanie do pliku #{test_file}...")
content = "To jest przykładowa treść pliku.\nDruga linia tekstu.\nTrzecia linia z polskimi znakami: ąęśćżźłóń."
case File.write(test_file, content) do
  :ok -> IO.puts("Zapisano pomyślnie!")
  {:error, reason} -> IO.puts("Błąd podczas zapisu: #{reason}")
end

# Odczyt pliku
IO.puts("\nOdczyt pliku #{test_file}:")
case File.read(test_file) do
  {:ok, content} ->
    IO.puts("Zawartość pliku:")
    IO.puts("---")
    IO.puts(content)
    IO.puts("---")
  {:error, reason} -> IO.puts("Błąd podczas odczytu: #{reason}")
end

# Odczyt pliku linia po linii
IO.puts("\nOdczyt pliku linia po linii:")
case File.open(test_file, [:read]) do
  {:ok, file} ->
    IO.puts("Zawartość pliku:")
    IO.puts("---")
    file
    |> IO.stream(:line)
    |> Enum.each(fn line -> IO.write("Linia: #{line}") end)
    IO.puts("---")
    File.close(file)
  {:error, reason} -> IO.puts("Błąd podczas otwierania pliku: #{reason}")
end

# Dopisywanie do pliku
IO.puts("\nDopisywanie do pliku #{test_file}...")
case File.write(test_file, "\nTo jest dopisana linia.", [:append]) do
  :ok -> IO.puts("Dopisano pomyślnie!")
  {:error, reason} -> IO.puts("Błąd podczas dopisywania: #{reason}")
end

# Sprawdzenie informacji o pliku
IO.puts("\nInformacje o pliku #{test_file}:")
case File.stat(test_file) do
  {:ok, %File.Stat{size: size, type: type, access: access, mtime: mtime}} ->
    IO.puts("Rozmiar: #{size} bajtów")
    IO.puts("Typ: #{type}")
    IO.puts("Prawa dostępu: #{access}")
    IO.puts("Data modyfikacji: #{inspect(mtime)}")
  {:error, reason} -> IO.puts("Błąd podczas sprawdzania informacji: #{reason}")
end

# Kopiowanie pliku
IO.puts("\nKopiowanie pliku #{test_file} do #{test_file2}...")
case File.copy(test_file, test_file2) do
  {:ok, bytes_copied} -> IO.puts("Skopiowano #{bytes_copied} bajtów!")
  {:error, reason} -> IO.puts("Błąd podczas kopiowania: #{reason}")
end

# --------- Operacje na ścieżkach ---------
IO.puts("\n--- Operacje na ścieżkach (Path) ---")

# Łączenie ścieżek
path = Path.join([test_dir, "subfolder", "example.txt"])
IO.puts("Połączona ścieżka: #{path}")

# Informacje o ścieżce
IO.puts("Katalog: #{Path.dirname(path)}")
IO.puts("Nazwa pliku: #{Path.basename(path)}")
IO.puts("Rozszerzenie: #{Path.extname(path)}")

# Generowanie unikalnych nazw plików tymczasowych
temp_file = Path.join(test_dir, "temp_#{:os.system_time(:millisecond)}.txt")
IO.puts("Unikalny plik tymczasowy: #{temp_file}")

# --------- Praca z zaawansowanymi operacjami na plikach ---------
IO.puts("\n--- Zaawansowane operacje na plikach ---")

# Zapis i odczyt pliku binarnego
binary_file = Path.join(test_dir, "binary.bin")
binary_data = <<1, 2, 3, 4, 5, 255>>
IO.puts("Zapisywanie danych binarnych do #{binary_file}...")
File.write!(binary_file, binary_data)
read_binary = File.read!(binary_file)
IO.puts("Odczytano dane binarne: #{inspect(read_binary)}")

# Zapisywanie struktury danych (serializacja)
data = %{name: "Elixir", year: 2011, features: ["functional", "concurrent", "distributed"]}
IO.puts("\nZapisywanie struktury danych do pliku...")
encoded_data = :erlang.term_to_binary(data)
data_file = Path.join(test_dir, "data.bin")
File.write!(data_file, encoded_data)

# Odczytywanie struktury danych (deserializacja)
IO.puts("Odczytywanie struktury danych z pliku...")
decoded_data = data_file |> File.read!() |> :erlang.binary_to_term()
IO.puts("Odczytana struktura: #{inspect(decoded_data)}")

# --------- Porządkowanie ---------
IO.puts("\n--- Porządkowanie (usuwanie plików testowych) ---")

# Pozostawiam pliki testowe do inspekcji
IO.puts("Pliki testowe zostały utworzone w katalogu: #{Path.expand(test_dir)}")
IO.puts("Aby je usunąć, odkomentuj poniższy kod:")

# Odkomentuj poniższe linie, aby usunąć pliki testowe
# File.rm!(test_file)
# File.rm!(test_file2)
# File.rm!(binary_file)
# File.rm!(data_file)
# File.rmdir!(test_subdir)
# File.rmdir!(test_dir)
# IO.puts("Wszystkie pliki testowe zostały usunięte!")

IO.puts("\nTo podsumowuje podstawowe operacje na plikach i katalogach w Elixir!")
