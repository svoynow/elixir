defmodule Base do
  import Bitwise

  @moduledoc """
  This module provides data encoding and decoding functions
  according to [RFC 4648](https://tools.ietf.org/html/rfc4648).

  This document defines the commonly used base 16, base 32, and base
  64 encoding schemes.

  ## Base 16 alphabet

      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |
      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|
      |      0|         0|      4|         4|      8|         8|     12|         C|
      |      1|         1|      5|         5|      9|         9|     13|         D|
      |      2|         2|      6|         6|     10|         A|     14|         E|
      |      3|         3|      7|         7|     11|         B|     15|         F|

  ## Base 32 alphabet

      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |
      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|
      |      0|         A|      9|         J|     18|         S|     27|         3|
      |      1|         B|     10|         K|     19|         T|     28|         4|
      |      2|         C|     11|         L|     20|         U|     29|         5|
      |      3|         D|     12|         M|     21|         V|     30|         6|
      |      4|         E|     13|         N|     22|         W|     31|         7|
      |      5|         F|     14|         O|     23|         X|       |          |
      |      6|         G|     15|         P|     24|         Y|  (pad)|         =|
      |      7|         H|     16|         Q|     25|         Z|       |          |
      |      8|         I|     17|         R|     26|         2|       |          |


  ## Base 32 (extended hex) alphabet

      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |
      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|
      |      0|         0|      9|         9|     18|         I|     27|         R|
      |      1|         1|     10|         A|     19|         J|     28|         S|
      |      2|         2|     11|         B|     20|         K|     29|         T|
      |      3|         3|     12|         C|     21|         L|     30|         U|
      |      4|         4|     13|         D|     22|         M|     31|         V|
      |      5|         5|     14|         E|     23|         N|       |          |
      |      6|         6|     15|         F|     24|         O|  (pad)|         =|
      |      7|         7|     16|         G|     25|         P|       |          |
      |      8|         8|     17|         H|     26|         Q|       |          |

  ## Base 64 alphabet

      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |
      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|
      |      0|         A|     17|         R|     34|         i|     51|         z|
      |      1|         B|     18|         S|     35|         j|     52|         0|
      |      2|         C|     19|         T|     36|         k|     53|         1|
      |      3|         D|     20|         U|     37|         l|     54|         2|
      |      4|         E|     21|         V|     38|         m|     55|         3|
      |      5|         F|     22|         W|     39|         n|     56|         4|
      |      6|         G|     23|         X|     40|         o|     57|         5|
      |      7|         H|     24|         Y|     41|         p|     58|         6|
      |      8|         I|     25|         Z|     42|         q|     59|         7|
      |      9|         J|     26|         a|     43|         r|     60|         8|
      |     10|         K|     27|         b|     44|         s|     61|         9|
      |     11|         L|     28|         c|     45|         t|     62|         +|
      |     12|         M|     29|         d|     46|         u|     63|         /|
      |     13|         N|     30|         e|     47|         v|       |          |
      |     14|         O|     31|         f|     48|         w|  (pad)|         =|
      |     15|         P|     32|         g|     49|         x|       |          |
      |     16|         Q|     33|         h|     50|         y|       |          |

  ## Base 64 (URL and filename safe) alphabet

      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |
      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|
      |      0|         A|     17|         R|     34|         i|     51|         z|
      |      1|         B|     18|         S|     35|         j|     52|         0|
      |      2|         C|     19|         T|     36|         k|     53|         1|
      |      3|         D|     20|         U|     37|         l|     54|         2|
      |      4|         E|     21|         V|     38|         m|     55|         3|
      |      5|         F|     22|         W|     39|         n|     56|         4|
      |      6|         G|     23|         X|     40|         o|     57|         5|
      |      7|         H|     24|         Y|     41|         p|     58|         6|
      |      8|         I|     25|         Z|     42|         q|     59|         7|
      |      9|         J|     26|         a|     43|         r|     60|         8|
      |     10|         K|     27|         b|     44|         s|     61|         9|
      |     11|         L|     28|         c|     45|         t|     62|         -|
      |     12|         M|     29|         d|     46|         u|     63|         _|
      |     13|         N|     30|         e|     47|         v|       |          |
      |     14|         O|     31|         f|     48|         w|  (pad)|         =|
      |     15|         P|     32|         g|     49|         x|       |          |
      |     16|         Q|     33|         h|     50|         y|       |          |

  """

  b16_alphabet    = '0123456789ABCDEF'
  b64_alphabet    = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  b64url_alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'
  b32_alphabet    = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'
  b32hex_alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUV'

  defmacrop encode_pair(alphabet, case, value) do
    quote do
      case unquote(value) do
        unquote(encode_pair_clauses(alphabet, case))
      end
    end
  end

  defp encode_pair_clauses(alphabet, case) do
    index = index(alphabet, case)
    shift = shift(alphabet)

    for {encoding1, value1} <- index, {encoding2, value2} <- index do
      encoding = bsl(encoding1, 8) + encoding2
      value = bsl(value1, shift) + value2
      [clause] = quote do: (unquote(value) -> unquote(encoding))
      clause
    end
  end

  defmacrop decode_char(alphabet, case, encoding) do
    quote do
      case unquote(encoding) do
        unquote(decode_char_clauses(alphabet, case))
      end
    end
  end

  defp decode_char_clauses(alphabet, case) do
    index = index(alphabet, case)

    clauses =
      for {encoding, value} <- index do
        [clause] = quote do: (unquote(encoding) -> unquote(value))
        clause
      end

    bad_char_clause = quote do: (c -> raise ArgumentError, bad_digit(c))

    clauses ++ bad_char_clause
  end

  defp shift(alphabet) do
    alphabet
    |> length()
    |> :math.log2()
    |> round()
  end

  defp to_lower(char) when char in ?A..?Z, do: char - ?A + ?a
  defp to_lower(char), do: char

  defp index(alphabet, case) when case in [:sensitive, :upper] do
    Stream.with_index(alphabet)
  end

  defp index(alphabet, :lower) do
    alphabet
    |> index(:sensitive)
    |> Stream.map(fn {encoding, value} -> {to_lower(encoding), value} end)
  end

  defp index(alphabet, :mixed) do
    [index(alphabet, :upper), index(alphabet, :lower)]
    |> Stream.concat()
    |> Stream.uniq()
  end


  defp bad_digit(c) do
    "non-alphabet digit found: #{inspect <<c>>, binaries: :as_strings} (byte #{c})"
  end

  defp maybe_pad(subject, false, _, _),
    do: subject
  defp maybe_pad(subject, _, group_size, pad) do
    case rem(byte_size(subject), group_size) do
      0 -> subject
      x -> subject <> String.duplicate(pad, group_size - x)
    end
  end

  @doc """
  Encodes a binary string into a base 16 encoded string.

  ## Options

  The accepted options are:

    * `:case` - specifies the character case to use when encoding

  The values for `:case` can be:

    * `:upper` - uses upper case characters (default)
    * `:lower` - uses lower case characters

  ## Examples

      iex> Base.encode16("foobar")
      "666F6F626172"

      iex> Base.encode16("foobar", case: :lower)
      "666f6f626172"

  """
  @spec encode16(binary, keyword) :: binary
  def encode16(data, opts \\ []) when is_binary(data) do
    case = Keyword.get(opts, :case, :upper)
    do_encode16(case, data)
  end

  @doc """
  Decodes a base 16 encoded string into a binary string.

  ## Options

  The accepted options are:

    * `:case` - specifies the character case to accept when decoding

  The values for `:case` can be:

    * `:upper` - only allows upper case characters (default)
    * `:lower` - only allows lower case characters
    * `:mixed` - allows mixed case characters

  ## Examples

      iex> Base.decode16("666F6F626172")
      {:ok, "foobar"}

      iex> Base.decode16("666f6f626172", case: :lower)
      {:ok, "foobar"}

      iex> Base.decode16("666f6F626172", case: :mixed)
      {:ok, "foobar"}

  """
  @spec decode16(binary, keyword) :: {:ok, binary} | :error
  def decode16(string, opts \\ []) do
    {:ok, decode16!(string, opts)}
  rescue
    ArgumentError -> :error
  end

  @doc """
  Decodes a base 16 encoded string into a binary string.

  ## Options

  The accepted options are:

    * `:case` - specifies the character case to accept when decoding

  The values for `:case` can be:

    * `:upper` - only allows upper case characters (default)
    * `:lower` - only allows lower case characters
    * `:mixed` - allows mixed case characters

  An `ArgumentError` exception is raised if the padding is incorrect or
  a non-alphabet character is present in the string.

  ## Examples

      iex> Base.decode16!("666F6F626172")
      "foobar"

      iex> Base.decode16!("666f6f626172", case: :lower)
      "foobar"

      iex> Base.decode16!("666f6F626172", case: :mixed)
      "foobar"

  """
  @spec decode16!(binary, keyword) :: binary
  def decode16!(string, opts \\ [])

  def decode16!(string, opts) when is_binary(string) and rem(byte_size(string), 2) == 0 do
    case = Keyword.get(opts, :case, :upper)
    do_decode16(case, string)
  end

  def decode16!(string, _opts) when is_binary(string) do
    raise ArgumentError, "odd-length string"
  end

  @doc """
  Encodes a binary string into a base 64 encoded string.

  Accepts `padding: false` option which will omit padding from
  the output string.

  ## Examples

      iex> Base.encode64("foobar")
      "Zm9vYmFy"

      iex> Base.encode64("foob")
      "Zm9vYg=="

      iex> Base.encode64("foob", padding: false)
      "Zm9vYg"

  """
  @spec encode64(binary, keyword) :: binary
  def encode64(data, opts \\ []) when is_binary(data) do
    pad? = Keyword.get(opts, :padding, true)
    do_encode64(data, pad?)
  end

  @doc """
  Decodes a base 64 encoded string into a binary string.

  Accepts `ignore: :whitespace` option which will ignore all the
  whitespace characters in the input string.

  Accepts `padding: false` option which will ignore padding from
  the input string.

  ## Examples

      iex> Base.decode64("Zm9vYmFy")
      {:ok, "foobar"}

      iex> Base.decode64("Zm9vYmFy\\n", ignore: :whitespace)
      {:ok, "foobar"}

      iex> Base.decode64("Zm9vYg==")
      {:ok, "foob"}

      iex> Base.decode64("Zm9vYg", padding: false)
      {:ok, "foob"}

  """
  @spec decode64(binary, keyword) :: {:ok, binary} | :error
  def decode64(string, opts \\ []) when is_binary(string) do
    {:ok, decode64!(string, opts)}
  rescue
    ArgumentError -> :error
  end

  @doc """
  Decodes a base 64 encoded string into a binary string.

  Accepts `ignore: :whitespace` option which will ignore all the
  whitespace characters in the input string.

  Accepts `padding: false` option which will ignore padding from
  the input string.

  An `ArgumentError` exception is raised if the padding is incorrect or
  a non-alphabet character is present in the string.

  ## Examples

      iex> Base.decode64!("Zm9vYmFy")
      "foobar"

      iex> Base.decode64!("Zm9vYmFy\\n", ignore: :whitespace)
      "foobar"

      iex> Base.decode64!("Zm9vYg==")
      "foob"

      iex> Base.decode64!("Zm9vYg", padding: false)
      "foob"

  """
  @spec decode64!(binary, keyword) :: binary
  def decode64!(string, opts \\ []) when is_binary(string) do
    pad? = Keyword.get(opts, :padding, true)
    string |> remove_ignored(opts[:ignore]) |> do_decode64(pad?)
  end

  @doc """
  Encodes a binary string into a base 64 encoded string with URL and filename
  safe alphabet.

  Accepts `padding: false` option which will omit padding from
  the output string.

  ## Examples

      iex> Base.url_encode64(<<255, 127, 254, 252>>)
      "_3_-_A=="

      iex> Base.url_encode64(<<255, 127, 254, 252>>, padding: false)
      "_3_-_A"

  """
  @spec url_encode64(binary, keyword) :: binary
  def url_encode64(data, opts \\ []) when is_binary(data) do
    pad? = Keyword.get(opts, :padding, true)
    do_encode64url(data, pad?)
  end

  @doc """
  Decodes a base 64 encoded string with URL and filename safe alphabet
  into a binary string.

  Accepts `ignore: :whitespace` option which will ignore all the
  whitespace characters in the input string.

  Accepts `padding: false` option which will ignore padding from
  the input string.

  ## Examples

      iex> Base.url_decode64("_3_-_A==")
      {:ok, <<255, 127, 254, 252>>}

      iex> Base.url_decode64("_3_-_A==\\n", ignore: :whitespace)
      {:ok, <<255, 127, 254, 252>>}

      iex> Base.url_decode64("_3_-_A", padding: false)
      {:ok, <<255, 127, 254, 252>>}

  """
  @spec url_decode64(binary, keyword) :: {:ok, binary} | :error
  def url_decode64(string, opts \\ []) when is_binary(string) do
    {:ok, url_decode64!(string, opts)}
  rescue
    ArgumentError -> :error
  end

  @doc """
  Decodes a base 64 encoded string with URL and filename safe alphabet
  into a binary string.

  Accepts `ignore: :whitespace` option which will ignore all the
  whitespace characters in the input string.

  Accepts `padding: false` option which will ignore padding from
  the input string.

  An `ArgumentError` exception is raised if the padding is incorrect or
  a non-alphabet character is present in the string.

  ## Examples

      iex> Base.url_decode64!("_3_-_A==")
      <<255, 127, 254, 252>>

      iex> Base.url_decode64!("_3_-_A==\\n", ignore: :whitespace)
      <<255, 127, 254, 252>>

      iex> Base.url_decode64!("_3_-_A", padding: false)
      <<255, 127, 254, 252>>

  """
  @spec url_decode64!(binary, keyword) :: binary
  def url_decode64!(string, opts \\ []) when is_binary(string)  do
    pad? = Keyword.get(opts, :padding, true)
    string |> remove_ignored(opts[:ignore]) |> do_decode64url(pad?)
  end

  @doc """
  Encodes a binary string into a base 32 encoded string.

  ## Options

  The accepted options are:

    * `:case` - specifies the character case to use when encoding
    * `:padding` - specifies whether to apply padding

  The values for `:case` can be:

    * `:upper` - uses upper case characters (default)
    * `:lower` - uses lower case characters

  The values for `:padding` can be:

    * `true` - pad the output string to the nearest multiple of 8 (default)
    * `false` - omit padding from the output string

  ## Examples

      iex> Base.encode32("foobar")
      "MZXW6YTBOI======"

      iex> Base.encode32("foobar", case: :lower)
      "mzxw6ytboi======"

      iex> Base.encode32("foobar", padding: false)
      "MZXW6YTBOI"

  """
  @spec encode32(binary, keyword) :: binary
  def encode32(data, opts \\ []) when is_binary(data) do
    case = Keyword.get(opts, :case, :upper)
    pad? = Keyword.get(opts, :padding, true)
    do_encode32(case, data, pad?)
  end

  @doc """
  Decodes a base 32 encoded string into a binary string.

  ## Options

  The accepted options are:

    * `:case` - specifies the character case to accept when decoding
    * `:padding` - specifies whether to require padding

  The values for `:case` can be:

    * `:upper` - only allows  upper case characters (default)
    * `:lower` - only allows lower case characters
    * `:mixed` - allows mixed case characters

  The values for `:padding` can be:

    * `true` - requires the input string to be padded to the nearest multiple of 8 (default)
    * `false` - ignores padding from the input string

  ## Examples

      iex> Base.decode32("MZXW6YTBOI======")
      {:ok, "foobar"}

      iex> Base.decode32("mzxw6ytboi======", case: :lower)
      {:ok, "foobar"}

      iex> Base.decode32("mzXW6ytBOi======", case: :mixed)
      {:ok, "foobar"}

      iex> Base.decode32("MZXW6YTBOI", padding: false)
      {:ok, "foobar"}

  """
  @spec decode32(binary, keyword) :: {:ok, binary} | :error
  def decode32(string, opts \\ []) do
    {:ok, decode32!(string, opts)}
  rescue
    ArgumentError -> :error
  end

  @doc """
  Decodes a base 32 encoded string into a binary string.

  An `ArgumentError` exception is raised if the padding is incorrect or
  a non-alphabet character is present in the string.

  ## Options

  The accepted options are:

    * `:case` - specifies the character case to accept when decoding
    * `:padding` - specifies whether to require padding

  The values for `:case` can be:

    * `:upper` - only allows upper case characters (default)
    * `:lower` - only allows lower case characters
    * `:mixed` - allows mixed case characters

  The values for `:padding` can be:

    * `true` - requires the input string to be padded to the nearest multiple of 8 (default)
    * `false` - ignores padding from the input string

  ## Examples

      iex> Base.decode32!("MZXW6YTBOI======")
      "foobar"

      iex> Base.decode32!("mzxw6ytboi======", case: :lower)
      "foobar"

      iex> Base.decode32!("mzXW6ytBOi======", case: :mixed)
      "foobar"

      iex> Base.decode32!("MZXW6YTBOI", padding: false)
      "foobar"

  """
  @spec decode32!(binary, keyword) :: binary
  def decode32!(string, opts \\ []) when is_binary(string) do
    case = Keyword.get(opts, :case, :upper)
    pad? = Keyword.get(opts, :padding, true)
    do_decode32(case, string, pad?)
  end

  @doc """
  Encodes a binary string into a base 32 encoded string with an
  extended hexadecimal alphabet.

  ## Options

  The accepted options are:

    * `:case` - specifies the character case to use when encoding
    * `:padding` - specifies whether to apply padding

  The values for `:case` can be:

    * `:upper` - uses upper case characters (default)
    * `:lower` - uses lower case characters

  The values for `:padding` can be:

    * `true` - pad the output string to the nearest multiple of 8 (default)
    * `false` - omit padding from the output string

  ## Examples

      iex> Base.hex_encode32("foobar")
      "CPNMUOJ1E8======"

      iex> Base.hex_encode32("foobar", case: :lower)
      "cpnmuoj1e8======"

      iex> Base.hex_encode32("foobar", padding: false)
      "CPNMUOJ1E8"

  """
  @spec hex_encode32(binary, keyword) :: binary
  def hex_encode32(data, opts \\ []) when is_binary(data) do
    case = Keyword.get(opts, :case, :upper)
    pad? = Keyword.get(opts, :padding, true)
    do_hex_encode32(case, data, pad?)
  end

  @doc """
  Decodes a base 32 encoded string with extended hexadecimal alphabet
  into a binary string.

  ## Options

  The accepted options are:

    * `:case` - specifies the character case to accept when decoding
    * `:padding` - specifies whether to require padding

  The values for `:case` can be:

    * `:upper` - only allows upper case characters (default)
    * `:lower` - only allows lower case characters
    * `:mixed` - allows mixed case characters

  The values for `:padding` can be:

    * `true` - requires the input string to be padded to the nearest multiple of 8 (default)
    * `false` - ignores padding from the input string

  ## Examples

      iex> Base.hex_decode32("CPNMUOJ1E8======")
      {:ok, "foobar"}

      iex> Base.hex_decode32("cpnmuoj1e8======", case: :lower)
      {:ok, "foobar"}

      iex> Base.hex_decode32("cpnMuOJ1E8======", case: :mixed)
      {:ok, "foobar"}

      iex> Base.hex_decode32("CPNMUOJ1E8", padding: false)
      {:ok, "foobar"}

  """
  @spec hex_decode32(binary, keyword) :: {:ok, binary} | :error
  def hex_decode32(string, opts \\ []) do
    {:ok, hex_decode32!(string, opts)}
  rescue
    ArgumentError -> :error
  end

  @doc """
  Decodes a base 32 encoded string with extended hexadecimal alphabet
  into a binary string.

  An `ArgumentError` exception is raised if the padding is incorrect or
  a non-alphabet character is present in the string.

  ## Options

  The accepted options are:

    * `:case` - specifies the character case to accept when decoding
    * `:padding` - specifies whether to require padding

  The values for `:case` can be:

    * `:upper` - only allows upper case characters (default)
    * `:lower` - only allows lower case characters
    * `:mixed` - allows mixed case characters

  The values for `:padding` can be:

    * `true` - requires the input string to be padded to the nearest multiple of 8 (default)
    * `false` - ignores padding from the input string

  ## Examples

      iex> Base.hex_decode32!("CPNMUOJ1E8======")
      "foobar"

      iex> Base.hex_decode32!("cpnmuoj1e8======", case: :lower)
      "foobar"

      iex> Base.hex_decode32!("cpnMuOJ1E8======", case: :mixed)
      "foobar"

      iex> Base.hex_decode32!("CPNMUOJ1E8", padding: false)
      "foobar"

  """
  @spec hex_decode32!(binary, keyword) :: binary
  def hex_decode32!(string, opts \\ []) when is_binary(string) do
    case = Keyword.get(opts, :case, :upper)
    pad? = Keyword.get(opts, :padding, true)
    do_hex_decode32(case, string, pad?)
  end

  defp remove_ignored(string, nil), do: string
  defp remove_ignored(string, :whitespace) do
    for <<char::8 <- string>>, char not in '\s\t\r\n', into: <<>>, do: <<char::8>>
  end

  enc16 = [upper: :enc16_upper, lower: :enc16_lower]

  for {case, fun} <- enc16 do
    defp unquote(fun)(char) do
      encode_pair(unquote(b16_alphabet), unquote(case), char)
    end
  end

  defp do_encode16(_, <<>>), do: <<>>

  for {case, fun} <- enc16 do
    defp do_encode16(unquote(case), data) do
      split =  8 * div(byte_size(data), 8)
      <<main::size(split)-binary, rest::binary>> = data
      main =
        for <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8 <- main>>, into: <<>> do
          <<unquote(fun)(c1)::16, unquote(fun)(c2)::16,
            unquote(fun)(c3)::16, unquote(fun)(c4)::16,
            unquote(fun)(c5)::16, unquote(fun)(c6)::16,
            unquote(fun)(c7)::16, unquote(fun)(c8)::16>>
        end
      case rest do
        <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8>> ->
          <<main::binary, unquote(fun)(c1)::16, unquote(fun)(c2)::16,
            unquote(fun)(c3)::16, unquote(fun)(c4)::16,
            unquote(fun)(c5)::16, unquote(fun)(c6)::16,
            unquote(fun)(c7)::16>>
        <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8>> ->
          <<main::binary, unquote(fun)(c1)::16, unquote(fun)(c2)::16,
            unquote(fun)(c3)::16, unquote(fun)(c4)::16,
            unquote(fun)(c5)::16, unquote(fun)(c6)::16>>
        <<c1::8, c2::8, c3::8, c4::8, c5::8>> ->
          <<main::binary, unquote(fun)(c1)::16, unquote(fun)(c2)::16,
            unquote(fun)(c3)::16, unquote(fun)(c4)::16,
            unquote(fun)(c5)::16>>
        <<c1::8, c2::8, c3::8, c4::8>> ->
          <<main::binary, unquote(fun)(c1)::16, unquote(fun)(c2)::16,
            unquote(fun)(c3)::16, unquote(fun)(c4)::16>>
        <<c1::8, c2::8, c3::8>> ->
          <<unquote(fun)(c1)::16, unquote(fun)(c2)::16,
            unquote(fun)(c3)::16>>
        <<c1::8, c2::8>> ->
          <<unquote(fun)(c1)::16, unquote(fun)(c2)::16>>
        <<c1::8>> ->
           <<unquote(fun)(c1)::16>>
        <<>> ->
          main
      end
    end
  end

  dec16 = [upper: :dec16_upper, lower: :dec16_lower, mixed: :dec16_mixed]

  for {case, fun} <- dec16 do
    defp unquote(fun)(encoding) do
      decode_char(unquote(b16_alphabet), unquote(case), encoding)
    end
  end

  defp do_decode16(_, <<>>), do: <<>>

  for {case, fun} <- dec16 do
    defp do_decode16(unquote(case), string) when rem(byte_size(string), 2) == 0 do
      split =  8 * div(byte_size(string), 8)
      <<main::size(split)-binary, rest::binary>> = string
      main =
        for <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8 <- main>>, into: <<>> do
          <<unquote(fun)(c1)::4, unquote(fun)(c2)::4,
            unquote(fun)(c3)::4, unquote(fun)(c4)::4,
            unquote(fun)(c5)::4, unquote(fun)(c6)::4,
            unquote(fun)(c7)::4, unquote(fun)(c8)::4>>
        end
      case rest do
        <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8>> ->
          <<main::binary, unquote(fun)(c1)::4, unquote(fun)(c2)::4,
            unquote(fun)(c3)::4, unquote(fun)(c4)::4,
            unquote(fun)(c5)::4, unquote(fun)(c6)::4>>
        <<c1::8, c2::8, c3::8, c4::8>> ->
          <<main::binary, unquote(fun)(c1)::4, unquote(fun)(c2)::4,
            unquote(fun)(c3)::4, unquote(fun)(c4)::4>>
        <<c1::8, c2::8>> ->
          <<main::binary, unquote(fun)(c1)::4, unquote(fun)(c2)::4>>
        <<>> ->
          main
      end
    end
  end

  defp enc64_pair(value) do
    encode_pair(unquote(b64_alphabet), :sensitive, value)
  end

  defp enc64_char(value) do
      value
      |> enc64_pair()
      |> band(0x00FF)
  end

  defp do_encode64(<<>>, _), do: <<>>
  defp do_encode64(data, pad?) do
    split =  6 * div(byte_size(data), 6)
    <<main::size(split)-binary, rest::binary>> = data
    main = for <<c1::12, c2::12, c3::12, c4::12 <- main>>, into: <<>> do
      <<enc64_pair(c1)::16, enc64_pair(c2)::16,
        enc64_pair(c3)::16, enc64_pair(c4)::16>>
    end
    tail = case rest do
      <<c1::12, c2::12, c3::12, c::4>> ->
        <<enc64_pair(c1)::16, enc64_pair(c2)::16, enc64_pair(c3)::16,
          enc64_char(bsl(c, 2))::8>>
      <<c1::12, c2::12, c3::8>> ->
        <<enc64_pair(c1)::16, enc64_pair(c2)::16, enc64_pair(bsl(c3, 4))::16>>
      <<c1::12, c2::12>> ->
        <<enc64_pair(c1)::16, enc64_pair(c2)::16>>
      <<c1::12, c2::4>> ->
        <<enc64_pair(c1)::16, enc64_char(bsl(c2, 2))::8>>
      <<c1::8>> ->
        <<enc64_pair(bsl(c1, 4))::16>>
      <<>> ->
        <<>>
    end
    main <> maybe_pad(tail, pad?, 4, "=")
  end

  defp dec64(encoding) do
    decode_char(unquote(b64_alphabet), :sensitive, encoding)
  end

  defp do_decode64(<<>>, _), do: <<>>
  defp do_decode64(string, false) do
    maybe_pad(string, true, 4, "=") |> do_decode64(true)
  end
  defp do_decode64(string, _pad?) when rem(byte_size(string), 4) == 0 do
    split = 8 * div(byte_size(string) - 4, 8)
    <<main::size(split)-binary, rest::binary>> = string
    main =
      for <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8 <- main>>, into: <<>> do
        <<dec64(c1)::6, dec64(c2)::6, dec64(c3)::6, dec64(c4)::6,
          dec64(c5)::6, dec64(c6)::6, dec64(c7)::6, dec64(c8)::6>>
      end
    tail = case rest do
      <<c1::8, c2::8, ?=, ?=>> ->
        <<dec64(c1)::6, bsr(dec64(c2), 4)::2>>
      <<c1::8, c2::8, c3::8, ?=>> ->
        <<dec64(c1)::6, dec64(c2)::6, bsr(dec64(c3), 2)::4>>
      <<c1::8, c2::8, c3::8, c4::8>> ->
        <<dec64(c1)::6, dec64(c2)::6, dec64(c3)::6, dec64(c4)::6>>
      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, ?=, ?=>> ->
        <<dec64(c1)::6, dec64(c2)::6, dec64(c3)::6, dec64(c4)::6,
          dec64(c5)::6, bsr(dec64(c6), 4)::2>>
      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, ?=>> ->
        <<dec64(c1)::6, dec64(c2)::6, dec64(c3)::6, dec64(c4)::6,
          dec64(c5)::6, dec64(c6)::6, bsr(dec64(c7), 2)::4>>
      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8>> ->
         <<dec64(c1)::6, dec64(c2)::6, dec64(c3)::6, dec64(c4)::6,
           dec64(c5)::6, dec64(c6)::6, dec64(c7)::6, dec64(c8)::6>>
    end
    main <> tail
  end
  defp do_decode64(_, _) do
    raise ArgumentError, "incorrect padding"
  end

  defp enc64url_pair(value) do
    encode_pair(unquote(b64url_alphabet), :sensitive, value)
  end

  defp enc64url_char(value) do
      value
      |> enc64url_pair()
      |> band(0x00FF)
  end

  defp do_encode64url(<<>>, _), do: <<>>
  defp do_encode64url(data, pad?) do
    split =  6 * div(byte_size(data), 6)
    <<main::size(split)-binary, rest::binary>> = data
    main = for <<c1::12, c2::12, c3::12, c4::12 <- main>>, into: <<>> do
      <<enc64url_pair(c1)::16, enc64url_pair(c2)::16,
        enc64url_pair(c3)::16, enc64url_pair(c4)::16>>
    end
    tail = case rest do
      <<c1::12, c2::12, c3::12, c::4>> ->
        <<enc64url_pair(c1)::16, enc64url_pair(c2)::16,
          enc64url_pair(c3)::16, enc64url_char(bsl(c, 2))::8>>
      <<c1::12, c2::12, c3::8>> ->
        <<enc64url_pair(c1)::16, enc64url_pair(c2)::16,
          enc64url_pair(bsl(c3, 4))::16>>
      <<c1::12, c2::12>> ->
        <<enc64url_pair(c1)::16, enc64url_pair(c2)::16>>
      <<c1::12, c2::4>> ->
        <<enc64url_pair(c1)::16, enc64url_char(bsl(c2, 2))::8>>
      <<c1::8>> ->
        <<enc64url_pair(bsl(c1, 4))::16>>
      <<>> ->
        <<>>
    end
    main <> maybe_pad(tail, pad?, 4, "=")
  end

  defp dec64url(encoding) do
    decode_char(unquote(b64url_alphabet), :sensitive, encoding)
  end

  defp do_decode64url(<<>>, _), do: <<>>
  defp do_decode64url(string, false) do
    maybe_pad(string, true, 4, "=") |> do_decode64url(true)
  end
  defp do_decode64url(string, _pad?) when rem(byte_size(string), 4) == 0 do
    split = 8 * div(byte_size(string) - 4, 8)
    <<main::size(split)-binary, rest::binary>> = string
    main =
      for <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8 <- main>>, into: <<>> do
        <<dec64url(c1)::6, dec64url(c2)::6, dec64url(c3)::6, dec64url(c4)::6,
          dec64url(c5)::6, dec64url(c6)::6, dec64url(c7)::6, dec64url(c8)::6>>
      end
    tail = case rest do
      <<c1::8, c2::8, ?=, ?=>> ->
        <<dec64url(c1)::6, bsr(dec64url(c2), 4)::2>>
      <<c1::8, c2::8, c3::8, ?=>> ->
        <<dec64url(c1)::6, dec64url(c2)::6, bsr(dec64url(c3), 2)::4>>
      <<c1::8, c2::8, c3::8, c4::8>> ->
        <<dec64url(c1)::6, dec64url(c2)::6, dec64url(c3)::6, dec64url(c4)::6>>
      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, ?=, ?=>> ->
        <<dec64url(c1)::6, dec64url(c2)::6, dec64url(c3)::6, dec64url(c4)::6,
          dec64url(c5)::6, bsr(dec64url(c6), 4)::2>>
      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, ?=>> ->
        <<dec64url(c1)::6, dec64url(c2)::6, dec64url(c3)::6, dec64url(c4)::6,
          dec64url(c5)::6, dec64url(c6)::6, bsr(dec64url(c7), 2)::4>>
      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8>> ->
         <<dec64url(c1)::6, dec64url(c2)::6, dec64url(c3)::6, dec64url(c4)::6,
           dec64url(c5)::6, dec64url(c6)::6, dec64url(c7)::6, dec64url(c8)::6>>
    end
    main <> tail
  end
  defp do_decode64url(_, _) do
    raise ArgumentError, "incorrect padding"
  end


  enc32 = [upper: :enc32_upper, lower: :enc32_lower]

  for {case, prefix} <- enc32 do
    defp unquote(:"#{prefix}_pair")(value) do
      encode_pair(unquote(b32_alphabet), unquote(case), value)
    end

    defp unquote(:"#{prefix}_char")(value) do
      value
      |> unquote(:"#{prefix}_pair")()
      |> band(0x00FF)
    end
  end

  defp do_encode32(_, <<>>, _), do: <<>>

  for {case, prefix} <- enc32 do
    pair = :"#{prefix}_pair"
    char = :"#{prefix}_char"

    defp do_encode32(unquote(case), data, pad?) do
      split =  5 * div(byte_size(data), 5)
      <<main::size(split)-binary, rest::binary>> = data
      main =
        for <<c1::10, c2::10, c3::10, c4::10 <- main>>, into: <<>> do
          <<unquote(pair)(c1)::16, unquote(pair)(c2)::16,
            unquote(pair)(c3)::16, unquote(pair)(c4)::16>>
        end
      tail = case rest do
        <<c1::10, c2::10, c3::10, c4::2>> ->
          <<unquote(pair)(c1)::16, unquote(pair)(c2)::16,
            unquote(pair)(c3)::16, unquote(char)(bsl(c4, 3))::8>>
        <<c1::10, c2::10, c3::4>> ->
          <<unquote(pair)(c1)::16, unquote(pair)(c2)::16,
            unquote(char)(bsl(c3, 1))::8>>
        <<c1::10, c2::6>> ->
          <<unquote(pair)(c1)::16, unquote(pair)(bsl(c2, 4))::16>>
        <<c1::8>> ->
          <<unquote(pair)(bsl(c1, 2))::16>>
        <<>> ->
          <<>>
      end
      main <> maybe_pad(tail, pad?, 8, "=")
    end
  end

  dec32 = [upper: :dec32_upper, lower: :dec32_lower, mixed: :dec32_mixed]

  for {case, fun} <- dec32 do
    defp unquote(fun)(encoding) do
      decode_char(unquote(b32_alphabet), unquote(case), encoding)
    end
  end

  defp do_decode32(_, <<>>, _), do: <<>>
  defp do_decode32(case, string, false),
    do: do_decode32(case, maybe_pad(string, true, 8, "="), true)

  for {case, fun} <- dec32 do
    defp do_decode32(unquote(case), string, _pad?) when rem(byte_size(string), 8) == 0 do
      split = byte_size(string) - 8
      <<main::size(split)-binary, rest::binary>> = string
      main =
        for <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8 <- main>>, into: <<>> do
          <<unquote(fun)(c1)::5, unquote(fun)(c2)::5,
            unquote(fun)(c3)::5, unquote(fun)(c4)::5,
            unquote(fun)(c5)::5, unquote(fun)(c6)::5,
            unquote(fun)(c7)::5, unquote(fun)(c8)::5>>
        end
      case rest do
        <<c1::8, c2::8, ?=, ?=, ?=, ?=, ?=, ?=>> ->
          <<main::binary, unquote(fun)(c1)::5, bsr(unquote(fun)(c2), 2)::3>>
        <<c1::8, c2::8, c3::8, c4::8, ?=, ?=, ?=, ?=>> ->
          <<main::binary, unquote(fun)(c1)::5, unquote(fun)(c2)::5,
            unquote(fun)(c3)::5, bsr(unquote(fun)(c4), 4)::1>>
        <<c1::8, c2::8, c3::8, c4::8, c5::8, ?=, ?=, ?=>> ->
          <<main::binary, unquote(fun)(c1)::5, unquote(fun)(c2)::5,
            unquote(fun)(c3)::5, unquote(fun)(c4)::5,
            bsr(unquote(fun)(c5), 1)::4>>
        <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, ?=>> ->
          <<main::binary, unquote(fun)(c1)::5, unquote(fun)(c2)::5,
            unquote(fun)(c3)::5, unquote(fun)(c4)::5,
            unquote(fun)(c5)::5, unquote(fun)(c6)::5,
            bsr(unquote(fun)(c7), 3)::2>>
        <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8>> ->
          <<main::binary, unquote(fun)(c1)::5, unquote(fun)(c2)::5,
            unquote(fun)(c3)::5, unquote(fun)(c4)::5,
            unquote(fun)(c5)::5, unquote(fun)(c6)::5,
            unquote(fun)(c7)::5, unquote(fun)(c8)::5>>
        <<>> ->
          main
      end
    end
  end

  defp do_decode32(_, _, _),
    do: raise ArgumentError, "incorrect padding"

  defp do_hex_encode32(_, <<>>, _), do: <<>>

  enc32hex = [upper: :enc32hex_upper, lower: :enc32hex_lower]

  for {case, prefix} <- enc32hex do
    defp unquote(:"#{prefix}_pair")(value) do
      encode_pair(unquote(b32hex_alphabet), unquote(case), value)
    end

    defp unquote(:"#{prefix}_char")(value) do
      value
      |> unquote(:"#{prefix}_pair")()
      |> band(0x00FF)
    end
  end

  for {case, prefix} <- enc32hex do
    pair = :"#{prefix}_pair"
    char = :"#{prefix}_char"

    defp do_hex_encode32(unquote(case), data, pad?) do
      split =  5 * div(byte_size(data), 5)
      <<main::size(split)-binary, rest::binary>> = data
      main =
        for <<c1::10, c2::10, c3::10, c4::10 <- main>>, into: <<>> do
          <<unquote(pair)(c1)::16, unquote(pair)(c2)::16,
            unquote(pair)(c3)::16, unquote(pair)(c4)::16>>
        end
      tail = case rest do
        <<c1::10, c2::10, c3::10, c4::2>> ->
          <<unquote(pair)(c1)::16, unquote(pair)(c2)::16,
            unquote(pair)(c3)::16, unquote(char)(bsl(c4, 3))::8>>
        <<c1::10, c2::10, c3::4>> ->
          <<unquote(pair)(c1)::16, unquote(pair)(c2)::16,
            unquote(char)(bsl(c3, 1))::8>>
        <<c1::10, c2::6>> ->
          <<unquote(pair)(c1)::16, unquote(pair)(bsl(c2, 4))::16>>
        <<c1::8>> ->
          <<unquote(pair)(bsl(c1, 2))::16>>
        <<>> ->
          <<>>
      end
      main <> maybe_pad(tail, pad?, 8, "=")
    end
  end

  dec32hex = [upper: :dec32hex_upper, lower: :dec32hex_lower, mixed: :dec32hex_mixed]

  for {case, fun} <- dec32hex do
    defp unquote(fun)(encoding) do
      decode_char(unquote(b32hex_alphabet), unquote(case), encoding)
    end
  end

  defp do_hex_decode32(_, <<>>, _), do: <<>>
  defp do_hex_decode32(case, string, false),
    do: do_hex_decode32(case, maybe_pad(string, true, 8, "="), true)

  for {case, fun} <- dec32hex do
    defp do_hex_decode32(unquote(case), string, _pad?) when rem(byte_size(string), 8) == 0 do
      split = byte_size(string) - 8
      <<main::size(split)-binary, rest::binary>> = string
      main =
        for <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8 <- main>>, into: <<>> do
          <<unquote(fun)(c1)::5, unquote(fun)(c2)::5,
            unquote(fun)(c3)::5, unquote(fun)(c4)::5,
            unquote(fun)(c5)::5, unquote(fun)(c6)::5,
            unquote(fun)(c7)::5, unquote(fun)(c8)::5>>
        end
      case rest do
        <<c1::8, c2::8, ?=, ?=, ?=, ?=, ?=, ?=>> ->
          <<main::binary, unquote(fun)(c1)::5, bsr(unquote(fun)(c2), 2)::3>>
        <<c1::8, c2::8, c3::8, c4::8, ?=, ?=, ?=, ?=>> ->
          <<main::binary, unquote(fun)(c1)::5, unquote(fun)(c2)::5,
            unquote(fun)(c3)::5, bsr(unquote(fun)(c4), 4)::1>>
        <<c1::8, c2::8, c3::8, c4::8, c5::8, ?=, ?=, ?=>> ->
          <<main::binary, unquote(fun)(c1)::5, unquote(fun)(c2)::5,
            unquote(fun)(c3)::5, unquote(fun)(c4)::5,
            bsr(unquote(fun)(c5), 1)::4>>
        <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, ?=>> ->
          <<main::binary, unquote(fun)(c1)::5, unquote(fun)(c2)::5,
            unquote(fun)(c3)::5, unquote(fun)(c4)::5,
            unquote(fun)(c5)::5, unquote(fun)(c6)::5,
            bsr(unquote(fun)(c7), 3)::2>>
        <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8>> ->
          <<main::binary, unquote(fun)(c1)::5, unquote(fun)(c2)::5,
            unquote(fun)(c3)::5, unquote(fun)(c4)::5,
            unquote(fun)(c5)::5, unquote(fun)(c6)::5,
            unquote(fun)(c7)::5, unquote(fun)(c8)::5>>
        <<>> ->
          main
      end
    end
  end

  defp do_hex_decode32(_, _, _),
    do: raise ArgumentError, "incorrect padding"
end
