class Enemy < ActiveRecord::Base
    belongs_to :item
    belongs_to :adventurer
    @@prompt = TTY::Prompt.new
    @@moves = ["Drop Kick", "Pocket Sand", "Right Hook", "Left Hook", "Crop Dust", "Belly Slap", "Razzle Dazzle", "Paper Cut", "Soda Can Crunch", "Lick", "Tickle", "Spay with WD40", "Wet Willy", "Belly Lint Ball Fling", "Toss Block Of Cheese", "Say A Corny Pun"]

    def display_enemy_hp
        puts "                                                                         #{self.name}"
        puts "                                                                         Health: #{self.hp}"
        puts ""
    end

    def move_prompt
      moves = @@moves.sample(4)
      @@prompt.select("Choose your attack:", [moves[0], moves[1], moves[2], moves[3]])
    end

    def attack(adventurer)
        dmg = adventurer.atk - self.blk
        if dmg > 0
          self.update(hp: self.hp - dmg)
          self.update(blk: 0)
          fourteen_space
          puts "You dealt #{dmg} damage!".center(112)
          fourteen_space
          sleep(2)
          system("clear")
          fourteen_space
          puts "#{self.name} has #{self.hp} HP left!".center(112)
          fourteen_space
          sleep(2)
          system("clear")

        elsif dmg <= 0
          self.update(blk: self.blk - adventurer.atk)
          fourteen_space
          puts "#{self.name}'s block was too strong! They have #{self.blk} block left!".center(112)
          fourteen_space
          sleep(2)
        end
    end

    def defend(adventurer)
      dmg = self.atk - adventurer.blk
      if dmg > 0
        adventurer.update(hp: adventurer.hp - dmg)
        adventurer.update(blk: 0)
        fourteen_space
        puts "You took #{dmg} damage!".center(112)
        fourteen_space
        sleep(2)
        fourteen_space
        puts "#{adventurer.name} has #{adventurer.hp} HP left!".center(112)
        fourteen_space
        sleep(2)
      elsif dmg <= 0
        adventurer.update(blk: adventurer.blk - self.atk)
        system("clear")
        fourteen_space
        puts "#{self.name} did not pierce your block!".center(112)
        fourteen_space
        sleep(2)
      end
    end

    def check_for_victor(adventurer, enemy_number)
        if self.hp <= 0
          adventurer.update(result: "win")
          if self.boss?
            system("clear")
            you_win
            sleep(3)
          end

          system("clear")
          battle_blink_animation_reverse
          system("clear")
          if self.boss?
            User.stop_music
            User.boss_victory_music
          else
            User.stop_music
            User.victory_music
            fourteen_space
            puts win_battle_quotes[rand(0..3)]
            fourteen_space
            sleep(2)
            system("clear")
            fourteen_space
            puts "You looted #{self.name}'s fanny pack for #{self.currency} sheckles!".center(112)
            fourteen_space
            adventurer.update(currency: adventurer.currency + self.currency)
            sleep(2)
            User.stop_music
            User.news_music
            adventurer.get_movie_and_news
            User.stop_music
            system("clear")
          end
          false
        elsif adventurer.hp <= 0
          system("clear")
          enemies[enemy_number]
          battle_blink_animation_reverse
          system("clear")
          six_space
          puts defeat_quotes[rand(0..3)]
          six_space
          sleep(2)
          User.stop_music
          User.game_over_music
          game_over
          sleep(2)
          Adventurer.game_over_main_menu
          false
        else
          true
        end
    end

    def enemy_text_appears
        system("clear")
        fourteen_space
        puts "You were ambushed by #{self.name}!!!!!!!".center(112)
        fourteen_space
    end

    def six_space
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
    end

    def fourteen_space
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
      puts ""
    end

    def game_start_quotes
      ["Corruption has soaked the soil, sapping all good life from these groves - let us burn out this evil.".center(112),
      "Our land is remote and unneighbored. Every lost resource must be recovered.".center(112),
      "They breed quickly down there in the dark, but perhaps we can slay them even faster.".center(112),
      "These Swine draw power from their horrid markings and crude idols - tear them down!".center(112)]
    end

    def win_battle_quotes
      ["These nightmarish creatures can be felled! They can be beaten!".center(112),
      "Seize this momentum! Push on to the task's end!".center(112),
      "Success so clearly in view... or is it merely a trick of the light?".center(112),
      "A trifling victory, but a victory nonetheless.".center(112),
      "Ghoulish horrors - brought low and driven into the mud!".center(112)]
    end

    def collecting_loot_quotes
      ["Impressive haul! If you value such things.".center(112),
      "Ornaments neatly ordered, lovingly admired.".center(112),
      "A full pack often attracts unwanted attention.".center(112)]
    end

    def defeat_quotes
      ["Another life wasted in the pursuit of glory and gold.".center(112),
       "This is no place for the weak, or the foolhardy.".center(112),
       "More blood soaks the soil, feeding the evil therein.".center(112),
       "Survival is a tenuous proposition in this sprawling tomb.".center(112)]
    end


end
