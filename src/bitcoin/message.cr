module Bitcoin
  abstract class Message
    def command
      self.class.name.split("::").last.downcase
    end

    def to_bytes : Bytes
      payload_bytes = payload.to_slice

      IO::Memory.new.tap do |io|
        io.write_bytes(Protocol::MAINNET_MAGIC)
        io.write(Bytes.new(command.to_unsafe, 12))
        io.write_bytes(payload_bytes.size.to_u32)
        io.write(Protocol.checksum(payload_bytes))
        io.write(payload_bytes)
      end.to_slice
    end

    def payload : IO
      IO::Memory.new
    end

    macro payload(schema)
      {% begin %}
        {% for hash in schema %}
          getter {{hash[:name]}}
        {% end %}

        def initialize(
          {% for hash in schema %}
            {% if hash[:default] %}
              @{{hash[:name].id}} : {{hash[:type]}} = {{hash[:default]}},
            {% else %}
              @{{hash[:name].id}} : {{hash[:type]}},
            {% end %}
          {% end %})
        end

        def self.from_payload(io : IO)
          {% for hash in schema %}
            {% if hash[:type].class_name == "Generic" && hash[:type].name.stringify == "Array" %}
              {{hash[:name].id}}_size = Bitcoin::Protocol.read_var_int(io)
              {{hash[:name].id}} = {{hash[:type]}}.new
              {{hash[:name].id}}_size.times do
                {{hash[:name].id}} << {{hash[:type].type_vars.first}}.from_payload(io)
              end
            {% elsif hash[:type].resolve == Bytes %}
              {{hash[:name].id}} = io.read_string({{hash[:size]}}).to_slice
            {% elsif hash[:type].resolve == String %}
              {% if hash[:size] == :var_int %}
                {{hash[:name].id}}_size = Bitcoin::Protocol.read_var_int(io)
                {{hash[:name].id}} = io.read_string({{hash[:name].id}}_size)
              {% else %}
                {{hash[:name].id}} = io.read_string({{hash[:size]}})
              {% end %}
            {% else %}
              {{hash[:name].id}} = io.read_bytes({{hash[:type]}})
            {% end %}
          {% end %}

          new(
          {% for hash in schema %}
            {{hash[:name].id}}: {{hash[:name].id}},
          {% end %}
          )
        end

        def payload : IO
          IO::Memory.new.tap do |io|
            {% for hash in schema %}
              {% if hash[:type].class_name == "Generic" && hash[:type].name.stringify == "Array" %}
                Bitcoin::Protocol.write_var_int(io, {{hash[:name].id}}.size)
                {{hash[:name].id}}.each do |structure|
                  io.write(structure.payload.to_slice)
                end
              {% elsif hash[:type].resolve == Bytes %}
                io.write({{hash[:name].id}})
              {% elsif hash[:type].resolve == String %}
                {% if hash[:size] == :var_int %}
                  Bitcoin::Protocol.write_var_int(io, {{hash[:name].id}}.size)
                {% end %}
                io.write({{hash[:name].id}}.to_slice)
              {% else %}
                io.write_bytes({{hash[:name].id}})
              {% end %}
            {% end %}
          end
        end
      {% end %}
    end
  end
end
