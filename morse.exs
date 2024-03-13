defmodule Morse do
  def decode(signal, tree) do
    encode_map = encode_tree(tree)
    decode_map = Map.new(encode_map, fn {key, val} -> {val, key} end)
    Enum.map(String.split(List.to_string(signal), " "), fn x -> Map.get(decode_map, String.to_charlist(x)) end)
  end
'''
  def decode([], _, acc) do
    Enum.reverse(acc)
  end
  def decode([single_singal | rest], tree, acc) do
    case single_singal do
      32 -> decode(rest, tree, acc)
      _ ->
        {rest, char} = decode_single([single_singal | rest], tree, [])
        decode(rest, tree, [char | acc])
    end
  end

  def decode_single([], tree, acc) do
    {[], decode_code(tree, acc)}
  end
  def decode_single([single_signal | rest], tree, acc) do
    case single_signal do
      32 -> {rest, decode_code(tree, Enum.reverse(acc))}
      _ -> decode_single(rest, tree, [single_signal | acc])
    end
  end

  def decode_code({:node, char, _, _}, []) do
    char
  end
  def decode_code({:node, _, long, short}, [single_signal | rest]) do
    case single_signal do
      ?. -> decode_code(short, rest)
      ?- -> decode_code(long, rest)
    end
  end
'''
  def encode(seq, tree) do
    encode_map = encode_tree(tree)
    Enum.join(Enum.map(seq, fn x -> Map.get(encode_map, x) end), " ")
  end
  def encode_tree(tree) do
    encode_tree(tree, [], Map.new())
  end
  def encode_tree(:nil, _, map) do
    map
  end
  def encode_tree({:node, char, long, short}, path, map) do
    map = encode_tree(long, [?-| path], map)
    map = encode_tree(short, [?. | path], map)
    Map.put(map, char, Enum.reverse(path))
  end
end
