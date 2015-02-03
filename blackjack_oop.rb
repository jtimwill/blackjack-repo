#Blackjack assignment 
#Tim Williams 2/2/2015
class Card 
  attr_accessor :suite, :value
  def initialize(s,v)
    self.suite = s
    self.value = v
  end
  def card_name
    value + " of " + suite
  end 
end

class Decks
  attr_accessor :deck
    SUITES = ["Hearts","Diamonds","Clubs","Spades"]
    VALUES = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"]

  def initialize(number_of_decks)
    deck_array = SUITES.product(VALUES)
    my_var = []
    for index in 0..51
      my_var[index] = Card.new(deck_array[index][0], deck_array[index][1])
    end 
    self.deck = my_var * number_of_decks
  end 

  def get_card(index)
    puts deck[index].suite
    puts deck[index].value
  end 

  def shuffle_deck
   self.deck = self.deck.shuffle
  end
end

class Player
  attr_accessor :hand

  def calculate_max_hand_value
    hand_value = 0
    hand.each do |element| 
      if element.value == "J" || element.value == "Q" || element.value == "K" 
        hand_value = hand_value + 10
      elsif element.value == "A"
        hand_value = hand_value + 11
      else 
        hand_value = hand_value + element.value.to_i
      end 
    end 
    hand_value
  end

  def evaluate_hand
    hand_value = self.calculate_max_hand_value
    if hand_value > 21
      hand.each do |element| 
        if element.value == "A"
        hand_value = hand_value - 10
        end 
        if hand_value <= 21
          break
        end 
      end 
    end 
    hand_value 
  end 
end

class Human < Player
  attr_accessor :bet, :choice, :worth, :name

  def get_player_bet
    loop do  
      puts "How much do you want to bet?"
      player_bet = gets.chomp
      if /^\d+(\.\d+)?$/.match(player_bet)
        if player_bet.to_f <= worth
          self.bet = player_bet.to_f
          break
        end
      end
    end  
  end 

  def show_bank_balance
    puts "Your bank balance is $#{worth}"
  end

  def hit_or_stay?
    begin
      puts "Hit or stay? (h/s)"
      user_input = gets.chomp.downcase
    end while !/[hs]/.match(user_input)
    self.choice =  user_input
  end 
end

class GameEngine
  attr_accessor :player, :dealer, :shoe_array, 
                :cut_location, :player_status

  def initialize
    self.player = Human.new
    self.player.hand = []
    self.dealer = Player.new
    self.dealer.hand = []
    self.shoe_array = Decks.new(4)
    self.shoe_array = shoe_array.shuffle_deck
    self.cut_location = rand(52) + 52 * 2
    self.player_status = ""
  end 

  def reshuffle_if_necessary
    #reshuffle if cut location has been reached
    if shoe_array.length < cut_location
      self.shoe_array = Decks.new(4)
      self.shoe_array = shoe_array.shuffle_deck
      self.cut_location = rand(52) + 52 * 2
    end 
  end

  def get_player_info
    puts "What is your name?"
    self.player.name = gets.chomp
    puts "Hello, #{player.name}"
    self.player.worth = 500
  end 

  def deal_first_four_cards
    self.player.hand.push(self.shoe_array.pop)
    self.dealer.hand.push(self.shoe_array.pop)
    self.player.hand.push(self.shoe_array.pop)
    self.dealer.hand.push(self.shoe_array.pop)
  end

  def show_first_cards
    puts "Your first card is: " + player.hand.first.card_name
    puts "Your second card is: " + player.hand.last.card_name
    puts "The dealer's first card: " + dealer.hand.first.card_name
  end

  def complete_player_hand
      begin
        puts "Your hand is worth: #{player.evaluate_hand}"
        self.set_player_status
      end while !/[wbs]/.match(player_status)
  end

  def set_player_status
    if player.evaluate_hand == 21
      self.blackjack
    elsif player.evaluate_hand > 21
      self.player_busts
    else
      self.handle_player_choice
    end 
  end

  def handle_player_choice
    self.player_status = player.hit_or_stay?
    if player_status == "h"
      self.player_hit
    elsif player_status == "s"
      self.player_stay
    end
  end

  def blackjack
    puts "Blackjack!"
    self.player_status = "s"
  end

  def player_busts
    puts "You busted"
    self.player_status = "b"
  end

  def player_stay
    puts "Stay"
  end

  def player_hit
    puts "Hit me!"
    self.player.hand.push(self.shoe_array.pop)
    puts "Your new card is: " + player.hand.last.card_name
  end 

  def complete_dealer_hand
    begin
      self.dealer.hand.push(self.shoe_array.pop)
    end while dealer.evaluate_hand < 17
     puts "Dealer's hand value: #{dealer.evaluate_hand}"
  end

  def dealer_busted?
    if dealer.evaluate_hand > 21 && player_status != "b"
      self.player_status = "w"
      puts "Dealer busted!"
    end 
  end

  def player_wins
    puts "Congratulations, you won $#{player.bet}"
    self.player.worth = player.worth + player.bet
  end

  def dealer_wins
    puts "Sorry, you lost $#{player.bet}"
    self.player.worth = player.worth - player.bet
  end

  def check_player_status
    if player_status == "w"
      self.player_wins
    elsif player_status == "b"
      self.dealer_wins
    elsif player.evaluate_hand > dealer.evaluate_hand
      self.player_wins
    elsif player.evaluate_hand < dealer.evaluate_hand
      self.dealer_wins
    else
      puts "You tied"
    end
  end

  def who_won?
    self.dealer_busted?
    check_player_status
  end

  def reset_game
    self.dealer.hand = []
    self.player.hand = []
    self.player_status = ""
  end

  def play_again?
    puts "If you want to try again type 'Y'" 
    response = gets.chomp 
    if player.worth <= 0
      puts "You have no money. Game over"
      response = 'n'
    end 
    response
  end

  def game_sequence
    self.reshuffle_if_necessary
    player.show_bank_balance
    player.get_player_bet
    self.deal_first_four_cards
    self.show_first_cards
    self.complete_player_hand
    self.complete_dealer_hand
    self.who_won?
    self.reset_game
  end

  def game_loop
    begin
      self.game_sequence
    end while self.play_again?.upcase == 'Y'  
  end

  def run
    self.get_player_info
    self.game_loop
  end 
end

new_game = GameEngine.new
new_game.run
