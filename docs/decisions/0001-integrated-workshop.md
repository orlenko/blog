# 0001: Integrate the workshop and blog

## Decision

Reuse the public `orlenko/blog` Jekyll repository as the complete Bjola.org
site. The root becomes the open-source project ledger, `/notes/` indexes the
existing posts, and dated article permalinks remain at the root. Keep the
current GitHub Actions deployment and configure the custom domain specifically
on `orlenko/blog` in GitHub Pages settings.

Project metadata lives in one small YAML file. Status vocabulary describes
observable availability: installable, live tool, alpha, or source experiment.
The catalogue includes a visible review date because those labels can age.

## Alternatives considered

- A new Bjola.org repository plus copied posts: rejected because it creates two
  content sources and complicates the one-file publishing workflow.
- Cloudflare Pages: deferred because GitHub Pages already builds this Jekyll
  site and supplies the legacy project-site redirect.
- A framework rewrite: rejected because there is no interactive product need.
- A remote Jekyll theme: removed so required layouts and styles remain local.

## Design-review response

The pre-code review exposed four migration hazards. We will not add a `CNAME`
file to the custom Actions workflow, will not configure the domain on the user
Pages repository, will not combine launch with a nameserver or registrar move,
and will not treat the old `/blog` URL as a production preview after `baseurl`
becomes empty. The finished production build is verified locally, then the
repository domain setting and DNS are changed as one coordinated cutover.
GitHub's redirect is tested against all existing article URLs immediately; the
domain setting and DNS are rolled back together if it does not preserve paths.
