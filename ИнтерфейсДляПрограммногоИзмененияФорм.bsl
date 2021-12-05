// см. МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	Результат = префикс_КлиентСервер.ПолучитьСтруктурированноеОписаниеИмениФормы(Форма.ИмяФормы);
	ВидМетаданных = Результат.ВидМетаданных;
	ТипОбъекта = Результат.ТипОбъекта;
	ИмяФормы = Результат.ИмяФормы;

	Если ТипОбъекта = "ЗаказКлиента" Тогда
		Если ИмяФормы = "ФормаДокумента" Тогда
			ДобавитьРеквизитСпецификацияИКомандуПоФормированиюПроизводственныхДокументов(Форма);
		КонецЕсли;
	ИначеЕсли ТипОбъекта = "Номенклатура" Тогда
		Если ИмяФормы = "ФормаЭлемента" Тогда
			ДобавитьНовыеРеквизитыВКарточкуНоменклатуры(Форма);
		КонецЕсли;
	ИначеЕсли ИмяФормы = "ФормаОтчета" ИЛИ ВидМетаданных = "Отчет" Тогда
		ЗапомнитьИмяОтчетаВРеквизитИзПараметра(Форма);
	КонецЕсли;

КонецПроцедуры

#Область ДоработкаФорм_ВнешнийПрограммныйИнтерфейс

// Функция добавляет реквизит формы
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  Имя - Строка, содержит имя реквизита
//  Тип - Строка типа, Тип или ОписаниеТипов
//  Заголовок - Строка, содержит отображаемый текст реквизита
//Если заголовок не задан, то формируется функцией "ПолучитьЗаголовокПоИмени"
//  Путь - Строка, содержит путь к реквизиту, не включая имя реквизита
//  СохраняемыеДанные - Булево, если Истина - указывает, что это сохраняемый при записи реквизит, по умолчанию Ложь
//  Значение - Произвольный, значение, присваиваемое реквизиту после его создания
//
// Возвращаемое значение:
//  РеквизитФормы - созданный реквизит формы
//
Функция ДобавитьРеквизит(Форма, Имя, Тип, Заголовок = Неопределено, Путь = Неопределено, СохраняемыеДанные = Неопределено, Значение = Неопределено)

	СвойстваРеквизита = Новый Структура;
	СвойстваРеквизита.Вставить("Имя", Имя);
	СвойстваРеквизита.Вставить("Тип", Тип);
	СвойстваРеквизита.Вставить("Заголовок", Заголовок);
	СвойстваРеквизита.Вставить("Путь", Путь);
	СвойстваРеквизита.Вставить("СохраняемыеДанные", СохраняемыеДанные);
	СвойстваРеквизита.Вставить("Значение", Значение);
	СвойстваРеквизитов = Новый Массив;
	СвойстваРеквизитов.Добавить(СвойстваРеквизита);
	Возврат ДобавитьРеквизиты(Форма, СвойстваРеквизитов)[0];

КонецФункции

// Функция добавляет реквизиты формы
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  Реквизиты - Массив структур:
//   * Имя - Строка, содержит имя реквизита
//   * Тип - Строка типа, Тип или ОписаниеТипов
//   * Заголовок - необязательный элемент, Строка, содержит отображаемый текст реквизита
//Если заголовок не задан, то формируется функцией "ПолучитьЗаголовокПоИмени"
//   * Путь - необязательный элемент, Строка, содержит путь к реквизиту, не включая имя реквизита
//   * СохраняемыеДанные - необязательный элемент, Булево, если Истина - указывает, что это сохраняемый при записи реквизит, по умолчанию Ложь
//   * Значение - необязательный элемент, Произвольный, значение, присваиваемое реквизиту после его создания
//
// Возвращаемое значение:
//  Массив Реквизитов формы - созданные реквизиты формы
//
Функция ДобавитьРеквизиты(Форма, СвойстваРеквизитов)

	НовыеРеквизиты = Новый Массив;

	Для Каждого СвойстваРеквизита Из СвойстваРеквизитов Цикл

		Имя = СвойстваРеквизита.Имя;
		Тип = СвойстваРеквизита.Тип;
		Если ТипЗнч(Тип) = Тип("Строка") Тогда
			Тип = Новый ОписаниеТипов(Тип);
		ИначеЕсли ТипЗнч(Тип) = Тип("Тип") Тогда
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(Тип);
       		Тип = Новый ОписаниеТипов(МассивТипов);
		КонецЕсли;
		Путь = Неопределено; Заголовок = Неопределено; СохраняемыеДанные = Неопределено;
		СвойстваРеквизита.Свойство("Путь", Путь);
		СвойстваРеквизита.Свойство("Заголовок", Заголовок);
		СвойстваРеквизита.Свойство("СохраняемыеДанные", СохраняемыеДанные);
		Если Путь = Неопределено Тогда
			Путь = "";
		КонецЕсли;
		Если Заголовок = Неопределено Тогда
			Заголовок = ПолучитьЗаголовокПоИмени(Имя);
		КонецЕсли;
		Если СохраняемыеДанные = Неопределено Тогда
			СохраняемыеДанные = Ложь;
		КонецЕсли;

		НовыйРеквизит = Новый РеквизитФормы(Имя, Тип, Путь, Заголовок, СохраняемыеДанные);
		НовыеРеквизиты.Добавить(НовыйРеквизит);

	КонецЦикла;

	Форма.ИзменитьРеквизиты(НовыеРеквизиты);

	Для Каждого СвойстваРеквизита Из СвойстваРеквизитов Цикл
		Если СвойстваРеквизита.Свойство("Значение") И СвойстваРеквизита.Значение <> Неопределено Тогда
			Форма[СвойстваРеквизита.Имя] = СвойстваРеквизита.Значение;
		КонецЕсли;
	КонецЦикла;

	Возврат НовыеРеквизиты;

КонецФункции

// Функция добавляет команду формы
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  Имя - Строка, содержит имя команды
//  Действие - Строка, содержит имя процедуры обработчика команды
//Для действия по умолчанию см. МодификацияКонфигурацииКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду
//
// Возвращаемое значение:
//  КомандыФормы - созданная команда
//
Функция ДобавитьКоманду(Форма, Имя, Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду")

	Команда = Форма.Команды.Добавить(Имя);
	Команда.Заголовок = ПолучитьЗаголовокПоИмени(Имя);
	Команда.Действие = Действие;
	Возврат Команда	

КонецФункции

// Функция добавляет на форму новый элемент типа ПолеФормы
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ПутьКданным - Строка, содержит путь к реквизиту, с которым связан объект
//  Родитель - Элемент формы, родитель для добавляемого элемента, если не указан, то добавляется на верхний уровень
//  ЭлементПередКоторымВставить - Элемент формы или Число (номер элемента формы, нумерация начинается с 1), перед которым должен быть вставлен новый элемент
//Если не указан, то элемент будет вставлен в конец
//Указание числом места вставки полезно, например, когда элемент нужно вставить в самое начало группы, а второй элемент формы может добавляться программно
//  ВидПоля - ВидПоляФормы, по умолчанию ПолеВвода
//  Эталон - Элемент формы, свойства которого нужно скопировать, при этом уникальные свойства не копируются (см. переменную ИсключаемыеСвойства внутри функции) 
//
// Возвращаемое значение:
//  ПолеФормы - созданное поле
//
Функция ДобавитьПоле(Форма, ПутьКданным, Родитель = Неопределено, ЭлементПередКоторымВставить = Неопределено, ВидПоля = Неопределено, Эталон = Неопределено)

	РеквизитСРодителем = ПолучитьРеквизитПоПути(Форма, ПутьКданным);
	Реквизит = РеквизитСРодителем.Реквизит;
	РодительРеквизита = РеквизитСРодителем.Родитель;

	ИмяЭлемента = ?(РодительРеквизита = Неопределено, Реквизит.Имя, РодительРеквизита.Имя + Реквизит.Имя);

	Если ТипЗнч(Реквизит) = Тип("Объектметаданных") Тогда
		ЭтоРеквизитОбъекта = Истина;
	Иначе
		ЭтоРеквизитОбъекта = Ложь;
	КонецЕсли;

	Если ВидПоля = Неопределено И Эталон = Неопределено Тогда
		Если ЭтоРеквизитОбъекта Тогда
			СвойствоТип = "Тип";
		Иначе
			СвойствоТип = "ТипЗначения";
		КонецЕсли;

		Если Реквизит[СвойствоТип].Типы().Количество() = 1 И Реквизит[СвойствоТип].Типы()[0] = Тип("Булево") Тогда
			ВидПоля = ВидПоляФормы.ПолеФлажка;
		Иначе
			ВидПоля = ВидПоляФормы.ПолеВвода;
		КонецЕсли;
	КонецЕсли;

	Если ТипЗнч(ЭлементПередКоторымВставить) = Тип("Число") Тогда
		ГруппаДляПоискаМестаВставки = Родитель;
		Если ГруппаДляПоискаМестаВставки = Неопределено Тогда
			ГруппаДляПоискаМестаВставки = Форма;
		КонецЕсли;
		Если ГруппаДляПоискаМестаВставки.ПодчиненныеЭлементы.Количество() < ЭлементПередКоторымВставить Тогда
			ЭлементПередКоторымВставить = ГруппаДляПоискаМестаВставки.ПодчиненныеЭлементы.Количество();
		ИначеЕсли ЭлементПередКоторымВставить < 1 Тогда
			ЭлементПередКоторымВставить = 1;
		КонецЕсли;
		ЭлементПередКоторымВставить = ГруппаДляПоискаМестаВставки.ПодчиненныеЭлементы[ЭлементПередКоторымВставить - 1];
	КонецЕсли;

	НовыйЭлемент = Форма.Элементы.Вставить(ИмяЭлемента, Тип("ПолеФормы"), Родитель, ЭлементПередКоторымВставить);

	Если Эталон <> Неопределено Тогда
		ИсключаемыеСвойства = Новый Массив;
		ИсключаемыеСвойства.Добавить("ПутьКДанным");
		ИсключаемыеСвойства.Добавить("ПутьКДаннымПодвала");
		ИсключаемыеСвойства.Добавить("Заголовок");
		ИсключаемыеСвойства.Добавить("Подсказка");
		ИсключаемыеСвойства.Добавить("РасширеннаяПодсказка");
		ИсключаемыеСвойства.Добавить("Видимость");
		ИсключаемыеСвойства.Добавить("Доступность");
		ИсключаемыеСвойства.Добавить("ТолькоПросмотр");
		ИсключаемыеСвойства.Добавить("СочетаниеКлавиш");
		ИсключаемыеСвойства.Добавить("АктивизироватьПоУмолчанию");
		Если Эталон.Вид = ВидПоляФормы.ПолеВвода Тогда
			ИсключаемыеСвойства.Добавить("ВыделенныйТекст");
			ИсключаемыеСвойства.Добавить("СвязьПоТипу");
			ИсключаемыеСвойства.Добавить("ПодсказкаВвода");
			ИсключаемыеСвойства.Добавить("ФормаВыбора");
			ИсключаемыеСвойства.Добавить("ОтметкаНезаполненного");
			ИсключаемыеСвойства.Добавить("АвтоОтметкаНезаполненного");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, Эталон, , СтрСоединить(ИсключаемыеСвойства, ","));
	КонецЕсли;

	Если ВидПоля <> Неопределено Тогда
		НовыйЭлемент.Вид = ВидПоля;
	КонецЕсли;

	Если ЭтоРеквизитОбъекта Тогда
		Если НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода И Реквизит.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку Тогда
			НовыйЭлемент.ОтметкаНезаполненного = Истина;
			НовыйЭлемент.АвтоОтметкаНезаполненного = Истина;
		КонецЕсли;
	КонецЕсли;

	НовыйЭлемент.ПутьКДанным = ПутьКДанным;

	Возврат НовыйЭлемент;

КонецФункции

// Функция добавляет на форму новый элемент типа КнопкаФормы
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  Команда - КомандаФормы
//  Родитель - Элемент формы, родитель для добавляемого элемента, если не указан, то добавляется на верхний уровень
//  ЭлементПередКоторымВставить - Элемент формы или Число (номер элемента формы, нумерация начинается с 1), перед которым должен быть вставлен новый элемент
//Если не указан, то элемент будет вставлен в конец
//Указание числом места вставки полезно, например, когда элемент нужно вставить в самое начало группы, а второй элемент формы может добавляться программно
//  ВидКоманды - ВидКнопкиФормы, по умолчанию ОбычнаяКнопка
//  Эталон - Элемент формы, свойства которого нужно скопировать, при этом уникальные свойства не копируются (см. переменную ИсключаемыеСвойства внутри функции)
//
// Возвращаемое значение:
//  КнопкаФормы - созданная кнопка
//
Функция ДобавитьКнопку(Форма, Команда, Родитель = Неопределено, ЭлементПередКоторымВставить = Неопределено, ВидКоманды = Неопределено, Эталон = Неопределено)

	Если ВидКоманды = Неопределено И Эталон = Неопределено Тогда
		ВидКоманды = ВидКнопкиФормы.ОбычнаяКнопка;
	КонецЕсли;

	Если ТипЗнч(ЭлементПередКоторымВставить) = Тип("Число") Тогда
		ГруппаДляПоискаМестаВставки = Родитель;
		Если ГруппаДляПоискаМестаВставки = Неопределено Тогда
			ГруппаДляПоискаМестаВставки = Форма;
		КонецЕсли;
		Если ГруппаДляПоискаМестаВставки.ПодчиненныеЭлементы.Количество() < ЭлементПередКоторымВставить Тогда
			ЭлементПередКоторымВставить = ГруппаДляПоискаМестаВставки.ПодчиненныеЭлементы.Количество();
		ИначеЕсли ЭлементПередКоторымВставить < 1 Тогда
			ЭлементПередКоторымВставить = 1;
		КонецЕсли;
		ЭлементПередКоторымВставить = ГруппаДляПоискаМестаВставки.ПодчиненныеЭлементы[ЭлементПередКоторымВставить - 1];
	КонецЕсли;

	НовыйЭлемент = Форма.Элементы.Вставить(Команда.Имя, Тип("КнопкаФормы"), Родитель, ЭлементПередКоторымВставить);

	Если Эталон <> Неопределено Тогда
		ИсключаемыеСвойства = Новый Массив;
		ИсключаемыеСвойства.Добавить("ИмяКоманды");
		ИсключаемыеСвойства.Добавить("Заголовок");
		ИсключаемыеСвойства.Добавить("РасширеннаяПодсказка");
		ИсключаемыеСвойства.Добавить("КнопкаПоУмолчанию");
		ИсключаемыеСвойства.Добавить("СочетаниеКлавиш");
		ИсключаемыеСвойства.Добавить("АктивизироватьПоУмолчанию");
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, Эталон, , СтрСоединить(ИсключаемыеСвойства, ","));
	КонецЕсли;

	Если ВидКоманды <> Неопределено Тогда
		НовыйЭлемент.Вид = ВидКоманды;
	КонецЕсли;

	НовыйЭлемент.ИмяКоманды = Команда.Имя;

	Возврат НовыйЭлемент;

КонецФункции

// Функция добавляет реквизит формы и создает на основе его новое поле
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  Имя - Строка, содержит имя реквизита
//  Тип - Строка типа, Тип или ОписаниеТипов
//  Заголовок - Строка, содержит отображаемый текст реквизита
//Если заголовок не задан, то формируется функцией "ПолучитьЗаголовокПоИмени"
//  Путь - Строка, содержит путь к реквизиту, не включая имя реквизита
//  СохраняемыеДанные - Булево, если Истина - указывает, что это сохраняемый при записи реквизит, по умолчанию Ложь
//  Значение - Произвольный, значение, присваиваемое реквизиту после его создания
//  Родитель - Элемент формы, родитель для добавляемого элемента, если не указан, то добавляется на верхний уровень
//  ЭлементПередКоторымВставить - Элемент формы или Число (номер элемента формы, нумерация начинается с 1), перед которым должен быть вставлен новый элемент
//Если не указан, то элемент будет вставлен в конец
//Указание числом места вставки полезно, например, когда элемент нужно вставить в самое начало группы, а второй элемент формы может добавляться программно
//  ВидПоля - ВидПоляФормы, по умолчанию ПолеВвода
//  Эталон - Элемент формы, свойства которого нужно скопировать, при этом уникальные свойства не копируются (см. переменную ИсключаемыеСвойства внутри функции)
//
// Возвращаемое значение:
//  Структура:
//   * РеквизитФормы - созданный реквизит формы
//   * ПолеФормы - созданное поле
//
Функция ДобавитьРеквизитИПоле(
	Форма,
	Имя, Тип, Заголовок = Неопределено, Путь = Неопределено, СохраняемыеДанные = Неопределено, Значение = Неопределено,
	Родитель = Неопределено, ЭлементПередКоторымВставить = Неопределено, ВидПоля = Неопределено, Эталон = Неопределено
)
	Реквизит = ДобавитьРеквизит(Форма, Имя, Тип, Заголовок, Путь, СохраняемыеДанные, Значение);
	ПутьКДанным = ?(ЗначениеЗаполнено(Реквизит.Путь), Реквизит.Путь + ".", "") + Реквизит.Имя;
	Поле = ДобавитьПоле(Форма, ПутьКДанным, Родитель, ЭлементПередКоторымВставить, ВидПоля, Эталон);
	Возврат Новый Структура("Реквизит, Поле", Реквизит, Поле);

КонецФункции

// Функция добавляет команду формы и создает на основе нее новую кнопку
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  Имя - Строка, содержит имя команды
//  Действие - Строка, содержит имя процедуры обработчика команды
//Для действия по умолчанию см. МодификацияКонфигурацииКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду
//  Родитель - Элемент формы, родитель для добавляемого элемента, если не указан, то добавляется на верхний уровень
//  ЭлементПередКоторымВставить - Элемент формы или Число (номер элемента формы, нумерация начинается с 1), перед которым должен быть вставлен новый элемент
//Если не указан, то элемент будет вставлен в конец
//Указание числом места вставки полезно, например, когда элемент нужно вставить в самое начало группы, а второй элемент формы может добавляться программно
//  ВидКоманды - ВидКнопкиФормы, по умолчанию ОбычнаяКнопка
//  Эталон - Элемент формы, свойства которого нужно скопировать, при этом уникальные свойства не копируются (см. переменную ИсключаемыеСвойства внутри функции)
// 
// Возвращаемое значение:
//  Структура:
//   * КомандыФормы - созданная команда
//   * КнопкаФормы - созданная кнопка
//
Функция ДобавитьКомандуИКнопку(
	Форма,
	Имя, Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду",
	Родитель = Неопределено, ЭлементПередКоторымВставить = Неопределено, ВидКоманды = Неопределено, Эталон = Неопределено
)
	Команда = ДобавитьКоманду(Форма, Имя, Действие);
	Кнопка = ДобавитьКнопку(Форма, Команда, Родитель, ЭлементПередКоторымВставить, ВидКоманды, Эталон);
	Возврат Новый Структура("Команда, Кнопка", Команда, Кнопка);

КонецФункции

// Функция добавляет на форму новый элемент типа ГруппаФормы
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ИмяЭлемента - Строка
//  Родитель - Элемент формы, родитель для добавляемого элемента, если не указан, то добавляется на верхний уровень
//  ЭлементПередКоторымВставить - Элемент формы или Число (номер элемента формы, нумерация начинается с 1), перед которым должен быть вставлен новый элемент
//Если не указан, то элемент будет вставлен в конец
//Указание числом места вставки полезно, например, когда элемент нужно вставить в самое начало группы, а второй элемент формы может добавляться программно
//  ВидГруппы - ВидГруппыФормы, по умолчанию ОбычнаяГруппа
//  Эталон - Элемент формы, свойства которого нужно скопировать, при этом уникальные свойства не копируются (см. переменную ИсключаемыеСвойства внутри функции)
//
// Возвращаемое значение:
//  ГруппаФормы - созданная группа
//
Функция ДобавитьГруппу(Форма, ИмяЭлемента, Родитель = Неопределено,  ЭлементПередКоторымВставить = Неопределено, ВидГруппы = Неопределено, Эталон = Неопределено)

	Если ВидГруппы = Неопределено И Эталон = Неопределено Тогда
		ВидГруппы = ВидГруппыФормы.ОбычнаяГруппа;
	КонецЕсли;

	Если ТипЗнч(ЭлементПередКоторымВставить) = Тип("Число") Тогда
		ГруппаДляПоискаМестаВставки = Родитель;
		Если ГруппаДляПоискаМестаВставки = Неопределено Тогда
			ГруппаДляПоискаМестаВставки = Форма;
		КонецЕсли;
		Если ГруппаДляПоискаМестаВставки.ПодчиненныеЭлементы.Количество() < ЭлементПередКоторымВставить Тогда
			ЭлементПередКоторымВставить = ГруппаДляПоискаМестаВставки.ПодчиненныеЭлементы.Количество();
		ИначеЕсли ЭлементПередКоторымВставить < 1 Тогда
			ЭлементПередКоторымВставить = 1;
		КонецЕсли;
		ЭлементПередКоторымВставить = ГруппаДляПоискаМестаВставки.ПодчиненныеЭлементы[ЭлементПередКоторымВставить - 1];
	КонецЕсли;

	НовыйЭлемент = Форма.Элементы.Вставить(ИмяЭлемента, Тип("ГруппаФормы"), Родитель, ЭлементПередКоторымВставить);

	Если Эталон <> Неопределено Тогда
		ИсключаемыеСвойства = Новый Массив;
		ИсключаемыеСвойства.Добавить("Заголовок");
		ИсключаемыеСвойства.Добавить("Подсказка");
		ИсключаемыеСвойства.Добавить("СочетаниеКлавиш");
		ИсключаемыеСвойства.Добавить("ПодчиненныеЭлементы");
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, Эталон, , СтрСоединить(ИсключаемыеСвойства, ","));
	КонецЕсли;

	Если ВидГруппы <> Неопределено Тогда
		НовыйЭлемент.Вид = ВидГруппы;
	КонецЕсли;

	НовыйЭлемент.Заголовок = ПолучитьЗаголовокПоИмени(ИмяЭлемента);

	Возврат НовыйЭлемент;

КонецФункции

#КонецОбласти

#Область ДоработкаФорм_СлужебныйПрограммныйИнтерфейс

// Возвращает произвольный реквизит Формы по переданному пути
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  Путь - Строка, путь к реквизиту формы, разделенный точками (Например, Объект.Товары.Спецификация)
//
// Возвращаемое значение:
//  Структура или Неопределено, если реквизит не найден:
//   * Реквизит - РеквизитФормы или ОбъектМетаданных (реквизит объекта)
//   * Родитель - РеквизитФормы, ОбъектМетаданных (реквизит объекта) или Неопределено, если родитель (табличная часть, ТЗ или ДЗ) отсутствует   
//
Функция ПолучитьРеквизитПоПути(Форма, Путь)

	СтруктураВозврата = Новый Структура("Реквизит, Родитель");
	ПутьРазделенныйТочками = СтрРазделить(Путь, ".");
	Если ПутьРазделенныйТочками.Количество() > 1 И ПутьРазделенныйТочками[0] = "Объект" Тогда
		ПутьРазделенныйТочками.Удалить(0);
		Если ПутьРазделенныйТочками.Количество() = 1 Тогда
			СтруктураВозврата.Реквизит = Форма.РеквизитФормыВЗначение("Объект").Метаданные().Реквизиты[ПутьРазделенныйТочками[0]];
			Возврат СтруктураВозврата;
		Иначе
			СтруктураВозврата.Родитель = Форма.РеквизитФормыВЗначение("Объект").Метаданные().ТабличныеЧасти[ПутьРазделенныйТочками[0]];
			СтруктураВозврата.Реквизит = СтруктураВозврата.Родитель.Реквизиты[ПутьРазделенныйТочками[1]];
			Возврат СтруктураВозврата;
		КонецЕсли;
	КонецЕсли;
	МассивРеквизитов = Форма.ПолучитьРеквизиты();
	Для Каждого Стр Из МассивРеквизитов Цикл
		Если
			ПутьРазделенныйТочками.Количество() > 1 И
			(
			(Стр.ТипЗначения.Типы().Количество() = 1 И Стр.ТипЗначения.Типы()[0] = Тип("ТаблицаЗначений")) ИЛИ
			(Стр.ТипЗначения.Типы().Количество() = 1 И Стр.ТипЗначения.Типы()[0] = Тип("ДеревоЗначений"))
			)
		Тогда
			Если Стр.Имя = ПутьРазделенныйТочками[0] Тогда
				СтруктураВозврата.Родитель = Стр;
			Иначе
				Продолжить;
			КонецЕсли;
			РеквизитыТаблицы = Форма.ПолучитьРеквизиты(Стр.Имя);
			Для Каждого СтрСтр Из РеквизитыТаблицы Цикл
				Если СтрСтр.Имя = ПутьРазделенныйТочками[1] Тогда
					СтруктураВозврата.Реквизит = СтрСтр;
					Возврат СтруктураВозврата;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Если Стр.Имя = Путь Тогда
				СтруктураВозврата.Реквизит = Стр;
				Возврат СтруктураВозврата;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецФункции

// Функция возвращает заголовок по наименованию так, как это происходит в конфигураторе (точное соответствие)
// При этом есть возможность убрать префикс, чтобы заголовок формировался без него
// Правила преобразования:
//  0) удаляется префикс при необходимости (вместе с разделителем)
//  1) символ "_" заменяется пробелом, при этом лишние пробелы удаляются
//  2) первая буква становится прописной
//  3) перед всеми прописными буквами кроме первой ставится пробел
//  * если прописными буквы идут друг за другом более, чем 2 раза, то пробел ставится только перед первой
//  4) все прописные буквы кроме первой превращаются в строчные
//  * если прописные буквы идут друг за другом более, чем 2 раза, то регистр букв не меняется
//  * если прописная буква является единственным символом или находится в конце строки, то регистр букв не меняется
//
// Параметры:
//  Имя - Строка, имя написаное в стиле CamelCase с возможным указанием префикса (например, "дк_ОформитьДокументыПроизводства")
//  РазделительПрефиксаОтИмени - Строка, по данному разделителю удаляется префикс
//  КонкретныйПрефикс - Строка, если значение заполнено, то данный префикс ищется перед разделителем, и только тогда префикс удаляется
//Если значение не заполнено, то префикс определяется автоматически перед разделителем
//
Функция ПолучитьЗаголовокПоИмени(Имя, РазделительПрефиксаОтИмени = "_", КонкретныйПрефикс = "")

	ИмяБезПрефикса = Имя;
	Если НЕ ЗначениеЗаполнено(КонкретныйПрефикс) И ЗначениеЗаполнено(РазделительПрефиксаОтИмени) Тогда
		КонкретныйПрефикс = Лев(Имя, Найти(Имя, РазделительПрефиксаОтИмени) - 1);
	КонецЕсли;
	СтрокаПередКоторойВключаяУдалитьСимволы = КонкретныйПрефикс + РазделительПрефиксаОтИмени;
	Если ЗначениеЗаполнено(СтрокаПередКоторойВключаяУдалитьСимволы) Тогда
		НачалоНужнойСтроки = Найти(Имя, СтрокаПередКоторойВключаяУдалитьСимволы);
		Если Лев(Имя, СтрДлина(СтрокаПередКоторойВключаяУдалитьСимволы)) = СтрокаПередКоторойВключаяУдалитьСимволы Тогда
			ИмяБезПрефикса = Прав(Имя, СтрДлина(Имя) - СтрДлина(СтрокаПередКоторойВключаяУдалитьСимволы));
		КонецЕсли;
	КонецЕсли;

	Заголовок = "";
	ПредСимвол = "";
	Для Сч = 1 По СтрДлина(ИмяБезПрефикса) Цикл
		Символ = Сред(ИмяБезПрефикса, Сч, 1);
		Если Символ = "_" Тогда
			Символ = ?(ПредСимвол = Символы.НПП, "", Символы.НПП);
		КонецЕсли;
		Заголовок = Заголовок + Символ;
		ПредСимвол = ?(Символ = "", Символы.НПП, Символ);
	КонецЦикла;

	Заголовок = СокрЛП(Заголовок);

	ЗаголовокДоработанный = "";
	ПредСимволСтрочный = "";
	ПредПредСимволСтрочный = "";
	ПредСимвол = "";
	Для Сч = 1 По СтрДлина(Заголовок) Цикл
		Символ = Сред(Заголовок, Сч, 1);
		СледСимвол = ?(Сч + 1 <= СтрДлина(Заголовок), Сред(Заголовок, Сч + 1, 1), "");
		СледСимволСтрочный = ?(СледСимвол = ВРег(СледСимвол), СледСимвол, "");
		СледСледСимвол = ?(Сч + 2 <= СтрДлина(Заголовок), Сред(Заголовок, Сч + 2, 1), "");
		Если СледСимволСтрочный <> "" Тогда
			СледСледСимволСтрочный = ?(СледСледСимвол = ВРег(СледСледСимвол), СледСледСимвол, "");
		Иначе
			СледСледСимволСтрочный = "";
		КонецЕсли;
		СимволДляКонкатенации = Символ;
		БылРазрыв = Ложь;
		Если Сч > 1 И ВРег(Символ) = Символ И ПредСимвол <> Символы.НПП И Символ <> Символы.НПП И 
			 (СтрДлина(СледСимволСтрочный + СледСледСимволСтрочный + ПредСимволСтрочный + ПредПредСимволСтрочный) < 2 ИЛИ Нрег(ПредСимвол) = ПредСимвол)  	
		Тогда
			Если НЕ(СтрДлина(СледСимволСтрочный + ПредСимволСтрочный) > 0 И СледСимвол = "") Тогда
				ЗаголовокДоработанный = ЗаголовокДоработанный + Символы.НПП;
				БылРазрыв = Истина;
			КонецЕсли;
			СимволДляКонкатенации = ?(СтрДлина(СледСимволСтрочный + ПредСимволСтрочный) > 0 И (НЕ БылРазрыв ИЛИ СледСимволСтрочный <> ""), Символ, НРег(Символ));
			Если БылРазрыв И СледСимволСтрочный <> "" И СледСледСимволСтрочный = "" И СледСледСимвол <> "" Тогда
				СимволДляКонкатенации = НРег(СимволДляКонкатенации);
			ИначеЕсли СледСимвол = "" И БылРазрыв Тогда
				СимволДляКонкатенации = Символ;
			КонецЕсли;
		КонецЕсли;
		ЗаголовокДоработанный = ЗаголовокДоработанный + СимволДляКонкатенации;
		ПредПредСимволСтрочный = ?(ПредСимвол = ВРег(ПредСимвол), ПредСимвол, "");
		ПредСимвол = Символ;
		ПредСимволСтрочный = ?(Символ = ВРег(Символ), Символ, "");
	КонецЦикла;

	Возврат Врег(Лев(ЗаголовокДоработанный, 1)) + Сред(ЗаголовокДоработанный, 2);

КонецФункции

#КонецОбласти


// Эту функцию корректнее размещать в клиентСерверном модуле, так как необходимость ее вызова возможна и с клиента

// Возвращает вид метаданных, тип объекта и имя формы строкой
//
// Параметры:
//  ПолноеИмяФормы - Строка, имя формы (Форма.ИмяФормы)
//
// Возвращаемое значение:
//  Структура:
//   * ВидМетаданных - Строка, содержит вид метаданных (например, "Документ", "Справочник", "ОбщаяФорма")
//   * ТипОбъекта - Строка, содержит тип объекта (например, "ЗаказКлиента", "Номенклатура", "Отчет")
//Для общих форм тип объекта Неопределено
//   * ИмяФормы - Строка, содержит конкретное имя формы (например, "ФормаДокумента", "ФормаЭлемента", "ФормаОтчета", "СчитываниеКартыЛояльности")
//
Функция ПолучитьСтруктурированноеОписаниеИмениФормы(ПолноеИмяФормы) Экспорт

	ЧастиИмениФормыРазделенныеТочками = СтрРазделить(ПолноеИмяФормы, ".");
	// Для разных типов объектов путь к форме может отличаться (например, общие формы)
	Если ЧастиИмениФормыРазделенныеТочками.Количество() = 2 Тогда
		ВидМетаданных = ЧастиИмениФормыРазделенныеТочками[0];
		ТипОбъекта = Неопределено;
		ИмяФормы   = ЧастиИмениФормыРазделенныеТочками[1];
	ИначеЕсли ЧастиИмениФормыРазделенныеТочками.Количество() = 3 Тогда
		ВидМетаданных   = ЧастиИмениФормыРазделенныеТочками[0];
		ТипОбъекта = ЧастиИмениФормыРазделенныеТочками[1];
		ИмяФормы   = ЧастиИмениФормыРазделенныеТочками[2];
	Иначе
		ВидМетаданных   = ЧастиИмениФормыРазделенныеТочками[0];
		ТипОбъекта = ЧастиИмениФормыРазделенныеТочками[1];
		ИмяФормы   = ЧастиИмениФормыРазделенныеТочками[3];
	КонецЕсли;

	Возврат Новый Структура("ВидМетаданных, ТипОбъекта, ИмяФормы", ВидМетаданных, ТипОбъекта, ИмяФормы);

КонецФункции
