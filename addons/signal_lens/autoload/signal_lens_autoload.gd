


extends Node


var target_node: Node = null



func _ready() -> void :
    EngineDebugger.register_message_capture("signal_lens", _on_node_signal_data_requested)






func _on_node_signal_data_requested(prefix, data) -> bool:
    var new_target_node = get_tree().root.get_node(data[0])



    if new_target_node == null:
        printerr("No node found in path " + str(data[0]))
        return false


    if new_target_node == get_tree().root:
        EngineDebugger.send_message("signal_lens:incoming_node_signal_data", ["Root"])
        return false


    if target_node != null:
        if target_node != new_target_node:
            for signal_name in target_node.get_signal_list().map( func(p_signal): return p_signal["name"]):
                if target_node.is_connected(signal_name, _on_target_node_signal_emitted):
                    target_node.disconnect(signal_name, _on_target_node_signal_emitted)


    target_node = new_target_node




    var target_node_name: String = target_node.name


    var target_node_signal_data: Array


    var target_node_signal_list: Array[Dictionary] = target_node.get_signal_list()



    for i in range(target_node_signal_list.size()):

        var raw_signal_data: Dictionary = target_node_signal_list[i]









        var parsed_signal_name: String = raw_signal_data["name"]


        var raw_signal_connections: Array[Dictionary] = target_node.get_signal_connection_list(raw_signal_data["name"])




        var parsed_signal_callables = parse_signal_callables_to_debugger_format(raw_signal_connections)


        var parsed_signal_data: Dictionary = {
                "signal": parsed_signal_name, 
                "callables": parsed_signal_callables
            }


        target_node_signal_data.append(parsed_signal_data)



        if not target_node.is_connected(parsed_signal_name, _on_target_node_signal_emitted):
            var signal_args: Array = raw_signal_data["args"]
            if signal_args.size() > 0:
                target_node.connect(parsed_signal_name, _on_target_node_signal_emitted.bind(target_node_name, parsed_signal_name).unbind(signal_args.size()))
            else:
                target_node.connect(parsed_signal_name, _on_target_node_signal_emitted.bind(target_node_name, parsed_signal_name))


    EngineDebugger.send_message("signal_lens:incoming_node_signal_data", [target_node_name, target_node_signal_data])
    return true


func parse_signal_callables_to_debugger_format(raw_signal_connections):
    var parsed_signal_callables: Array[Dictionary]

    for raw_signal_connection: Dictionary in raw_signal_connections:
        var parsed_callable_object: Object = raw_signal_connection["callable"].get_object()
        var parsed_callable_object_name: String







        if parsed_callable_object.get("name") != null:
            parsed_callable_object_name = parsed_callable_object.get("name")
        else:
            parsed_callable_object_name = parsed_callable_object.to_string()

        var parsed_callable_method_name = str(raw_signal_connection["callable"].get_method())


        if parsed_callable_method_name == "_on_target_node_signal_emitted": continue

        var parsed_callable_data = {
            "object_name": parsed_callable_object_name, 
            "method_name": parsed_callable_method_name
            }

        parsed_signal_callables.append(parsed_callable_data)
    return parsed_signal_callables




func _on_target_node_signal_emitted(node_name, signal_name):
    EngineDebugger.send_message("signal_lens:incoming_node_signal_emission", [node_name, signal_name])
