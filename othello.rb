class Othello
  attr_accessor :board
  attr_accessor :input_row
  attr_accessor :have_stone

  def initialize
    @board = Array.new(10).map{Array.new(10, 0)}
    @input_row = {"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8}
    @have_stone = [2, 2]
  end

=begin
  function : play
=end
  # win_player -> 1 or 2
  def play
    puts "GAME START!"
    setup
    start

    if have_stone[0] > have_stone[1]
      win_player = 1
    else
      win_player = 2
    end

    puts "Player#{win_player} WIN!"
  end

=begin
  function : setup
  スタートの前準備
=end
  def setup
    board[4][4] = 2
    board[4][5] = 1
    board[5][4] = 1
    board[5][5] = 2
    10.times do |i|
      10.times do |j|
        if i != 0 && j != 0
          next
        end
        board[i][j] = -1
      end
    end
  end

=begin
  function : start
=end
  def start
    # 盤面を描画
    board_create

    60.times do |turn|
      # 先攻(黒◯)
      if turn % 2 == 0
        puts "Player1 TURN."
      # 後攻(白×)
      elsif turn % 2 == 1
        puts "Player2 TURN."
      end
      puts "Enter a vacant point to place a stone."
      puts "(ex)3 d"
      
      input = gets.chomp

      update_board(input, turn % 2)
      board_create
      stone_count

      p have_stone
      if have_stone.min == 0
        break
      end
    end
  end

=begin
  function : update_board
  入力を受け付けて盤面を更新
=end
  def update_board(input, turn)
    tmp_col, tmp_row = input.split(" ")
    row = input_row[tmp_row]
    col = tmp_col.to_i

    board[col][row] = turn + 1

    # 上下左右斜めをチェック
    8.times do |num|
      if num == 2 || num == 6
        i = 0
      elsif num == 0 || num == 1 || num == 7
        i = -1
      elsif num == 3 || num == 4 || num == 5
        i = 1
      end

      if num == 0 || num == 4
        j = 0
      elsif num == 5 || num == 6 || num == 7
        j = -1
      elsif num == 1 || num == 2 || num == 3
        j = 1
      end

      update_board_sub(col, row, i, j)
    end
  end

  def update_board_sub(col, row, i, j)
    if board[col][row] == 1
      my = 1
      op = 2
    elsif board[col][row] == 2
      my = 2
      op = 1
    end

    tmp_i = i
    tmp_j = j
    while board[col + i][row + j] != -1
      if board[col + i][row + j] == 0
        break
      end

      if board[col + i][row + j] == op
        i += tmp_i
        j += tmp_j
        next
      elsif board[col + i][row + j] == my
        while i != 0 || j != 0
          board[col + i][row + j] = my
          i -= tmp_i
          j -= tmp_j
        end
        break
      end
    end
  end

=begin
  function : board_create
  盤面を描画
=end
  def board_create
    print "\n"
    puts " |a|b|c|d|e|f|g|h|"
    10.times do |i|
      if i == 0 || i == 9
        next
      end

      puts "------------------"
      print "#{i}|"
      10.times do |j|
        if j == 0 || j == 9
          next
        end
        if board[i][j] == 1
          print "◯"
        elsif board[i][j] == 2
          print "×"
        elsif board[i][j] == 0
          print " "
        end
        print "|"
      end
      print "\n"
    end
    puts "------------------"
    print "\n"
  end

=begin
  functin : stone_count
  黒と白の数を調べる
=end
  def stone_count
    p1_cnt = 0
    p2_cnt = 0

    10.times do |i|
      if i == 0 || i == 9
        next
      end

      10.times do |j|
        if j == 0 || j == 9
          next
        end

        if board[i][j] == 1
          p1_cnt += 1
        elsif board[i][j] == 2
          p2_cnt += 1
        end
      end
    end

    have_stone[0] = p1_cnt
    have_stone[1] = p2_cnt
  end

end

Othello.new.play