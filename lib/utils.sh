#!/bin/zsh

format_table() {
  local input="$1"
  local max_col_widths=()
  local lines=("${(f)input}")

  # Find the maximum width for each column
  for line in "${lines[@]}"; do
    local cols=("${(s/|/)line}")
    for i in {1..4}; do
      local col_width="${#cols[$i]}"
      if (( col_width > max_col_widths[$i] )); then
        max_col_widths[$i]="$col_width"
      fi
    done
  done

  # Print the adjusted table
  for line in "${lines[@]}"; do
    local cols=("${(s/|/)line}")
    local formatted_line=""
    for i in {1..4}; do
      local col="${cols[$i]}"
      local padding_width="$((max_col_widths[$i] - ${#col}))"
      formatted_line+="${col}${(r:padding_width:: :)}"
      if (( i < 4 )); then
        formatted_line+=" | "
      fi
    done
    echo "$formatted_line"
  done
}
