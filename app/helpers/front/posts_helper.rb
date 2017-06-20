module Front::PostsHelper
  def article_description(text, length=200)
    # desc = sanitize(article.description.html_safe)
    # output = truncate(desc, length: 200, escape: false)
    output = h truncate(text, length: length, omission: ' ... ', escape: false)
    output.html_safe
  end
end
