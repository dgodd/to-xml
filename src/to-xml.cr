class Object
  def to_xml
    String.build do |str|
      to_xml str
    end
  end
end

module ToXML
  class Error < Exception
  end
end

class Hash
  def to_xml(io)
    return if empty?

    each do |key, value|
      if value.is_a? Array
        value.each do |v|
          to_xml_node(io, key, v)
        end
      else
        to_xml_node(io, key, value)
      end
    end
  end

  private def to_xml_node(io : String::Builder, key : String, value : String | Nil | Bool | Int | Float | Hash | Array)
    attrs = value.select { |k,v| k[0]=='@'} if value.is_a? Hash
    value = value.select { |k,v| k[0]!='@'} if value.is_a? Hash
    io << "<"
    io << key
    attrs.each do |k,v|
      io << " #{k[1,k.size]}=\"#{v}\""
    end if attrs
    io << ">"
    if value.is_a?(Hash) && value.has_key?("$")
      value["$"].to_xml(io)
    else
      value.to_xml(io)
    end
    io << "</#{key}>"
  end
end

class Array
  def to_xml(io)
    io << "Can't do to_xml directly, needs a top level node"
  end
end

struct Nil
  def to_xml(io)
    io << ""
  end
end

class String
  def to_xml(io)
    io << self
  end
end

struct Bool
  def to_xml(io)
    to_s io
  end
end

struct Int
  def to_xml(io)
    to_s io
  end
end

struct Float
  def to_xml(io)
    case self
    when .nan?
      raise ToXML::Error.new("NaN not allowed in JSON")
    when .infinite?
      raise ToXML::Error.new("Infinity not allowed in JSON")
    else
      to_s io
    end
  end
end
