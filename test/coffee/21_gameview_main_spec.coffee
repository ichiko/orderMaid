# dom_view_screen.coffee
# target dom_view_screen.coffee

describe 'OrderMaidGameView', ->
	
	describe 'initialized', ->
		it 'tick is reset', ->
			game = new OrderMaidGameView()
			expect(game.prevTick).toEqual(0)

# 設定等が別ファイルにある場合に、windowにはやしておかないと、別ファイルから参照できない
# テスト対象のコードを1ファイルにまとめるほうがよいのか?
# 実際のコードと同じ状態にするほうが、衝突による問題も検知できそうだが。

	describe 'checkInputDelay', ->
		game = null
		beforeEach ->
			game = new OrderMaidGameView()

		it 'return false when not timeout', ->
			spyOn(game, 'getCurrentMilli').andReturn(10)
			expect(game.checkInputDelay()).toBe(false)

		it 'return true when time', ->
			spyOn(game, 'getCurrentMilli').andReturn(101)
			expect(game.checkInputDelay()).toBe(true)