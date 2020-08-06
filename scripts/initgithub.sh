
echo -e '\n' `uuid` `date -R ` '\n' >> README.md
git init
git add README.md
git commit -m "init commit"
git remote add origin $1
git push -u origin master

