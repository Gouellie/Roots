extends Node

# warning-ignore:unused_signal
signal main_scene_loaded

# warning-ignore:unused_signal
signal tick

# warning-ignore:unused_signal
signal tilepanel_selected(sender, selected_blueprint)

# warning-ignore:unused_signal
signal tile_selected(tile)

# warning-ignore:unused_signal
signal tile_rotated(tile)

# warning-ignore:unused_signal
signal ui_click_disabled

# warning-ignore:unused_signal
signal blueprint_created(blueprint)

# warning-ignore:unused_signal
signal building_mode_toggle(is_active)

# warning-ignore:unused_signal
signal progress_updated(new_value)

# warning-ignore:unused_signal
signal eraser_mode_toggled

# warning-ignore:unused_signal
signal tile_placed(new_tile)

# warning-ignore:unused_signal
signal tile_removed_at(cellv)

# warning-ignore:unused_signal
signal tile_deleted(at_position) # todo remove and use other one above
# warning-ignore:unused_signal
signal tile_network_updated

# warning-ignore:unused_signal
signal game_over(resolve_behavior)

# warning-ignore:unused_signal
signal victory(resolve_behavior)

# warning-ignore:unused_signal
signal give_up

# warning-ignore:unused_signal
signal open_plant_shop

# warning-ignore:unused_signal
signal close_plant_shop

# warning-ignore:unused_signal
signal shop_upgrade_bought

# warning-ignore:unused_signal
signal shop_upgrade_level_changed

# warning-ignore:unused_signal
signal shop_buy_sun_upgrade(level)

# warning-ignore:unused_signal
signal shop_buy_water_upgrade(level)

# warning-ignore:unused_signal
signal shop_buy_soil_upgrade(level)

# warning-ignore:unused_signal
signal shop_draw_tiles

# warning-ignore:unused_signal
signal shop_heal_all_tiles

# warning-ignore:unused_signal
signal plant_shop_closed

# warning-ignore:unused_signal
signal init_player_resource_manager(_resource_manager)

# warning-ignore:unused_signal
signal init_entity_manager(_entity_manager)

# warning-ignore:unused_signal
signal init_turn_manager(_turn_manager)

# warning-ignore:unused_signal
signal init_ingredient_manager(_ingredient_manager)

# warning-ignore:unused_signal
signal init_fog_manager(_fog_manager)

# warning-ignore:unused_signal
signal init_season_manager(_season_manager)

# warning-ignore:unused_signal
signal spawn_plant(fertile_soil, position)

# warning-ignore:unused_signal
signal num_plants_changed(_num_plants)

# warning-ignore:unused_signal
signal info_request(info)

# warning-ignore:unused_signal
signal production_amount_changed(_dictionary)

# warning-ignore:unused_signal
signal consumption_amount_changed(_dictionary)

# warning-ignore:unused_signal
signal income_amount_changed()

# warning-ignore:unused_signal
signal ingredient_unfogged(_ingredient)

# warning-ignore:unused_signal
signal player_resource_amount_added(indentifier, amount)

# warning-ignore:unused_signal
signal player_resource_amount_deducted(indentifier, amount)

# warning-ignore:unused_signal
signal season_changed(season)

# warning-ignore:unused_signal
# use to only request the notification
signal display_season_notif(season) 

# warning-ignore:unused_signal
signal open_settings

# warning-ignore:unused_signal
signal close_settings

# warning-ignore:unused_signal
signal settings_closed
