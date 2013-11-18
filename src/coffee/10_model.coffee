# model.coffee
# require backbone.js

class Dish extends Backbone.Model
	defaults: {
		id: 0
		name: ''
		preparedTime: 0
	}

class DishList extends Backbone.Collection
	model: Dish

class CustomerOrder extends Backbone.Model
	defaults: {
		cellX: 0
		cellY: 0
		dishId: 0
		score: 0
		waitingMsg: '待ってました'
		hasNoDishMsg: 'なにも持ってないじゃん'
		deliveredMsg: 'もう来てるよ？'
		isDelivered: false
		charIconNo: 0
	}

class CustomerList extends Backbone.Collection
	model: CustomerOrder

class CookingOrder extends Backbone.Model
	defaults: {
		dishId: 0
		num: 0
	}

class CookingList extends Backbone.Collection
	model: CookingOrder

class StageInfo extends Backbone.Model
	defaults: {
		level: 0
		title: ''
		status: 0
		totalScore: 0
		menu: new DishList()
		customers: new CustomerList()
	}

StageInfo.STATE_LOADING = 'STATE_LOADING'
StageInfo.STATE_MAIN_READY = 'STATE_MAIN_READY'
StageInfo.STATE_MAIN_TAKE_ORDER = 'STATE_MAIN_TAKE_ORDER'
StageInfo.STATE_MAIN_PRE_ORDER_TO_CHEF = 'STATE_MAIN_PRE_ORDER_TO_CHEF'
StageInfo.STATE_MAIN_ORDER_TO_CHEF = 'STATE_MAIN_ORDER_TO_CHEF'		# sub scene
StageInfo.STATE_MAIN_COOKING = 'STATE_MAIN_COOKING'
StageInfo.STATE_MAIN_DISH_READY = 'STATE_MAIN_DISH_READY'
StageInfo.STATE_MAIN_DELIVER_DISH = 'STATE_MAIN_DELIVER_DISH'
StageInfo.STATE_MAIN_SERVE_DISH = 'STATE_MAIN_SERVE_DISH'
StageInfo.STATE_MAIN_SELECT_DISH = 'STATE_MAIN_SELECT_DISH'		# sub scene
StageInfo.STATE_MAIN_CHECK_DISH = 'STATE_MAIN_CHECK_DISH'
StageInfo.STATE_MAIN_ALL_DELIVERED = 'STATE_MAIN_ALL_DELIVERED'

StageInfo.STATE_TALKING = 32
StageInfo.STATE_ANIMATING = 64