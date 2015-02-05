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
    shoe_array = []
    for index in 0..51
      shoe_array[index] = Card.new(deck_array[index][0], deck_array[index][1])
    end 
    self.deck = shoe_array * number_of_decks
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
  attr_accessor :hand, :status

  def initialize
    self.hand = []
    self.status = ""
  end 

  def reset
    self.hand = []
    self.status = ""
  end

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
    hand_value = calculate_max_hand_value
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

  def deal_card(shoe_array)
    self.hand.push(shoe_array.pop)
  end
end

class Dealer < Player 

  def dealer_busted? 
    if evaluate_hand > 21 
      self.status = "b"
      puts "Dealer busted!"
    end 
  end

  def complete_hand(shoe_array)
    begin
      self.hand.push(shoe_array.pop)
    end while evaluate_hand < 17
     puts "Dealer's hand value: #{evaluate_hand}"
  end

  def show_card
    puts "The dealer's first card: " + hand.first.card_name
  end
end

class Human < Player
  attr_accessor :bet, :choice, :worth, :name

  def get_player_info  
    puts "What is your name?"
    self.name = gets.chomp
    puts "Hello, #{self.name}"
    self.worth = 500
  end 

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

  def blackjack 
    puts "Blackjack!"
    self.status = "s"
  end

  def player_busts 
    puts "You busted"
    self.status = "b"
  end

  def player_stay
    puts "Stay"
  end

  def player_wins
    puts "Congratulations, you won $#{bet}"
    self.worth = worth + bet
  end

  def player_loses
    puts "Sorry, you lost $#{bet}"
    self.worth = worth - bet
  end

  def show_cards
    puts "Your first card is: " + hand.first.card_name
    puts "Your second card is: " + hand.last.card_name
  end

  def player_hit(shoe_array)
    puts "Hit me!"
    self.hand.push(shoe_array.pop)
    puts "Your new card is: " + hand.last.card_name
  end 
end

class GameEngine
  attr_accessor :player, :dealer, :shoe_array, :cut_location

  def initialize
    self.player = Human.new
    self.dealer = Dealer.new
    self.shoe_array = Decks.new(4)
    self.shoe_array = shoe_array.shuffle_deck
    self.cut_location = rand(52) + 52 * 2
  end 

  def reshuffle_if_necessary
    #reshuffle if cut location has been reached
    if shoe_array.length < cut_location
      self.shoe_array = Decks.new(4)
      self.shoe_array = shoe_array.shuffle_deck
      self.cut_location = rand(52) + 52 * 2
    end 
  end

  def deal_first_four_cards
    player.deal_card(shoe_array)
    dealer.deal_card(shoe_array)
    player.deal_card(shoe_array)
    dealer.deal_card(shoe_array)
  end

  def show_first_cards
    player.show_cards
    dealer.show_card
  end
############################################FIX THIS
  def complete_player_hand
    begin
      puts "Your hand is worth: #{player.evaluate_hand}"
      set_player_status
    end while !/[wbs]/.match(player.status)
  end

  def set_player_status 
    if player.evaluate_hand == 21
      player.blackjack
    elsif player.evaluate_hand > 21
      player.player_busts
    else
      handle_player_choice
    end 
  end

  def handle_player_choice
    player.status = player.hit_or_stay?
    if player.status == "h"
      player.player_hit(shoe_array)
    elsif player.status == "s"
      player.player_stay
    end
  end
##############################################
  def check_player_status
    if player.status == "w" || dealer.status == "b"
      player.player_wins
    elsif player.status == "b"
      player.dealer_wins
    elsif player.evaluate_hand > dealer.evaluate_hand
      player.player_wins
    elsif player.evaluate_hand < dealer.evaluate_hand
      player.player_loses
    else
      puts "You tied"
    end
  end

  def who_won?
    dealer.dealer_busted?
    check_player_status
  end

  def reset_game
    player.reset
    dealer.reset
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
    reshuffle_if_necessary
    player.show_bank_balance
    player.get_player_bet
    deal_first_four_cards
    show_first_cards
    complete_player_hand
    dealer.complete_hand(shoe_array)
    who_won?
    reset_game
  end

  def game_loop
    begin
      game_sequence
    end while self.play_again?.upcase == 'Y'  
  end

  def run
    player.get_player_info
    game_loop
  end 
end

new_game = GameEngine.new
new_game.run
