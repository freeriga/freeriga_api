I18n.available_locales = [:lv, :ru, :en]

Globalize.fallbacks = {
  lv: [:lv, :en, :ru],
  ru: [:ru, :lv, :en],
  en: [:en, :lv, :ru]
}
