-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Окт 25 2023 г., 22:00
-- Версия сервера: 5.6.51-log
-- Версия PHP: 8.0.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `SPPR`
--

-- --------------------------------------------------------

--
-- Структура таблицы `account`
--

CREATE TABLE `account` (
  `id` int(11) NOT NULL,
  `login` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `account`
--

INSERT INTO `account` (`id`, `login`, `password`) VALUES
(1, 'admin@gmail.com', 'admin123');

-- --------------------------------------------------------

--
-- Структура таблицы `Client`
--

CREATE TABLE `Client` (
  `id` int(11) NOT NULL,
  `fio` varchar(255) NOT NULL,
  `age` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `Client`
--

INSERT INTO `Client` (`id`, `fio`, `age`) VALUES
(1, 'Агапов Михаил Алексеевич', 45),
(2, 'Синицына Полина Даниловна', 34),
(3, 'Злобин Всеволод Тимофеевич', 29),
(4, 'Новикова Сара Тимофеевна', 31),
(5, 'Малахов Артём Константинович', 14),
(6, 'Устинова Ева Никитична', 9),
(7, 'Фирсова Виктория Гордеевна', 16),
(8, 'Денисова Ксения Максимовна', 21),
(9, 'Воронин Никита Иванович', 21),
(10, 'Моисеева Александра Николаевна', 67);

-- --------------------------------------------------------

--
-- Структура таблицы `Doctor`
--

CREATE TABLE `Doctor` (
  `id` int(11) NOT NULL,
  `fio` varchar(254) NOT NULL,
  `seniority` int(11) NOT NULL,
  `qualification` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `Doctor`
--

INSERT INTO `Doctor` (`id`, `fio`, `seniority`, `qualification`) VALUES
(1, 'Севастьянов Даниил Ярославович', 5, 60),
(2, 'Уткин Тихон Александрович', 3, 60),
(3, 'Горюнов Евгений Давидович', 4, 72),
(4, 'Басов Артём Кириллович', 6, 120),
(5, 'Щербакова Ксения Семёновна', 2, 48),
(6, 'Васильев Кирилл Ильич', 5, 84),
(7, 'Авдеев Александр Артёмович', 3, 60),
(8, 'Кузьмин Семён Русланович', 4, 84),
(9, 'Соколова Камила Михайловна', 2, 36),
(10, 'Филиппова Ирина Алексеевна', 6, 120),
(11, 'Морозов Лев Лукич ', 5, 108),
(12, 'Свешникова Виктория Романовна', 3, 66);

-- --------------------------------------------------------

--
-- Структура таблицы `provided_service`
--

CREATE TABLE `provided_service` (
  `id` int(11) NOT NULL,
  `id_doctor` int(11) NOT NULL,
  `id_client` int(11) NOT NULL,
  `id_service` int(11) NOT NULL,
  `price` double NOT NULL,
  `datetime` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `provided_service`
--

INSERT INTO `provided_service` (`id`, `id_doctor`, `id_client`, `id_service`, `price`, `datetime`) VALUES
(1, 1, 2, 1, 5000, '2023-10-10'),
(2, 2, 3, 2, 3500, '2023-10-10'),
(3, 3, 6, 3, 3500, '2023-10-10'),
(4, 4, 5, 4, 1500, '2023-10-10'),
(5, 5, 7, 5, 2000, '2023-10-10'),
(6, 1, 10, 2, 4000, '2023-10-10'),
(7, 2, 10, 3, 3000, '2023-10-01'),
(8, 4, 1, 4, 1500, '2023-10-05'),
(9, 2, 2, 5, 2000, '2023-10-01'),
(10, 4, 1, 1, 6000, '2023-10-01'),
(11, 6, 10, 2, 4700, '2023-10-01'),
(12, 8, 4, 3, 2800, '2023-10-01'),
(13, 12, 6, 4, 1000, '2023-10-01'),
(14, 5, 5, 5, 2000, '2023-10-01'),
(15, 10, 9, 1, 7000, '2023-10-01'),
(16, 11, 3, 2, 4200, '2023-10-01'),
(17, 12, 4, 3, 2600, '2023-10-10'),
(18, 8, 7, 4, 1100, '2023-10-10'),
(19, 9, 3, 5, 1800, '2023-10-10'),
(20, 4, 8, 1, 7500, '2023-10-10'),
(21, 6, 10, 2, 6000, '2023-10-01'),
(22, 7, 1, 3, 3000, '2023-10-10'),
(23, 2, 7, 4, 900, '2023-10-10'),
(24, 5, 3, 5, 1600, '2023-10-10'),
(25, 10, 8, 1, 6500, '2023-10-10'),
(26, 11, 10, 2, 4800, '2023-10-01'),
(27, 8, 6, 3, 2700, '2023-10-01'),
(28, 3, 4, 4, 950, '2023-10-10'),
(29, 5, 9, 5, 1500, '2023-10-10'),
(30, 4, 8, 1, 5800, '2023-10-10'),
(31, 1, 4, 2, 4300, '2023-10-10'),
(32, 2, 2, 3, 2500, '2023-10-10'),
(33, 3, 6, 4, 1000, '2023-10-01'),
(34, 9, 7, 5, 1300, '2023-10-01'),
(35, 4, 8, 1, 6200, '2023-10-01'),
(36, 6, 5, 2, 4100, '2023-10-01');

-- --------------------------------------------------------

--
-- Структура таблицы `Service`
--

CREATE TABLE `Service` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `Service`
--

INSERT INTO `Service` (`id`, `name`) VALUES
(1, 'Ортодонтия'),
(2, 'Протезирование'),
(3, 'Реставрация'),
(4, 'Чистка зубов'),
(5, 'Экстракция зуба');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `Client`
--
ALTER TABLE `Client`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `Doctor`
--
ALTER TABLE `Doctor`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `provided_service`
--
ALTER TABLE `provided_service`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_doctor` (`id_doctor`),
  ADD KEY `fk_client` (`id_client`),
  ADD KEY `fk_service` (`id_service`);

--
-- Индексы таблицы `Service`
--
ALTER TABLE `Service`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `account`
--
ALTER TABLE `account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `Client`
--
ALTER TABLE `Client`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `Doctor`
--
ALTER TABLE `Doctor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT для таблицы `provided_service`
--
ALTER TABLE `provided_service`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT для таблицы `Service`
--
ALTER TABLE `Service`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `provided_service`
--
ALTER TABLE `provided_service`
  ADD CONSTRAINT `fk_client` FOREIGN KEY (`id_client`) REFERENCES `Client` (`id`),
  ADD CONSTRAINT `fk_doctor` FOREIGN KEY (`id_doctor`) REFERENCES `Doctor` (`id`),
  ADD CONSTRAINT `fk_service` FOREIGN KEY (`id_service`) REFERENCES `Service` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
