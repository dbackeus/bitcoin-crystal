module Bitcoin
  abstract class Message
    macro payload(schema)
      {% begin %}
        {% for hash in schema %}
          getter {{hash[:name]}}
        {% end %}

        def initialize({% for hash in schema %}
          {% if hash[:default] %}
            @{{hash[:name].id}} : {{hash[:type]}} = {{hash[:default]}},
          {% else %}
            @{{hash[:name].id}} : {{hash[:type]}},
          {% end %}
        {% end %})
        end

        def self.from_payload(io : IO)
          {% for hash in schema %}
            {% if hash[:type].resolve == Bytes %}
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

        def to_payload : IO
          IO::Memory.new.tap do |io|
            {% for hash in schema %}
              {% if hash[:type].resolve == Bytes %}
                io.write({{hash[:name].id}})
              {% elsif hash[:type].resolve == String %}
                {% if hash[:size] == :var_int %}
                  Bitcoin::Protocol.write_var_int(io, {{hash[:name].id}}.size)
                {% end %}
                io.write(@user_agent.to_slice)
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
