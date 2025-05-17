# Wyrażenia regularne w Elixir

IO.puts("=== Wyrażenia regularne w Elixir ===\n")

# Wyrażenia regularne reprezentowane są przez typy Regex
IO.puts("--- Tworzenie wyrażeń regularnych ---")

# Tworzenie wyrażenia regularnego za pomocą sigila ~r
regex1 = ~r/elixir/i  # flaga 'i' oznacza case insensitive (nierozróżnianie wielkości liter)
IO.puts("Regex 1: #{inspect(regex1)}")

# Inne sposoby tworzenia wyrażeń regularnych
regex2 = ~r/^[0-9]{2}-[0-9]{3}$/  # kod pocztowy: 12-345
IO.puts("Regex 2: #{inspect(regex2)}")

regex3 = ~r/\d+\.\d{2}/  # liczba z dwiema cyframi po przecinku
IO.puts("Regex 3: #{inspect(regex3)}")

regex4 = Regex.compile!("^[A-Z][a-z]+$")  # słowo zaczynające się wielką literą
IO.puts("Regex 4: #{inspect(regex4)}")

# Sprawdzanie dopasowania (pattern matching)
IO.puts("\n--- Sprawdzanie dopasowania ---")

tekst1 = "Uczę się języka Elixir"
czy_zawiera = Regex.match?(regex1, tekst1)
IO.puts("Czy tekst zawiera 'elixir' (case insensitive): #{czy_zawiera}")

tekst2 = "Mój kod pocztowy to 12-345"
czy_poprawny = Regex.match?(regex2, "12-345")
IO.puts("Czy kod pocztowy jest poprawny: #{czy_poprawny}")

# Wyszukiwanie dopasowań
IO.puts("\n--- Wyszukiwanie dopasowań ---")

tekst3 = "Ceny: 12.99, 8.50 i 123.45 zł"

# Funkcja run zwraca wszystkie dopasowania
dopasowania = Regex.run(regex3, tekst3)
IO.puts("Pierwsze dopasowanie liczby z 2 miejscami po przecinku: #{inspect(dopasowania)}")

# Funkcja scan zwraca wszystkie dopasowania jako listę
wszystkie_dopasowania = Regex.scan(regex3, tekst3)
IO.puts("Wszystkie dopasowania liczb: #{inspect(wszystkie_dopasowania)}")

# Wyodrębnianie części dopasowania
IO.puts("\n--- Wyodrębnianie grup dopasowania ---")

email_regex = ~r/^(\w+)@(\w+)\.(\w+)$/
email = "kontakt@example.com"

# Nazwa użytkownika, domena i TLD jako osobne grupy
grupy = Regex.run(email_regex, email)
IO.puts("Pełne dopasowanie i grupy: #{inspect(grupy)}")

# Pomijanie pełnego dopasowania, zwracanie tylko grup
tylko_grupy = Regex.run(email_regex, email, capture: :all_but_first)
IO.puts("Tylko grupy: #{inspect(tylko_grupy)}")

# Dzielenie tekstu przy użyciu wyrażeń regularnych
IO.puts("\n--- Dzielenie tekstu ---")

tekst4 = "Jan,Maria;Tomasz:Anna,Piotr"
podzielony = Regex.split(~r/[,;:]/, tekst4)
IO.puts("Podzielony tekst: #{inspect(podzielony)}")

# Zastępowanie przy użyciu wyrażeń regularnych
IO.puts("\n--- Zastępowanie tekstu ---")

tekst5 = "Mój telefon to 123-456-789"
phone_regex = ~r/\d{3}-\d{3}-\d{3}/
zamieniony = Regex.replace(phone_regex, tekst5, "XXX-XXX-XXX")
IO.puts("Tekst po zamianie numeru: #{zamieniony}")

# Zaawansowane zastępowanie z funkcją
IO.puts("\n--- Zaawansowane zastępowanie ---")

tekst6 = "Daty: 2023-01-15, 2023-02-20, 2023-03-25"
date_regex = ~r/(\d{4})-(\d{2})-(\d{2})/

# Zamiana formatu daty z YYYY-MM-DD na DD.MM.YYYY
zmieniony_format = Regex.replace(date_regex, tekst6, fn _, rok, miesiac, dzien ->
  "#{dzien}.#{miesiac}.#{rok}"
end)

IO.puts("Daty po zmianie formatu: #{zmieniony_format}")

# Opcje wyrażeń regularnych
IO.puts("\n--- Opcje wyrażeń regularnych ---")
IO.puts("Dostępne opcje w Elixir:")
IO.puts("i - case insensitive (nierozróżnianie wielkości liter)")
IO.puts("m - multiline mode (^ i $ dopasowują początek i koniec linii)")
IO.puts("s - dot matches newlines (. dopasowuje również znaki nowej linii)")
IO.puts("U - ungreedy (operatory ? + * dopasowują minimalną liczbę znaków)")
IO.puts("u - Unicode (włączenie obsługi Unicode)")

# Przykład z Unicode
regex_unicode = ~r/^[ąęóśćźżłń]+$/u
IO.puts("\nCzy 'ąęść' pasuje do wzoru polskich znaków: #{Regex.match?(regex_unicode, "ąęść")}")

# Wskazówki dotyczące wydajności
IO.puts("\n--- Wskazówki dotyczące wydajności ---")
IO.puts("1. Kompiluj regex raz i używaj wielokrotnie")
IO.puts("2. Unikaj nadmiernego używania .*")
IO.puts("3. Używaj zamierzonego grupowania (?:...)")
IO.puts("4. Dla prostych operacji rozważ String.contains?/2, String.starts_with?/2 itp.")
