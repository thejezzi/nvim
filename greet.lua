-- hello_lines.lua
-- Reads all input from stdin, prints "Hello" for each line encountered.
-- Usage: some_command | lua hello_lines.lua
-- Or: lua hello_lines.lua < input_file.txt
print("Say hello to:")

-- io.lines() returns an iterator that reads one line at a time
for line in io.lines() do
  -- The loop body executes once for each line read from stdin
  print("- " .. line .. "")
end

print("HELLOOOOOOOO!")
