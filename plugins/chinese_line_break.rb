#encoding: UTF-8

require './plugins/post_filters'

class String
  han = '\p{Han}|[，。？；：‘’“”、！……（）]'
  @@chinese_regex = /(#{han}) *\n *(#{han})/m
  def join_chinese!
    gsub!(@@chinese_regex, '\1\2')
  end
end

# Use Jekylly's plugin system to modify the content before invoking rdicount
module Jekyll
  class JoinChineseFilter < PostFilter
    def pre_render(post)
      post.content.join_chinese!
    end
  end
end
