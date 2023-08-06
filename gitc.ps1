# use the whole command line args as the commit message, and commit
$commit_msg_parts = $args
$commit_msg = $commit_msg_parts -join " "
echo "commit message: $commit_msg"
git commit -m $commit_msg