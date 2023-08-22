if [ -z "$1" ]
then
  ls -G ~/.commands/ | fzf | read cmd_file
else
  ls -G ~/.commands/ | fzf -q $1 | read cmd_file
fi
echo $cmd_file > ~/.commands/.x_last_select
source ~/.commands/$cmd_file