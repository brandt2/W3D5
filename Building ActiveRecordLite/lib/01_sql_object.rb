require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @list ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        "#{table_name}"
    SQL
    @list.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |column|
      define_method(column) {attributes[column]}
      define_method("#{column}=") { |value| attributes[column] = value}
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    "#{self.to_s.downcase}s"
  end

  # change an array of hashes into an array of objects
  def self.all
    table = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        "#{table_name}"
    SQL
    table.map do |object|
      self.new(object)
    end
  end

  # change an array of hashes into an array of objects
  def self.parse_all(results)
    results.map do |object|
      self.new(object)
    end
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      # need to call class on self in order to use the class method
      if self.class.columns.include?(attr_name)
        # an object is used to call the send method
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
