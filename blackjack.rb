#Blackjack assignment 
#Tim Williams 1/20/2015

#create four decks of cards 
card_1 = {type: "ace", suit: "diamonds", value: 11}
card_2 = {type: "two", suit: "diamonds", value: 2}
card_3 = {type: "three", suit: "diamonds", value: 3}
card_4 = {type: "four", suit: "diamonds", value: 4}
card_5 = {type: "five", suit: "diamonds", value: 5}
card_6 = {type: "six", suit: "diamonds", value: 6}
card_7 = {type: "seven", suit: "diamonds", value: 7}
card_8 = {type: "eight", suit: "diamonds", value: 8}
card_9 = {type: "nine", suit: "diamonds", value: 9}
card_10 = {type: "ten", suit: "diamonds", value: 10}
card_11 = {type: "jack", suit: "diamonds", value: 10}
card_12 = {type: "queen", suit: "diamonds", value: 10}
card_13 = {type: "king", suit: "diamonds", value: 10}

card_14 = {type: "ace", suit: "hearts", value: 11}
card_15 = {type: "two", suit: "hearts", value: 2}
card_16 = {type: "three", suit: "hearts", value: 3}
card_17 = {type: "four", suit: "hearts", value: 4}
card_18 = {type: "five", suit: "hearts", value: 5}
card_19 = {type: "six", suit: "hearts", value: 6}
card_20 = {type: "seven", suit: "hearts", value: 7}
card_21 = {type: "eight", suit: "hearts", value: 8}
card_22 = {type: "nine", suit: "hearts", value: 9}
card_23 = {type: "ten", suit: "hearts", value: 10}
card_24 = {type: "jack", suit: "hearts", value: 10}
card_25 = {type: "queen", suit: "hearts", value: 10}
card_26 = {type: "king", suit: "hearts", value: 10}

card_27 = {type: "ace", suit: "spades", value: 11}
card_28 = {type: "two", suit: "spades", value: 2}
card_29 = {type: "three", suit: "spades", value: 3}
card_30 = {type: "four", suit: "spades", value: 4}
card_31 = {type: "five", suit: "spades", value: 5}
card_32 = {type: "six", suit: "spades", value: 6}
card_33 = {type: "seven", suit: "spades", value: 7}
card_34 = {type: "eight", suit: "spades", value: 8}
card_35 = {type: "nine", suit: "spades", value: 9}
card_36 = {type: "ten", suit: "spades", value: 10}
card_37 = {type: "jack", suit: "spades", value: 10}
card_38 = {type: "queen", suit: "spades", value: 10}
card_39 = {type: "king", suit: "spades", value: 10}

card_40 = {type: "ace", suit: "clubs", value: 11}
card_41 = {type: "two", suit: "clubs", value: 2}
card_42 = {type: "three", suit: "clubs", value: 3}
card_43 = {type: "four", suit: "clubs", value: 4}
card_44 = {type: "five", suit: "clubs", value: 5}
card_45 = {type: "six", suit: "clubs", value: 6}
card_46 = {type: "seven", suit: "clubs", value: 7}
card_47 = {type: "eight", suit: "clubs", value: 8}
card_48 = {type: "nine", suit: "clubs", value: 9}
card_49 = {type: "ten", suit: "clubs", value: 10}
card_50 = {type: "jack", suit: "clubs", value: 10}
card_51 = {type: "queen", suit: "clubs", value: 10}
card_52 = {type: "king", suit: "clubs", value: 10}

deck_one = [card_1,card_2,card_3,card_4,card_5,card_6,card_7,card_8,card_9,
            card_10,card_11,card_12,card_13,card_14,card_15,card_16,card_17,
            card_18,card_19,card_20,card_21,card_22,card_23,card_24,card_25,
            card_26,card_27,card_28,card_29,card_30,card_31,card_32,card_33,
            card_34,card_35,card_36,card_37,card_38,card_39,card_40,card_41,
            card_42,card_43,card_44,card_45,card_46,card_47,card_48,card_49,
            card_50,card_51,card_52]

deck_two = deck_one
deck_three = deck_one
deck_three = deck_one
deck_four = deck_one

cut_location = rand(52) + 52 * 2
four_decks = deck_one + deck_two + deck_three + deck_four
shoe_array = four_decks.shuffle

#discard first 
discard_array = []
discard_array = shoe_array.pop
dealer_array = []
player_array = []
player_name = ""
cut_location = 0
player_bet = ""
player_bank = 100.00
players_choice = ""
player_hand_value = 0
dealer_hand_value = 0
player_status = ""
dealer_status = ""

#get hand value:
def evaluate_hand(hand_array)
  array_max = hand_array.length - 1
  total_value = 0

  for index in 0..array_max
      total_value = total_value + hand_array[index].values[2]
  end 

  return total_value
end #=>int

#get number of aces in a hand
def count_aces(hand_array)
  array_max = hand_array.length - 1
  number_of_aces = 0

  for index in 0..array_max
    if hand_array[index].values[2] == 11
      number_of_aces = number_of_aces + 1
    end 
  end 

  return number_of_aces
end #=>int

#get card type string 
def card_name_string(hand_array)
    card_name = hand_array.values[0] + " of " + hand_array.values[1]
end #String name 

#4.1 ask player for a bet //gets (make sure it's int or float)
def get_player_bet(player_bank)

  loop do  
    puts "How much do you want to bet?"
    player_bet = gets.chomp
    #loop until the player inputs an int or float of equal or 
    #greater value than the value of the player's bank 
    if /^\d+(\.\d+)?$/.match(player_bet)
      if player_bet.to_f <= player_bank
        return player_bet
        break
      end
    end
  end  
end #=> player_bet (int)

#find out if player wants to hit or stay
def hit_or_stay
  begin

    puts "Hit or stay? (h/s)"
    user_input = gets.chomp

  #loop until the user inputs an h,H,s or S
  end while !/[hHsS]/.match(user_input)
  return user_input
end #=> string 

#START GAME
#0. get player name //gets 
puts "What is your name?"
player_name = gets.chomp
puts "Hello, " + player_name

begin 
  #Show bank balance
  puts "Your bank balance is $ #{player_bank}"
  #get player bet
  player_bet = get_player_bet(player_bank)
  #if cut location is reached, reshuffle deck
  if discard_array.length-1 >= cut_location
    shoe_array = four_decks.shuffle
    #discard first card
    discard_array = shoe_array.pop
    #get new cut location
    cut_location = rand(52) + 52 * 2
  end 

  #Deal first four cards
  player_array.push(shoe_array.pop)
  puts "Your first card: " + card_name_string(player_array[0])
  dealer_array.push(shoe_array.pop)
  player_array.push(shoe_array.pop)
  puts "Your second card: " + card_name_string(player_array[1])
  dealer_array.push(shoe_array.pop)

  #reveal the dealer's first card 
  puts "The dealer's first card: " + card_name_string(dealer_array[0])

  #evaluate dealer and player cards 
  puts "Player hand value: #{evaluate_hand(player_array)}"

    #Player Loop
    begin 

      player_hand_value = evaluate_hand(player_array)

        if player_hand_value > 21 && count_aces(player_array) > 0
          for index in 0..player_array.length
            if player_array[index].values[2] == 11
              player_array[index].values[2] = 1
              break #leave for loop after changing an ace value to 1
            end 
          end
        elsif player_hand_value > 21 && count_aces(player_array) == 0
          player_status = "b" #player busts
        elsif player_hand_value == 21
          player_status = "w" #player wins
        elsif player_hand_value < 21 
          #get player decision
          players_choice = hit_or_stay

            if players_choice == "h"
              player_array.push(shoe_array.pop) #deal another card
               #display player hand value
              puts "Your new card: " + card_name_string(player_array.last)
              puts "Player hand value: #{evaluate_hand(player_array)}"

            elsif players_choice == "s"
              player_status = "s"
              #break #gets stuck 
            end 
        end

    end while !/[bws]/.match(player_status)
    #End Player Loop

    #Dealer Loop
    begin

      dealer_hand_value = evaluate_hand(dealer_array)
      
      if player_status == "b"
        break
      elsif player_status == "w"
        break
      elsif dealer_hand_value > 21 && count_aces(dealer_array) > 0
            for index in 0..dealer_array.length
              if dealer_array[index].values[2] == 11
                dealer_array[index].values[2] = 1
                break #leave for loop after changing an ace value to 1
              end 
            end
      elsif dealer_hand_value > 21 && count_aces(dealer_array) == 0
        player_status = "w"
      elsif dealer_hand_value == 17 && count_aces(dealer_array) > 0
            for index in 0..dealer_array.length
              if dealer_array[index].values[2] == 11
                dealer_array[index].values[2] = 1
                break #leave for loop after changing an ace value to 1
              end 
            end
      elsif dealer_hand_value < 17
        #hit 
        dealer_array.push(shoe_array.pop)
      elsif dealer_hand_value >= 17 #already implied that dealer hand is <22
        if dealer_hand_value > player_hand_value
          player_status = "l" #player loses
        elsif dealer_hand_value == player_hand_value
          player_status = "d" #player ties
        elsif dealer_hand_value < player_hand_value
          player_status = "w"
        end 
      end 

     end while !/[wlbd]/.match(player_status)
    #End dealer loop 

   #Show dealer cards
   puts "Dealer hand value: #{evaluate_hand(dealer_array)}"

   #Update bank account and show results
   if player_status == "w"
    player_bank = player_bank + player_bet.to_f
    puts "Congratulations, you won $" + player_bet
   elsif player_status == "l" || player_status == "b"
    player_bank = player_bank - player_bet.to_f
    puts "Sorry, you lost $" + player_bet
   elsif player_status == "d"
    puts "Tie"
   end 

  #move the cards from the table to the discard rack
  #discard_array = discard_array + player_array + dealer_array
  dealer_array = []
  player_array = []
  players_choice = ""

  #Play again? 
  puts "If you want to play again type 'Y'" 
  response = gets.chomp

  if player_bank <= 0
    puts "have no money. Game over"
    response = 'n'
  end 

end while response.downcase == 'y'
#End main loop
