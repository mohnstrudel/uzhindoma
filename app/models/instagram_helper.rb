class InstagramHelper < ApplicationRecord
	def by_tag(keyword, max_count = 12)
	    keyword = URI.escape(keyword)
	    url = "https://www.instagram.com/explore/tags/#{keyword}/?__a=1"
	    
	    doc = Nokogiri::HTML(open(url))
	    instagram_data = JSON.parse(doc)
	    node_size = instagram_data["tag"]["media"]["nodes"].size

	    logger.info "Node size for Instagram query - #{node_size}"

	    nodes = instagram_data["tag"]["media"]["nodes"]
		logger.info "Node type is - #{nodes.class}"
	    while node_size < max_count
	      # If we get less images on first try, then we need to paginate further
	      next_page = instagram_data["tag"]["media"]["page_info"]["end_cursor"]
	      params = "&max_id=#{next_page}"
	      new_nodes = JSON.parse( open( "#{url}#{params}" ).read )["tag"]["media"]["nodes"]
	      logger.info "We're now inside while loop. Current nodes size - #{node_size}, next iteration nodes size - #{new_nodes.size}"
	      node_size += new_nodes.size

	      # Possible candidate for refactoring due to each loop
	      # Consider flattening the two arrays
	      new_nodes.each do |new_node|
	      	nodes << new_node
	      end
	    end

	    logger.info "End result node size - #{nodes.size}"
	    return nodes
	end


end
