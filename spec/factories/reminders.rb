FactoryBot.define do
  factory :reminder do
    title { "Test123" }
    description { "Test description" }
    trigger_at { 1.day.from_now }
    price { "9.99" }
    currency { "Euro" }
    recurrence { "Daily" }
  end
end
