require "fileutils"
require "minitest/autorun"
require "tmpdir"
require "yaml"
require "jekyll"

class HomepageTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def setup
    @source = Dir.mktmpdir("bjola-homepage-")
    FileUtils.cp(File.join(ROOT, "index.html"), @source)
    %w[_includes _data notes projects].each do |directory|
      FileUtils.cp_r(File.join(ROOT, directory), @source)
    end
    FileUtils.mkdir_p(File.join(@source, "_posts"))
    @catalogue = YAML.safe_load(File.read(File.join(@source, "_data/projects.yml")))
  end

  def teardown
    FileUtils.remove_entry(@source)
  end

  def project(id)
    {
      "id" => id, "name" => id, "language" => "Go",
      "status" => "installable", "status_label" => "Installable",
      "short" => "Keep work running.", "description" => "A useful daily tool.",
      "repository" => "https://example.com/#{id}",
      "install" => "install #{id}",
      "workflow" => { "label" => "#{id} workflow", "steps" => ["Start", "Continue"] }
    }
  end

  def post(slug, date, metadata = {}, directory: "_posts")
    folder = File.join(@source, directory)
    FileUtils.mkdir_p(folder)
    frontmatter = { "title" => slug, "date" => date }.merge(metadata)
    path = File.join(folder, "#{date[0, 10]}-#{slug}.md")
    File.write(path, YAML.dump(frontmatter) + "---\n\nA build note.\n")
  end

  def render
    config = Jekyll.configuration(
      "source" => @source, "destination" => File.join(@source, "_site"),
      "config" => [], "quiet" => true, "future" => false,
      "plugins" => [], "permalink" => "/:year/:month/:day/:title.html"
    )
    Jekyll::Site.new(config).process
    @homepage = File.read(File.join(@source, "_site/index.html"))
    @notes = File.read(File.join(@source, "_site/notes/index.html"))
    @html = File.read(File.join(@source, "_site/projects/index.html"))
    @html.scan(/<article class="(?:lead-project|project-row)" id="([^"]+)">/).flatten
  end

  def lead
    @html[/<article class="lead-project".*?<\/article>/m]
  end

  def test_new_tool_post_promotes_itself_and_links_to_its_generated_permalink
    post("new-tool", "2024-03-04 18:00:00 +0000", { "project" => project("new-tool") })
    ids = render
    assert_equal ["new-tool"] + @catalogue.fetch("featured").map { |entry| entry.fetch("id") }, ids
    assert_includes lead, 'href="/2024/03/04/new-tool.html"'
    assert_includes lead, "new-tool workflow"
    numbers = @html.scan(/<div class="project-index"><span>(\d+)<\/span>/).flatten
    assert_equal (1..ids.length).map { |number| format("%02d", number) }, numbers
  end

  def test_latest_post_per_tool_wins_without_duplicating_catalogue_entries
    post("old-undrudge", "2024-03-04 09:00:00 +0000", { "project" => project("undrudge") })
    post("another-tool", "2024-03-04 10:00:00 +0000", { "project" => project("another-tool") })
    post("new-undrudge", "2024-03-04 11:00:00 +0000", { "project" => project("undrudge") })
    ids = render
    assert_equal ["undrudge", "another-tool"], ids.first(2)
    assert_equal ids.uniq, ids
    assert_includes lead, 'href="/2024/03/04/new-undrudge.html"'
    row = @html[/<article class="project-row" id="another-tool".*?<\/article>/m]
    assert_includes row, 'href="/2024/03/04/another-tool.html"'
  end

  def test_regular_notes_unpublished_posts_and_drafts_do_not_take_over
    post("public-tool", "2024-03-04 09:00:00 +0000", { "project" => project("public-tool") })
    post("ordinary-note", "2024-03-05 09:00:00 +0000")
    post("unpublished", "2024-03-06 09:00:00 +0000", { "published" => false, "project" => project("unpublished") })
    post("draft", "2024-03-07 09:00:00 +0000", { "project" => project("draft") }, directory: "_drafts")
    post("future", "2099-03-08 09:00:00 +0000", { "project" => project("future") })
    ids = render
    assert_equal "public-tool", ids.first
    %w[ordinary-note unpublished draft future].each { |id| refute_includes ids, id }
    %w[unpublished draft future].each { |id| refute_includes @homepage, "#{id}.html" }
  end

  def test_catalogue_remains_available_without_tool_posts
    post("ordinary-note", "2024-03-05 09:00:00 +0000")
    assert_equal @catalogue.fetch("featured").map { |entry| entry.fetch("id") }, render
    assert_includes lead, 'href="/2026/05/04/undrudge.html"'
  end

  def test_homepage_shows_all_notes_newest_first_and_preserves_notes_url
    post("older", "2024-03-04 09:00:00 +0000")
    post("newer", "2024-03-05 09:00:00 +0000", { "project" => project("newer") })
    render
    expected = ["/2024/03/05/newer.html", "/2024/03/04/older.html"]
    [@homepage, @notes].each do |page|
      assert_equal expected, page.scan(/<h3><a href="([^"]+)">/).flatten
      refute_includes page, 'class="workbench-hero"'
      refute_includes page, 'class="lead-project"'
    end
    assert_equal @homepage, @notes
  end
end
