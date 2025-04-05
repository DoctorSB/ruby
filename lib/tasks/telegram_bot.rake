# lib/tasks/telegram_bot.rake
require 'telegram/bot'

namespace :telegram do
    desc "Run Telegram Bot"
    task run: :environment do
      Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
        bot.listen do |message|
          if message.is_a?(Telegram::Bot::Types::CallbackQuery)
            if message.data =~ /delete_(\d+)/
              product_id = $1.to_i
              product = Product.find_by(id: product_id)
              if product
                product.destroy
                bot.api.send_message(chat_id: message.from.id, text: "✅ Товар удалён.")
              else
                bot.api.send_message(chat_id: message.from.id, text: "⚠️ Товар не найден.")
              end
            end
          end
        end
      end
    end
  end
  