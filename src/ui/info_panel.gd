extends Panel



func on_info_request_received(info_entity) -> void:
	info_entity.get_info()


#class_name Info
#var header
#var categories = []

#class_name Info_Category
#var category : PoolStringArray = []
