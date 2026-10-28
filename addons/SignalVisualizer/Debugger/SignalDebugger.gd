extends Node






var _signal_graph: SignalGraph
var _lambda_map: Dictionary = {}






func _ready():
    if OS.is_debug_build():
        EngineDebugger.register_message_capture("signal_debugger", _on_signal_debugger_message_capture)






func _on_signal_debugger_message_capture(message: String, data: Array) -> bool:
    if message == "start":
        _signal_graph = generate_signal_graph()
        for signal_item in _signal_graph.signals:
            _connect_to_signal(signal_item)
        EngineDebugger.send_message(
            "signal_debugger:generated_graph", 
            [[_signal_graph.signals.map( func(item): return item.dictionary_representation), _signal_graph.edges.map( func(item): return item.dictionary_representation)]]
        )
    if message == "stop" and _signal_graph:
        for signal_item in _signal_graph.signals:
            _disconnect_from_signal(signal_item)

    if message == "invoke_signal" and data.size() == 2:
        var node_name = data[0]
        var signal_name = data[1]

        var root_node = get_tree().current_scene
        var node = root_node if root_node.name == node_name else root_node.find_child(node_name)
        if node:
            var connection_list = node.get_signal_connection_list(signal_name)
            for connection in connection_list:
                var callable = connection["callable"]
                var bound_args = callable.get_bound_arguments()
                var bound_args_count = callable.get_bound_arguments_count()
                var method = callable.get_method()
                callable.callv([node])

    return true

func _on_signal_execution(signal_name: String, node_name: String, args):
    EngineDebugger.send_message(
        "signal_debugger:signal_executed", 
        [Time.get_datetime_string_from_system(), node_name, signal_name]
    )






func generate_signal_graph() -> SignalGraph:
    var graph = SignalGraphUtility.create_signal_graph_from_node(get_tree().current_scene)
    return graph




















































func _connect_to_signal(signal_item: SignalDescription):
    var root_node = get_tree().current_scene
    var _execute: Callable = func(args = []): _on_signal_execution(signal_item.signal_name, signal_item.node_name, args)
    if root_node.name == signal_item.node_name:
        root_node.connect(signal_item.signal_name, _execute)
        _lambda_map[signal_item] = _execute
    else:
        var child = root_node.find_child(signal_item.node_name)
        if child:
            child.connect(signal_item.signal_name, _execute)
            _lambda_map[signal_item] = _execute

func _disconnect_from_signal(signal_item: SignalDescription):
    var root_node = get_tree().current_scene
    if root_node.name == signal_item.node_name:
        var callable = _lambda_map[signal_item]
        if callable:
            root_node.disconnect(signal_item.signal_name, callable)
            _lambda_map.erase(signal_item)
    else:
        var child = root_node.find_child(signal_item.node_name)
        if child:
            var callable = _lambda_map[signal_item]
            if callable:
                child.disconnect(signal_item.signal_name, callable)
                _lambda_map.erase(signal_item)
