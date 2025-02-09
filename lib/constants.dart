// Класс для настроек полей ввода авторизации
const int maxPasswordLength = 20;
const int maxEmailLength = 30;
const int maxUsernameLength = 20;
const List<String> defaultTypes = [
  'Выпечка',
  'Молочная продукция',
  'Балаклея',
  'Мясо',
  'Рыба',
  'Снеки',
  'Морепродукты',
  'Кондитерские изделия',
  'Овощи',
  'Фрукты',
  'Напитки',
  'Полуфабрикаты',
  'Прочее'
];

const Map<String, String> typesIcons = {
  'Выпечка': 'assets/images/bread.svg',
  'Молочная продукция': 'assets/images/milk.svg',
  'Балаклея': 'assets/images/plant.svg',
  'Мясо': 'assets/images/meat.svg',
  'Рыба': 'assets/images/fish.svg',
  'Морепродукты': 'assets/images/seafish.svg',
  'Снеки': 'assets/images/sneaks.svg',
  'Кондитерские изделия': 'assets/images/sweets.svg',
  'Овощи': 'assets/images/veg.svg',
  'Фрукты': 'assets/images/fruit.svg',
  'Напитки': 'assets/images/drinks.svg',
  'Полуфабрикаты': 'assets/images/ready.svg',
  'Прочее': 'assets/images/other.svg'
};
