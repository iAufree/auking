module ApplicationHelper

	  # Gemoji Helper
	  # def emojify(content)
	  #   h(content).to_str.gsub(/:([\w+-]+):/) do |match|
	  #     if emoji = Emoji.find_by_alias($1)
	  #       %(<img alt="#$1" src="#{asset_path("emoji/#{emoji.image_filename}")}" style="vertical-align:middle" width="20" height="20" />)
	  #     else
	  #       match
	  #     end
	  #   end.html_safe if content.present?
	  # end

	class CodeRayify < Redcarpet::Render::HTML
	  def block_code(code, language)
	    language ||= :plaintext
	    CodeRay.scan(code, language).div
	  end
	end
	
	def markdown_format(text)

	  coderayified = CodeRayify.new(filter_html: true, 
	                                hard_wrap: true)

	  options = {
	    fenced_code_blocks: true,
	    no_intra_emphasis: true,
	    autolink: true,
	    strikethrough: true,
	    lax_html_blocks: true,
	    superscript: true
	  }
	  markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
	  markdown_to_html.render(text).html_safe
	end

	def auto_links(text)
		  text.gsub /@(\w+)/ do |username|
	   	  name = username.gsub('@', '')
	   	  user = User.find_by_name(name)
	  	if user.present?
		  text = link_to(username, user_path(name))
	    else
	      text = username
	    end
      end.html_safe
	end

    def markdown(text)
      auto_links(markdown_format(text))
      # sanitize(auto_links(),
      #          tags: %w(p br img h1 h2 h3 h4 blockquote pre code strong em a ul ol li span),
      #          attributes: %w(href src class title alt target rel))
    end

end
