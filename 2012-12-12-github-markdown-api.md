# GitHub Markdown API

I find GitHub Flavored Markdown rendering very confusing. What library renders
content exactly the same as GitHub renders Readme.md? And what if I need to
render markdown in Python, etc.?

Better to use GitHub's managed service for rendering Markdown.

```bash
curl --data text="# GitHub Markdown API" -s -X POST https://gist.github.com/preview
<h1>GitHub Markdown API</h1>
```

Of course, cURL lets us send data from a file or URL:

```bash
curl --data text@2012-12-12-github-markdown-api.md -s -X POST https://gist.github.com/preview
<h1>GitHub Markdown API</h1>
...

curl https://raw.github.com/nzoschke/noah/master/2012-12-12-github-markdown-api.md | \
  curl --data-urlencode text@- -s -X POST https://gist.github.com/preview
<h1>GitHub Markdown API</h1>
...
```

-Noah