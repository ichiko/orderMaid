# helper.coffee
# require model.coffee

class MenuHelper
	init: (menu) ->
		@dishList = menu

	getDishName: (dish_id) ->
		name = ''
		if @dishList?
			list = @dishList.where({id: dish_id})
			if list.length > 0
				name = list[0].get('name')
		return name