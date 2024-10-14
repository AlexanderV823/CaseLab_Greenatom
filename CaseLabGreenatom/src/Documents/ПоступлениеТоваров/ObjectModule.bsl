#Область ОбработчикиСобытий

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Префикс = "ПТУ";
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = ТекущийСотрудникСервер.СотрудникТекущегоПользователя();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		Контрагент = ДанныеЗаполнения.Контрагент;
		ДокументЗаказ = ДанныеЗаполнения;
		
		Если ЗначениеЗаполнено(ДокументЗаказ.ДокументПоступления) Тогда
			
			ВызватьИсключение СтрШаблон("Для %1 уже создан %2", ДокументЗаказ, ДокументЗаказ.ДокументПоступления); //Откажемся от создания документа, если по нему уже было создано ПТУ.	
			
		КонецЕсли;
		
		Для Каждого ТекСтрокаПозиции Из ДанныеЗаполнения.Позиции Цикл
			
			НоваяСтрока = Позиции.Добавить();
			НоваяСтрока.Количество = ТекСтрокаПозиции.Количество;
			НоваяСтрока.Номенклатура = ТекСтрокаПозиции.Наименование;
			НоваяСтрока.СтавкаНДС = ТекСтрокаПозиции.СтавкаНДС;
			НоваяСтрока.Сумма = ТекСтрокаПозиции.Сумма;
			НоваяСтрока.СуммаНДС = ТекСтрокаПозиции.СуммаНДС;
			НоваяСтрока.Цена = ТекСтрокаПозиции.Цена;
			НоваяСтрока.СуммаСНДС = ТекСтрокаПозиции.СуммаСНДС;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Сумма = Позиции.Итог("СуммаСНДС");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
			
	Движения.ОстаткиТоваров.Очистить();
	Движения.Закупки.Очистить();
	
	Движения.ОстаткиТоваров.Записывать = Истина;
	Движения.Закупки.Записывать = Истина;
	
	ТипИнгредиент = Перечисления.ТипНоменклатуры.Продукт;
	ТипРасходныйМатериал = Перечисления.ТипНоменклатуры.РасходныйМатериал;
	
	СтатусИсполнен = Перечисления.СтатусЗаказаПоставщика.Исполнен;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровПозиции.Номенклатура КАК Номенклатура,
		|	ПоступлениеТоваровПозиции.Номенклатура.Тип КАК НоменклатураТипНоменклатуры,
		|	СУММА(ПоступлениеТоваровПозиции.Количество) КАК Количество,
		|	ПоступлениеТоваров.Контрагент КАК Контрагент,
		|	ПоступлениеТоваров.Ответственный КАК Ответственный,
		|	ПоступлениеТоваров.Склад КАК Склад,
		|	ПоступлениеТоваровПозиции.СуммаСНДС КАК Сумма,
		|	ПоступлениеТоваровПозиции.Цена КАК Цена,
		|	ПоступлениеТоваровПозиции.СтавкаНДС КАК СтавкаНДС,
		|	ПоступлениеТоваров.ДокументЗаказ КАК ДокументЗаказ,
		|	ПоступлениеТоваров.ДокументЗаказ.ДокументПоступления КАК ДокументЗаказДокументПоступления
		|ИЗ
		|	Документ.ПоступлениеТоваров.Позиции КАК ПоступлениеТоваровПозиции
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваров КАК ПоступлениеТоваров
		|		ПО ПоступлениеТоваровПозиции.Ссылка = ПоступлениеТоваров.Ссылка
		|ГДЕ
		|	ПоступлениеТоваровПозиции.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеТоваровПозиции.Номенклатура,
		|	ПоступлениеТоваровПозиции.Номенклатура.Тип,
		|	ПоступлениеТоваров.Контрагент,
		|	ПоступлениеТоваров.Ответственный,
		|	ПоступлениеТоваров.Склад,
		|	ПоступлениеТоваровПозиции.СуммаСНДС,
		|	ПоступлениеТоваровПозиции.Цена,
		|	ПоступлениеТоваровПозиции.СтавкаНДС,
		|	ПоступлениеТоваров.ДокументЗаказ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ЗаказПоставщику", ДокументЗаказ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					
		Если ВыборкаДетальныеЗаписи.НоменклатураТипНоменклатуры = ТипИнгредиент Или ВыборкаДетальныеЗаписи.НоменклатураТипНоменклатуры = ТипРасходныйМатериал Тогда
			
			Если ВыборкаДетальныеЗаписи.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС Тогда
				
				СтавкаНДС = 0;
				
			ИначеЕсли ВыборкаДетальныеЗаписи.СтавкаНДС = Перечисления.СтавкиНДС.НДС10 Тогда
				
				СтавкаНДС = 10;
				
			ИначеЕсли ВыборкаДетальныеЗаписи.СтавкаНДС = Перечисления.СтавкиНДС.НДС20 Тогда
				
				СтавкаНДС = 20;
				
			КонецЕсли;
             			
			//Запись движения по Регистру накопления Остатки Товаров
			
			Движение = Движения.ОстаткиТоваров.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
			Движение.Количество = ВыборкаДетальныеЗаписи.Количество;
			Движение.Сумма = ВыборкаДетальныеЗаписи.Сумма;
			Движение.Склад = ВыборкаДетальныеЗаписи.Склад;
						
			//Запись движения по Регистру накопления Закупки
			
			Движение = Движения.Закупки.Добавить();
			Движение.Период = Дата;
			Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
			Движение.Контрагент = ВыборкаДетальныеЗаписи.Контрагент;
			Движение.Количество = ВыборкаДетальныеЗаписи.Количество;
			Движение.Сумма = ВыборкаДетальныеЗаписи.Сумма;
			Движение.Ответственный = ВыборкаДетальныеЗаписи.Ответственный;
			Движение.Склад = ВыборкаДетальныеЗаписи.Склад;
			
			//Запись по регистру Цены
			
			Движение = Движения.Цены.Добавить();
			Движение.Активность = Истина;
			Движение.Контрагент = ВыборкаДетальныеЗаписи.Контрагент;
			Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
			Движение.ЦенаБезНДС = ВыборкаДетальныеЗаписи.Цена;
			Движение.СтавкаНДС = ВыборкаДетальныеЗаписи.СтавкаНДС;
			Движение.ЦенаСНДС = ВыборкаДетальныеЗаписи.Цена + (ВыборкаДетальныеЗаписи.Цена * СтавкаНДС / 100);
			Движение.СуммаНДС = ВыборкаДетальныеЗаписи.Цена * СтавкаНДС / 100;
			
			//Запись статуса в документ Заказ поставщику
			
			ЗаказПоставщику = ВыборкаДетальныеЗаписи.ДокументЗаказ.ПолучитьОбъект();
			ЗаказПоставщику.Статус = Перечисления.СтатусЗаказаПоставщика.Исполнен;
			ЗаказПоставщику.ДокументПоступления = Ссылка;
			ЗаказПоставщику.Записать();
			
			Иначе 
			
			Продолжить;
			
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти