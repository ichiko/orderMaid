# view.coffee
# require backbone.js
# require model.coffee
# require helper.coffee

# Viewはテンプレート処理がなければ、テストできる。
# テンプレート処理があると、テンプレートが見つからないときにstr.replaceがこける。

class GameScreenView extends Backbone.View
	# model: StageInfo
	el: '#playView'

	initialize: ->
		@prevTick = 0
		@game = new OrderMaidGameView(@, @model)
		@game.start()

	# 厳密にコントローラたろうとすると、キー入力制御もこっち。
	# だが、キー入力のうけつけが、inputでないとだめっぽいので、
	# enchant.jsで入力受付するほうが楽だ。



