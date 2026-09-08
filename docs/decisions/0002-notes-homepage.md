# 0002: Make Notes the homepage

The homepage uses the existing Notes layout, with posts visible immediately
and newest first. `/notes/` retains the same view for existing links. Both
routes render one shared include so they cannot drift apart.

The project catalogue moves to `/projects/`, reachable from the primary
navigation. Its automatic promotion from published tool-post metadata remains
part of the normal Jekyll build. Drafts stay excluded from both pages.

This supersedes the root-page placement in decision 0001. The project-led
homepage hid the notes behind a large introduction and catalogue; the user
prefers to arrive directly at the posts. Existing article permalinks are kept.
