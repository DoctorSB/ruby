# app/services/telegram_notifier.rb
require 'telegram/bot'

class TelegramNotifier
  ADMIN_CHAT_ID = ENV['TELEGRAM_ADMIN_CHAT_ID'] # Задай в .env или credentials

  def self.send_new_product(product)
    message = <<~MSG
      🆕 Новый товар:
      📦 Название: #{product.name}
      📝 Описание: #{product.description}
      💰 Цена: #{product.price} ₽
    MSG

    Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
        bot.api.send_message(
            chat_id: ADMIN_CHAT_ID,
            text: message,
            reply_markup: {
              inline_keyboard: [
                [{ text: "❌ Удалить", callback_data: "delete_#{product.id}" }]
              ]
            }.to_json
          )
          
    end
  end
end
