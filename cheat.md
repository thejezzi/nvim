# Cheats

Cheats are just some vim tricks I've found over time that I'm sure many people
know but in case you dont here you go.

## Bang Bang

The bang bang motion in `NormalMode` is pretty awesome and is so useful you can
do almost everything with it.

This command originates from the `ex` line editor, the predecessor to `vi` (and
thus Vim). The `!` command in `ex` was used to run shell commands or filter text
through them. `!!` is a shorthand specifically for filtering the current line
using the _last_ external command executed via `!`.

Essentially, it's a shortcut for `:.!{last_command}`, where `{last_command}` is
the most recently used external filter command where `.` specifies the range and
`!` executes the command for the input from range which is a filter for the
currently selected line.

This is super useful when using command to pipe some text from neovim into some
binary and back into neovim or want to paste some output directly into neovim.

Let's say you want the current date in your buffer you would just type:
`!!date` and there you are:

```text
!!date
outputs: Do 10. Apr 23:37:24 CEST 2025
```

Or lets say you want to order some numbers you could use sort by visualy
selecting them and typing `!sort`.

Other use cases are

- `jq` for JSON pretty printing
- `bc` for calculating
- `sed` for text transformation
- `date` for date parsing
- `base64` for encoding stuff before sending off some requests
- `sha256sum`, `md5sum`
- `pandoc` for parsing markdown to html
- Templating by using a scripting language like Python or Javascript or the best
  of them all lua.
- `terraform fmt` for formatting terraform files
