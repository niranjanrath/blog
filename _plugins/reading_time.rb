module Jekyll
  module ReadingTimeFilter
    def reading_time(content)
      words_per_minute = @context.registers[:site].config["words_per_minute"] || 200
      words = content.to_s.split.size
      minutes = (words / words_per_minute.to_f).ceil
      minutes = 1 if minutes < 1
      "#{minutes} min read"
    end
  end
end

Liquid::Template.register_filter(Jekyll::ReadingTimeFilter)
