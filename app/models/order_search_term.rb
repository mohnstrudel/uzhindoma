class OrderSearchTerm
  attr_reader :where_clause, :where_args, :order

  def initialize(search_term)
    search_term = search_term.downcase
    @where_clause = ""
    @where_args = {}

    build_for_search(search_term)
  end

  def build_for_search(search_term)
    @where_clause << case_insensitive_search(:first_name)
    @where_args[:first_name] = starts_with(search_term)

    @where_clause << " OR #{case_insensitive_search(:second_name)}"
    @where_args[:second_name] = starts_with(search_term)

    @where_clause << " OR #{case_insensitive_search(:phone)}"
    @where_args[:phone] = starts_with(search_term)

    @order = "created_at desc"
  end

  def case_insensitive_search(field_name)
    "lower(#{field_name}) like :#{field_name}"
  end

  def starts_with(search_term)
    "%" + search_term + "%"
  end
end