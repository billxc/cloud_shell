$branch = git branch | fzf
if ($null -eq $branch) { 
  echo "No branch selected."
  return 
}
git switch $branch.Trim()