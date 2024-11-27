hist() {
  omz_history | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' | awk '{$1=$1};1' | sort | uniq | fzf
}

daemon() {
  while true
  do
    # run the command
    $@
  sleep 1
  done
}