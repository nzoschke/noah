# GitHub Markdown API

*Updated on 12/14 to use the [documented markdown API](http://developer.github.com/v3/markdown/) instead of the Gist preview service.*

I find GitHub Flavored Markdown rendering very confusing. What library renders content exactly the same as GitHub renders Readme.md? And what if I need to render markdown in Python, etc.?

Better to use GitHub's managed service for rendering Markdown:

```bash
$ curl --data '{"text": "# GitHub Markdown API"}' https://api.github.com/markdown
<h1>
<a name="github-markdown-api" class="anchor" href="#github-markdown-api"><span class="mini-icon mini-icon-link"></span></a>GitHub Markdown API</h1>
```

There is also a "raw mode" (not JSON based) that is easier for shell integration:

```bash
$ curl --data "# GitHub Markdown API" -H "Content-Type:text/plain" -s https://api.github.com/markdown/raw
<h1>
<a name="github-markdown-api" class="anchor" href="#github-markdown-api"><span class="mini-icon mini-icon-link"></span></a>GitHub Markdown API</h1>
```

Of course, cURL lets us send data from a file or URL:

```bash
$ curl --data-binary @2012-12-12-github-markdown-api.md -H "Content-Type:text/plain" -s https://api.github.com/markdown/raw
<h1>
<a name="github-markdown-api" class="anchor" href="#github-markdown-api"><span class="mini-icon mini-icon-link"></span></a>GitHub Markdown API</h1>
...

$ curl -s https://raw.github.com/nzoschke/noah/master/2012-12-12-github-markdown-api.md | \
    curl --data-binary @- -H "Content-Type:text/plain" -s https://api.github.com/markdown/raw
<h1>
<a name="github-markdown-api" class="anchor" href="#github-markdown-api"><span class="mini-icon mini-icon-link"></span></a>GitHub Markdown API</h1>...
```

-Noah