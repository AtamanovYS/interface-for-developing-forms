&НаСервере
Процедура ОбработатьExcel(ДвоичныеДанные, Расширение)
	
	ФайлНаСервере = ПолучитьИмяВременногоФайла(Расширение);
	ДвоичныеДанные.Записать(ФайлНаСервере);	
	
	Попытка
		Рез = ПрочитатьExcel(ФайлНаСервере);
		УдалитьФайлы(ФайлНаСервере);
	Исключение
		УдалитьФайлы(ФайлНаСервере);
		ВызватьИсключение;
	КонецПопытки;

	СчетчикДляНовыхГрупп = 950;
	НашлиНачалоТаблицы = Ложь;
	
	ТабДок = Неопределено;
	Для Каждого Страница Из Рез Цикл
		Если СокрЛП(НРег(Страница.Представление)) = "_1с" Тогда
			ТабДок = Страница.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ТабДок = Неопределено Тогда
		Для Каждого Страница Из Рез Цикл
			Если СокрЛП(НРег(Страница.Представление)) = "_1c" Тогда
				ТабДок = Страница.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Если ТабДок = Неопределено Тогда
		Для Каждого Страница Из Рез Цикл
			Если СокрЛП(НРег(Страница.Представление)) = "1с" Тогда
				ТабДок = Страница.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ТабДок = Неопределено Тогда
		Для Каждого Страница Из Рез Цикл
			Если СокрЛП(НРег(Страница.Представление)) = "1c" Тогда
				ТабДок = Страница.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Если ТабДок = Неопределено Тогда
		Для Каждого Страница Из Рез Цикл
			Если СокрЛП(НРег(Страница.Представление)) = "account" Тогда
				ТабДок = Страница.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;

	ОбходимСтраницаСИнвойсом = Ложь;
	Если ТабДок = Неопределено Тогда
		ОбходимСтраницаСИнвойсом = Истина;
		Для Каждого Страница Из Рез Цикл
			Если СокрЛП(НРег(Страница.Представление)) = "invoice_pl" Тогда
				ТабДок = Страница.Значение;
				Прервать
			ИначеЕсли СокрЛП(НРег(Страница.Представление)) = "invoice" Тогда
				ТабДок = Страница.Значение;
				Прервать
			ИначеЕсли СокрЛП(НРег(Страница.Представление)) = "ci" Тогда	
				ТабДок = Страница.Значение;	
				Прервать
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если ТабДок = Неопределено Тогда
		Для Каждого Страница Из Рез Цикл
			Если СтрНайти(СокрЛП(Нрег(Страница.Представление)), "invoice") <> 0 Тогда
				ТабДок = Страница.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если ТабДок = Неопределено Тогда
		Вызватьисключение "Не найдена нужная страница в Excel";
	КонецЕсли;	
 	Для Сч = 1 По 50 Цикл
		Если НашлиНачалоТаблицы Тогда Прервать; КонецЕсли;
		ТЗИзЕкселя = ПолучитьТЗИзЕкселя(ТабДок, Сч, 1);	
		Если ТЗИзЕкселя = Неопределено Тогда Продолжить; КонецЕсли;
		Для Каждого КолонкаЕкселя Из ТЗИзЕкселя.Колонки Цикл
			Если СтрНайти(НРег(КолонкаЕкселя.Имя), "quantity") <> 0 ИЛИ СтрНайти(НРег(КолонкаЕкселя.Имя), "qty") <> 0 Тогда
				НашлиНачалоТаблицы = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	Если НЕ НашлиНачалоТаблицы Тогда
		ВызватьИсключение "Неизвестная структура Excel (не найдена колонка с количеством)";
	КонецЕсли;
 
КонецПроцедуры

#Область ПереводExcelвТаблицу

&НаСервереБезКонтекста
Функция  ПолучитьТЗИзЕкселя(ТабличныйДокумент, НомерСтрокиНачалаТаблицы, НомерКолонкиНачалаТаблицы, НомерСтрокиКонцаТаблицы = Неопределено, НомерКолонкиКонцаТаблицы = Неопределено)
	ОбластьТаблицы = ТабличныйДокумент.Область(НомерСтрокиНачалаТаблицы, НомерКолонкиНачалаТаблицы, ?(НомерСтрокиКонцаТаблицы = Неопределено, ТабличныйДокумент.ВысотаТаблицы, НомерСтрокиКонцаТаблицы), ?(НомерКолонкиКонцаТаблицы = Неопределено, ТабличныйДокумент.ШиринаТаблицы, НомерКолонкиКонцаТаблицы));
	Попытка
		ПостроительЗапроса = Новый ПостроительЗапроса;  
		ПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ОбластьТаблицы);  
		ПостроительЗапроса.Выполнить();
		Возврат ПостроительЗапроса.Результат.Выгрузить();
	Исключение
		Возврат Неопределено;
	КонецПопытки;
КонецФункции
&НаСервереБезКонтекста
Функция ПрочитатьExcel(ФайлExcel, ФункцияОбработкиСтрок = "СокрЛП(?)",
        ОграничиватьСверху = Истина, ОграничиватьСлева = Истина, ОграничиватьСнизу = Истина, ОграничиватьСправа = Истина) Экспорт 
    
    Ф = НовыйФайл(ФайлExcel);
    ВесьТабДок = Новый ТабличныйДокумент();
    ВесьТабДок.Прочитать(Ф.ПолноеИмя, СпособЧтенияЗначенийТабличногоДокумента.Значение);
    
    Результат = Новый СписокЗначений;
    Области = ВесьТабДок.Области;
    Если Области.Количество()=0 Тогда 
        ВызватьИсключение("В файле нет областей");
    КонецЕсли;
    
    Для Каждого Обл Из Области Цикл
        ТекТабДок = Новый ТабличныйДокумент;
        ОгрОбласть = ПолучитьОграниченнуюОбласть(ВесьТабДок, Обл);
        // вставим область в табдок
        ОгрОбласть.Имя = Обл.Имя;
        ТекТабДок.ВставитьОбласть(ОгрОбласть, 
            ТекТабДок.Область(1, ОгрОбласть.Лево, ОгрОбласть.Низ - ОгрОбласть.Верх + 1, ОгрОбласть.Право)
        );
        СократитьСтроки(ТекТабДок, ФункцияОбработкиСтрок);
        Результат.Добавить(ТекТабДок, Обл.Имя);
    КонецЦикла;
    // зачищаем исходный таб док. хз, может лишнее
    ВесьТабДок.Очистить();
    ВесьТабДок = Неопределено;
    
    Возврат Результат;
    
КонецФункции
&НаСервереБезКонтекста
Процедура СократитьСтроки(ТабДок, ФункцияОбработкиСтрок = "СокрЛП(?)")
    
    Если ПустаяСтрока(ФункцияОбработкиСтрок) Тогда 
        Возврат;
    КонецЕсли;
    
    Если Ложь Тогда ТабДок = Новый ТабличныйДокумент; КонецЕсли; // фейк
    
    Для Стр = 1 По ТабДок.ВысотаТаблицы Цикл 
        Для Кол = 1 По ТабДок.ШиринаСтраницы Цикл 
            ТекОбласть = ТабДок.Область(Стр, Кол);
            ТекстОбласти = ТекОбласть.Текст;
            Если Не ТекОбласть.СодержитЗначение И Не ПустаяСтрока(ТекОбласть.Текст)    Тогда 
                Выражение = СтрЗаменить(ФункцияОбработкиСтрок, "?", "ТекстОбласти");
                ТекОбласть.Текст = Вычислить(Выражение);
            КонецЕсли;
        КонецЦикла;
    КонецЦикла;
    
КонецПроцедуры
&НаСервереБезКонтекста
Функция ПолучитьОграниченнуюОбласть(ТабДок, ОбластьЯчеек,
    ОграничиватьСверху = Истина, ОграничиватьСлева = Истина, ОграничиватьСнизу = Истина, ОграничиватьСправа = Истина)
    
    Если Не ОграничиватьСверху И Не ОграничиватьСлева И Не ОграничиватьСправа И Не ОграничиватьСнизу Тогда 
        Возврат ОбластьЯчеек;
    КонецЕсли;
    
    Если Ложь Тогда // фейк
        ТабДок = Новый ТабличныйДокумент;
        ОбластьЯчеек = ТабДок.Области[0];
    КонецЕсли;
    
    Лево = Неопределено; Право = Неопределено; Верх = Неопределено; Низ = Неопределено;
    МаксШирина = ТабДок.ШиринаТаблицы;
    Для Стр = ОбластьЯчеек.Верх По ОбластьЯчеек.Низ Цикл
        Для Кол = 1 По МаксШирина Цикл 
            ТекОбласть = ТабДок.Область(Стр, Кол);
            Если ЭтоЗначащаяОбласть(ТекОбласть) Тогда 
                Лево = ?(Лево=Неопределено, Кол, Мин(Лево, Кол));
                Право = ?(Право=Неопределено, Кол, Макс(Право, Кол));
                Верх = ?(Верх=Неопределено, Стр, Верх);
                Низ = ?(Низ=Неопределено, Стр, Макс(Низ, Стр));
            КонецЕсли;
        КонецЦикла;
    КонецЦикла;
    
    Результат = ТабДок.Область(
        ?(ОграничиватьСверху, ?(Верх=Неопределено, ОбластьЯчеек.Верх, Верх), ОбластьЯчеек.Верх),
        ?(ОграничиватьСлева, ?(Лево=Неопределено, ОбластьЯчеек.Лево, Лево), ОбластьЯчеек.Лево),
        ?(ОграничиватьСнизу, ?(Низ=Неопределено, ОбластьЯчеек.Низ, Низ), ОбластьЯчеек.Низ),
        ?(ОграничиватьСправа, ?(Право=Неопределено, ОбластьЯчеек.Право, Право), ОбластьЯчеек.Право)
    );
    
    Возврат Результат;
    
КонецФункции
&НаСервереБезКонтекста
Функция ЭтоЗначащаяОбласть(ОбластьЯчеек)
    Возврат Не ПустаяСтрока(ОбластьЯчеек.Текст) 
        Или ОбластьЯчеек.Гиперссылка
        Или ОбластьЯчеек.СодержитЗначение
        //Или ОбластьЯчеек.ГраницаСверху.ТипЛинии<>ТипЛинииЯчейкиТабличногоДокумента.НетЛинии
        //Или ОбластьЯчеек.ГраницаСнизу.ТипЛинии<>ТипЛинииЯчейкиТабличногоДокумента.НетЛинии
        Или ОбластьЯчеек.ГраницаСлева.ТипЛинии<>ТипЛинииЯчейкиТабличногоДокумента.НетЛинии
        Или ОбластьЯчеек.ГраницаСправа.ТипЛинии<>ТипЛинииЯчейкиТабличногоДокумента.НетЛинии
    ;
КонецФункции
&НаСервереБезКонтекста
Функция ТекстОбластиЛиста(Лист, Знач Верх = Неопределено, Знач Лево = Неопределено, Знач Низ = Неопределено, Знач Право = Неопределено) Экспорт
    
    ТипЗнчЛист = ТипЗнч(Лист);
    Если ТипЗнчЛист=Тип("ТабличныйДокумент") Тогда 
        ТабДок = Лист;
    ИначеЕсли ТипЗнчЛист=Тип("ЭлементСпискаЗначений") Тогда 
        ТабДок = Лист.Значение;
    Иначе 
        ТабДок = Новый ТабличныйДокумент; // фейк
        ВызватьИсключение("Неподдерживаемый тип параметра Лист " + ТипЗнчЛист);
    КонецЕсли;
    
    Область = ТабДок.Область(Верх, Лево, Низ, Право);
    Результат = "";
    ГорРазд = Символы.Таб;
    ВертРазд = Символы.ВК;
    
    ОблЛево = ?(Область.Лево=0, 1, Область.Лево);
    ОблПраво = ?(Область.Право=0, ТабДок.ШиринаТаблицы, Мин(Область.Право, ТабДок.ШиринаТаблицы));
    ОблВерх = ?(Область.Верх=0, 1, Область.Верх);
    ОблНиз = ?(Область.Низ=0, ТабДок.ВысотаТаблицы, Мин(Область.Низ, ТабДок.ВысотаТаблицы));
    
    Для Стр=ОблВерх По ОблНиз Цикл 
        
        Для Кол=ОблЛево По ОблПраво Цикл
            
            ТекстЯчейки = ТабДок.Область(Стр, Кол).Текст;
            ЭтоПустаяЯчейка = ПустаяСтрока(ТекстЯчейки);
            
            Если ЭтоПустаяЯчейка Тогда 
                ТекстЯчейки = ГорРазд;
            КонецЕсли;
            Если Кол=ОблПраво И Стр=ОблНиз Тогда 
                Разделитель = "";
            ИначеЕсли Кол=ОблПраво Тогда
                Разделитель = ВертРазд;
            Иначе 
                Разделитель = ?(ЭтоПустаяЯчейка, "", ГорРазд);
            КонецЕсли;
            
            Результат = Результат + ТекстЯчейки + Разделитель;
                
        КонецЦикла;
        
    КонецЦикла;
    
    Возврат Результат;
    
КонецФункции
&НаСервереБезКонтекста
Функция НовыйФайл(Файл, ПроверятьСуществование = Истина)
    
    ТипЗнчФайл = ТипЗнч(Файл);
    Результат = Неопределено;
    Если ТипЗнчФайл=Тип("Файл") Тогда 
        Результат = Файл;
    ИначеЕсли ТипЗнчФайл=Тип("Строка") Тогда 
        Результат = Новый Файл(Файл);
    Иначе 
        ВызватьИсключение("Непредусмотренный тип параметра Файл " + ТипЗнчФайл);
    КонецЕсли;
    
    Если ПроверятьСуществование=Истина И Не Результат.Существует() Тогда 
        ВызватьИсключение("Файл не существует");
    КонецЕсли;
    
    Возврат Результат;
    
КонецФункции

#КонецОбласти
