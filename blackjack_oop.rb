#Blackjack assignment 
#Tim Williams 2/1/2015
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
  attr_accessor :hand_value, :hand

  def evaluate_hand
    total_value = 0
    hand.each do |element| 
      if element.value == "J" || element.value == "Q" || element.value == "K" 
        total_value = total_value + 10
      elsif element.value == "A"
        total_value = total_value + 11
      else 
        total_value = total_value + element.value.to_i
      end
    end 
      #Reduce Aces if necessary
      if total_value > 21
        hand.each do |element| 
          if element.value == "A"
            total_value = total_value - 10
          end 
          if total_value <= 21
            break
          end 
        end 
      end 
    self.hand_value = total_value
  end 
end

class Human < Player
  attr_accessor :bet, :choice, :worth, :name
  #get bet
  def get_player_bet
    loop do  
      puts "How much do you want to bet?"
      player_bet = gets.chomp
      #loop until the player inputs an int or float of equal or 
      #greater value than the value of the player's bank 
      if /^\d+(\.\d+)?$/.match(player_bet)
        if player_bet.to_f <= worth
          self.bet = player_bet.to_f
          break
        end
      end
    end  
  end 

  #find out if player wants to hit or stay
  def hit_or_stay?
    begin
      puts "Hit or stay? (h/s)"
      user_input = gets.chomp.downcase
    #loop until the user inputs an h,H,s or S
    end while !/[hs]/.match(user_input)
    self.choice =  user_input
  end 
end

class GameEngine
  attr_accessor :player, :dealer, :shoe_array, :cut_location, :player_status
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

  def run

    puts "What is your name?"
    self.player.name = gets.chomp
    puts "Hello, #{player.name}"
    self.player.worth = 500

    begin
      #reshuffle if cut location has been reached
      if shoe_array.length < cut_location
        self.shoe_array = Decks.new(4)
        self.shoe_array = shoe_array.shuffle_deck
        self.cut_location = rand(52) + 52 * 2
      end 

      #Show bank balance
      puts "Your bank balance is $#{player.worth}"
      #get player bet
      player.get_player_bet

      #Deal first four cards
      self.player.hand.push(self.shoe_array.pop)
      puts "Your first card is: " + player.hand.last.card_name
      self.dealer.hand.push(self.shoe_array.pop)
      self.player.hand.push(self.shoe_array.pop)
      puts "Your second card is: " + player.hand.last.card_name
      self.dealer.hand.push(self.shoe_array.pop)
      #Reveal dealer's first card
      puts "The dealer's first card: " + dealer.hand.first.card_name

      #Player Loop
      begin
        #get user's choice
        puts "Your hand is worth: #{player.evaluate_hand}"
        if player.evaluate_hand == 21
          puts "You win"
          self.player_status = "w"
        elsif player.evaluate_hand > 21
          puts "You busted"
           self.player_status = "l"
        else
          self.player_status = player.hit_or_stay?
          if player_status == "h"
            puts "Hit me!"
            self.player.hand.push(self.shoe_array.pop)
            puts "Your new card is: " + player.hand.last.card_name
          elsif player_status == "s"
            puts "Stay"
          end
        end 
      end while !/[wls]/.match(player_status)

      #Dealer Loop
      begin
        self.dealer.hand.push(self.shoe_array.pop)
      end while dealer.evaluate_hand < 17

      puts "Dealer's hand value: #{dealer.evaluate_hand}"

      if dealer.evaluate_hand > 21 && player_status != "l"
        self.player_status = "w"
        puts "Dealer busted!"
      end 

      #Update bank account and show results
      if player_status == "w"
        #player wins
        puts "Congratulations, you won $#{player.bet}"
        self.player.worth = player.worth + player.bet
      elsif player_status == "l"
        #dealer wins
        puts "Sorry, you lost $#{player.bet}"
        self.player.worth = player.worth - player.bet
      elsif player.evaluate_hand > dealer.evaluate_hand
        #player wins
        puts "Congratulations, you won $#{player.bet}"
        self.player.worth = player.worth + player.bet
      elsif player.evaluate_hand < dealer.evaluate_hand
        #dealer wins
        puts "Sorry, you lost $#{player.bet}"
        self.player.worth = player.worth - player.bet
      else
        puts "You tied"
      end

      self.dealer.hand = []
      self.player.hand = []
      self.player_status = ""
      #Play again?
      puts "If you want to try again type 'Y'" 
      response = gets.chomp 

      if player.worth <= 0
        puts "You have no money. Game over"
        response = 'n'
      end 
    end while response.upcase == 'Y'  
  end 
end

new_game = GameEngine.new
new_game.run
