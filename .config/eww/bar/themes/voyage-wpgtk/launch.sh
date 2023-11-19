top_padding="49"
eww_windows="bar"

# start widgets
${EWW} open-many --toggle $eww_windows &&
  bspc config top_padding "${top_padding}"
