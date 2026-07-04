# Automatically generates one page per unique "topics" value found across
# all posts' front matter, e.g. a post tagged `topics: [AI]` gets a page at
# /topics/ai/ listing every post with that topic. No manual page creation
# needed — add a new topic to a post's front matter and its page appears
# on the next build.

module Site
  class TopicPage < Jekyll::Page
    def initialize(site, base, dir, topic)
      @site = site
      @base = base
      @dir  = dir
      @name = "index.html"

      self.process(@name)
      self.data = {}
      self.data["layout"] = "topic"
      self.data["title"] = topic
      self.data["topic"] = topic
    end
  end

  class TopicPagesGenerator < Jekyll::Generator
    safe true

    def generate(site)
      topics = site.posts.docs.flat_map { |post| post.data["topics"] || [] }
                   .map(&:to_s).uniq

      topics.each do |topic|
        slug = Jekyll::Utils.slugify(topic)
        site.pages << TopicPage.new(site, site.source, File.join("topics", slug), topic)
      end

      # Expose the full topic list (with slugs and post counts) to every
      # template via site.data so the sidebar / mobile menu can render it.
      site.data["topics_index"] = topics.sort.map do |topic|
        {
          "name"  => topic,
          "slug"  => Jekyll::Utils.slugify(topic),
          "count" => site.posts.docs.count { |p| (p.data["topics"] || []).map(&:to_s).include?(topic) }
        }
      end
    end
  end
end
