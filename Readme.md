# Pages

Generate Markdown for GitHub Pages

## Getting Started

Fetch and use Pages to generate gh-pages HTML files from Markdown files:

```bash
$ git ls-files
2012-12-12-first.md
2012-12-13-second.md

$ git remote add pages https://github.com/nzoschke/pages.git
$ git fetch pages

$ git show pages/gh-pages:generate | sh
* Creating gh-pages branch from pages/master
* Generating HTML
* Committing HTML to gh-pages branch
    Switched to branch 'gh-pages'
    rm 'index.html'
    add '2012-12-12-first.html'
    add '2012-12-13-second.html'
    add 'index.html'
    [gh-pages 9aaa4e5] html
     3 files changed, 122 insertions(+), 67 deletions(-)
     create mode 100644 2012-12-12-first.html
     create mode 100644 2012-12-13-second.html
     rewrite index.html (60%)
    Switched to branch 'master'
* Pending publish with `git push origin gh-pages`
```

## Custom Themes

Pages treats gh-pages/index.html as a template for the entire site. You can
customize this file and it's referenced assets, and re-gen to change the site
layout.

You can also use the GitHub Pages "Automatic Page Generator" on your repo to 
select from the themes that GitHub provides.

## Todo

Improve index table of contents layout
Improve index.html -> ERB logic, it's completely broken on some themes.
Inject GitHub's Markdown stylesheet