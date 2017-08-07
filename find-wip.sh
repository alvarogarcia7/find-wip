git_status=$(mktemp)
temp=$(mktemp)

find "$1" -iname ".git" -type d >> $temp

while read -r line; do
    cd "$line/.."
    pwd >> $git_status
    git status|grep "Your branch is ahead" >> $git_status
    cd - >> $git_status
done < $temp

cat $git_status |grep "ahead" -B1
