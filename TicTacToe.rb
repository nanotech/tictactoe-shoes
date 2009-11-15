SIZE = 100
PAD = 10
WINDOW_SIZE = ((SIZE + PAD) * 3) + (PAD)

Shoes.app :width => WINDOW_SIZE, :height => WINDOW_SIZE,
	:resizable => false, :title => 'Tic-Tac-Toe!' do
	def did_win(board)
		won = false
		3.times do |x|
			col = (0..2).map { |y| board[x][y] }
			won = true if col.all? { |b| b and b == col.first }
		end

		3.times do |y|
			row = (0..2).map { |x| board[x][y] }
			won = true if row.all? { |b| b and b == row.first }
		end

		nwse = (0..2).map { |i| board[i][i] }
		won = true if nwse.all? { |b| b and b == nwse.first }

		nesw = [board[2][0], board[1][1], board[0][2]]
		won = true if nesw.all? { |b| b and b == nesw.first }

		return won
	end

	def empty_grid
		Array.new(3) { Array.new(3, nil) }
	end

	PlayerColors = {
		1 => red,
		2 => blue
	}

	player = 1

	@filled = empty_grid
	@rects = []
	@animation = nil

	def reset
		@filled = empty_grid
		@rects.each { |k| k.style :fill => gray }
	end

	background black

	3.times do |x|
		3.times do |y|
			@rects << rect(:width => SIZE, :height => SIZE,
						  :top => (y * (SIZE + PAD)) + PAD,
						  :left => (x * (SIZE + PAD)) + PAD,
						  :fill => gray).click do |r|

				color = PlayerColors[player]

				unless @filled[x][y]
					@filled[x][y] = player

					r.style :fill => color

					if did_win(@filled)
						@rects.each { |k| k.style :fill => color }
						toggle = false

						@animation = every(0.5) do |i|
							c = (toggle) ? color : gray
							toggle = !toggle
							@rects.each do |k|
								k.style :fill => c
							end
							if i >= 5
								@animation.stop 
								reset
							end
						end
					elsif @filled.flatten.all? { |b| !b.nil? }
						@rects.each { |k| k.style :fill => red }

						@animation = every(0.5) do |i|
							c = (@rects.first.style[:fill].eql? red) ? blue : red
							@rects.each do |k|
								k.style :fill => c
							end
							if i >= 5
								@animation.stop 
								reset
							end
						end
					end

					# swap the player
					player = (-player) + 3
				end
			end
		end
	end
end
