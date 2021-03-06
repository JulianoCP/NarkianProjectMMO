extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 4041
var max_players = 100

var gameserverlist = {}

func _ready():
	start_gameserver()

func _process(_delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func start_gameserver():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("GameServerHub started")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")

func _peer_connected(gameserver_id):
	print("Game Server " + str(gameserver_id) + " connected")
	gameserverlist["GameServer1"] = gameserver_id

func _peer_disconnected(gameserver_id):
	print("Game Server " + str(gameserver_id) + " disconnected")
	
func distribute_login_token(token, gameserver):
	var gameserver_peer_id = gameserverlist[gameserver]
	rpc_id(gameserver_peer_id,"receive_login_token", token)
	
